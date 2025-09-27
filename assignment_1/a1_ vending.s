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

msg_end:     
      .asciz "end change: "
      end_len = . - msg_end

msg_end_1:
      .asciz " cents"
      end_len_1 = . - msg_end_1
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

# Entering 'd' or 'D' adds 10 to that counter.
   cmpb    $'d',coinchoice
   je      add10
   cmpb    $'D',coinchoice
   je      add10

# Entering 'n' or 'N' adds 5 to that counter.
   cmpb    $'n',coinchoice
   je      add5
   cmpb    $'N',coinchoice
   je      add5
   jmp     call_exit

add25:
    add    $25,counter
    # call itoa(counter,itoa_string) - converts the integer in counter to ascii in itoa_string
    call   itoa		# jump to the label itoa, which will return to next instruction
    # after calling itoa, print out the counter value in itoa_string
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $4,%edx
    int    $0x80
    jmp    main

add10:
    add    $10,counter
    # call itoa(counter,itoa_string) - converts the integer in counter to ascii in itoa_string
    call   itoa         # jump to the label itoa, which will return to next instruction
    # after calling itoa, print out the counter value in itoa_string
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $4,%edx
    int    $0x80
    jmp    main

add5:
    add    $5,counter
    # call itoa(counter,itoa_string) - converts the integer in counter to ascii in itoa_string
    call   itoa         # jump to the label itoa, which will return to next instruction
    # after calling itoa, print out the counter value in itoa_string
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $4,%edx
    int    $0x80
    jmp    main


# exit here
call_exit:
    # print "end change: "
    mov $4, %eax
    mov $1, %ebx
    mov $msg_end, %ecx
    mov $12, %edx
    int $0x80

    # convert counter to ascii
    call itoa

    # skip leading spaces
    lea itoa_string, %esi
skip_spaces:
    cmpb $' ', (%esi)
    jne  print_number
    inc  %esi
    jmp  skip_spaces

print_number:
    lea itoa_string+4, %edi   # end of buffer
    sub %esi, %edi            # length = end - start
    mov %edi, %edx            # edx = length
    mov $4, %eax
    mov $1, %ebx
    mov %esi, %ecx
    int $0x80

    # print " cents"
    mov $4, %eax
    mov $1, %ebx
    mov $msg_end_1, %ecx
    mov $6, %edx              # if you define " cents" with leading space
    int $0x80

#   Function itoa() to convert integer variable counter's value to ASCII characters, placed in variable itoa_string.
itoa:
#   copy counter to %eax to prepare for division
    mov    counter,%eax
#   copy four spaces to itoa_string
    movl   $0x20202020,itoa_string
#   point %edi index register to the last byte of itoa_string, think:
#   char *itoa_string="    ";
#   char *edi = &itoa_string[3];
    lea    itoa_string+3,%edi
itoa_loop:
    mov    $0,%edx
    idivl  ten
    addl   $'0',%edx	# convert from binary 0 (or 1-9) to '0' (or '1'-'9')
    movb   %dl,(%edi)	# think: *(edi) = '0'
    dec    %edi		# think: edi--;
    cmpl   $0,%eax
    jg     itoa_loop
    ret			# ret: returns/jumps to the instruction after CALL itoa