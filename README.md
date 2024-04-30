Compile Commands:\

flex analyzer.l\
bison -d parser.y\
gcc lex.yy.c parser.tab.c -o parser -lfl\

using program:\

./parser program_1binut.txt main.c\
gcc main.c -o testProgram\

