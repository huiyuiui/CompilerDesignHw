parser: scanner.l parser.y 
	flex scanner.l
	byacc -vd parser.y
	gcc -o parser lex.yy.c y.tab.c -lfl
	
clean:
	rm -f lex.yy.c y.tab.h y.tab.c y.output parser