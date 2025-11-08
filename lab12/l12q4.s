.global MkTwoDimIntArray
.global TwoDimIntArraySet
.global TwoDimIntArrayGet
.global main
.data
TwoDimIntSpace: .zero 4096
TwoDimIntSpaceRow: .long 0
TwoDimIntSpaceCol: .long 0
a: .long 0
.text
main:
  pushl %ebp
  movl  %esp, %ebp
# eax = MkTwoDimIntArray(4,4)
  pushl $4
  pushl $4
  call MkTwoDimIntArray
  addl $8,%esp
# a = eax
  movl %eax,a

# a[0][0] = 0
  pushl $0
  pushl $0
  pushl $0
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

# a[0][1] = 1
  pushl $1
  pushl $1
  pushl $0
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

# a[0][2] = 7
  pushl $7
  pushl $2
  pushl $0
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

# a[0][3] = 4
  pushl $4
  pushl $3
  pushl $0
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

# a[1][0] = 0
  pushl $0
  pushl $0
  pushl $1
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

# a[1][1] = 6
  pushl $6
  pushl $1
  pushl $1
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

# a[1][2] = 8
  pushl $8
  pushl $2
  pushl $1
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

# a[1][3] = 5
  pushl $5
  pushl $3
  pushl $1
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

# a[2][0] = 7
  pushl $7
  pushl $0
  pushl $2
  pushl a
  call TwoDimIntArraySet
  add $16,%esp

  leave
  ret

MkTwoDimIntArray:
  pushl %ebp
  movl  %esp, %ebp
  lea TwoDimIntSpace,%eax       # eax = &TwoDimSpace[0]
  movl 8(%ebp),%ebx
  movl %ebx,TwoDimIntSpaceRow
  movl 12(%ebp),%ebx
  movl %ebx,TwoDimIntSpaceCol
  leave
  ret

TwoDimIntArraySet:
  pushl %ebp
  movl  %esp, %ebp
  movl 8(%ebp),%edi     # edi = &array[0]
  movl 12(%ebp),%eax    # eax = row
  imull TwoDimIntSpaceCol,%eax  # eax = row*Number of Columns
  addl 16(%ebp),%eax    # eax = row*Number of Columns + col index
  shll $2,%eax          # multiply by 4 to account for integer length of 4
  addl %eax,%edi        # edi = &array[0][0] + eax = &array[row][col]
  movl 20(%ebp),%eax    # eax = value
  movl %eax,(%edi)      # array[row][col] = value
  leave
  ret

TwoDimIntArrayGet:
  pushl %ebp
  movl  %esp, %ebp
  movl 8(%ebp),%edi     # edi = &array[0]
  movl 12(%ebp),%eax    # eax = row
  imull TwoDimIntSpaceCol,%eax  # eax = row*Number of Columns
  addl 16(%ebp),%eax    # eax = row*Number of Columns + col index
  shll $2,%eax          # multiply by 4 to account for integer length of 4
  addl %eax,%edi        # edi = &array[0][0] + eax = &array[row][col]
  movl (%edi),%eax      # array[row][col] = value
  leave
  ret