#
# This is the skeleton program for CMPE 102 assignment 2
#
# gcc -g sjsusimulator.s -o sjsusimulator.exe
#
.global  main
.data
ten: .long 10
counter: .long 0
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
    cmpl   $0x20627573,instruction      # cmpl "sub ",instruction in hex
    je     do_sub
    cmpl   $0x206f7571,instruction      # cmpl "quo ",instruction in hex
    je     do_quo
    jmp    main
do_mov:
    call   atoi				# calling atoi() to convert instruction+4 to binary
    mov    counter,%eax			# placing atoi result from counter to eax
    mov    %eax,alu			# placing eax to variable alu
    call   itoa				# calling itoa() to convert alu to string
#   eax = write(1,itoa_string,11)
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $11,%edx
    int    $0x80
    jmp    main				# jumps back to label main for another instruction
do_add:
    call   atoi
    mov    counter,%eax
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
    call   atoi
    mov    counter,%eax
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
do_sub:
    call   atoi
    mov    counter,%eax
    sub    %eax,alu                     # add operand to alu
    movl   alu, %eax                    # copy alu to eax
    movl   %eax,counter                 # copy eax to counter to be converted to string
#   eax = write(1,itoa_string,11)
    call   itoa
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $11,%edx
    int    $0x80
    jmp    main                         # jumps back to label main for another instruction

do_quo:
    call   atoi
    mov    counter,%eax
    idivl  alu,%eax
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
atoi:
    mov    ilen,%esi			# set esi to the length of instruction variable
    dec    %esi				# decrement by 1 to point at the last byte
    mov    $1,%ebx			# using ebx as the scale factor, starting from 1 or 10^0, then 10^1,10^2,etc
    movl   $0,counter    		# initialize the result counter to 0
atoi_loop: 
    mov    $0,%eax
    movb   instruction(%esi),%al	# eax = instruction[esi]
    subb   $'0',%al			# convert from character like '0' to binary like 0
    imull  %ebx				# multiply eax by the scaling factor in ebx
    add    %eax,counter			# add the value of one digit to the counter
    imull   $10,%ebx,%ebx		# multiply the scaling factor by 10, to get 1,10,100,etc
    dec    %esi				# esi = esi -1, moving to right
    cmpl   $4,%esi			# Have we reached index 4 (the space) of "mov 125"
    jge    atoi_loop			# not yet, jump back
    ret
#   Function itoa() to convert integer variable counter's value to ASCII characters, placed in variable itoa_string.
itoa:
#   copy counter to %eax to prepare for division
    mov    counter,%eax
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
    ret			# ret: returns/jumps to the instruction after CALL itoa