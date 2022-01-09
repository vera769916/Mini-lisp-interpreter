%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	int yylex(void);
	void yyerror(const char *message);

	char* varname[100];
	int var_value_table[100];
	int varcount = 0;
    
%}

%code requires {
	typedef struct Node Node;
	struct Node{
		int ival;
		int bval;
		char* str;
	};
}

%union{
    int ival;
    char* str;
    int bval;
    Node node;
}

%token <bval> bool_val
%token <ival> number
%token <str> id
%token <str> mod_
%token <str> and_
%token <str> or_
%token <str> not_
%token <str> print_num
%token <str> print_bool
%token <str> define
%token <str> if_
%token <str> lambda

%type <node> STMT STMTS PRINT_STMT DEF_STMT EXP
%type <node> NUM_OP PLUS PLUS_EXP MINUS MULTIPLY MULTIPLY_EXP DIVIDE MODULUS
%type <node> GREATER SMALLER EQUAL EQUAL_EXP LOGICAL_OP AND_OP AND_EXP OR_OP OR_EXP NOT_OP
%type <node> IF_EXP VARIABLE

%left and_ or_
%left not_ '='
%left '<' '>'
%left '+' '-'
%left '*' '/' mod_
%left '(' ')'
%%

PROGRAM
	: STMTS { }
	;

STMTS 
	: STMT STMTS { }
	| STMT { }
	;

STMT
	: EXP { $$ = $1; }
	| DEF_STMT { $$ = $1; }
	| PRINT_STMT { $$ = $1; }
	;

PRINT_STMT 
	: '(' print_num EXP ')' { printf("%d\n", $3.ival); }
	| '(' print_bool EXP ')' { 
		if ($3.bval == 1)
			printf("#t\n");
		else
			printf("#f\n");
	}
	;

EXP
	: bool_val { $$.bval = $1; }
	| number { $$.ival = $1; }
	| VARIABLE  { $$ = $1; }
	| NUM_OP  { $$ = $1; }
	| LOGICAL_OP  { $$ = $1; }
	| IF_EXP  { $$ = $1; }
	;

NUM_OP
	: PLUS { $$ = $1; }
	| MINUS { $$ = $1; }
	| MULTIPLY { $$ = $1; }
	| DIVIDE { $$ = $1; }
	| MODULUS { $$ = $1; }
	| GREATER { $$ = $1; }
	| SMALLER { $$ = $1; }
	| EQUAL { $$ = $1; }
	;

PLUS
	: '(' '+' EXP PLUS_EXP ')' { $$.ival = $3.ival + $4.ival; }
	;

PLUS_EXP
	: EXP PLUS_EXP { $$.ival = $1.ival + $2.ival; }
	| EXP { $$ = $1; }
	;

MINUS
	: '(' '-' EXP EXP ')' { $$.ival = $3.ival - $4.ival; }
	;

MULTIPLY
	: '(' '*' EXP MULTIPLY_EXP ')' { $$.ival = $3.ival * $4.ival; }
	;

MULTIPLY_EXP
	: EXP MULTIPLY_EXP { $$.ival = $1.ival * $2.ival; }
	| EXP { $$ = $1; }
	;

DIVIDE
	: '(' '/' EXP EXP ')' { $$.ival = $3.ival / $4.ival; }
	;

MODULUS
	: '(' mod_ EXP EXP ')' { $$.ival = $3.ival % $4.ival; }
	;

GREATER
	: '(' '>' EXP EXP ')' { $$.bval = ($3.ival > $4.ival); }
	;

SMALLER
	: '(' '<' EXP EXP ')' { $$.bval = ($3.ival < $4.ival); }
	;

EQUAL
	: '(' '=' EXP EQUAL_EXP ')' { $$.bval = ($3.ival == $4.ival); }
	;

EQUAL_EXP
	: EXP EQUAL_EXP { $$.bval = ($1.ival == $2.ival); }
	| EXP { $$ = $1; }
	;

LOGICAL_OP
	: AND_OP { $$ = $1; }
	| OR_OP { $$ = $1; }
	| NOT_OP { $$ = $1; }
	;

AND_OP
	: '(' and_ EXP AND_EXP ')' { $$.bval = ($3.bval && $4.bval); }
	;

AND_EXP
	: EXP AND_EXP { $$.bval = ($1.bval && $2.bval); }
	| EXP { $$ = $1; }
	;

OR_OP
	: '(' or_ EXP OR_EXP ')' { $$.bval = ($3.bval || $4.bval); }
	;

OR_EXP
	: EXP OR_EXP { $$.bval = ($1.bval || $2.bval); }
	| EXP { $$ = $1; }
	;

NOT_OP
	: '(' not_ EXP ')' { $$.bval = !($3.bval); }
	;

IF_EXP
	: '(' if_ EXP EXP EXP ')' {
		if ($3.bval == 0) {
			$$.bval = $5.bval;
			$$.ival = $5.ival;
		}
		else {
			$$.bval = $4.bval;
			$$.ival = $4.ival;
		}
	}
	;

DEF_STMT
	: '(' define VARIABLE EXP ')' {
		varname[varcount] = $3.str;
		var_value_table[varcount++] = $4.ival;
	}
	;

VARIABLE
	: id { 
		int i;
		for (i = 0; i < varcount; i++) {
			if (strcmp(varname[i], $1) == 0) { //var have been declare
				$$.str = $1;
				$$.ival = var_value_table[i];
				break;
			}
		}
		if (i >= varcount)  //not fount in var table
			$$.str = $1;
	}
	;

%%

void yyerror(const char *message) {
    printf("Syntax error\n");
    exit(0);
}

int main(void) {

    yyparse();

    return 0;
}
