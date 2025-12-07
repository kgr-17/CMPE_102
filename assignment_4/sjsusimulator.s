#
# This is the skeleton program for CMPE 102 assignment 4
#
# gcc sjsusimulator.s itob.c -o sjsusimulator.exe -g
#
.global  main
.data
ten: .long 10
counter: .long 0
itoa_string: .ascii "          \n"
itob_string: .space 40
sjsuprompt: .ascii "\n(sjsu) "
instruction: .space 64
hexdigits:   .ascii "0123456789abcdef"
hex_string:  .ascii "0x00000000\n"     # 2 + 8 + '\n' = 11 bytes
ilen: .long 0
alu: .long 0
memory: .long 0,0,0,0,0,0,0,0   # @0..@7
.text
main:
#   similar to eax = write(1,"(sjsu) \n"
    mov    $4,%eax
    mov    $1,%ebx
    mov    $sjsuprompt,%ecx
    mov    $7,%edx
    int    $0x80
#   similar to eax = read(0,instruction,16)
    mov    $3,%eax
    mov    $0,%ebx
    mov    $instruction,%ecx
    mov    $64,%edx
    int    $0x80
    dec    %eax
    mov    %eax,ilen


#assignment 4
    cmpl   $0x206f7473,instruction      # "sto "
    je     do_sto
    cmpl   $0x0a657661, instruction    # "ave\n"
    je     do_ave
    cmpl   $0x0a78616d, instruction    # "max\n"
    je     do_max
    cmpl   $0x0a6e696d, instruction    # "min\n"
    je     do_min



#assignment 2
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


# assignment 3
    cmpl   $0x20726f72,instruction      # cmpl "ror ",instruction in hex
    je     do_ror
    cmpl   $0x206c6f72,instruction      # cmpl "rol ",instruction in hex
    je     do_rol
    cmpl   $0x0a746f6e,instruction      # cmpl "not\n",instruction in hex
    je     do_not
    cmpl   $0x206c6173,instruction      # cmpl "sal ",instruction in hex
    je     do_sal
    cmpl   $0x20726173,instruction      # cmpl "sar ",instruction in hex
    je     do_sar
    cmpl   $0x20646e61,instruction      # cmpl "and ",instruction in hex
    je     do_and

    cmpl   $0x20726f78,instruction      # "xor "
    je     do_xor
    
    cmpw   $0x726f,instruction      # cmpw "or",instruction in hex
    jne    main                     # jump to main if not "or". this one have to be the last cmpl 
    cmpb   $' ',instruction+2       # cmpb " ",instruction+2, the space after "or"
    je     do_or

    jmp    main





# mov function
do_mov:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_mov

    # operand is @n
    movzx instruction+5, %esi    # load '0'..'7'
    subl  $'0', %esi             # → 0..7
    shll  $2, %esi               # *4
    movl  memory(%esi), %eax     # eax = memory[n]
    movl  %eax, counter          # counter = memory[n]
    jmp   resume_mov

operand_not_memory_mov:
    call   atoi                  # as before
    mov    counter,%eax

resume_mov:
    mov    %eax,alu			# placing eax to variable alu
    call   itoa				# calling itoa() to convert alu to string
#   eax = write(1,itoa_string,11)
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $11,%edx
    int    $0x80

    push   $itob_string
    push   alu
    call   itob
    addl   $8,%esp

    mov    $4, %eax
    mov    $1, %ebx
    mov    $itob_string, %ecx
    mov    $34, %edx
    int    $0x80

    jmp    main				# jumps back to label main for another instruction



# assignment 4

# sto function
do_sto:
    movzx instruction+5,%esi    # move instruction[5] to low byte of esi, clear left 3 bytes to 0s
    subl  $'0',%esi             # convert '0'-'7' to numerical 0-7
    shll $2,%esi                # esi=esi*4
    movl alu,%eax
    movl %eax,memory(%esi)	# move ALU to memory[esi*4]
    jmp main



# ave - average of memory[0..7] -> ALU
do_ave:
    movl  $0, %eax          # sum = 0
    movl  $0, %esi          # i = 0

