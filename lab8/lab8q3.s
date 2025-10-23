#
# This is the skeleton program for CMPE 102 assignment 1
#
# gcc -g vending.s -o vending.exe
#
.global  main
.data
ten: .long 10
itoa_string: .ascii "    "
msg:
    .ascii "\nenter coin choice (q/Q,d/D,n/N):" # length 34
    len = . - msg 	# setting len to current position - position of msg = 34
coinchoice:
    .ascii "    "
counter: .long 0
.text
main:
#   similar to eax = write(1,"\nenter coin choice (q/Q,d/D,n/N):",34)
    mov    $4,%eax
    mov    $1,%ebx
    mov    $msg,%ecx
    mov    $len,%edx
    int    $0x80
#   similar to eax = read(0,&coinchoice,2)
    mov    $3,%eax
    mov    $0,%ebx
    mov    $coinchoice,%ecx
    mov    $2,%edx
    int    $0x80

#   if coinchoice == 'q' jump to add25 to add 25 to counter and print the new value
    cmpb   $'q',coinchoice
    je     add25
#   if coinchoice == 'Q' jump to add25 to add 25 to counter and print the new value
    cmpb   $'Q',coinchoice
    je     add25
    jmp    main
add25:
    add    $25,counter
    # call itoa(counter,itoa_string) - converts the integer in counter to ascii in itoa_string
    push   $itoa_string
    push   counter
    push   ten
    call   itoa	
    add    $12,%esp		# jump to the label itoa, which will return to next instruction
    # after calling itoa, print out the counter value in itoa_string
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $4,%edx
    int    $0x80
    jmp     main
# exit here
call_exit:
    mov    $1,%eax
    mov    $0,%ebx
    int    $0x80

#   Function itoa() to convert integer variable counter's value to ASCII characters, placed in variable itoa_string.
itoa:
#   copy counter to %eax to prepare for division
#   copy four spaces to itoa_string
#   point %edi index register to the last byte of itoa_string, think:
#   char *itoa_string="    ";
#   char *edi = &itoa_string[3];
    mov    8(%esp), %eax          # eax = value to convert
    mov    12(%esp), %edi         # edi = buf pointer
    movl   $0x20202020, (%edi)    # write "    " into the 4-byte buffer
    add    $3, %edi               # edi -> last byte (index 3)

    mov    4(%esp), %ecx          # ecx = base (10)





itoa_loop:
    mov    $0,%edx
    idivl  %ecx
    addl   $'0',%edx	# convert from binary 0 (or 1-9) to '0' (or '1'-'9')
    movb   %dl,(%edi)	# think: *(edi) = '0'
    dec    %edi		# think: edi--;
    cmpl   $0,%eax
    jg     itoa_loop
    ret			# ret: returns/jumps to the instruction after CALL itoa
