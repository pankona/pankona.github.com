---
title: "gomobile (build) で作るアプリでファイルを保存する"
date: 2018-01-31T16:30:10+09:00
categories: [go,gomobile]
---

gomobile という Go 言語で Android/iOS のアプリを作ろうというプロジェクト (準公式) が存在する。
ページはココ → [gomobile の公式 wiki ページ - https://github.com/golang/go/wiki/Mobile](https://github.com/golang/go/wiki/Mobile)

`gomobile build` コマンド一発で Go のソースから APK が生成されるというなかなか豪快なコマンドなのであるが、
いかんせん色々制限があって、いざ何か作ってみようとするとまあまあハマる。
どんな苦行があるかは [手前味噌だが Qiita の記事](https://qiita.com/pankona/items/11941a5cfb668e653b4a) に何となく記しておいた。

上記記事には書いてなかったハマりポイントとして、**「ファイルを永続領域に保存する API がない」**というのがある。
ファイルを保存できないということは、ゲーム作ってて何かセーブデータでも保存しよう、とかそういうことができないってことである。
割と致命的である。

ただ、実は gomobile はパッケージ内に JNI を触る実装を持っていて (何故か internal パッケージなので外から触れないが) 、
それを参考にすれば、cgo 経由で JNI に触ることができる。
JNI に触れるということは、Java の API に触れるということで、それはすなわち Android SDK の API に触れるということである。
Go から Android SDK の API に触れるのである。

## Android アプリ作成におけるファイル保存領域の取得

ググればさっさと出てくるが、Android アプリを作る際には以下のようなコードを書くと、
ファイルを永続保存できる領域へのディレクトリパスを取得できる (アプリアンインストールと共に削除される) 。

```java
public class MyActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        String dir = this.getCacheDir().getAbsolutePath();
        // dir にはファイル保存可能領域 (internal storage) への絶対パスが入る
    }
}
```

## gomobile (build) アプリ作成時におけるファイル保存領域の取得

つまりは上記と同様の処理を JNI で書いてやれば良い。
以下のようになる。

### jni を呼び出すパッケージと関数

```go
// +build android

package jni

/*
#cgo LDFLAGS: -landroid
#include <jni.h>
#include <stdlib.h>

JavaVM* current_vm;
jobject current_ctx;

static char *
_lockJNI(uintptr_t* envp, int* attachedp) {
	JNIEnv* env;

	if (current_vm == NULL) {
		return "no current JVM";
	}

	*attachedp = 0;
	switch ((*current_vm)->GetEnv(current_vm, (void**)&env, JNI_VERSION_1_6)) {
	case JNI_OK:
		break;
	case JNI_EDETACHED:
		if ((*current_vm)->AttachCurrentThread(current_vm, &env, 0) != 0) {
			return "cannot attach to JVM";
		}
		*attachedp = 1;
		break;
	case JNI_EVERSION:
		return "bad JNI version";
	default:
		return "unknown JNI error from GetEnv";
	}

	*envp = (uintptr_t)env;
	return NULL;
}

static char *
_checkException(uintptr_t jnienv) {
	jthrowable exc;
	JNIEnv* env = (JNIEnv*)jnienv;
	if (!(*env)->ExceptionCheck(env)) {
		return NULL;
	}

	exc = (*env)->ExceptionOccurred(env);
	(*env)->ExceptionClear(env);

	jclass clazz = (*env)->FindClass(env, "java/lang/Throwable");
	jmethodID toString = (*env)->GetMethodID(env, clazz, "toString", "()Ljava/lang/String;");
	jobject msgStr = (*env)->CallObjectMethod(env, exc, toString);
	return (char*)(*env)->GetStringUTFChars(env, msgStr, 0);
}

void
_unlockJNI() {
	(*current_vm)->DetachCurrentThread(current_vm);
}
*/
import "C"

import (
	"errors"
	"runtime"
	"unsafe"
)

func RunOnJVM(fn func(vm, env, ctx uintptr) error) error {
	errch := make(chan error)
	go func() {
		runtime.LockOSThread()
		defer runtime.UnlockOSThread()

		env := C.uintptr_t(0)
		attached := C.int(0)
		if errStr := C._lockJNI(&env, &attached); errStr != nil {
			errch <- errors.New(C.GoString(errStr))
			return
		}
		if attached != 0 {
			defer C._unlockJNI()
		}

		vm := uintptr(unsafe.Pointer(C.current_vm)) // #nosec
		if err := fn(vm, uintptr(env), uintptr(C.current_ctx)); err != nil {
			errch <- err
			return
		}

		if exc := C._checkException(env); exc != nil {
			errch <- errors.New(C.GoString(exc))
			C.free(unsafe.Pointer(exc)) // #nosec
			return
		}
		errch <- nil
	}()
	return <-errch
}
```

### jni パッケージを使ってファイル保存領域を取得するメソッド

```go
// +build android

package storage

/*
#include <jni.h>
#include <stdlib.h>

static const char *
getFilesDir(uintptr_t java_vm, uintptr_t jni_env, uintptr_t jni_ctx) {
	JNIEnv* env = (JNIEnv*)jni_env;
	jobject ctx = (jobject)jni_ctx;

	jclass context = (*env)->FindClass(env, "android/content/Context");
	if(context == NULL) {
		return NULL;
	}
	jmethodID getFilesDir = (*env)->GetMethodID(env, context, "getFilesDir", "()Ljava/io/File;");
	if(getFilesDir == NULL){
		return NULL;
	}

	jobject f = (*env)->CallObjectMethod(env, ctx, getFilesDir);
	if (f == NULL) {
		return NULL;
	}

	jclass file = (*env)->FindClass(env, "java/io/File");
	if (file == NULL) {
		return NULL;
	}

	jmethodID getAbsolutePath = (*env)->GetMethodID(env, file, "getAbsolutePath", "()Ljava/lang/String;");
	if (getAbsolutePath == NULL) {
		return NULL;
	}

	jstring path = (jstring)(*env)->CallObjectMethod(env, f, getAbsolutePath);
	return (*env)->GetStringUTFChars(env, path, 0);
}
*/
import "C"

import (
	"unsafe"

	"github.com/pankona/gomo-simra/simra/internal/jni"
	"github.com/pankona/gomo-simra/simra/simlog"
)

type storageAndroid struct{}

func NewStorage() Storager {
	return &storageAndroid{}
}

var path string

func (s *storageAndroid) DirectoryPath() string {
	if path != "" {
		return path
	}
	jni.RunOnJVM(
		func(vm, env, ctx uintptr) error {
			cpath := C.getFilesDir(C.uintptr_t(vm), C.uintptr_t(env), C.uintptr_t(ctx))
			if cpath == nil {
				simlog.Errorf("failed to get FilesDir!")
			}
			path = C.GoString(cpath)
			C.free(unsafe.Pointer(cpath)) // #nosec
			return nil
		})
	return path
}
```

### DirectoryPath() を呼び出す部分

```go
func f() {
    dir := storage.NewStorage().DirectoryPath()
    fmt.Printf("path to internal storage: %s", dir)
}
```

## (余談) キャッシュディレクトリの取得

上記のコードで永続保存が可能な領域へのパスが取得できるので、それはそれで良いのであるが、
実はもっと手軽にファイル保存が可能な領域へのパスを取得できる方法があり、
それは環境変数 `TMPDIR` を参照することである。

ただし、本値は Android SDK の API で言うところの `Context.getCacheDir` に相当し、
Android 端末の状況によっては削除され得る領域であることに気をつける必要がある。
が、ちょっと保存したいくらいの用途であれば耐えうるような気がする。
以下のようにして取得する。

```go
func f() {
    dir := os.Getenv("TMPDIR")
    fmt.Printf("path to internal storage (for cache): %s", dir)
}
```