ave_loop:
    cmpl  $8, %esi          # while (i < 8)
    jge   ave_done_sum
    addl  memory(,%esi,4), %eax
    incl  %esi
    jmp   ave_loop

ave_done_sum:
    cdq                      # sign-extend EAX into EDX
    movl  $8, %ecx
    idivl %ecx               # EAX = sum / 8
    movl  %eax, alu
    movl  %eax, counter

    # print decimal
    call  itoa
    mov   $4, %eax
    mov   $1, %ebx
    mov   $itoa_string, %ecx
    mov   $11, %edx
    int   $0x80

    # print hex
    call  itox
    mov   $4, %eax
    mov   $1, %ebx
    mov   $hex_string, %ecx
    mov   $11, %edx
    int   $0x80

    jmp   main



# max - maximum of memory[0..7] -> ALU
do_max:
    movl  memory, %eax      # max = memory[0]
    movl  $1, %esi          # i = 1

max_loop:
    cmpl  $8, %esi
    jge   max_done
    movl  memory(,%esi,4), %edx   # cur = memory[i]
    cmpl  %eax, %edx              # compare cur with max
    jle   max_skip                # if cur <= max, keep max
    movl  %edx, %eax              # else max = cur
max_skip:
    incl  %esi
    jmp   max_loop

max_done:
    movl  %eax, alu
    movl  %eax, counter

    # print decimal
    call  itoa
    mov   $4, %eax
    mov   $1, %ebx
    mov   $itoa_string, %ecx
    mov   $11, %edx
    int   $0x80

    # print hex
    call  itox
    mov   $4, %eax
    mov   $1, %ebx
    mov   $hex_string, %ecx
    mov   $11, %edx
    int   $0x80

    jmp   main




# min - minimum of memory[0..7] -> ALU
do_min:
    movl  memory, %eax      # min = memory[0]
    movl  $1, %esi          # i = 1

min_loop:
    cmpl  $8, %esi
    jge   min_done
    movl  memory(,%esi,4), %edx   # cur = memory[i]
    cmpl  %eax, %edx              # compare cur with min
    jge   min_skip                # if cur >= min, keep min
    movl  %edx, %eax              # else min = cur
min_skip:
    incl  %esi
    jmp   min_loop

min_done:
    movl  %eax, alu
    movl  %eax, counter

    # print decimal
    call  itoa
    mov   $4, %eax
    mov   $1, %ebx
    mov   $itoa_string, %ecx
    mov   $11, %edx
    int   $0x80

    # print hex
    call  itox
    mov   $4, %eax
    mov   $1, %ebx
    mov   $hex_string, %ecx
    mov   $11, %edx
    int   $0x80

    jmp   main








# assignment 3

#ror function
do_ror:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_ror

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %ecx      # rotate count from memory
    jmp   resume_ror

operand_not_memory_ror:
    call  atoi
    movl  counter, %ecx

resume_ror:
    andl   $31, %ecx            # count %= 32
    movl   alu, %eax            # value to rotate
    rorl   %cl, %eax            # rotate right by CL
    movl   %eax, alu
    movl   %eax, counter        # for itoa()

    call   itoa                 # print decimal in itoa_string
    mov    $4, %eax
    mov    $1, %ebx
    mov    $itoa_string, %ecx
    mov    $11, %edx
    int    $0x80

    # print binary: itob(value, buf)
    push   $itob_string
    push   alu
    call   itob
    addl   $8, %esp

    mov    $4, %eax
    mov    $1, %ebx
    mov    $itob_string, %ecx
    mov    $34, %edx
    int    $0x80

    jmp    main                




#rol function
do_rol:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_rol

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %ecx
    jmp   resume_rol

operand_not_memory_rol:
    call  atoi
    mov   counter, %ecx

