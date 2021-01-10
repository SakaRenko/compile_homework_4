.section  .rodata
STR0:
.string "%c, %d\n"
STR1:
.string "%c"
STR2:
.string "%c\n"
STR3:
.string "result is: %d\n"
STR4:
.string "Have fun: %d %d\n"
.text
.globl good
.type good, @function
good:
pushl %ebp
movl %esp, %ebp
subl $20, %esp
L0:
movl 9(%ebp), %eax
movl $0 ,%ebx
cmp %ebx, %eax
jl L1
jmp L2
L1:
movl $0 ,%eax
movl %ebp, %esp
popl %ebp
ret
jmp L2
L2:
movl 9(%ebp), %eax
pushl %eax
movzbl 8(%ebp), %eax
pushl %eax
pushl $STR0
call printf
addl $12, %esp
movl 9(%ebp), %eax
movl $1 ,%ebx
subl %ebx, %eax
movl %eax, -20(%ebp)
movl $-4, %eax
movl $-20, %ebx
addl %ebp, %eax
addl %ebp, %ebx
movl 0(%ebx), %ecx
movl %ecx, 0(%eax)
movl -4(%ebp), %eax
pushl %eax
movzbl 8(%ebp), %eax
subl $1, %esp
movb %al, 0(%esp)
call good
addl $5, %esp
movl %eax, -20(%ebp)
movl -20(%ebp), %eax
movl %ebp, %esp
popl %ebp
ret
.text
.globl main
.type main, @function
main:
pushl %ebp
movl %esp, %ebp
subl $235, %esp
movl $-61, %eax
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
movl $-61, %eax
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
movl $-122, %eax
movl $-61, %ebx
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
movl $-123, %eax
addl %ebp, %eax
pushl %eax
pushl $STR1
call scanf
addl $8, %esp
movl $-127, %eax
movl $10 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
movzbl -123(%ebp), %eax
pushl %eax
pushl $STR2
call printf
addl $8, %esp
L3:
movl $-61, %eax
addl $1, %eax
movl %eax, -171(%ebp)
movl -171(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -175(%ebp)
movl -175(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -179(%ebp)
movl -179(%ebp), %eax
addl %ebp, %eax
movl 0(%eax), %eax
movl $0 ,%ebx
cmp %ebx, %eax
jg L4
jmp L5
L4:
movl $-61, %eax
addl $1, %eax
movl %eax, -187(%ebp)
movl -187(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -191(%ebp)
movl -191(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -195(%ebp)
movl $-61, %eax
addl $1, %eax
movl %eax, -199(%ebp)
movl -199(%ebp), %eax
movl $0 ,%ebx
imull $12, %ebx, %ebx
addl %ebx, %eax
movl %eax, -203(%ebp)
movl -203(%ebp), %eax
movl $1 ,%ebx
imull $4, %ebx, %ebx
addl %ebx, %eax
movl %eax, -207(%ebp)
movl -207(%ebp), %eax
addl %ebp, %eax
movl 0(%eax), %eax
movl $1 ,%ebx
subl %ebx, %eax
movl %eax, -211(%ebp)
movl -195(%ebp), %eax
movl $-211, %ebx
addl %ebp, %eax
addl %ebp, %ebx
movl 0(%ebx), %ecx
movl %ecx, 0(%eax)
movl $2 ,%eax
pushl %eax
movl $97 ,%eax
subl $1, %esp
movb %al, 0(%esp)
call good
addl $5, %esp
movl %eax, -215(%ebp)
movl -215(%ebp), %eax
pushl %eax
pushl $STR3
call printf
addl $8, %esp
movl $-135, %eax
movl $0 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
movl $-139, %eax
movl $10 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
movl $-139, %eax
movl $10 ,%ebx
addl %ebp, %eax
movl %ebx, 0(%eax)
L6:
movl -135(%ebp), %eax
movl -139(%ebp), %ebx
cmp %ebx, %eax
jl L7
jmp L8
L7:
movl -139(%ebp), %eax
pushl %eax
movl -135(%ebp), %eax
pushl %eax
pushl $STR4
call printf
addl $12, %esp
movl -135(%ebp), %eax
movl $1 ,%ebx
addl %ebx, %eax
movl %eax, -235(%ebp)
movl $-135, %eax
movl $-235, %ebx
addl %ebp, %eax
addl %ebp, %ebx
movl 0(%ebx), %ecx
movl %ecx, 0(%eax)
jmp L6
L8:
jmp L3
L5:
movl $0 ,%eax
movl %ebp, %esp
popl %ebp
ret
.section .note.GNU-stack,"",@progbits
