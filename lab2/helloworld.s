# Hello World program in x86 32-bit assembly
#
# To compile this program into an executable helloworld.exe:
#
# gcc helloworld.s -o helloworld.exe
#
.global  main
.data
msg:
    .ascii "Hello, what is your name?\n"
msg_len = . - msg
msg_final:
    .ascii "Nice to meet you, "
msg_final_len = . - msg_final
    .section .bss
    .lcomm name, 100            # input buffer
.text
main:
#   calling write(1,msg,18)
    mov    $4,%eax      # eax=4 means indirectly call write()
    mov    $1,%ebx      # ebx=1 means write to channel 1 of Linux
    mov    $msg,%ecx    # ecx=msg means write the value of variable msg
    mov    $msg_len,%edx     # edx=14 means write 14 bytes of msg
    int    $0x80        # interupt 0x80 invokes OS control function

#   calling read(0,msg,100)
    mov    $3,%eax      # eax=4 means indirectly call read()
    mov    $0,%ebx      # ebx=0 means write to channel  of Linux
    mov    $name,%ecx    # ecx=msg means write the value of variable msg
    mov    $100,%edx     # edx=14 means write 14 bytes of msg
    int    $0x80        # interupt 0x80 invokes OS control function

#   calling write(1,msg_fianl,100)
    mov    $4,%eax      # eax=4 means indirectly call read()
    mov    $1,%ebx      # ebx=0 means write to channel  of Linux
    mov    $msg_final,%ecx    # ecx=msg means write the value of variable msg
    mov    $msg_final_len,%edx     # edx=14 means write 14 bytes of msg
    int    $0x80        # interupt 0x80 invokes OS control function


#   calling write(1,msg_fianl,100)
    mov    $4,%eax      # eax=4 means indirectly call read()
    mov    $1,%ebx      # ebx=0 means write to channel  of Linux
    mov    $name,%ecx    # ecx=msg means write the value of variable msg
    mov    $100,%edx     # edx=14 means write 14 bytes of msg
    int    $0x80        # interupt 0x80 invokes OS control function


# exit(0)
    movl $1, %eax
    xorl %ebx, %ebx
    int  $0x80
