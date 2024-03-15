parser: scanner.l parser.y 
	flex scanner.l
	byacc -vd parser.y
	gcc -o parser lex.yy.c y.tab.c code.c -lfl
	
clean:
	rm -f lex.yy.c y.tab.h y.tab.c y.output parser

run:
	./parser < 0.c
	riscv32-unknown-elf-gcc main.c codegen.s
	spike pk a.out