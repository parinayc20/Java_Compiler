%option yylineno
%option noyywrap
%{
    #include <bits/stdc++.h>
	#include "parser.tab.h"
    using namespace std;
	string text_block;

    void err (const char* s)
    {
        if(s == NULL) {
            printf("Error in memory allocation");
            exit(0);
        }
    }
%}

%s COMMENT_TAIL
%s COMMENT_TAIL_STAR
%s TEXT
%s TEXT1
%s TEXT2

JAVA_DIGIT   [0-9]
NZ_DIGIT     [1-9]
HEX_DIGIT    [0-9a-fA-F]
OCT_DIGIT    [0-7]
BIN_DIGIT    [01]
HEX_NUM      "0"("x"|"X"){HEX_DIGIT}+([_]+{HEX_DIGIT}+)*
UNICODE		 "\\"[u]+{HEX_DIGIT}{4}
HEX_SIG      {HEX_NUM}(".")?|"0"("x"|"X"){HEX_DIGIT}*([_]+{HEX_DIGIT}+)*"."{HEX_DIGIT}+([_]+{HEX_DIGIT}+)*
DIGIT 		 {JAVA_DIGIT}+([_]+{JAVA_DIGIT}+)*
LINE_TERMINATOR  "\r"|"\n"|"\r\n"
WHITE_SPACE  [ \t\f] 
JAVA_LETTER  [a-zA-Z]|"_"|"$"
JAVA_LETTER_DIGIT {JAVA_LETTER}|{JAVA_DIGIT}
KEYWORD "abstract"|"continue"|"for"|"new"|"switchassert"|"default"|"if"|"package"|"synchronized"|"boolean"|"do"|"goto"|"private"|"this"|"break"|"double"|"implements"|"protected"|"throw"|"byte"|"else"|"import"|"public"|"throws"|"case"|"enum"|"instanceof"|"return"|"transient"|"catch"|"extends"|"int"|"short"|"try"|"char"|"final"|"interface"|"static"|"void"|"class"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"while"|"exports"|"opens"|"requires"|"uses"|"module"|"permits"|"sealed"|"var"|"non-sealed"|"provides"|"to"|"with"|"open"|"record"|"transitive"|"yield" 
OCT_ESC			 "\\"({OCT_DIGIT}|{OCT_DIGIT}{2}|[0-3]{OCT_DIGIT}{2})
ESCAPE_SEQ		 "\\"("b"|"s"|"t"|"n"|"f"|"r"|"\""|"'"|"\\")|{UNICODE}|{OCT_ESC}
BOOLEAN_LITERAL "true"|"false"
NULL_LITERAL    "null"
SEPARATORS      "("|")"|"{"|"}"|"["|"]"|";"|","|"."|"..."|"@"|"::"
OPERATORS       "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>="
text_block      \"\"\"(([ \h\t\f]*){LINE_TERMINATOR}(([^\"\\]|(\"[^\"\\])|(\"\"[^\"\\])|{ESCAPE_SEQ})*))\"\"\"

%%

{text_block} {
    string s(yytext);
    s = s.substr(3, s.length() - 6);
    char* st = new char[s.length() + 1];
    strcpy(st, s.c_str());
    yylval.strval = strdup(st);
    return TEXT_BLOCK_LITERAL;
}

<INITIAL>"/*" BEGIN(COMMENT_TAIL);
<COMMENT_TAIL>"*"     BEGIN(COMMENT_TAIL_STAR);
<COMMENT_TAIL>[^*]*   BEGIN(COMMENT_TAIL);
<COMMENT_TAIL_STAR>"*"     BEGIN(COMMENT_TAIL_STAR);
<COMMENT_TAIL_STAR>[^*/]*  BEGIN(COMMENT_TAIL);
<COMMENT_TAIL_STAR>"/"     BEGIN(INITIAL);
"//"[^\r\n]* {}

{WHITE_SPACE} {}
{LINE_TERMINATOR} {}

