all:
	bison -d -o FP.tab.c FP.y
	gcc -c -g -I.. FP.tab.c
	flex -o lex.yy.c FP.l
	gcc -c -g -I.. lex.yy.c
	gcc -o FP FP.tab.o lex.yy.o -ll
test: all
	./FP < test.lsp
	make clean

clean:
	rm lex.yy.c FP.tab.c FP.tab.h