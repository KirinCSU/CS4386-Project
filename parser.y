%{
#include "structs.h"
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>

int yylex();
int yyerror(const char* p)
{
	printf("%s", p);
}

struct SymbolRec* symbolTable = NULL;
const char* enumStrings[2] = {"int", "bool"};
struct Program* programMain;
%}

%union
{
char* sym;
int num;
enum Types typesU;
struct Program* programU;
struct Declarations* declarationsU;
struct StatementSequence* statementSequenceU;
struct Statement* statementU;
struct Assignment* assignmentU;
struct IfStatement* ifStatementU;
struct ElseClause* elseClauseU;
struct WhileStatement* whileStatementU;
struct WriteInt* writeIntU;
struct Expression* expressionU;
struct SimpleExpression* simpleExpressionU;
struct Term* termU;
struct Factor* factorU;
};

%token <num> NUM;
%token <sym> BOOLLIT;
%token <sym> IDENT;
%token <sym> LP RP ASGN SC OP2 OP3 OP4 IF THEN ELSE BEGN END WHILE DO PROGRAM VAR INT AS BOOL WRITEINT READINT;

%type <programU> program;
%type <declarationsU> declarations;
%type <typesU> type;
%type <statementSequenceU> statementSequence;
%type <statementU> statement;
%type <assignmentU> assignment;
%type <ifStatementU> ifStatement;
%type <elseClauseU> elseClause;
%type <whileStatementU> whileStatement;
%type <writeIntU> writeInt;
%type <expressionU> expression;
%type <simpleExpressionU> simpleExpression;
%type <termU> term;
%type <factorU> factor;

%start program

%%

program: PROGRAM declarations BEGN statementSequence END
{
	struct Program* p = malloc(sizeof(struct Program));
	p->declarations = $2;
	p->statementSequence = $4;
	programMain = p;
	printf("program\n");
};

declarations: VAR IDENT AS type SC declarations
{
	struct Declarations* p = malloc(sizeof(struct Declarations));
	p->identifier = strdup($2);
	p->type = $4;
	p->declarations = $6;
	$$ = p;
	printf("declarations: var %s as %s\n", p->identifier, enumStrings[(int)p->type]);
}
|
{
	$$ = NULL;
};

type: INT
{
	$$ = INTT;
}
| BOOL
{
	$$ = BOOLT;
};

statementSequence: statement SC statementSequence
{
	struct StatementSequence* p = malloc(sizeof(struct StatementSequence));
	p->statement = $1;
	p->statementSequence = $3;
	$$ = p;
	printf("statementSequence: statement\n");
}
|
{
	$$ = NULL;
};

statement: assignment
{
	struct Statement* p = malloc(sizeof(struct Statement));
	p->statementType = 0;
	p->assignment = $1;
	$$ = p;
	printf("statement: assignment\n");
}
| ifStatement
{
	struct Statement* p = malloc(sizeof(struct Statement));
	p->statementType = 1;
	p->ifStatement = $1;
	$$ = p;
	printf("statement: ifStatement\n");
}
| whileStatement
{
	struct Statement* p = malloc(sizeof(struct Statement));
	p->statementType = 2;
	p->whileStatement = $1;
	$$ = p;
	printf("statement: whileStatement\n");
}
| writeInt
{
	struct Statement* p = malloc(sizeof(struct Statement));
	p->statementType = 3;
	p->writeInt = $1;
	$$ = p;
	printf("statement: writeInt\n");
};

assignment: IDENT ASGN expression
{
	struct Assignment* p = malloc(sizeof(struct Assignment));
	p->assignmentType = 0;
	p->identifier = $1;
	p->expression = $3;
	$$ = p;
	printf("assignment: expression\n");
	printf("%s\n", p->identifier);
}
| IDENT ASGN READINT
{
	struct Assignment* p = malloc(sizeof(struct Assignment));
	p->assignmentType = 1;
	p->identifier = $1;
	p->readInt = 1;
	$$ = p;
	printf("assignment: readInt\n");
};

ifStatement: IF expression THEN statementSequence elseClause END
{
	struct IfStatement* p = malloc(sizeof(struct IfStatement));
	p->expression = $2;
	p->statementSequence = $4;
	p->elseClause = $5;
	$$ = p;
	printf("ifStatement\n");
};

elseClause: ELSE statementSequence
{
	struct ElseClause* p = malloc(sizeof(struct ElseClause));
	p->statementSequence = $2;
	$$ = p;
	printf("elseClause\n");
}
|
{
	$$ = NULL;
};

whileStatement: WHILE expression DO statementSequence END
{
	struct WhileStatement* p = malloc(sizeof(struct WhileStatement));
	p->expression = $2;
	p->statementSequence = $4;
	$$ = p;
	printf("whileStatement\n");
};

writeInt: WRITEINT expression
{
	struct WriteInt* p = malloc(sizeof(struct WriteInt));
	p->expression = $2;
	$$ = p;
	printf("writeInt\n");
};

