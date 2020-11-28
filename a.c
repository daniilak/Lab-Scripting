#include <stdio.h>
 
int main () {
    int a = 15;
    if (a == 15) {
        a = 15;
    }
    printf("%d\n", a++);
    printf("%d\n", a);

    printf ("Hello World\n");
    printf("%d\n", 12);
    printf("%10.3f\n", 12.234657);

    printf("%5d - %p\n", a, &a);

    // int a = 5;
    float c = 6.98;
    int *pa;
    float *pc;
    printf(" %p %p %p\n", pa, pc);
    pa = NULL;
    pc = NULL;
    
    printf(" %15p %15p\n", pa, pc);
}