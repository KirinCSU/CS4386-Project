#ifndef STRUCTS_H
#define STRUCTS_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

enum Types
{
	INTT,
	BOOLT,
};

struct SymbolRec
{
	char* name;
	enum Types type;
	union
	{
		int integer;
		int boolean;
	} value;
	struct SymbolRec* next;
};

struct StatementSequence;

struct Expression;

struct Factor
{
	int factorType;
	union
	{
		char* identifier;
		int num;
		char* boollit;
		struct Expression* expression;
	};
};

struct Term
{
	int termType;
	union
	{
		struct Factor* factor;
		struct
		{
			char* op2;
			struct Factor* op2Left;
			struct Factor* op2Right;
		};
	};
};

struct SimpleExpression
{
	int simpleExpressionType;
	union
	{
		struct Term* term;
		struct
		{
			char* op3;
			struct Term* op3Left;
			struct Term* op3Right;
		};
	};
};

struct Expression
{
	int expressionType;
	union
	{
		struct SimpleExpression* simpleExpression;
		struct
		{
			char* op4;
			struct SimpleExpression* op4Left;
			struct SimpleExpression* op4Right;
		};
	};
};

struct WriteInt
{
	struct Expression* expression;
};

struct WhileStatement
{
	struct Expression* expression;
	struct StatementSequence* statementSequence;
};

struct ElseClause
{
	struct StatementSequence* statementSequence;
};

struct IfStatement
{
	struct Expression* expression;
	struct StatementSequence* statementSequence;
	struct ElseClause* elseClause;
};

struct Assignment
{
	char* identifier;
	int assignmentType;
	union
	{
		int readInt;
		struct Expression* expression;
	};
};

struct Statement
{
	int statementType;
	union
	{
		struct Assignment* assignment;
		struct IfStatement* ifStatement;
		struct WhileStatement* whileStatement;
		struct WriteInt* writeInt;
	};
};

struct StatementSequence
{
	struct Statement* statement;
	struct StatementSequence* statementSequence;
};

struct Declarations
{
	char* identifier;
	enum Types type;
	struct Declarations* declarations;
};

struct Program
{
	struct Declarations* declarations;
	struct StatementSequence* statementSequence;
};

#endif