"import" {
	yylval.strval = strdup(yytext);
    return IMPORT;
}
"package" {
	yylval.strval = strdup(yytext);
    return PACKAGE;
}
"extends" {
	yylval.strval = strdup(yytext);
    return EXTENDS;
}
"implements" {
	yylval.strval = strdup(yytext);
    return IMPLEMENTS;
}
"public" {
	yylval.strval = strdup(yytext);
    return PUBLIC;
}
"private" {
	yylval.strval = strdup(yytext);
    return PRIVATE;
}
"static" {
	yylval.strval = strdup(yytext);
    return STATIC;
}
"new" {
	yylval.strval = strdup(yytext);
    return NEW;
}
"abstract" {
	yylval.strval = strdup(yytext);
    return ABSTRACT;
}
"final" {
	yylval.strval = strdup(yytext);
    return FINAL;
}
"native" {
	yylval.strval = strdup(yytext);
    return NATIVE;
}
"synchronized" {
	yylval.strval = strdup(yytext);
    return SYNCHRONIZED;
}
"transient" {
	yylval.strval = strdup(yytext);
    return TRANSIENT;
}
"volatile" {
	yylval.strval = strdup(yytext);
    return VOLATILE;
}
"super" {
	yylval.strval = strdup(yytext);
    return SUPER;
}
"protected" {
	yylval.strval = strdup(yytext);
    return PROTECTED;
}
"void" {
	yylval.strval = strdup(yytext);
    return VOID;
}
"throws" {
	yylval.strval = strdup(yytext);
    return THROWS;
}
"if" {
	yylval.strval = strdup(yytext);
    return IF;
}
"else" {
	yylval.strval = strdup(yytext);
    return ELSE;
}
"switch" {
	yylval.strval = strdup(yytext);
    return SWITCH;
}
"while" {
	yylval.strval = strdup(yytext);
    return WHILE;
}
"do" {
	yylval.strval = strdup(yytext);
    return DO;
}
"for" {
	yylval.strval = strdup(yytext);
    return FOR;
}
"break" {
	yylval.strval = strdup(yytext);
    return BREAK;
}
"continue" {
	yylval.strval = strdup(yytext);
    return CONTINUE;
}
"return" {
	yylval.strval = strdup(yytext);
    return RETURN;
}
"throw" {
	yylval.strval = strdup(yytext);
    return THROW;
}
"finally" {
	yylval.strval = strdup(yytext);
    return FINALLY;
}
"case" {
	yylval.strval = strdup(yytext);
    return CASE;
}
"default" {
	yylval.strval = strdup(yytext);
    return DEFAULT;
}
"this" {
	yylval.strval = strdup(yytext);
    return THIS;
}
"class" {
	yylval.strval = strdup(yytext);
    return CLASS;
}
"instanceof" {
	yylval.strval = strdup(yytext);
    return INSTANCEOF;
}
"interface" {
	yylval.strval = strdup(yytext);
    return INTERFACE;
}
"byte" {
	yylval.strval = strdup(yytext);
    return BYTE;
}
"short" {
	yylval.strval = strdup(yytext);
    return SHORT;
}
"char" {
	yylval.strval = strdup(yytext);
    return CHAR;
}
"int" {
	yylval.strval = strdup(yytext);
    return INT;
}
"long" {
	yylval.strval = strdup(yytext);
    return LONG;
}
"float" {
	yylval.strval = strdup(yytext);
    return FLOAT;
}
"double" {
	yylval.strval = strdup(yytext);
    return DOUBLE;
}
"boolean" {
	yylval.strval = strdup(yytext);
    return BOOLEAN;
}
"String" {
	yylval.strval = strdup(yytext);
    return STRING;
}

{NULL_LITERAL} {
    yylval.strval = strdup(yytext);
    return NULL_LITERAL;
}

{BOOLEAN_LITERAL} {
    yylval.strval = strdup(yytext);
    return BOOLEAN_LITERAL;
}

{JAVA_LETTER}{JAVA_LETTER_DIGIT}* {
    yylval.strval = strdup(yytext);
    return IDENTIFIER;
}

"0"|{NZ_DIGIT}{JAVA_DIGIT}*([_]+{JAVA_DIGIT}+)*("l"|"L")? {
    yylval.strval = strdup(yytext);
    return INTEGER_LITERAL;
}

{HEX_NUM}("l"|"L")? {
    yylval.strval = strdup(yytext);
    return INTEGER_LITERAL;
}

"0"{OCT_DIGIT}*([_]+{OCT_DIGIT}+)*("l"|"L")? {
    yylval.strval = strdup(yytext);
    return INTEGER_LITERAL;
}

"0"("b"|"B"){BIN_DIGIT}+([_]+{BIN_DIGIT}+)*("l"|"L")? {
    yylval.strval = strdup(yytext);
    return INTEGER_LITERAL;
}

({DIGIT}(".")?{DIGIT}?|"."{DIGIT})(("e"|"E")("+"|"-")?{DIGIT})?("f"|"F"|"d"|"D")? {
    yylval.strval = strdup(yytext);
    return FLOATING_POINT_LITERAL;
}

{HEX_SIG}(("p"|"P")("+"|"-")?{DIGIT})("f"|"F"|"d"|"D")? {
    yylval.strval = strdup(yytext);
    return FLOATING_POINT_LITERAL;
}

