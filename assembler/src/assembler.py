from lark import Lark
from lark import Transformer
from sys import argv, stderr, stdout
from enum import IntEnum, unique
from docopt import docopt


def build_parser(path: str):
    with open(path, 'r') as f:
        return Lark(f.read())

@unique
class Opcodes(IntEnum):
    ADD = 0
    ADDI = 0x40
    NAND = 0x10
    NANDI = 0x50
    XOR = 0x20
    XORI = 0x60
    LOAD = 0x70
    STORE = 0x78
    BRANCH = 0x80
    LOADBYTE = 0x08


class Serializer(Transformer):
    def __init__(self):
        self.seq = 0
        self.instructions = []
        self.symbols = {}

    @staticmethod
    def _numparse(item):
        if isinstance(item, list):
            num = item[0]
        elif isinstance(item, str):
            num = item
        else:
            print(f"Unknown type for _numparse: {item}", file=stderr)
            exit(1)
        if len(num) < 2:
            rv = int(num)
        else:
            if num[1] == 'b':
                rv = int(num[2:], 2)
            elif num[1] == 'x':
                rv = int(num[2:], 16)
            else:
                rv = int(num)
        return rv

    @staticmethod
    def _regparse(item):
        if isinstance(item, str):
            reg = item
        else:
            print(f"Unknown type for _regparse: {item}", file=stderr)
            exit(1)
        if reg[0] != 'r':
            print(f"Illegal register: {item}", file=stderr)
            exit(1)
        return int(reg[1:])

    def immediate_value(self, item):
        return Serializer._numparse(item)

    def BRANCH_IMMEDIATE(self, item):
        return Serializer._numparse(item)

    def BYTE_IMMEDIATE(self, item):
        return Serializer._numparse(item)

    def IMMEDIATE_OPCODE(self, item):
        item = item.lower()
        if item == 'addi':
            return Opcodes.ADDI
        if item == 'xori':
            return Opcodes.XORI
        if item == 'nandi':
            return Opcodes.NANDI
        print(f"Unknown immediate opcode: {item}", file=stderr)
        exit(1)


    def REGISTER_OPCODE(self, item):
        item = item.lower()
        if item == 'add':
            return Opcodes.ADD
        if item == 'xor':
            return Opcodes.XOR
        if item == 'nand':
            return Opcodes.NAND
        if item == 'load':
            return Opcodes.LOAD
        print(f"Unknown register opcode: {item}", file=stderr)
        exit(1)

    def store_instruction(self, item):
        rv = (Opcodes.STORE, Serializer._regparse(item[0]), self.seq)
        self.seq += 1
        return rv

    def LABEL_IDENTIFIER(self, item):
        return str(item)

    def branch_instruction(self, item):
        target = item[0].children[0]
        if isinstance(target, str):
            if target in self.symbols:
                target = self.symbols[target]
        rv = (Opcodes.BRANCH, target, self.seq)
        self.seq += 1
        return rv

    def immediate_instruction(self, item):
        rv = (item[0], item[1], self.seq)
        self.seq += 1
        return rv

    def register_instruction(self, item):
        rv = (item[0], Serializer._regparse(item[1]), self.seq)
        self.seq += 1
        return rv

    def loadbyte_instruction(self, item):
        rv = (Opcodes.LOADBYTE, item[0], self.seq)
        self.seq += 2
        return rv

    def label(self, item):
        slabel = item[0]
        if slabel in self.symbols:
            print(f'Label {slabel} used twice', file=stderr)
            exit(1)
        self.symbols[slabel] = self.seq

    def instruction(self, item):
        self.instructions.append(item)

    def program(self, item):
        # Replace target labels with addrseses
        def settargets(inst):
            if inst[0][0] == Opcodes.BRANCH and isinstance(inst[0][1], str):
                tgt = inst[0][1]
                if not (tgt in self.symbols):
                    print(f"Branch to non existen label: {tgt}",
                          file=stderr)
                    exit(1)
                tgt = self.symbols[tgt]
                return (inst[0][0], tgt, inst[0][2])
            return inst[0]

        self.instructions = list(map(settargets, self.instructions))

    def start(self, item):
        return self.instructions
                

def binarize(instruction):
    opcode = int(instruction[0].real)
    if instruction[0] != Opcodes.LOADBYTE:
        arg = instruction[1]
        rv = [opcode | arg]
    else:
        arg = instruction[1]
        rv = [opcode, arg]
    return rv


docopts = f'''assembler
usage:
    {argv[0]} [-b] <assembly-file>
    {argv[0]} [-b] <assembly-file> <output-file>

options:
    -b              Write as binary
'''

if __name__ == '__main__':
    args = docopt(docopts)
    asmparser = build_parser('assembly.lark')

    with open(args['<assembly-file>']) as f:
        tree = asmparser.parse(f.read())

    serial = Serializer().transform(tree)
    _binary = list(map(binarize, serial))
    binary = []
    for bi in _binary:
        for b in bi:
            binary.append(b)
    if args['-b']:
        binary = bytes(binary)
        stdwrite = stdout.buffer.write
    else:
        def printhex(l):
            for ll in l:
                print(f'{ll:02x}')
        stdwrite = printhex


    if args['<output-file>'] is not None:
        with open(args['<output-file>'], 'wb') as f:
            f.write(binary)
    else:
        stdwrite(binary)
