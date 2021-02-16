#define N 10000000
#include<vector>
#include<iostream>
#include<assert.h>
#define MAX_ERR 1e-6
__global__ void vector_add(float *out, float *a, float *b, int n) {
    
    int stride=blockDim.x;//スレッドの全体の数
    int index=threadIdx.x;//現在のスレッドの番号(0=255)
    //もしsスレッドの数が一つならばindex=0,stride=1になる
    for(int i =index; i < N; i+=stride){
        out[i] = a[i] + b[i];
    }
}

int main(){
    float *a, *b, *out; 
    float *d_a,*d_b,*d_out;
    // 1.Allocate memory
    a   = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

     //vectorの初期化
    for(int i = 0; i < N; i++){
        a[i] = 1.0f;
        b[i] = 2.0f;
    }

    //a のデバイス用メモリの割り当て
    cudaMalloc((void**)&d_a,sizeof(float)*N);
    cudaMalloc((void**)&d_b,sizeof(float)*N);
    cudaMalloc((void**)&d_out,sizeof(float)*N);
    //データをホストからデバイスに転送
    cudaMemcpy(d_a,a,sizeof(float)*N,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,b,sizeof(float)*N,cudaMemcpyHostToDevice);
    
    // Main function
    vector_add<<<1,128>>> (d_out,d_a, d_b, N);

    // hostメモリへデータを転送する
    cudaMemcpy(out,d_out,sizeof(float)*N,cudaMemcpyDeviceToHost);

    //Verification
    for(int i=0;i<N;i++){
        assert(fabs(out[i]-a[i]-b[i])<MAX_ERR);
    }

    printf("Assertion finished passed\n");

    //デバイスメモリの開放
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_out);

    //ホストメモリの開放
    free(a);
    free(b);
    free(out);
}
