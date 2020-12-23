.section  .rodata
STR0:
.string "%c, %d\n"
STR1:
.string "%c"
STR2:
.string "%c\n"
STR3:
.string "good! then\n"
STR4:
.string "result is: %d\n"
STR5:
.string "Have fun: %d\n"
.text
.globl good
.type good, @function
good:
pushl %ebp
movl %esp, %ebp
subl $8, %esp
movl 9(%ebp), %eax
pushl %eax
movzbl 8(%ebp), %eax
pushl %eax
pushl $STR0
call printf
addl $12, %esp
movl $-4, %eax
movl $9, %ebx
addl %ebp, %eax
addl %ebp, %ebx
movl 0(%ebx), %ecx
movl %ecx, 0(%eax)
movl $0 ,%eax
movl %ebp, %esp
popl %ebp
ret
.text
.globl main
.type main, @function
main:
pushl %ebp
movl %esp, %ebp
subl $279, %esp
movl $-65, %eax
addl $1, %eax
movl %eax, -143(%ebp)
movl -143(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -147(%ebp)
movl -147(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -151(%ebp)
movl -151(%ebp), %eax
movl $10 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
movl $-65, %eax
addl $1, %eax
movl %eax, -155(%ebp)
movl -155(%ebp), %eax
movl $3 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -159(%ebp)
movl -159(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -163(%ebp)
movl -163(%ebp), %eax
movl $5 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
movl $-126, %eax
movl $-65, %ebx
addl %ebp, %eax
addl %ebp, %ebx
movl 57(%ebx), %ecx
movl %ecx, 57(%eax)
movl 53(%ebx), %ecx
movl %ecx, 53(%eax)
movl 49(%ebx), %ecx
movl %ecx, 49(%eax)
movl 45(%ebx), %ecx
movl %ecx, 45(%eax)
movl 41(%ebx), %ecx
movl %ecx, 41(%eax)
movl 37(%ebx), %ecx
movl %ecx, 37(%eax)
movl 33(%ebx), %ecx
movl %ecx, 33(%eax)
movl 29(%ebx), %ecx
movl %ecx, 29(%eax)
movl 25(%ebx), %ecx
movl %ecx, 25(%eax)
movl 21(%ebx), %ecx
movl %ecx, 21(%eax)
movl 17(%ebx), %ecx
movl %ecx, 17(%eax)
movl 13(%ebx), %ecx
movl %ecx, 13(%eax)
movl 9(%ebx), %ecx
movl %ecx, 9(%eax)
movl 5(%ebx), %ecx
movl %ecx, 5(%eax)
movl 1(%ebx), %ecx
movl %ecx, 1(%eax)
movb 0(%ebx), %cl
movb %cl, 0(%eax)
movl $-4, %eax
movl $0 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
movl $-127, %eax
addl %ebp, %eax
pushl %eax
pushl $STR1
call scanf
addl $8, %esp
movl $-131, %eax
movl $10 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
movzbl -127(%ebp), %eax
pushl %eax
pushl $STR2
call printf
addl $8, %esp
L0:
movl $-65, %eax
addl $1, %eax
movl %eax, -175(%ebp)
movl -175(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -179(%ebp)
movl -179(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -183(%ebp)
movl -183(%ebp), %eax
addl %ebp, %eax
movl 0(%eax), %eax
movl $0 ,%ebx
cmp %ebx, %eax
jg L3
jmp L2
L3:
movl -4(%ebp), %eax
movl $20 ,%ebx
cmp %ebx, %eax
jl L1
jmp L4
L4:
movl -4(%ebp), %eax
movl $100 ,%ebx
movl $0, %edx
idivl %ebx
movl %edx, -199(%ebp)
movl -199(%ebp), %eax
movl $99 ,%ebx
cmp %ebx, %eax
je L1
jmp L2
L1:
L5:
movl $-65, %eax
addl $1, %eax
movl %eax, -207(%ebp)
movl -207(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -211(%ebp)
movl -211(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -215(%ebp)
movl -215(%ebp), %eax
addl %ebp, %eax
movl 0(%eax), %eax
movl $0 ,%ebx
cmp %ebx, %eax
jg L6
jmp L7
L6:
pushl $STR3
call printf
addl $4, %esp
jmp L7
L7:
movl $-65, %eax
addl $1, %eax
movl %eax, -223(%ebp)
movl -223(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -227(%ebp)
movl -227(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -231(%ebp)
movl $-65, %eax
addl $1, %eax
movl %eax, -235(%ebp)
movl -235(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -239(%ebp)
movl -239(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -243(%ebp)
movl -243(%ebp), %eax
addl %ebp, %eax
movl 0(%eax), %eax
movl $1 ,%ebx
subl %ebx, %eax
movl %eax, -247(%ebp)
movl -231(%ebp), %eax
movl $-247, %ebx
addl %ebp, %eax
addl %ebp, %ebx
movl 0(%ebx), %ecx
movl %ecx, 0(%eax)
movl $-126, %eax
addl $1, %eax
movl %eax, -243(%ebp)
movl -243(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -247(%ebp)
movl -247(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -251(%ebp)
movl -251(%ebp), %eax
addl %ebp, %eax
movl 0(%eax), %eax
pushl %eax
pushl $STR4
call printf
addl $8, %esp
movl $2 ,%eax
pushl %eax
movl $97 ,%eax
subl $1, %esp
movb %al, 0(%esp)
call good
addl $5, %esp
movl %eax, -263(%ebp)
movl $-139, %eax
movl $10 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
movl $-135, %eax
movl $0 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
L8:
movl -135(%ebp), %eax
movl -139(%ebp), %ebx
cmp %ebx, %eax
jl L9
jmp L10
L9:
movl -135(%ebp), %eax
pushl %eax
pushl $STR5
call printf
addl $8, %esp
movl -135(%ebp), %eax
movl $1 ,%ebx
addl %ebx, %eax
movl %eax, -279(%ebp)
movl $-135, %eax
movl $-279, %ebx
addl %ebp, %eax
addl %ebp, %ebx
movl 0(%ebx), %ecx
movl %ecx, 0(%eax)
jmp L8
L10:
jmp L0
L2:
movl $0 ,%eax
movl %ebp, %esp
popl %ebp
ret
.section .note.GNU-stack,"",@progbits
