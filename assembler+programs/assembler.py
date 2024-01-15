# usage: put assembly code in input.txt, and make sure input.txt sit in the same
# folder as this .py file. Then make sure any comment starts at a new line
# and occupy that whole line, make sure to correct all grammeric mistakes given by
# the program. Output of 9 bits machine codes should then be found in mach_code.txt.
def convert_register_to_bin(register, line_number):
    register = register.upper()
    if register.startswith("R") and len(register) == 2:
        reg_num = int(register[1])
        if reg_num >= 0 and reg_num <= 7:
            return format(reg_num, "03b")
    print(f"Error at line {line_number}: Invalid register '{register}'. Register should be in the range R0 to R7.")
    return None


def process_register_instruction(opcode_bin, operands, num_bits, line_number):
    operands = operands.split()

    # Check the number of operands
    if len(operands) != 2:
        print(f"Error at line {line_number}: Invalid number of operands in '{operands}'. Expected 2 operands.")
        return None

    register1 = operands[0].strip()
    register2 = operands[1].strip()

    # Check register format and range
    register1_bin = convert_register_to_bin(register1, line_number)
    register2_bin = convert_register_to_bin(register2, line_number)
    if register1_bin is None or register2_bin is None:
        return None

    # Construct and return machine code
    machine_code = opcode_bin + register1_bin + register2_bin
    return machine_code


def process_single_operand_instruction(opcode_bin, operand, num_bits, line_number):
    operand = operand.strip()

    # Check register format and range
    operand_bin = convert_register_to_bin(operand, line_number)
    if operand_bin is None:
        return None

    # Construct and return machine code
    machine_code = opcode_bin + "00" + operand_bin
    return machine_code

def process_immediate_instruction(opcode_bin, operands, num_bits, num_operands, line_number):
    operands = operands.split()

    # Check the number of operands
    if len(operands) != num_operands:
        print(f"Error at line {line_number}: Invalid number of operands in '{operands}'. Expected {num_operands} operands.")
        return None

    immediate = operands[0].strip()
    immediate_bin = ""

    # Check if immediate has a sign (only for 3-bit operands)
    if num_bits == 3:
        if immediate[0] == "+":
            immediate = immediate[1:]
            immediate_bin += "0"
        elif immediate[0] == "-":
            immediate = immediate[1:]
            immediate_bin += "1"
        else:
            print(f"Error at line {line_number}: Missing sign for immediate '{immediate}'.")
            return None

    # Check immediate range and format
    try:
        immediate = int(immediate)

        if num_bits == 3:
            if immediate not in [1, 2, 3, 4]:
                print(f"Error at line {line_number}: Immediate out of range in '{operands}'. Immediate should be -4, -3, -2, -1, 1, 2, 3, 4.")
                return None
            immediate_bin += format(immediate - 1, f"02b")

        elif num_bits == 5:
            if immediate < 0 or immediate > 31:
                print(f"Error at line {line_number}: Immediate out of range in '{operands}'. Immediate should be in the range 0 to 31.")
                return None
            immediate_bin = format(immediate, f"05b")

        else:
            print(f"Error at line {line_number}: Invalid number of bits for immediate.")
            return None

    except ValueError:
        print(f"Error at line {line_number}: Invalid immediate '{immediate}'. Immediate should be an integer.")
        return None

    # Construct and return machine code
    machine_code = opcode_bin + immediate_bin

    if num_bits == 3:
        machine_code += convert_register_to_bin(operands[1], line_number)


    return machine_code


def process_instruction(instruction, line_number):
    opcode, operands = instruction.split(maxsplit=1)

    if opcode == "ADD":
        return process_register_instruction("000", operands, 3, line_number)
    elif opcode == "MOV":
        return process_register_instruction("111", operands, 3, line_number)
    elif opcode == "XOR":
        return process_single_operand_instruction("0010", operands, 3, line_number)
    elif opcode == "XORB":
        return process_single_operand_instruction("0011", operands, 3, line_number)
    elif opcode == "LW":
        return process_immediate_instruction("0100", operands, 5, 1, line_number)
    elif opcode == "LWI":
        return process_immediate_instruction("0101", operands, 5, 1, line_number)
    elif opcode == "SW":
        return process_immediate_instruction("0110", operands, 5, 1, line_number)
    elif opcode == "EXIT":
        return process_immediate_instruction("0111", operands, 5, 1, line_number)
    elif opcode == "BRE":
        return process_immediate_instruction("1000", operands, 5, 1, line_number)
    elif opcode == "BRNE":
        return process_immediate_instruction("1001", operands, 5, 1, line_number)
    elif opcode == "ADDI":
        return process_immediate_instruction("101", operands, 3, 2, line_number)
    elif opcode == "SHIFTI":
        return process_immediate_instruction("110", operands, 3, 2, line_number)
    else:
        print(f"Error at line {line_number}: Invalid opcode '{opcode}'")
        return None



def assemble(input_file, text_output_file):
    with open(input_file, "r") as input_file:
        instructions = input_file.readlines()

    machine_code_output = []
    assembled_line_count = 0

    for line_number, instruction in enumerate(instructions, start=1):
        instruction = instruction.strip()

        # Skip empty lines and comments
        if not instruction or instruction.startswith("//"):
            if instruction.startswith("//branch destination"):
                try:
                    k_value = int(instruction.split(" ")[-1])
                    print(f"branch destination {k_value} at line {assembled_line_count}")
                except ValueError:
                    print(f"Error at line {line_number}: Invalid integer k in branch destination comment")
            continue

        machine_code = process_instruction(instruction, line_number)

        if machine_code:
            machine_code_output.append(machine_code)
            assembled_line_count += 1

    with open(text_output_file, "w") as text_file:
        text_file.write("\n".join(machine_code_output))

    print("Assembly completed.")

assemble("program1.txt", "program1_mc.txt")
assemble("program2.txt", "program2_mc.txt")
assemble("program3.txt", "program3_mc.txt")
