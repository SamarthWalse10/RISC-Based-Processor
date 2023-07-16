
dict = {"ADD": "00000", "SUB": "00001", "MUL": "00010", "NAND": "00011", "LOAD": "00100",
        "STORE": "00101", "BRE": "00110", "BRG": "00111", "BRL": "01000", "JMP": "01001"}


def num_extract(str):
    return int(''.join([i for i in str if i.isdigit() or i == "-"]))


def CompOf2(str):
    n = len(str)
    i = n - 1
    while (i >= 0):
        if (str[i] == '1'):
            break
        i -= 1
    if (i == -1):
        return '1'+str
    k = i - 1
    while (k >= 0):
        if (str[k] == '1'):
            str = list(str)
            str[k] = '0'
            str = ''.join(str)
        else:
            str = list(str)
            str[k] = '1'
            str = ''.join(str)
        k -= 1
    return str


def dec2bin(num):
    binary = format(int(num), 'b').replace("0b", "")
    if binary[0] == "-":
        binary = binary[1:].rjust(len(binary[1:])+1, "0")
        return CompOf2(binary)
    else:
        binary = binary.rjust(len(binary)+1, "0")
        return binary


def numConcat(list_num):
    return "".join([str(i) for i in list_num])


def decode(s):
    s = s.strip().split(" ")
    opcode = s[0].upper()
    if opcode == "ADD" or opcode == "SUB" or opcode == "MUL" or opcode == "NAND":
        dest = dec2bin(num_extract(s[1])).rjust(5, "0")
        src1 = dec2bin(num_extract(s[2])).rjust(5, "0")
        src2 = dec2bin(num_extract(s[3])).rjust(5, "0")
        return numConcat([dict.get(opcode), dest, src1, src2]).ljust(32, "0")
    elif opcode == "LOAD":
        dest = dec2bin(num_extract(s[1])).rjust(5, "0")
        data_mem_addr = dec2bin(num_extract(s[2])).rjust(17, "0")
        return numConcat([dict.get(opcode), dest, "0"*5, data_mem_addr])
    elif opcode == "STORE":
        src = dec2bin(num_extract(s[1])).rjust(5, "0")
        data_mem_addr = dec2bin(num_extract(s[2])).rjust(17, "0")
        return numConcat([dict.get(opcode), "0"*5, src, data_mem_addr])
    elif opcode == "BRE" or opcode == "BRG" or opcode == "BRL" or opcode == "JMP":
        binary = dec2bin(num_extract(s[1]))
        offset = binary.rjust(16, binary[0])
        return numConcat([dict.get(opcode), "0"*11, offset])


program_asm_file = open(
    r"D:\samarth_personal\programming\Verilog\processor_assembler\program.asm", "r")
program_bin_file = open(
    r"D:\samarth_personal\programming\Verilog\processor\processor.srcs\sources_1\new\program.bin", "w")
program_asm_file_lines = program_asm_file.readlines()
program_bin_file_lines = []
for lines in program_asm_file_lines:
    lines = lines.split("//")[0].strip()
    if lines != "":
        program_bin_file_lines.append("{}{}".format(decode(lines), " \n"))
program_bin_file.writelines(program_bin_file_lines)
program_asm_file.close()
program_bin_file.close()



