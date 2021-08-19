//
//  SignUtil.h
//  PJLive
//
//  Created by PublicJoker on 2021/8/17.
//  Copyright © 2021 君凯商联网. All rights reserved.
//

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dlfcn.h> /* 必须加这个头文件 */
#include <assert.h>

typedef int (*sign_func_pointer) (char * __restrict);
 
void dynamic_call_function(){
    
    //动态库路径
    char *dylib_path = "../lib/libnative-signtools.so";
    
    //打开动态库
    void *handle = dlopen(dylib_path, RTLD_GLOBAL | RTLD_NOW);
    if (handle == NULL) {
        //打开动态库出错
        fprintf(stderr, "%s\n", dlerror());
    } else {
        
        //获取 printf 地址
        sign_func_pointer sign_func = dlsym(handle, "getSignMd5");
        
        //地址获取成功则调用
        if (sign_func) {
            sign_func("c17fcd90f5df3248225e5930a9aa2646");
        }
        
        dlclose(handle); //关闭句柄
    }
}

char * sign(char *content)
{
    printf("come in\n");
 
    void *handler = dlopen("/PJLive/lib/libnative-signtools.so", RTLD_NOW);
    printf("dlopen - %sn", dlerror());
    assert(handler != NULL);
    
    char * (*pTest)(char *);
    pTest = (char * (*)(char *))dlsym(handler, "com.haidan.app.tool.Utils.getSignMd5");
    
    char *result = (*pTest)(content);
 
    dlclose(handler);
    
    printf("go out\n");
    return result;
}

