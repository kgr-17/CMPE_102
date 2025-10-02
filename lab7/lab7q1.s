.global  main
.data
mainmsg:
    .ascii "main here\n"
    mainlen = . - mainmsg
mainbackmsg:
    .ascii "back to main\n"
    mainbacklen = . - mainbackmsg
foomsg:
    .ascii "foo here\n"
    foolen = . - foomsg
foobackmsg:
    .ascii "back to foo\n"
    foobacklen = . - foobackmsg
barmsg:
    .ascii "bar here\n"
    barlen = . - barmsg
barbackmsg:
    .ascii "back to bar\n"
    barbacklen = . - barbackmsg
Liumsg:
    .ascii "Liu here\n"
    Liulen = . - Liumsg
.text
main:
    mov    $4,%eax
    mov    $1,%ebx
    mov    $mainmsg,%ecx
    mov    $mainlen,%edx
    int    $0x80
    call foo
    mov    $4,%eax
    mov    $1,%ebx
    mov    $mainbackmsg,%ecx
    mov    $mainbacklen,%edx
    int    $0x80
    mov    $1,%eax
    mov    $0,%ebx
    int    $0x80
# foo function here...
foo:
    mov    $4,%eax
    mov    $1,%ebx
    mov    $foomsg,%ecx
    mov    $foolen,%edx
    int    $0x80
    call   bar
    mov    $4,%eax
    mov    $1,%ebx
    mov    $foobackmsg,%ecx
    mov    $foobacklen,%edx
    int    $0x80
    ret
# bar function here...
bar:
    mov    $4,%eax
    mov    $1,%ebx
    mov    $barmsg,%ecx
    mov    $barlen,%edx
    int    $0x80
    call   Liu
    mov    $4,%eax
    mov    $1,%ebx
    mov    $barbackmsg,%ecx
    mov    $barbacklen,%edx
    int    $0x80
    ret

Liu:
    mov    $4,%eax
    mov    $1,%ebx
    mov    $Liumsg,%ecx
    mov    $Liulen,%edx
    int    $0x80
    ret