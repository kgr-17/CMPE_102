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
hexdigits:   .ascii "0123456789abcdef"
hex_string:  .ascii "0x00000000\n"     # 2 + 8 + '\n' = 11 bytes
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
    cmpl   $0x206f7571,instruction      # cmpl "quo ",instruction in hex
    je     do_quo
    cmpl   $0x206d6572,instruction      # cmpl "rem ",instruction in hex
    je     do_rem
    cmpl   $0x206d7573,instruction     # "sum "
    je     do_sum
    cmpl   $0x0a6d7573,instruction     # "sum\n"
    je     do_sum
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


    # print hex line
    call   itox
    mov    $4,%eax
    mov    $1,%ebx
    mov    $hex_string,%ecx
    mov    $11,%edx              # "0x" + 8 + "\n"
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


        # print hex line
    call   itox
    mov    $4,%eax
    mov    $1,%ebx
    mov    $hex_string,%ecx
    mov    $11,%edx              # "0x" + 8 + "\n"
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

        # print hex line
    call   itox
    mov    $4,%eax
    mov    $1,%ebx
    mov    $hex_string,%ecx
    mov    $11,%edx              # "0x" + 8 + "\n"
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

    # print hex line
    call   itox
    mov    $4,%eax
    mov    $1,%ebx
    mov    $hex_string,%ecx
    mov    $11,%edx              # "0x" + 8 + "\n"
    int    $0x80

    jmp    main                         # jumps back to label main for another instruction

do_quo:
    call atoi                 # convert operand to binary -> stored in counter
    mov counter,%ebx              # divisor in EBX
    mov alu,%eax          # dividend in EAX
    cdq                       # sign-extend EAX into EDX (for idiv)
    idivl %ebx                # EAX = EAX / EBX; EDX = remainder
    mov %eax,alu              # save quotient back to ALU
    mov %eax,counter          # also store in counter for itoa()
    call itoa
    mov $4,%eax
    mov $1,%ebx
    mov $itoa_string,%ecx
    mov $11,%edx
    int $0x80


    # print hex line
    call   itox
    mov    $4,%eax
    mov    $1,%ebx
    mov    $hex_string,%ecx
    mov    $11,%edx              # "0x" + 8 + "\n"
    int    $0x80

    jmp main

do_rem:
    call atoi                 # convert operand to binary -> stored in counter
    mov counter,%ebx              # divisor in EBX
    mov alu,%eax          # dividend in EAX
    cdq                       # sign-extend EAX into EDX (for idiv)
    idivl %ebx                # EAX = EAX / EBX; EDX = remainder
    mov %edx,alu              # save quotient back to ALU
    mov %edx,counter          # also store in counter for itoa()
    call itoa
    mov $4,%eax
    mov $1,%ebx
    mov $itoa_string,%ecx
    mov $11,%edx
    int $0x80

    # print hex line
    call   itox
    mov    $4,%eax
    mov    $1,%ebx
    mov    $hex_string,%ecx
    mov    $11,%edx              # "0x" + 8 + "\n"
    int    $0x80

    jmp main


do_sum:
    mov alu,%eax
    mov $0,%edx  #sum = 0

    cmp $0,%eax
    mov $1,%ecx
    mov $-1,%ebx
    jg sum_positive
    jl sum_negative
    jmp sum_done


sum_positive:
    add %ecx,%edx
    add $1,%ecx
    cmp %eax,%ecx
    jle sum_positive
    jmp sum_done

sum_negative:
    add %ebx,%edx
    sub $1,%ebx
    cmp %eax,%ebx
    jge sum_negative
    jmp sum_done

sum_done:
    mov    %edx,alu         # store sum into ALU
    mov    %edx,counter     # store in counter for itoa
    call   itoa
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $11,%edx
    int    $0x80

    # print hex line
    call   itox
    mov    $4,%eax
    mov    $1,%ebx
    mov    $hex_string,%ecx
    mov    $11,%edx              # "0x" + 8 + "\n"
    int    $0x80

    jmp    main
    


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
    mov counter,%eax
    movl $0x20202020,itoa_string
    movl $0x20202020,itoa_string+4
    movw $0x2020,itoa_string+8
    lea itoa_string+9,%edi

    mov $0,%ecx          # clear ECX for sign flag
    test %eax,%eax
    jns itoa_loop_start  # jump if non-negative
    neg %eax             # make it positive
    mov $1,%ecx          # sign flag = 1

itoa_loop_start:
    mov $0,%edx
    idivl ten
    addl $'0',%edx
    movb %dl,(%edi)
    dec %edi
    test %eax,%eax
    jnz itoa_loop_start

    cmp $0,%ecx
    je itoa_done
    movb $'-',(%edi)
    dec %edi

itoa_done:
    ret



# itox(): write ALU as "0x????????\n" into hex_string
itox:
    mov    alu,%eax              # working copy
    mov    $8,%ecx               # 8 hex digits
    lea    hex_string+9,%edi     # point at last digit position

.itox_loop:
    mov    %eax,%edx
    and    $0xF,%edx             # low nibble
    movb   hexdigits(%edx),%dl   # map nibble -> hex char
    movb   %dl,(%edi)            # store char
    dec    %edi
    shr    $4,%eax               # logical shift right, get next nibble
    dec    %ecx
    jnz    .itox_loop
    ret