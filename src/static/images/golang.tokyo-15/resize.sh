#!/bin/bash -e

mv ./DSC_0310.jpg 01.jpg 
mv ./DSC_0314.jpg 02.jpg
mv ./DSC_0312.jpg 03.jpg
mv ./DSC_0315.jpg 04.jpg
mv ./DSC_0307.jpg 05.jpg
mv ./DSC_0306.jpg 06.jpg
mv ./DSC_0313.jpg 07.jpg
mv ./DSC_0311.jpg 08.jpg
mv ./DSC_0308.jpg 09.jpg
mv ./DSC_0309.jpg 10.jpg

convert ./01.jpg -resize 15% ./resized_01.jpg 
convert ./02.jpg -resize 15% ./resized_02.jpg
convert ./03.jpg -resize 15% ./resized_03.jpg
convert ./04.jpg -resize 15% ./resized_04.jpg
convert ./05.jpg -resize 15% ./resized_05.jpg
convert ./06.jpg -resize 15% ./resized_06.jpg
convert ./07.jpg -resize 15% ./resized_07.jpg
convert ./08.jpg -resize 15% ./resized_08.jpg
convert ./09.jpg -resize 15% ./resized_09.jpg
convert ./10.jpg -resize 15% ./resized_10.jpg