resume_rol:
    andl   $31, %ecx            # count %= 32
    mov    alu,%eax             # load ALU value into EAX
    mov    %eax,%edx            # copy ALU value to EDX
    shll   %cl,%eax             # logical shift left by operand bits
    mov    $32,%ebx             # set EBX to 32
    sub    %ecx,%ebx            # calculate 32 - operand
    mov    %ebx,%ecx            # store result back in ECX
    shrl   %cl,%edx             # logical shift right by (32 - operand) bits
    orl    %edx,%eax            # combine the two parts
    mov    %eax,alu             # store result back in ALU
    mov    %eax,counter         # store in counter for itoa()
    call   itoa
    mov    $4,%eax
    mov    $1,%ebx
    mov    $itoa_string,%ecx
    mov    $11,%edx
    int    $0x80

    # print binary representation
    push   $itob_string
    push   alu
    call   itob
    addl   $8,%esp

    mov    $4,%eax
    mov    $1,%ebx
    mov    $itob_string,%ecx
    mov    $34,%edx
    int    $0x80

    jmp    main





#not function
#not function has no operand → no change.
do_not:
    mov    alu, %eax             # load ALU value into EAX
    not    %eax                  # perform bitwise NOT on EAX
    mov    %eax, alu             # store result back in ALU
    mov    %eax, counter         # store in counter for itoa()

    call   itoa                  # print decimal in itoa_string
    mov    $4, %eax
    mov    $1, %ebx
    mov    $itoa_string, %ecx
    mov    $11, %edx
    int    $0x80

    # print binary: itob(value, buf)
    push   $itob_string
    push   alu
    call   itob
    addl   $8, %esp

    mov    $4, %eax
    mov    $1, %ebx
    mov    $itob_string, %ecx
    mov    $34, %edx
    int    $0x80

    jmp    main



# sal function
do_sal:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_sal

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %ecx      # shift count from memory
    jmp   resume_sal

operand_not_memory_sal:
    call  atoi
    mov   counter, %ecx

resume_sal:
    mov    alu, %eax            # load ALU value into EAX
    sall   %cl, %eax            # arithmetic shift left by operand bits
    mov    %eax, alu            # store result back in ALU
    mov    %eax, counter        # store in counter for itoa()

    call   itoa                 # print decimal in itoa_string
    mov    $4, %eax
    mov    $1, %ebx
    mov    $itoa_string, %ecx
    mov    $11, %edx
    int    $0x80

    # print binary: itob(value, buf)
    push   $itob_string
    push   alu
    call   itob
    addl   $8, %esp

    mov    $4, %eax
    mov    $1, %ebx
    mov    $itob_string, %ecx
    mov    $34, %edx
    int    $0x80

    jmp    main




#sar function
do_sar:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_sar

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %ecx
    jmp   resume_sar

operand_not_memory_sar:
    call  atoi
    mov   counter, %ecx

resume_sar:
    mov    alu, %eax            # load ALU value into EAX
    sarl   %cl, %eax            # arithmetic shift right by operand bits
    mov    %eax, alu            # store result back in ALU
    mov    %eax, counter        # store in counter for itoa()

    call   itoa                 # print decimal in itoa_string
    mov    $4, %eax
    mov    $1, %ebx
    mov    $itoa_string, %ecx
    mov    $11, %edx
    int    $0x80

    # print binary: itob(value, buf)
    push   $itob_string
    push   alu
    call   itob
    addl   $8, %esp

    mov    $4, %eax
    mov    $1, %ebx
    mov    $itob_string, %ecx
    mov    $34, %edx
    int    $0x80

    jmp    main





#and function
do_and:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_and

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %eax
    movl  %eax, counter
    jmp   resume_and

operand_not_memory_and:
    call  atoi
    mov   counter, %eax

resume_and:
    and    %eax, alu            # perform bitwise AND with ALU
    mov    alu, %eax            # store result back in EAX
    mov    %eax, counter        # store result in counter for itoa()

    call   itoa                 # print decimal in itoa_string
    mov    $4, %eax
    mov    $1, %ebx
    mov    $itoa_string, %ecx
    mov    $11, %edx
    int    $0x80

    # print binary: itob(value, buf)
    push   $itob_string
    push   alu
    call   itob
    addl   $8, %esp

    mov    $4, %eax
    mov    $1, %ebx
    mov    $itob_string, %ecx
    mov    $34, %edx
    int    $0x80

    jmp    main






