.text
.global subtract
subtract:
    pushl  %ebp
    movl   %esp, %ebp

    movl  8(%ebp),%eax
    subl  12(%ebp),%eax
    leave
    ret