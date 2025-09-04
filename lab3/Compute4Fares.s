        .file   "DemoAbsVal.c"
        .section        .rodata
.LC0:
        .string "enter age:"
.LC1:
        .string "%d"
.LC2:
        .string "computed fare is %d\n"
        .text
        .globl  main
        .type   main, @function
main:
.LFB0:
        .cfi_startproc
        leal    4(%esp), %ecx
        .cfi_def_cfa 1, 0
        andl    $-16, %esp
        pushl   -4(%ecx)
        pushl   %ebp
        .cfi_escape 0x10,0x5,0x2,0x75,0
        movl    %esp, %ebp
        pushl   %ecx
        .cfi_escape 0xf,0x3,0x75,0x7c,0x6
        subl    $20, %esp
        subl    $12, %esp
        pushl   $.LC0
        call    puts
        addl    $16, %esp
        subl    $8, %esp
        leal    x, %eax
        pushl   %eax
        pushl   $.LC1
        call    __isoc99_scanf
        addl    $16, %esp
// Core code here to do the same as:
// if (age >= 65) fare=12 else if (age < 18) fare=10 else fare=15
        movl    x, %eax
        cmpl    $65, %eax
        jge     .SENIOR_FARE
        cmpl    $18, %eax
        jge     .YOUTH_FARE
        cmpl    $5,  %eax
        jge     .CHILDREN_FARE
        movl    $0, %eax
        jmp     .DONE
.SENIOR_FARE:
        movl    $18, %eax
        jmp     .DONE
.YOUTH_FARE:        
        movl    $20, %eax
        jmp     .DONE
.CHILDREN_FARE:
        movl    $15, %eax
.DONE:
// Core code done
        subl    $8, %esp
        pushl   %eax
        pushl   $.LC2
                                                                        