#xor function
do_xor:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_xor

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %eax
    movl  %eax, counter
    jmp   resume_xor

operand_not_memory_xor:
    call  atoi
    mov   counter, %eax

resume_xor:
    xor    %eax, alu            # perform bitwise XOR with ALU
    mov    alu, %eax            # store result back in EAX
    mov    %eax, counter        # store result in counter for itoa()

    call   itoa                 # print decimal in itoa_string
    mov    $4, %eax
    mov    $1, %ebx
    mov    $itoa_string, %ecx
    mov    $11, %edx
    int    $0x80

    # print binary: itob(value, buf)
    push   $itob_string
    push   alu
    call   itob
    addl   $8, %esp

    mov    $4, %eax
    mov    $1, %ebx
    mov    $itob_string, %ecx
    mov    $34, %edx
    int    $0x80

    jmp    main




#or function
do_or:
    cmpb  $'@', instruction+3
    jne   operand_not_memory_or

    movzbl instruction+4, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %eax
    movl  %eax, counter
    jmp   resume_or

operand_not_memory_or:
    call  atoi
    mov   counter, %eax

resume_or:
    or     %eax, alu            # perform bitwise OR with ALU
    mov    alu, %eax            # store result back in EAX
    mov    %eax, counter        # store result in counter for itoa()

    call   itoa                 # print decimal in itoa_string
    mov    $4, %eax
    mov    $1, %ebx
    mov    $itoa_string, %ecx
    mov    $11, %edx
    int    $0x80

    # print binary: itob(value, buf)
    push   $itob_string
    push   alu
    call   itob
    addl   $8, %esp

    mov    $4, %eax
    mov    $1, %ebx
    mov    $itob_string, %ecx
    mov    $34, %edx
    int    $0x80

    jmp    main























# assignment 2


# add function
do_add:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_add

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %eax      # EAX = memory[n]
    movl  %eax, counter
    jmp   resume_add

operand_not_memory_add:
    call  atoi
    mov   counter, %eax

resume_add:
    add    %eax,alu			# add operand to alu
    movl   alu, %eax			# copy alu to eax
    movl   %eax,counter			# copy eax to counter to be converted to string
    #  eax = write(1,itoa_string,11)
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


# sub function
do_sub:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_sub

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %eax
    movl  %eax, counter
    jmp   resume_sub

operand_not_memory_sub:
    call  atoi
    mov   counter, %eax

resume_sub:
    sub   %eax, alu               # ALU -= operand
    movl  alu, %eax
    movl  %eax, counter
    call  itoa
    mov   $4,%eax
    mov   $1,%ebx
    mov   $itoa_string,%ecx
    mov   $11,%edx
    int   $0x80

    call  itox
    mov   $4,%eax
    mov   $1,%ebx
    mov   $hex_string,%ecx
    mov   $11,%edx
    int   $0x80

    jmp   main




# mul function
do_mul:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_mul

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %eax      # operand from memory
    movl  %eax, counter
    jmp   resume_mul

operand_not_memory_mul:
    call  atoi
    mov   counter, %eax

resume_mul:
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



# quo function
do_quo:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_quo

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %ebx      # divisor from memory
    jmp   resume_quo

operand_not_memory_quo:
    call  atoi
    mov   counter, %ebx           # divisor from immediate

resume_quo:
    mov   alu, %eax               # dividend in EAX
    cdq                            # sign-extend EAX into EDX
    idivl %ebx                    # EAX = quotient, EDX = remainder
    mov   %eax, alu
    mov   %eax, counter
    call  itoa
    mov   $4,%eax
    mov   $1,%ebx
    mov   $itoa_string,%ecx
    mov   $11,%edx
    int   $0x80

    call  itox
    mov   $4,%eax
    mov   $1,%ebx
    mov   $hex_string,%ecx
    mov   $11,%edx
    int   $0x80

    jmp   main


