FLEX := flex
CC := gcc
YACC := byacc
FLAG := -lfl
file := Function1.c
all: codegen
	./codegen < $(file) > out.txt
	riscv32-unknown-elf-gcc main.c codegen.S -o sample_prog
	spike pk sample_prog

codegen: lex.yy.c y.tab.c
	$(CC) -o $@ $^ $(FLAG)

lex.yy.c: scanner.l
	$(FLEX) $^

y.tab.c: parser.y
	$(YACC) -d $^
	
validation: sample_prog
	spike pk sample_prog
	
sample_prog: main.c codegen.S
	riscv32-unknown-elf-gcc $^ -o sample_prog
	
check: parser.y
	yacc -v parser.y
clean:
	rm lex.yy.c sample_prog y.tab.h y.tab.c out.txt codegen codegen.S