.global  main
.data
iarray: .long 10,20,30,40,50,60,70,80,90,100
.text 
main:
    movl $0,%ecx                # ecx used as the sum counter
    movl $0,%esi                # esi used as the index
loop:
    addl $4, %esi
    addl iarray(%esi),%ecx      # ecx = ecx + iarray(esi)
    addl $4, %esi               # esi = esi + 4
    cmpl $10*4,%esi             # Has esi reached the end of iarray?
    jl   loop                   # not yet, repeat
#exit 
    mov    $1,%eax
    mov    $0,%ebx
    int    $0x80