"\'"([^\\\'\r\n]|{ESCAPE_SEQ})"\'" {
    string s(yytext);
    s = s.substr(1, s.length() - 2);
    char* st = new char[s.length() + 1];
    strcpy(st, s.c_str());
    yylval.strval = strdup(st);
    return CHARACTER_LITERAL;
}

"\""([^\\\"\r\n]|{ESCAPE_SEQ})*"\"" {
    string s(yytext);
    s = s.substr(1, s.length() - 2);
    char* st = new char[s.length() + 1];
    strcpy(st, s.c_str());
    yylval.strval = strdup(st);
    return STRING_LITERAL;
}

"!=" {
	yylval.strval = strdup(yytext);
    return NOT_EQUAL_TO;
}
"." {
	yylval.strval = strdup(yytext);
    return DOT;
}
"," {
	yylval.strval = strdup(yytext);
    return COMMA;
}
"*" {
	yylval.strval = strdup(yytext);
    return MULTIPLY;
}
"[" {
	yylval.strval = strdup(yytext);
    return SQUARE_OPEN;
}
"]" {
	yylval.strval = strdup(yytext);
    return SQUARE_CLOSE;
}
"(" {
	yylval.strval = strdup(yytext);
    return PAR_OPEN;
}
")" {
	yylval.strval = strdup(yytext);
    return PAR_CLOSE;
}
"{" {
	yylval.strval = strdup(yytext);
    return CURLY_OPEN;
}
"}" {
	yylval.strval = strdup(yytext);
    return CURLY_CLOSE;
}
"?" {
	yylval.strval = strdup(yytext);
    return QUESTION;
}
";" {
	yylval.strval = strdup(yytext);
    return SEMICOLON;
}
":" {
	yylval.strval = strdup(yytext);
    return COLON;
}
"++" {
	yylval.strval = strdup(yytext);
    return INCREMENT;
}
"--" {
	yylval.strval = strdup(yytext);
    return DECREMENT;
}
"!" {
	yylval.strval = strdup(yytext);
    return EXCLAMATION;
}
"~" {
	yylval.strval = strdup(yytext);
    return NEGATION;
}
"+" {
	yylval.strval = strdup(yytext);
    return PLUS;
}
"-" {
	yylval.strval = strdup(yytext);
    return MINUS;
}
"/" {
	yylval.strval = strdup(yytext);
    return DIVIDE;
}
"%" {
	yylval.strval = strdup(yytext);
    return MODULO;
}
"&" {
	yylval.strval = strdup(yytext);
    return BITWISE_AND;
}
"|" {
	yylval.strval = strdup(yytext);
    return BITWISE_OR;
}
"^" {
	yylval.strval = strdup(yytext);
    return BITWISE_XOR;
}
"&&" {
	yylval.strval = strdup(yytext);
    return AND_LOGICAL;
}
"||" {
	yylval.strval = strdup(yytext);
    return OR_LOGICAL;
}
">>>" {
	yylval.strval = strdup(yytext);
    return UNSIGNED_RIGHT_SHIFT;
}
"<<" {
	yylval.strval = strdup(yytext);
    return LEFT_SHIFT;
}
">>" {
	yylval.strval = strdup(yytext);
    return RIGHT_SHIFT;
}
"<" {
	yylval.strval = strdup(yytext);
    return LESS_THAN;
}
">" {
	yylval.strval = strdup(yytext);
    return GREATER_THAN;
}
"<=" {
	yylval.strval = strdup(yytext);
    return LESS_THAN_OR_EQUAL_TO;
}
">=" {
	yylval.strval = strdup(yytext);
    return GREATER_THAN_OR_EQUAL_TO;
}
"==" {
	yylval.strval = strdup(yytext);
    return EQUAL_TO;
}
"=" {
	yylval.strval = strdup(yytext);
    return ASSIGN;
}
"+=" {
	yylval.strval = strdup(yytext);
    return PLUS_ASSIGN;
}
"-=" {
	yylval.strval = strdup(yytext);
    return MINUS_ASSIGN;
}
"*=" {
	yylval.strval = strdup(yytext);
    return MULTIPLY_ASSIGN;
}
"/=" {
	yylval.strval = strdup(yytext);
    return DIVIDE_ASSIGN;
}
"%=" {
	yylval.strval = strdup(yytext);
    return MOD_ASSIGN;
}
"&=" {
	yylval.strval = strdup(yytext);
    return AND_ASSIGN;
}
"|=" {
	yylval.strval = strdup(yytext);
    return OR_ASSIGN;
}
"^=" {
	yylval.strval = strdup(yytext);
    return XOR_ASSIGN;
}
"<<=" {
	yylval.strval = strdup(yytext);
    return LEFT_SHIFT_ASSIGN;
}
">>=" {
	yylval.strval = strdup(yytext);
    return RIGHT_SHIFT_ASSIGN;
}
">>>=" {
	yylval.strval = strdup(yytext);
    return UNSIGNED_RIGHT_SHIFT_ASSIGN;
}

<COMMENT_TAIL,COMMENT_TAIL_STAR,TEXT,TEXT1,TEXT2><<EOF>> {
	cerr << "Line number: " << yylineno << " Illegal Characters" << endl;
    return 0;
}

. {
	cerr << "Line number: " << yylineno << " Illegal Characters" << endl;
    return 0;
}
%%