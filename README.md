# Mini-Lisp Interpreter

## Features

### Basic Features

* [x] Syntax Validation
* [x] Print
* [x] Numerical Operations
* [x] Logical Operations
* [x] if Expression
* [x] Variable Definition
* [ ] Function
* [ ] Named Function

### Bonus Features

* [ ] Recursion
* [ ] Type Checking
* [ ] Nested Function
* [ ] First-class Function

## Usage

### Compile

	$ make

or

	$ bison -d -o FP.tab.c FP.y
	$ gcc -c -g -I.. FP.tab.c
	$ flex -o lex.yy.c FP.l
	$ gcc -c -g -I.. lex.yy.c
	$ gcc -o FP FP.tab.o lex.yy.o -ll

### Test

	$ make test

or
	$ ./FP < test.lsp
