    ldih 0
    ldil 7
    mov r0, r3
    ldih 0
    ldil 0
    st r0, r3 // mem[0] = 7;
    mov r0, r3 // r0 = 0;
    ldih f
    ldil 8
    st r0, r3 // mem[1] = 0;
    ldih 0
    ldil 1
    mov r1, r3 // r1 = 1;
    mov r2, r3 // r2 = 1;
    ldih 0
    ldil 0 // r3 = 0;
    ld r3, r3 // r3 = mem[0];
    cmp r0, r3
    ldih 2
    ldil 1
    je r3 // if(r0 == mem[0]) jmp end;
    add r1, r2
    ldih f
    ldil 8
    st r1, r3 // mem[1] = r1 + r2;
    mov r1, r2 // r1 = r2;
    ld r2, r3 // r2 = mem[1];
    ldih 0
    ldil 1
    add r0, r3 // r0++;
    ldih 0
    ldil e
    jmp r3
    ldih 2
    ldil 3
    jmp r3

