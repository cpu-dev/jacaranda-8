#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <stdint.h>

// #define DEBUG

typedef enum {
    MOV = 0,
    ADD,
    AND,
    OR,
    NOT,
    SLL,
    SRL,
    SRA,
    CMP,
    JE,
    JMP,
    LDIH,
    LDIL,
    LD,
    ST
} inst_t;

typedef enum {
    R0,
    R1,
    R2,
    R3
} reg_t;

int
opcode(char *mnemonic)
{
    if(!strncmp(mnemonic, "mov", 3))
        return MOV;
    if(!strncmp(mnemonic, "add", 3))
        return ADD;
    if(!strncmp(mnemonic, "and", 3))
        return AND;
    if(!strncmp(mnemonic, "or", 2))
        return OR;
    if(!strncmp(mnemonic, "not", 3))
        return NOT;
    if(!strncmp(mnemonic, "sll", 3))
        return SLL;
    if(!strncmp(mnemonic, "srl", 3))
        return SRL;
    if(!strncmp(mnemonic, "sra", 3))
        return SRA;
    if(!strncmp(mnemonic, "cmp", 3))
        return CMP;
    if(!strncmp(mnemonic, "je", 2))
        return JE;
    if(!strncmp(mnemonic, "jmp", 3))
        return JMP;
    if(!strncmp(mnemonic, "ldih", 4))
        return LDIH;
    if(!strncmp(mnemonic, "ldil", 4))
        return LDIL;
    if(!strncmp(mnemonic, "ld", 2))
        return LD;
    if(!strncmp(mnemonic, "st", 2))
        return ST;
    return -1;
}

int
rs(char *p)
{
#ifdef DEBUG
    printf("arguments(rs): %s\n", p);
#endif
    return strtol(++p, &p, 10);
}

int
imm(char *p)
{
#ifdef DEBUG
    printf("arguments(imm): %s\n", p);
#endif
   return strtol(p, &p, 10);
}

int
rdrs(char *p)
{
#ifdef DEBUG
    printf("arguments(rd/rs): %s\n", p);
#endif
    int rd, rs;
    rd = strtol(++p, &p, 10);
    while(isspace(*p) || *p == ',')
        ++p;
    rs = strtol(++p, &p, 10);
    return (rd << 2) + rs;
}

int
main(void)
{
    char buf[256];
    char *p;
    int inst;
    FILE *in, *out;

    printf("FILE name: ");
    scanf("%s", buf);

    if((in = fopen(buf, "r")) == NULL) {
        puts("file open error!");
        return -1;
    }

    if((out = fopen("out.bin", "wb")) == NULL) {
        puts("file open error!");
        return -1;
    }

    while(fgets(buf, 256, in) != NULL) {
        if(*buf == '\n') continue;
        p = buf;
        while(isspace(*p)) ++p;
        if(!strncmp(p, "//", 2)) continue;
        inst = opcode(p);
#ifdef DEBUG
        printf("instruction number: %d\n", inst);
#endif
        while(isalpha(*p)) ++p;
        while(isspace(*p)) ++p;
        switch(inst) {
            case -1:
                printf("invalid instruction!!!\n");
                return -1;
            case JE:
            case JMP:
                fprintf(out, "%1x%1x", inst, rs(p));
                break;
            case LDIH:
            case LDIL:
                fprintf(out, "%1x%1x", inst, imm(p));
                break;
            default:
                fprintf(out, "%1x%1x", inst, rdrs(p));
                break;
        }
    }
    fprintf(out, "\n");
    fclose(in);
    fclose(out);
    return 0;
}

