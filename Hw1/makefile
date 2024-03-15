scanner: scanner.l
	flex scanner.l
	gcc -o scanner lex.yy.c -lfl

clean:
	rm -f lex.yy.c scanner
