/*
I'm level 1 test.
*/

struct ans
{
    char b;
    int a[5][3];
};

void good(char aa, int bb)
{
    printf("%c, %d\n", aa, bb);
    int d = bb;
    return 0;
}

int main() {
int s;
struct ans a, c;
a.a[0][1] = 10;
a.a[3][1] = 5;
c = a;
s = 0;
char ch;
scanf("%c", ch);
int b = 10;
printf("%c\n", ch);
// printf("result is: %d\n", a.a[0]);
while(a.a[0][1]>0 && (s < 20 || s % 100 == 99)) {
if(a.a[0][1] > 0)
    printf("good! then\n");
a.a[0][1] = a.a[0][1] - 1;
printf("result is: %d\n", c.a[0][1]);
good('a', 2);
int i;
int b = 10;
for(i=0; i<b; i = i + 1) {
printf("Have fun: %d\n", i);
}
}
return 0;
}
// No more compilation error.
