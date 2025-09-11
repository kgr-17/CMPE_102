.global  main
.data
student_id: .long 0
.text
main:
  # part_1
  movl $15547376,student_id
  movl student_id, %eax
  movl %eax, %ebx
  imull %ebx

  #part_2
  movl student_id, %eax
  negl %eax
  cdq
  movl $11, %ebx
  idiv %ebx
  ret