expression: simpleExpression
{
	struct Expression* p = malloc(sizeof(struct Expression));
	p->expressionType = 0;
	p->simpleExpression = $1;
	$$ = p;
	printf("expression: simpleExpression\n");
}
| simpleExpression OP4 simpleExpression
{
	struct Expression* p = malloc(sizeof(struct Expression));
	p->expressionType = 1;
	p->op4 = strdup($2);
	p->op4Left = $1;
	p->op4Right = $3;
	$$ = p;
	printf("expression: OP4\n");
};

simpleExpression: term OP3 term
{
	struct SimpleExpression* p = malloc(sizeof(struct SimpleExpression));
	p->simpleExpressionType = 1;
	p->op3 = strdup($2);
	p->op3Left = $1;
	p->op3Right = $3;
	$$ = p;
	printf("simpleExpression: OP3\n");
}
| term
{
	struct SimpleExpression* p = malloc(sizeof(struct SimpleExpression));
	p->simpleExpressionType = 0;
	p->term = $1;
	$$ = p;
	printf("simpleExpression: term\n");
};

term: factor OP2 factor
{
	struct Term* p = malloc(sizeof(struct Term));
	p->termType = 1;
	p->op2 = strdup($2);
	p->op2Left = $1;
	p->op2Right = $3;
	$$ = p;
	printf("term: OP2\n");
}
| factor
{
	struct Term* p = malloc(sizeof(struct Term));
	p->termType = 0;
	p->factor = $1;
	$$ = p;
	printf("term factor\n");
};

factor: IDENT
{
	struct Factor* p = malloc(sizeof(struct Factor));
	p->factorType = 0;
	p->identifier = $1;
	$$ = p;
	printf("factor: IDENT: %s\n", $1);
}
| NUM
{
	struct Factor* p = malloc(sizeof(struct Factor));
	p->factorType = 1;
	p->num = $1; //$1
	$$ = p;
	printf("factor: NUM: %d\n", $1);
}
| BOOLLIT
{
	struct Factor* p = malloc(sizeof(struct Factor));
	p->factorType = 2;
	p->boollit = strdup($1);
	$$ = p;
	printf("factor: BOOLLIT: %s\n", $1);
}
| LP expression RP
{
	struct Factor* p = malloc(sizeof(struct Factor));
	p->factorType = 3;
	p->expression = $2;
	$$ = p;
	printf("factor: expression\n");
};

%%

void addSymbol(enum Types type, char* name)
{
	struct SymbolRec* entry = symbolTable;
	if(entry != NULL)
	{
		while(entry->next != NULL)
		{
			entry = entry->next;
		}
		entry->next = malloc(sizeof(struct SymbolRec));
		entry->next->name = strdup(name);
		entry->next->type = type;
		entry->next->next = NULL;
	}
	else
	{
		entry = malloc(sizeof(struct SymbolRec));
		entry->name = name;
		entry->type = type;
		entry->next = NULL;

		symbolTable = entry;
	}

}

int setSymbol(char* name, int value)
{
	struct SymbolRec* entry = symbolTable;
	while(entry != NULL)
	{
		if(strcmp(entry->name, name) == 0)
		{
			if(entry->type == INTT)
			{
				entry->value.integer = value;
			}
			else
			{
				entry->value.boolean = value;
			}
			return 0;
		}
		entry = entry->next;
	}
	return 1;
}

int hasSymbol(char* name)
{
	struct SymbolRec* entry = symbolTable;
	while(entry != NULL)
	{
		if(strcmp(entry->name, name) == 0)
		{
			return 1;
		}
		entry = entry->next;
	}
	return 0;
}

int isInt(char* name)
{
	struct SymbolRec* entry = symbolTable;
	while(entry != NULL)
	{
		if(strcmp(entry->name, name) == 0)
		{
			if(entry->type == INTT)
			{
				return 1;
			}
		}
		entry = entry->next;
	}
	return 0;
}

void printExpression(FILE* yyout, struct Expression* expressionP);

void printFactor(FILE* yyout, struct Factor* factorP)
{

	if(factorP->factorType == 0)
	{	
		if(!hasSymbol(factorP->identifier))
		{
			printf("Syntax Error: Variable not declared! %s\n", factorP->identifier);
		}
		fprintf(yyout, "%s", factorP->identifier);
	}
	else if(factorP->factorType == 1)
	{
		fprintf(yyout, "%d", factorP->num);
	}
	else if(factorP->factorType == 2)
	{
		fprintf(yyout, "%s", factorP->boollit);
	}
	else if(factorP->factorType == 3)
	{
		fprintf(yyout, "(");
		printExpression(yyout, factorP->expression);
		fprintf(yyout, ")");
	}
}

void printTerm(FILE* yyout, struct Term* termP)
{
	
	if(termP->termType == 0)
	{
		printFactor(yyout, termP->factor);
	}
	else
	{
		printFactor(yyout, termP->op2Left);
		fprintf(yyout, "%s", termP->op2);
		printFactor(yyout, termP->op2Right);
	}
}

