        .global main
        .text

main:
        movl    $0, %eax        # eax = NULL pointer (0)
        movl    (%eax), %ebx    # try to read from address 0 → segmentation fault

        movl    $1, %eax        # exit() in case something weird happens
        movl    $0, %ebx
        int     $0x80
