#include<iostream>
#include<bitset>
#include<fstream>
#include <cstdio>

uint8_t reg[4] = {0, 0, 0, 0};
uint8_t pc = 0;
uint8_t ram[256];
uint8_t rom[256];
bool flag;

// ldil 3 : reg[3] = 3
// mov 0 3: reg[0] = reg[3]
// ldil 5 : reg[3] = 4
// mov 1 3: reg[1] = reg[3]
// jmp 1  : pc = reg[1]

int main(int argc, char *argv[]){
    uint8_t op, rs, rd, imm;
    uint8_t instr;
    int cnt;
    std::ifstream fin(argv[1], std::ios::binary);
    uint8_t inst_reader;

    if(!fin) {
        std::cout << "file open error!" << std::endl;
        return -1;
    }

    cnt = 0;
    while(!fin.eof()) {
        fin.read((char *)&inst_reader, sizeof(uint8_t));
        rom[cnt++] = inst_reader;
    }

    cnt = 0;
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
        printf("tx_data = %x\n", ram[253]);
    }

        return 0;
}
