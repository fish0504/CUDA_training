# CUDA

#### CUDAの勉強用のレポジトリ

## CUDAのサンプルをビルドする

以下のURLに従って、とりあえずサンプルをビルドして中身を見てみた
https://symfoware.blog.fc2.com/blog-entry-2394.html



途中に
```
error: #error -- unsupported GNU version! gcc versions later than 7 are not supported!
```
エラーが出たので
https://stackoverflow.com/questions/53344283/gcc-versions-later-than-7-are-not-supported-by-cuda-10-qt-error-in-arch-linux
の最後の
```
ln -s /usr/bin/gcc-7 /usr/local/cuda/bin/gcc
ln -s /usr/bin/g++-7 /usr/local/cuda/bin/g++
```
をターミナルから入力すると解決した.
おそらく一時的にgccのバージョンを切り替えた



## CUDAのチュートリアル


https://cuda-tutorial.readthedocs.io/en/latest/tutorials/tutorial01/

参考
https://symfoware.blog.fc2.com/blog-category-38.html

Tutorial2の並列実行の結果
1ブロックでスレッド数のみを変化させて実験した。
```
nvcc vector_add.cu -o vector_grid128 //コンパイル
nvprof ./vector_grid128　//パフォーマンス測定
```
| スレッド数 | 実行時間 |
| ---------- | -------- |
| 1          | 625.42ms |
| 128        | 24.809ms |
|   256      |12.687ms          |
| 512        |6.6360ms|


## GPU並列化の参考資料
https://www.slideshare.net/KMC_JP/gpgpu-91122680