void printSimpleExpression(FILE* yyout, struct SimpleExpression* simpleExpressionP)
{
	if(simpleExpressionP->simpleExpressionType == 0)
	{
		printTerm(yyout, simpleExpressionP->term);
	}
	else
	{
		printTerm(yyout, simpleExpressionP->op3Left);
		fprintf(yyout, "%s", simpleExpressionP->op3);
		printTerm(yyout, simpleExpressionP->op3Right);
	}
}

void printExpression(FILE* yyout, struct Expression* expressionP)
{
	if(expressionP->expressionType == 0)
	{
		printSimpleExpression(yyout, expressionP->simpleExpression);
	}
	else if(expressionP->expressionType == 1)
	{
		printSimpleExpression(yyout, expressionP->op4Left);
		fprintf(yyout, "%s", expressionP->op4);
		printSimpleExpression(yyout, expressionP->op4Right);
	}
}

void printStatements(FILE* yyout, struct StatementSequence* statementSequenceP)
{
	while(statementSequenceP != NULL)
	{
		if(statementSequenceP->statement->statementType == 0)
		{
			struct Assignment* assignmentP = statementSequenceP->statement->assignment;
			if(assignmentP->assignmentType == 1)
			{
				if(!hasSymbol(assignmentP->identifier))
				{
					printf("Syntax Error: Variable not declared! %s\n", assignmentP->identifier);
					return 0;
				}
				if(!isInt(assignmentP->identifier))
				{
					printf("Syntax Error: Type mismatch! %s\n", assignmentP->identifier);
				}

				fprintf(yyout, "{\n");
				fprintf(yyout, "int i; scanf(\"%%d\", &i);");
				fprintf(yyout, "%s = i;\n", assignmentP->identifier);
				fprintf(yyout, "}\n");
			}
			else
			{	
				if(!hasSymbol(assignmentP->identifier))
				{
					printf("Syntax Error: Variable not declared! %s\n", assignmentP->identifier);
					return 0;
				}
				if(!isInt(assignmentP->identifier))
				{
					printf("Syntax Error: Type mismatch! %s\n", assignmentP->identifier);
				}

				fprintf(yyout, "%s = ", assignmentP->identifier);
				printExpression(yyout, assignmentP->expression);
				fprintf(yyout, ";\n");
			}
		}
		else if(statementSequenceP->statement->statementType == 1)
		{
			struct IfStatement* ifStatementP = statementSequenceP->statement->ifStatement;
			fprintf(yyout, "if(");
			printExpression(yyout, ifStatementP->expression);
			fprintf(yyout, ")\n");
			fprintf(yyout, "{\n");
			printStatements(yyout, ifStatementP->statementSequence);
			fprintf(yyout, "}\n");
			fprintf(yyout, "else\n");
			fprintf(yyout, "{\n");
			if(ifStatementP->elseClause)
			{
				printStatements(yyout, ifStatementP->elseClause->statementSequence);
			}
			fprintf(yyout, "\n");
			fprintf(yyout, "}\n");
		}
		else if(statementSequenceP->statement->statementType == 2)
		{
			struct WhileStatement* whileStatementP = statementSequenceP->statement->whileStatement;
			fprintf(yyout, "while(");
			printExpression(yyout, whileStatementP->expression);
			fprintf(yyout, ")\n");
			fprintf(yyout, "{\n");
			printStatements(yyout, whileStatementP->statementSequence);
			fprintf(yyout, "\n}\n"); //?
		}
		else if(statementSequenceP->statement->statementType == 3)
		{
			struct WriteInt* writeIntP = statementSequenceP->statement->writeInt;
			fprintf(yyout, "printf(\"%%d\\n\", ");
			printExpression(yyout, writeIntP->expression);
			fprintf(yyout, ");\n");
		}
		statementSequenceP = statementSequenceP->statementSequence;
	}
}

int main(int argc, char **argv)
{
	if(argc != 3)
	{
		printf("Needs TCLFile CFile\n");
		return 0;
	}

	extern FILE* yyin;
	extern FILE* yyout;
	yyin = fopen(argv[1], "r");
	yyout = fopen(argv[2], "w");

	yyparse();

	printf("Success\n");

	fprintf(yyout, "#include <stdio.h>\n");
	fprintf(yyout, "int main() \n");
	fprintf(yyout, "{\n");

	//Print Declarations
	struct Declarations* declarationsP = programMain->declarations;

	while(declarationsP != NULL)
	{

		if(hasSymbol(declarationsP->identifier))
		{
			printf("Syntax Error: Variable already exists! %s\n", declarationsP->identifier);
			return 0;
		}
		else
		{
			addSymbol(declarationsP->type, declarationsP->identifier);
			if(declarationsP->type == INTT)
			{
				fprintf(yyout, "int %s;\n", declarationsP->identifier);
			}
			else
			{
				fprintf(yyout, "bool %s;\n", declarationsP->identifier);
			}
		}
		declarationsP = declarationsP->declarations;
	}


	//Print StatementSequence
	struct StatementSequence* statementSequenceP = programMain->statementSequence;

	printStatements(yyout, statementSequenceP);

	fprintf(yyout, "return 0;\n");
	fprintf(yyout, "}\n");

	fclose(yyin);
	fclose(yyout);

	return 0;
}
