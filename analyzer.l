%{
#include "structs.h"
#include "parser.tab.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}

%%
[1-9][0-9]*|0 			{yylval.num = atoi(yytext); return NUM;}
"false"|"true" 			{yylval.sym = strdup(yytext); return BOOLLIT;}
[A-Z][A-Z0-9]* 			{yylval.sym = strdup(yytext); return IDENT;}
"(" 				{yylval.sym = strdup(yytext); return LP;}
")" 				{yylval.sym = strdup(yytext); return RP;}
":=" 				{yylval.sym = strdup(yytext); return ASGN;}
";" 				{yylval.sym = strdup(yytext); return SC;}
"*"|"div"|"mod" 		{yylval.sym = strdup(yytext); return OP2;}
"+"|"-" 			{yylval.sym = strdup(yytext); return OP3;}
"="|"!="|"<"|">"|"<="|">=" 	{yylval.sym = strdup(yytext); return OP4;}
"if" 				{yylval.sym = strdup(yytext); return IF;}
"then" 				{yylval.sym = strdup(yytext); return THEN;}
"else" 				{yylval.sym = strdup(yytext); return ELSE;}
"begin" 			{yylval.sym = strdup(yytext); return BEGN;}
"end" 				{yylval.sym = strdup(yytext); return END;}
"while" 			{yylval.sym = strdup(yytext); return WHILE;}
"do" 				{yylval.sym = strdup(yytext); return DO;}
"program" 			{yylval.sym = strdup(yytext); return PROGRAM;}
"var" 				{yylval.sym = strdup(yytext); return VAR;}
"as" 				{yylval.sym = strdup(yytext); return AS;}
"int" 				{yylval.sym = strdup(yytext); return INT;}
"bool" 				{yylval.sym = strdup(yytext); return BOOL;}
"writeInt" 			{yylval.sym = strdup(yytext); return WRITEINT;}
"readInt" 			{yylval.sym = strdup(yytext); return READINT;}
[ \t\n\r]+
<<EOF>> 			{return 0;}
. 				{printf("unrecognized token: %s\n", yytext); exit(0);}
%%

int yywrap()
{
return 1;
}
