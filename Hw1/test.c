#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    char out[300];
    char *str1 = "hello world\n";
    strcpy(out, str1);
    printf("%s", out);
    char *str2 = "feng yu qi cheng feng po lang";
    strcat(out, str2);
    printf("%s", out);
    memset(out, 0, 300);
    printf("%s", out);
    printf("\ndone");
}

    // void lineOutput(char* str){
    //     size_t out_len = strlen(out);
    //     size_t str_len = strlen(str);
    //     char* temp = (char*)malloc(strlen(out) + strlen(str) + 1);
    //     strcpy(temp, out);
    //     strcat(temp, str);
    //     free(out);
    //     out = temp;
    // }
    