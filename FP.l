%option noyywrap
%{
    #include "FP.tab.h"
%}
separator [\t\n\r ]
letter [a-z]
digit [0-9]

number (0|[1-9]{digit}*|-[1-9]{digit}*)
id {letter}({letter}|{digit}|'-')*

%%

"+"|"-"|"*"|"/"|">"|"<"|"=" {return(yytext[0]);}
"("|")"  {return yytext[0];}
"mod" {return(mod_);}
"and" {return(and_);}
"or" {return(or_);}
"not" {return(not_);}
"if" {return(if_);}
"define" {return(define);}
"print-num" {return(print_num);}
"print-bool" {return(print_bool);}
"lambda" {return(lambda);}

"#t" {yylval.bval = 1; return(bool_val);}
"#f" {yylval.bval = 0; return(bool_val);}
{number} {yylval.ival = atoi(yytext); return(number);}
{id} {yylval.str = strdup(yytext); return(id);}

\n {}
{separator} { }
. { }

%%