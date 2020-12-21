/*
I'm level 1 test.
*/

struct ans
{
    int b;
    int a[5][3];
};

int good(int aa, char bb)
{
    if(aa < 0) return 0;
    printf("%d, %c\n", aa, bb);
    int d = aa + bb;

}

int main() {
int s;
struct ans a;
a.a[0][1] = 10;
a.a[3][1] = 5;
s = 0;
char ch;
scanf("%c", ch);
printf("%c\n", ch);
// printf("result is: %d\n", a.a[0]);
while(a.a[0][1]>0 && (s < 20 || s % 100 == 99)) {
if(a.a[0][1] > 0)
    printf("good! then");
a.a[0][1] = a.a[0][1] - 1;
s = good(2, 'a');
printf("result is: %d\n", a.a[0][1]);
int i;
int b = 10;
for(i=0; i<b; i = i + 1) {
printf("Have fun: %d\n", i);
}
}
return 0;
}
// No more compilation error.
