ldih f
ldil a
mov r2, r3 // r2 = INT_VECTOR_ADDR
ldih 1
ldil 0
st r3, r2 // INT_VECTOR_ADDR = r3
ldih f
ldil f
mov r2, r3 // r2 = UFR1
ldih 0
ldil 3
st r3, r2 // UFR1 = 0b00000011
ldih 0
ldil 0
mov r0, r3 // r0 = 0
ldil 1
mov r1, r3 // r1 = 1
ldih f
ldil b
st r0, r3 // LED_ADDR = r0
add r0, r1 // r0 += 1
ldih 1
ldil 1
jmp r3 //loop
ldih f
ldil c
ld r0, r3 // r0 = RX_DATA
// while(busy_flag == 1);
ldih f
ldil d
mov r1, r3 // r1 = UTD;
ldih f
ldil e
ld r2, r3 // r2 = UFR2;
ldih 0
ldil 1
and r2, r3 // r2 = UFR2 & 0b00000001;
cmp r2, r3 // r2 = busy_flag == 1
ldih 1
ldil b
je r3 // je check_busy
st r0, r1 // UTD = r0;
iret
