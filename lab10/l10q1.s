#
# This is the skeleton program for CMPE 102 assignment 2
#
# gcc -g sjsusimulator.s -o sjsusimulator.exe
#
.global  main
.data
ten: .long 10
counter: .long 0
itob_string: .ascii "                                  \n"
sign: .ascii " "
itoa_string: .ascii "          \n"
sjsuprompt: .ascii "(sjsu) "
instruction: .ascii "                "
ilen: .long 0
alu: .long 0
.text
main:
#   similar to eax = write(1,"(sjsu) "
    mov    $4,%eax
    mov    $1,%ebx
    mov    $sjsuprompt,%ecx
    mov    $7,%edx
    int    $0x80
#   similar to eax = read(0,instruction,16)
    mov    $3,%eax
    mov    $0,%ebx
    mov    $instruction,%ecx
    mov    $16,%edx
    int    $0x80
    dec    %eax
    mov    %eax,ilen
    cmpl   $0x20766f6d,instruction	# cmpl "mov ",instruction in hex
    je     do_mov
    cmpl   $0x20646461,instruction	# cmpl "add ",instruction in hex
    je     do_add
    cmpl   $0x206c756d,instruction	# cmpl "mul ",instruction in hex
    je     do_mul
    jmp     main
do_mov:
    pushl $instruction+4
    call atoi
    add $4,%esp

    mov    %eax,alu			# placing eax to variable alu
    mov    %eax,counter
    call   itoa				# calling itoa() to convert alu to string
    mov    %eax,counter			# placing eax to variable counter
#   eax = write(1,itoa_string,11)
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $11,%edx
    int    $0x80
    jmp    main				# jumps back to label main for another instruction
do_add:
    pushl $instruction+4
    call atoi
    add $4,%esp

    add    %eax,alu			# add operand to alu
    movl   alu, %eax			# copy alu to eax
    movl   %eax,counter			# copy eax to counter to be converted to string
#   eax = write(1,itoa_string,11)
    call   itoa
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $11,%edx
    int    $0x80
    jmp    main				# jumps back to label main for another instruction
do_mul:
    pushl $instruction+4
    call atoi
    add $4,%esp

    imul    alu,%eax
    mov    %eax,alu
    mov    %eax,counter
    call   itoa
#   eax = write(1,itoa_string,11)
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $11,%edx
    int    $0x80
    jmp    main				# jumps back to label main for another instruction
# exit here
    mov    $1,%eax
    mov    $0,%ebx
    int    $0x80
#   Function atoi() to convert an ascii string like "mov 125" in variable instruction into binary 125, in variable counter
#   Function itoa() to convert integer variable counter's value to ASCII characters, placed in variable itoa_string.
itoa:
#   copy counter to %eax to prepare for division
    mov    counter,%eax
    cmpl   $0,%eax
    jge    not_negative
    negl   %eax
not_negative:
#   copy 10 spaces to itoa_string
    movl   $0x20202020,itoa_string
    movl   $0x20202020,itoa_string+4
    movw   $0x2020,itoa_string+8
#   point %edi index register to the last byte of itoa_string, think:
#   char *itoa_string="    ";
#   char *edi = &itoa_string[9];
    lea    itoa_string+9,%edi
itoa_loop:
    mov    $0,%edx
    idivl  ten
    addl   $'0',%edx	# convert from binary 0 (or 1-9) to '0' (or '1'-'9')
    movb   %dl,(%edi)	# think: *(edi) = '0'
    dec    %edi		# think: edi--;
    cmpl   $0,%eax
    jg     itoa_loop
    cmpl   $0,counter
    jge    counter_not_negative
    movb   $'-',(%edi)
counter_not_negative:
    ret		

