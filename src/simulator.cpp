
#include<iostream>
#include<bitset>

uint8_t reg[4] = {0, 0, 0, 0};
uint8_t pc = 0;
uint8_t ram[129];
uint8_t rom[111] = {0xc0
    , 0xd7
    , 0x03
    , 0xc0
    , 0xd0
    , 0xf3
    , 0x03
    , 0xd1
    , 0xf3
    , 0xc0
    , 0xd1
    , 0x07
    , 0x0b
    , 0xc0
    , 0xd0
    , 0xef
    , 0x93
    , 0xc1
    , 0xdd
    , 0xa3
    , 0x16
    , 0xd1
    , 0xf7
    , 0x06
    , 0xeb
    , 0x13
    , 0xc0
    , 0xdd
    , 0xb3
    , 0x00
    , 0xc1
    , 0xdd
    , 0xb3
};
bool flag;

// ldil 3 : reg[3] = 3
// mov 0 3: reg[0] = reg[3]
// ldil 5 : reg[3] = 4
// mov 1 3: reg[1] = reg[3]
// jmp 1  : pc = reg[1]

int main(){
    uint8_t op, rs, rd, imm;
    uint8_t instr;
    int cnt = 0;

    while(1){
        char enter = 0;
        //fetch & decode
        op = rom[pc] >> 4;
        rs = 0x03 & rom[pc];
        rd = (0x0d & rom[pc]) >> 2;
        imm = 0x0f & rom[pc];
        //execute & writeback
        switch(op){
            case 0x0:
                reg[rd] = reg[rs];
                pc++;
                break;
            case 0x1:
                reg[rd] += reg[rs];
                pc++;
                break;
            case 0x2:
                reg[rd] -= reg[rs];
                pc++;
                break;
            case 0x3:
                reg[rd] &= reg[rs];
                pc++;
                break;
            case 0x4:
                reg[rd] |= reg[rs];
                pc++;
                break;
            case 0x5:
                reg[rd] = ~reg[rs];
                pc++;
                break;
            case 0x6:
                reg[rd] = reg[rd] << reg[rs];
                pc++;
                break;
            case 0x7:
                reg[rd] = reg[rd] >> reg[rs];
                pc++;
                break;
            case 0x8:
                reg[rd] = reg[rd] >> reg[rs];
                pc++;
                break;
            case 0x9:
                flag = reg[rd] == reg[rs];
                pc++;
                break;
            case 0xa:
                if(flag){
                    pc = reg[rs];
                    flag = false;
                }else{
                    pc++;
                }
                break;
            case 0xb:
                pc = reg[rs];
                break;
            case 0xc:
                reg[3] = reg[3] || (imm << 4);
                pc++;
                break;
            case 0xd:
                reg[3] = imm;
                pc++;
                break;
            case 0xe:
                reg[rd] = ram[reg[rs]];
                pc++;
                break;
            case 0xf:
                ram[reg[rs]] = reg[rd];
                pc++;
                break;
        }
        cnt++;
        printf("pc = %x\n", pc);
        printf("op = %x\n", op);
        printf("reg[0] = %x\n", reg[0]);
        printf("reg[1] = %x\n", reg[1]);
        printf("reg[2] = %x\n", reg[2]);
        printf("reg[3] = %x\n", reg[3]);
        printf("mem[0] = %x\n", ram[0]);
        printf("mem[1] = %x\n", ram[1]);
        printf("imm = %x\n", imm);
        printf("flag = %x\n\n", flag);
    }

        return 0;
}
