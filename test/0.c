/*
I'm level 1 test.
*/

struct ans
{
    char b;
    int a[5][3];
};

int good(char aa, int bb)
{
    if(bb < 0) return 0; 
    printf("%c, %d\n", aa, bb);
    int d = bb - 1;
    return good(aa, d);
}

int main() {
struct ans a, c;
a.a[0][1] = 10;
a.a[3][1] = 5;
c = a;
char ch;
scanf("%c", ch);
int b = 10;
printf("%c\n", ch);
// printf("result is: %d\n", a.a[0]);
while(a.a[0][1]>0) {
a.a[0][1] = a.a[0][1] - 1;
int s;
printf("result is: %d\n",  good('a', 2));
int i = 0;
int b = 10;
for(b = 10; i<b; i = i + 1) {
printf("Have fun: %d %d\n", i, b);
}
}
return 0;
}
// No more compilation error.
