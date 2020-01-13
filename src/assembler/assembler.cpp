#include<iostream>
#include<fstream>
#include<string>

int opcode_dec(std::string);
int oprand_dec(std::string, std::string);
int ref_label_table(std::string);

int main(int argc, char *argv[]){
    std::string filename = argv[1];
    std::string input;
    int input_size;

    std::ifstream asm_file(filename);
    std::ofstream label_table("label_table");
    std::ofstream bin_file(filename + ".o");
    if(asm_file.fail()){
        std::cerr << "cannnot open file" << std::endl;
        return -1;
    }
    // generate label table
    int cnt = 1;
    while(getline(asm_file, input)){
        input_size = input.size();
        if(input[input_size - 1] == ':'){
            label_table << input + " " + std::to_string(cnt) << std::endl;
            cnt--;
        }
        std::cout << input_size << std::endl;
        cnt++;
    }
    label_table.close();
    asm_file.clear();
    asm_file.seekg(0, std::ios_base::beg);
    
    //generate binary
    while(getline(asm_file, input)){
        std::string opcode;
        std::string oprand1;
        std::string oprand2;
    
        int space_posi[2];
        int j = 0;
    
        std::cout << input << std::endl;
        for(int i = 0; i < input.size(); i++){
            //remove comment
            if(input[i] == '/'){
                input = input.substr(0, i - 1);
                break;
            }
        }

        //先頭の空白を削除
        for(int i = 0;i < input.size(); i++){
            if(std::isspace(input[i]) == 0){
                input = input.substr(i + 1);
                break;
            }
        }

        for(int i = 0;i < input.size(); i++){
            if(std::isspace(input[i])){
            }else if(input[i] == ','){
            }else{

            }
        }

        /*for(int i = 0; i < input.size(); i++){  //あとでトークナイザ変更する
            if(input[i] == ' '){
                opcode = input.substr(0, i);
                space_posi[j] = i;
                j++;
            }
        }*/
        oprand1 = j == 2 ? input.substr(space_posi[0] + 1, space_posi[1]) 
                         : input.substr(space_posi[0] + 1);
        oprand2 = j == 2 ? input.substr(space_posi[1] + 1) : "";
        j = 0;

        std::cout << "[DEBUG]" << opcode << std::endl;
        std::cout << "[DEBUG]" << oprand1 << std::endl;
        std::cout << "[DEBUG]" << oprand2 << std::endl;

        //decode elements
        int opcode_bin, oprand1_bin, oprand2_bin;
        opcode_bin = opcode_dec(opcode);
        oprand1_bin = oprand_dec(oprand1, opcode);
        oprand2_bin = oprand_dec(oprand2, opcode);

        int bin;
        bin = (opcode_bin << 4) | (oprand1_bin << 2) | oprand2_bin;
        
        //write binary
        bin_file << bin << std::endl;
    }
    bin_file.close();
    asm_file.close();
}

int oprand_dec(std::string oprand, std::string opcode){
    int oprand_bin;
    if(opcode == ""){
        oprand_bin = 0;
    }else if(opcode == "je" || opcode == "jmp"){
        oprand_bin = ref_label_table(oprand);
    }else if(opcode == "ldih" || opcode == "ldil"){
        oprand_bin = std::stoi(oprand, nullptr, 16);
    }else{
        if(oprand == "r0"){
            oprand_bin = 0x0;
        }else if(oprand == "r1"){
            oprand_bin = 0x1;
        }else if(oprand == "r2"){
            oprand_bin = 0x2;
        }else if(oprand == "r3"){
            oprand_bin = 0x3;
        }else{
            std::cerr << "不正なオペランドです -> " << oprand << std::endl;
            return -1;
        }
    }
    return oprand_bin;
}

int opcode_dec(std::string opcode){
    int opcode_bin;
    if(opcode == "mov"){
        opcode_bin = 0x0;
    }else if(opcode == "add"){
        opcode_bin = 0x1;
    }else if(opcode == "sub"){
        opcode_bin = 0x2;
    }else if(opcode == "and"){
        opcode_bin = 0x3;
    }else if(opcode == "or"){
        opcode_bin = 0x4;
    }else if(opcode == "not"){
        opcode_bin = 0x5;
    }else if(opcode == "sll"){
        opcode_bin = 0x6;
    }else if(opcode == "srl"){
        opcode_bin = 0x7;
    }else if(opcode == "sra"){
        opcode_bin = 0x8;
    }else if(opcode == "cmp"){
        opcode_bin = 0x9;
    }else if(opcode == "je"){
        opcode_bin = 0xa;
    }else if(opcode == "jmp"){
        opcode_bin = 0xb;
    }else if(opcode == "ldih"){
        opcode_bin = 0xc;
    }else if(opcode == "ldil"){
        opcode_bin = 0xd;
    }else if(opcode == "ld"){
        opcode_bin = 0xe;
    }else if(opcode == "st"){
        opcode_bin = 0xf;
    }else{
        std::cerr << "不正なオペコードです -> " << opcode << std::endl;
        return -1;
    }
    return opcode_bin;
}

int ref_label_table(std::string oprand){
    std::ifstream label_table("label_table");
    std::string input;
    int oprand_bin;
    std::string label;
    std::string index;
    while(getline(label_table, input)){
        for(int i = 0; i < input.size(); i++){
            if(input[i] == ' '){
                label = input.substr(0, i - 1);
                index = input.substr(i);
                break;
            }
        }
        if(label == oprand){
            label_table.close();
            return std::stoi(index);
        }
    }
    std::cerr << "This label was not found -> " << label << std::endl;
    return -1;
}
