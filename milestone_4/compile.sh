flex src/lexer.l
bison -d src/parser.y
g++ lex.yy.c parser.tab.c parser.tab.h -o parser