# rem Function
do_rem:
    cmpb  $'@', instruction+4
    jne   operand_not_memory_rem

    movzbl instruction+5, %esi
    subl  $'0', %esi
    shll  $2, %esi
    movl  memory(%esi), %ebx      # divisor from memory
    jmp   resume_rem

operand_not_memory_rem:
    call  atoi
    mov   counter, %ebx

resume_rem:
    mov   alu, %eax
    cdq
    idivl %ebx                    # EAX = quotient, EDX = remainder
    mov   %edx, alu
    mov   %edx, counter
    call  itoa
    mov   $4,%eax
    mov   $1,%ebx
    mov   $itoa_string,%ecx
    mov   $11,%edx
    int   $0x80

    call  itox
    mov   $4,%eax
    mov   $1,%ebx
    mov   $hex_string,%ecx
    mov   $11,%edx
    int   $0x80

    jmp   main


# sum Function
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
    



















# handler function
#   Function atoi() to convert an ascii string like "mov 125" in variable instruction into binary 125, in variable counter
atoi:
    xor    %esi, %esi          # start at index 0
    mov    ilen, %ecx          # last valid index (no '\n')
    xor    %eax, %eax          # value = 0
    xor    %ebx, %ebx          # sign flag = 0

# skip the mnemonic (letters) until we hit space or tab
.a_skip_mnemonic:
    cmp    %ecx, %esi
    jg     .a_store            # no operand, treat as 0
    movzbl instruction(%esi), %edx
    cmp    $' ', %edx
    je     .a_after_space
    cmp    $9,  %edx           # '\t'
    je     .a_after_space
    inc    %esi
    jmp    .a_skip_mnemonic

# now skip any extra spaces/tabs before the operand
.a_after_space:
    inc    %esi
.a_skip_ws:
    cmp    %ecx, %esi
    jg     .a_store
    movzbl instruction(%esi), %edx
    cmp    $' ', %edx
    je     .bump_ws
    cmp    $9,  %edx
    je     .bump_ws
    jmp    .a_sign_check
.bump_ws:
    inc    %esi
    jmp    .a_skip_ws


# optional sign
.a_sign_check:
    cmp    $'-', %edx
    jne    .a_bin_check
    mov    $1, %ebx            # sign = 1
    inc    %esi
    movzbl instruction(%esi), %edx

# binary prefix 0b / 0B?
.a_bin_check:
    cmp    $'0', %edx
    jne    .a_parse_dec
    cmp    %ecx, %esi
    jge    .a_parse_dec           # no room for +1, treat as decimal
    movzbl instruction+1(%esi), %edx
    cmp    $'b', %edx
    je     .a_parse_bin_start
    cmp    $'B', %edx
    je     .a_parse_bin_start
    jmp    .a_parse_dec


# parse binary: value = (value<<1) + bit
.a_parse_bin_start:
    add    $2, %esi
.a_parse_bin:
    cmp    %ecx, %esi
    jg     .a_apply_sign
    movzbl instruction(%esi), %edx
    cmp    $'0', %edx
    jb     .a_apply_sign
    cmp    $'1', %edx
    ja     .a_apply_sign
    shll   $1, %eax
    sub    $'0', %edx
    add    %edx, %eax
    inc    %esi
    jmp    .a_parse_bin

# parse decimal: value = value*10 + digit
.a_parse_dec:
    cmp    %ecx, %esi
    jg     .a_apply_sign
.a_dec_loop:
    cmp    %ecx, %esi
    jg     .a_apply_sign
    movzbl instruction(%esi), %edx
    cmp    $'0', %edx
    jb     .a_apply_sign
    cmp    $'9', %edx
    ja     .a_apply_sign
    imull  $10, %eax, %eax
    sub    $'0', %edx
    add    %edx, %eax
    inc    %esi
    jmp    .a_dec_loop

# sign and store
.a_apply_sign:
    test   %ebx, %ebx
    jz     .a_store
    negl   %eax
.a_store:
    mov    %eax, counter
    ret

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