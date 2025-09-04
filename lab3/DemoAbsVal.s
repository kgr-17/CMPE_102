        .file   "DemoAbsVal.c"
        .section        .rodata
.LC0:
        .string "enter x:"
.LC1:
        .string "%d"
.LC2:
        .string "absolute value is %d\n"
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
// if (x < 0) x = -x
        movl    x, %eax
        cmpl    $0, %eax
        jge     .ALREADY_POSITIVE
        negl    %eax
.ALREADY_POSITIVE:
// Core code done, print %eax as answer
        subl    $8, %esp
        pushl   %eax
        pushl   $.LC2
        call    printf
        addl    $16, %esp
        movl    $0, %eax
        movl    -4(%ebp), %ecx
        .cfi_def_cfa 1, 0
        leave
        .cfi_restore 5
        leal    -4(%ecx), %esp
        .cfi_def_cfa 4, 4
        ret
        .cfi_endproc
.LFE0:
        .size   main, .-main
                                                                                             [ Read 62 lines ]
^G Get Help      ^O Write Out     ^W Where Is      ^K Cut Text      ^J Justify       ^C Cur Pos       ^Y Prev Page     M-\ First Line   M-W WhereIs Next ^^ Mark Text     M-} Indent Text  M-U Undo
^X Exit          ^R Read File     ^\ Replace       ^U Uncut Text    ^T To Spell      ^_ Go To Line    ^V Next Page     M-/ Last Line    M-] To Bracket   M-^ Copy Text    M-{ Unindent TextM-E Redo
