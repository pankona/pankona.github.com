---
title: "gomobile build で JNI から Toast を出せなかった話"
date: 2018-01-29T08:41:12+09:00
categories: [DroidKaigi]
---

本日は 2018/01/29 であり、DroidKaigi 本番 (2018/02/08) までもう二週間もないところまできた。
来週の木曜日である。ヤバイ。準備捗ってない…。

とはいえ色々調査は進めている。
gomobile 関連で色々調べて分かったことを書いておく。

## JNI だけで Toast を出すのは無理な気がする

`Toast.makeText(this, "hogehoge", Toast.LENGTH_SHORT);`

「Java でやるなら」、上のような書き方をすれば Toast は出る。実に簡単。

これと同じことを gomobile with JNI でやろうと思うと、以下のようなコードになる。
(下記はエラーチェックを省略している)

先に書いておくと、下記のコードは正しく動作しない。

```go
package toast

/*
#include <jni.h>
#include <stdlib.h>

static int
showToast(uintptr_t java_vm, uintptr_t jni_env, uintptr_t jni_ctx, char* text) {
    JNIEnv* env = (JNIEnv*)jni_env;
    jobject ctx = (jobject)jni_ctx;

    // Toast クラスの取得 ... 1
    jclass toast = (*env)->FindClass(env, "android/widget/Toast");

    // makeText メソッドの ID を取得 ... 2
    jmethodID makeText = (*env)->GetStaticMethodID(env, toast, "makeText",
        "(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;");

    // String を生成 ... 3
    jstring jstr = (*env)->NewStringUTF(env, "hogehoge");

    // makeText メソッドを呼び出し ... 4
    jobject toastobj = (*env)->CallStaticObjectMethod(env, toast, makeText,
        ctx, jstr, 0); // 0 = Toast.LENGTH_SHORT

    // show メソッド の IDの を取得 ... 5
    jmethodID methodShow = (*env)->GetMethodID(env, toastobj, "show", "()V");

    // show メソッドを呼び出し ... 6
    (*env)->CallVoidMethod(env, toastobj, methodShow);

    return 0;
}
*/
import "C"

import (
    "fmt"

    "github.com/pankona/gomo-simra/simra/jni"
)

type t struct{}

func NewToaster() Toaster {
    return &t{}
}

func (t *t) Show(text string) error {
    jni.RunOnJVM(
        func(vm, env, ctx uintptr) error {
            ret := C.showToast(C.uintptr_t(vm), C.uintptr_t(env), C.uintptr_t(ctx), C.CString(text))
            fmt.Printf("ret = %d\n", ret)
            return nil
        })
    return nil
}
```

上記のコードは、「4」のところが正しく動作しないようである。`toastobj` には NULL が返却される。
~~いまのところ原因はよく分かっていないが、`makeText` の第二引数が `CharSequence` であることと、~~
~~そこに `jstring` を渡している、ということで、型があってないというのが原因なのではないかと想像する。~~

~~`jstring` は `java/lang/String` と同じものという理解でおり、であれば `CharSequence` として扱っても~~
~~良いのではないかという気がしないでもない (`String` は `CharSequence` のサブクラスなので) のだが、~~
~~事実、正しく動作していないところを鑑みるには、やっぱりダメなんじゃないかという気がしている。~~

~~Java のレイヤでは書ける以下のような例は、~~
~~JNI のレイヤでは表現することができないと思われる。~~

~~`CharSequence cs = new String("hogehoge");`~~

~~ちなみに、「AndroidNDKプログラミング第二版」には、JNI から Toast を出す例が掲載されていたが、~~
~~肝心の CharSequence に関しては Java のレイヤで生成されたものを JNI に引き渡す構成になっており、~~
~~もう少し原因究明に届かなかった。~~

(2018/01/31 追記)

上記は完全にウソだった。勘違いであった。申し訳ございません！

ちゃんとどのようなエラーが (4) で吐かれているか補足してみたところ、以下の例外が投げられていた。

```plaintext
java.lang.RuntimeException: Can't create handler inside thread that has not called Looper.prepare()
```

つまり Toast を出そうとはしているようであるが、UI スレッド以外から呼び出すことはできない、ということで
Toast の出力に失敗しているようである。`CharSequence` は完全に無罪であった。すまん、`CharSequence`。

さて、上記のエラーを解消するためには、Toast を UI スレッド上で実行する必要がある。
定番のやり方は `Handler` を用いるやり方である。例えば以下のようなやり方。

```java
activity.runOnUiThread(new Runnable() {
    public void run() {
        Toast.makeText(activity, "Hello", Toast.LENGTH_SHORT).show();
    }
});
```

これを JNI で表現するにはどうすれば良いかを考えれば良い。
無名クラスとか出てきていてやっぱり無理なんじゃないかっていう気がしているが、
とりあえず試みてみようとは思う。

## Java のレイヤに CharSequence をとらないメソッドを定義すればいけるが…

上記の原因の仮説を若干補強するものとして、
CharSequence を取らずに Toast を出すメソッドを Java レイヤに準備しておき、
それを JNI から呼び出すようなコードを書いた場合は無事に Toast が出力される。

以下のようなコードをあらかじめ Java のレイヤに書いておき、
それを上記の JNI と同様のノリで呼び出すようにする。

```java
// static Activity goNativeActivity;
// onCreate にて goNativeActivity = this;

public void showToast(final String message) {
    Handler h = new Handler(goNativeActivity.getApplication().getMainLooper());
    h.post(new Runnable() {
        @Override
        public void run() {
            Toast.makeText(goNativeActivity, message, Toast.LENGTH_SHORT).show();
        }
    });
}
```

今回、DroidKaigi 向けには gomobile build を使って Go だけで Android アプリを書いてみようという試みであるので、
Java に手を入れていく手法は有り難いのであるが、追っての調査はまた別の機会にとっておくことにする。
