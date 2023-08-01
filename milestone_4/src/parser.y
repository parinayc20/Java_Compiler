%{
#include<bits/stdc++.h>
#include "src/gen_3AC.hpp"
#include "src/gen_x86.hpp"

#define YYDEBUG 1

using namespace std;

extern int yylineno;

vector<string> nodes;
vector<int> line_no;
vector<vector<int>> adj;
int node_count = 0;

vector<string> nodes_copy;
vector<vector<int>> adj_copy;

map<int, int> node_prod;
map<int, node_attr> node_attr_map;


vector<map<string, map<string, string>>> sym_tab;
map<int, int> parent;
map<int, vector<int>> children;
map<string, int> class_map;
map<int, string> class_map_2;
map<int, int> node_to_sym_tab;
map<int, pair<string, int>> node_to_type;
vector<vector<pair<string, map<string, string>>>> func_params;
int curr_sym_tab = 0;
int func_param_ind = -1;
map<int,int> parse_to_ast;

int temp_count;
int label_count;
int offset = 0;
string return_reg = "rax";

map<string, string> type_size;
string curr_class;

// Map for variables and their offsets

int class_offset;
map<string,int> class_offset_map;

int curr_offset;
map<string,int> curr_offset_map;

map<string,int> reg_to_node;

extern int yylex(void);
void yyerror(const char*);

%}

%define parse.error verbose

%union{
    char* strval;
    int intval;
}

%token<strval> INTEGER_LITERAL FLOATING_POINT_LITERAL BOOLEAN_LITERAL CHARACTER_LITERAL STRING_LITERAL TEXT_BLOCK_LITERAL NULL_LITERAL BOOLEAN STRING BYTE SHORT INT LONG CHAR FLOAT DOUBLE SQUARE_OPEN SQUARE_CLOSE DOT PACKAGE SEMICOLON IMPORT PUBLIC PROTECTED PRIVATE STATIC ABSTRACT FINAL NATIVE SYNCHRONIZED TRANSIENT VOLATILE IDENTIFIER CURLY_CLOSE CURLY_OPEN COMMA IMPLEMENTS EXTENDS CLASS ASSIGN THROWS PAR_CLOSE PAR_OPEN VOID SUPER THIS INTERFACE FINALLY CATCH TRY THROW RETURN CONTINUE BREAK FOR DO WHILE DEFAULT CASE COLON SWITCH IF ELSE NEW INCREMENT DECREMENT NEGATION EXCLAMATION LEFT_SHIFT RIGHT_SHIFT UNSIGNED_RIGHT_SHIFT LESS_THAN LESS_THAN_OR_EQUAL_TO GREATER_THAN GREATER_THAN_OR_EQUAL_TO INSTANCEOF EQUAL_TO NOT_EQUAL_TO POWER OR_LOGICAL AND_LOGICAL BITWISE_AND BITWISE_OR BITWISE_XOR BITWISE_NOT QUESTION MULTIPLY_ASSIGN DIVIDE_ASSIGN MOD_ASSIGN PLUS_ASSIGN MINUS_ASSIGN LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN UNSIGNED_RIGHT_SHIFT_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN MINUS PLUS MULTIPLY DIVIDE MODULO;

%type<intval> FloatingPointType VariableDeclarators FormalParameterList BreakStatement MethodInvocation MethodBody MethodDeclaration BlockStatement Interfaces ClassType ForStatement DoStatement ConstantExpression Type ConstructorDeclarator ForStatementNoShortIf MultiplicativeExpression ReferenceType ArgumentList SingleTypeImportDeclaration StaticInitializer MethodHeader PostIncrementExpression RelationalExpression CompilationUnit InterfaceMemberDeclarations SimpleName TryStatement Modifiers Expression ClassTypeList MethodDeclarator ClassBodyDeclarations LocalVariableDeclaration ImportDeclaration ClassBodyDeclaration PrimitiveType EqualityExpression ArrayCreationExpression Name ClassInstanceCreationExpression TypeDeclarations ConstructorBody AndExpression StatementExpression Modifier ClassBody ClassDeclaration SynchronizedStatement UnaryExpression StatementNoShortIf DimExprs SwitchLabels WhileStatement Assignment Statement ConstructorDeclaration AssignmentExpression LabeledStatement InterfaceMemberDeclaration VariableModifier LeftHandSide PostDecrementExpression ClassOrInterfaceType PackageDeclaration Throws AbstractMethodDeclaration PreIncrementExpression VariableDeclaratorId ExclusiveOrExpression IntegralType InclusiveOrExpression StatementExpressionList FormalParameter ArrayAccess Literal ExtendsInterfaces ArrayType LocalVariableDeclarationStatement QualifiedName WhileStatementNoShortIf AdditiveExpression DimExpr ContinueStatement ForUpdate SwitchBlockStatementGroups ShiftExpression ArrayInitializer PostfixExpression IfThenStatement PreDecrementExpression Super ReturnStatement SwitchBlockStatementGroup FieldAccess PrimaryNoNewArray FieldDeclaration VariableInitializer Dims NumericType IfThenElseStatement LabeledStatementNoShortIf ForInit TypeDeclaration Catches ConditionalAndExpression ConstantDeclaration Block VariableInitializers CatchClause VariableDeclarator ClassMemberDeclaration InterfaceBody BlockStatements UnaryExpressionNotPlusMinus ExplicitConstructorInvocation InterfaceDeclaration ImportDeclarations InterfaceType CastExpression ConditionalExpression Primary InterfaceTypeList ThrowStatement ExpressionStatement SwitchBlock AssignmentOperator TypeImportOnDemandDeclaration ConditionalOrExpression Finally StatementWithoutTrailingSubstatement SwitchLabel SwitchStatement IfThenElseStatementNoShortIf EmptyStatement MethodBlock MethodBlockStatement MethodBlockStatements MethodTypeDeclaration;

%start CompilationUnit

%%
Literal : INTEGER_LITERAL
{
     nodes.push_back(string("INTEGER_LITERAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Literal");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| FLOATING_POINT_LITERAL
{
     nodes.push_back(string("FLOATING_POINT_LITERAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Literal");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| CHARACTER_LITERAL
{
     nodes.push_back(string("CHARACTER_LITERAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Literal");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}
| STRING_LITERAL
{
     nodes.push_back(string("STRING_LITERAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Literal");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 3;
}
| TEXT_BLOCK_LITERAL
{
     nodes.push_back(string("TEXT_BLOCK_LITERAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Literal");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 4;
}
| NULL_LITERAL
{
     nodes.push_back(string("NULL_LITERAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Literal");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 5;
}
| BOOLEAN_LITERAL
{
     nodes.push_back(string("BOOLEAN_LITERAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Literal");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 6;
}

Type : PrimitiveType
{
     nodes.push_back("Type");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ReferenceType
{
     nodes.push_back("Type");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

PrimitiveType : NumericType
{
     nodes.push_back("PrimitiveType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| BOOLEAN
{
     nodes.push_back(string("BOOLEAN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("PrimitiveType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| STRING
{
     nodes.push_back(string("STRING"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("PrimitiveType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}

NumericType : IntegralType
{
     nodes.push_back("NumericType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| FloatingPointType
{
     nodes.push_back("NumericType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

IntegralType : BYTE
{
     nodes.push_back(string("BYTE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("IntegralType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| SHORT
{
     nodes.push_back(string("SHORT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("IntegralType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| INT
{
     nodes.push_back(string("INT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("IntegralType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}
| LONG
{
     nodes.push_back(string("LONG"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("IntegralType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 3;
}
| CHAR
{
     nodes.push_back(string("CHAR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("IntegralType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 4;
}

FloatingPointType : FLOAT
{
     nodes.push_back(string("FLOAT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("FloatingPointType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| DOUBLE
{
     nodes.push_back(string("DOUBLE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("FloatingPointType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

ReferenceType : ClassOrInterfaceType
{
     nodes.push_back("ReferenceType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ArrayType
{
     nodes.push_back("ReferenceType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

ClassOrInterfaceType : Name
{
     nodes.push_back("ClassOrInterfaceType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

ClassType : ClassOrInterfaceType
{
     nodes.push_back("ClassType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

InterfaceType : ClassOrInterfaceType
{
     nodes.push_back("InterfaceType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

ArrayType : PrimitiveType SQUARE_OPEN SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ArrayType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| Name SQUARE_OPEN SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ArrayType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}
| ArrayType SQUARE_OPEN SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ArrayType");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 2;
}

Name : SimpleName
{
     nodes.push_back("Name");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| QualifiedName
{
     nodes.push_back("Name");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

SimpleName : IDENTIFIER
{
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("SimpleName");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

QualifiedName : Name DOT IDENTIFIER
{
     nodes.push_back(string("DOT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("QualifiedName");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}

CompilationUnit : PackageDeclaration ImportDeclarations TypeDeclarations
{
     nodes.push_back("CompilationUnit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| PackageDeclaration
{
     nodes.push_back("CompilationUnit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| ImportDeclarations
{
     nodes.push_back("CompilationUnit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| TypeDeclarations
{
     nodes.push_back("CompilationUnit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| PackageDeclaration ImportDeclarations
{
     nodes.push_back("CompilationUnit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}
| PackageDeclaration TypeDeclarations
{
     nodes.push_back("CompilationUnit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 5;
}
| ImportDeclarations TypeDeclarations
{
     nodes.push_back("CompilationUnit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 6;
}

ImportDeclarations : ImportDeclaration
{
     nodes.push_back("ImportDeclarations");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ImportDeclarations ImportDeclaration
{
     nodes.push_back("ImportDeclarations");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

TypeDeclarations : TypeDeclaration
{
     nodes.push_back("TypeDeclarations");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| TypeDeclarations TypeDeclaration
{
     nodes.push_back("TypeDeclarations");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

PackageDeclaration : PACKAGE Name SEMICOLON
{
     nodes.push_back(string("PACKAGE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("PackageDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}

ImportDeclaration : SingleTypeImportDeclaration
{
     nodes.push_back("ImportDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| TypeImportOnDemandDeclaration
{
     nodes.push_back("ImportDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

SingleTypeImportDeclaration : IMPORT Name SEMICOLON
{
     nodes.push_back(string("IMPORT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("SingleTypeImportDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}

TypeImportOnDemandDeclaration : IMPORT Name DOT MULTIPLY SEMICOLON
{
     nodes.push_back(string("IMPORT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("DOT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("MULTIPLY"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("TypeImportOnDemandDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back($2);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back(node_count + 6);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 0;
}

TypeDeclaration : ClassDeclaration
{
     nodes.push_back("TypeDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| InterfaceDeclaration
{
     nodes.push_back("TypeDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| SEMICOLON
{
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("TypeDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}

MethodTypeDeclaration : ClassDeclaration
{
     nodes.push_back("MethodTypeDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| InterfaceDeclaration
{
     nodes.push_back("MethodTypeDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

Modifiers : Modifier
{
     nodes.push_back("Modifiers");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| Modifiers Modifier
{
     nodes.push_back("Modifiers");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

Modifier : PUBLIC
{
     nodes.push_back(string("PUBLIC"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| PROTECTED
{
     nodes.push_back(string("PROTECTED"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| PRIVATE
{
     nodes.push_back(string("PRIVATE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}
| STATIC
{
     nodes.push_back(string("STATIC"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 3;
}
| ABSTRACT
{
     nodes.push_back(string("ABSTRACT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 4;
}
| FINAL
{
     nodes.push_back(string("FINAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 5;
}
| NATIVE
{
     nodes.push_back(string("NATIVE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 6;
}
| SYNCHRONIZED
{
     nodes.push_back(string("SYNCHRONIZED"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 7;
}
| TRANSIENT
{
     nodes.push_back(string("TRANSIENT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 8;
}
| VOLATILE
{
     nodes.push_back(string("VOLATILE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Modifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 9;
}

ClassDeclaration : Modifiers CLASS IDENTIFIER Super Interfaces ClassBody
{
     nodes.push_back(string("CLASS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($4);
     adj[node_count + 4].push_back($5);
     adj[node_count + 4].push_back($6);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| CLASS IDENTIFIER Super Interfaces ClassBody
{
     nodes.push_back(string("CLASS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back($4);
     adj[node_count + 4].push_back($5);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}
| Modifiers CLASS IDENTIFIER Interfaces ClassBody
{
     nodes.push_back(string("CLASS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($4);
     adj[node_count + 4].push_back($5);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 2;
}
| Modifiers CLASS IDENTIFIER Super ClassBody
{
     nodes.push_back(string("CLASS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($4);
     adj[node_count + 4].push_back($5);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 3;
}
| CLASS IDENTIFIER Super ClassBody
{
     nodes.push_back(string("CLASS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back($4);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 4;
}
| CLASS IDENTIFIER Interfaces ClassBody
{
     nodes.push_back(string("CLASS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back($4);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 5;
}
| Modifiers CLASS IDENTIFIER ClassBody
{
     nodes.push_back(string("CLASS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($4);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 6;
}
| CLASS IDENTIFIER ClassBody
{
     nodes.push_back(string("CLASS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($3);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 7;
}

Super : EXTENDS ClassType
{
     nodes.push_back(string("EXTENDS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Super");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

Interfaces : IMPLEMENTS InterfaceTypeList
{
     nodes.push_back(string("IMPLEMENTS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Interfaces");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

InterfaceTypeList : InterfaceType
{
     nodes.push_back("InterfaceTypeList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| InterfaceTypeList COMMA InterfaceType
{
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("InterfaceTypeList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

ClassBody : CURLY_OPEN CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| CURLY_OPEN ClassBodyDeclarations CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ClassBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

ClassBodyDeclarations : ClassBodyDeclaration
{
     nodes.push_back("ClassBodyDeclarations");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ClassBodyDeclarations ClassBodyDeclaration
{
     nodes.push_back("ClassBodyDeclarations");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

ClassBodyDeclaration : ClassMemberDeclaration
{
     nodes.push_back("ClassBodyDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| StaticInitializer
{
     nodes.push_back("ClassBodyDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| ConstructorDeclaration
{
     nodes.push_back("ClassBodyDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| TypeDeclaration
{
     nodes.push_back("ClassBodyDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}

ClassMemberDeclaration : FieldDeclaration
{
     nodes.push_back("ClassMemberDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| MethodDeclaration
{
     nodes.push_back("ClassMemberDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

FieldDeclaration : Modifiers Type VariableDeclarators SEMICOLON
{
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("FieldDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| Type VariableDeclarators SEMICOLON
{
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("FieldDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

VariableDeclarators : VariableDeclarator
{
     nodes.push_back("VariableDeclarators");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| VariableDeclarators COMMA VariableDeclarator
{
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("VariableDeclarators");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

VariableDeclarator : VariableDeclaratorId
{
     nodes.push_back("VariableDeclarator");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| VariableDeclaratorId ASSIGN VariableInitializer	
{	
     nodes.push_back(string("ASSIGN(=)"));	
     line_no.push_back(yylineno);	
     adj.push_back(vector<int>());	
     nodes.push_back("VariableDeclarator");	
     line_no.push_back(yylineno);	
     adj.push_back(vector<int>());	
     adj[node_count + 1].push_back($1);	
     adj[node_count + 1].push_back(node_count + 0);	
     adj[node_count + 1].push_back($3);	
     $$ = node_count + 1;	
     node_count += 2;	
     node_prod[nodes.size() - 1] = 1;	
}

VariableDeclaratorId : IDENTIFIER
{
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("VariableDeclaratorId");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| VariableDeclaratorId SQUARE_OPEN SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("VariableDeclaratorId");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

VariableInitializer : Expression
{
     nodes.push_back("VariableInitializer");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ArrayInitializer
{
     nodes.push_back("VariableInitializer");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

MethodDeclaration : MethodHeader MethodBody
{
     nodes.push_back("MethodDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

MethodHeader : Modifiers Type MethodDeclarator Throws
{
     nodes.push_back("MethodHeader");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     adj[node_count + 0].push_back($4);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| Modifiers VOID MethodDeclarator Throws
{
     nodes.push_back(string("VOID"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("MethodHeader");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     adj[node_count + 2].push_back($4);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| Type MethodDeclarator Throws
{
     nodes.push_back("MethodHeader");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| Modifiers Type MethodDeclarator
{
     nodes.push_back("MethodHeader");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| Type MethodDeclarator
{
     nodes.push_back("MethodHeader");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}
| VOID MethodDeclarator Throws
{
     nodes.push_back(string("VOID"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("MethodHeader");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 5;
}
| Modifiers VOID MethodDeclarator
{
     nodes.push_back(string("VOID"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("MethodHeader");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 6;
}
| VOID MethodDeclarator
{
     nodes.push_back(string("VOID"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("MethodHeader");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 7;
}

MethodDeclarator : IDENTIFIER PAR_OPEN FormalParameterList PAR_CLOSE
{
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("MethodDeclarator");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back($3);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}
| IDENTIFIER PAR_OPEN PAR_CLOSE
{
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("MethodDeclarator");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 1;
}
| MethodDeclarator SQUARE_OPEN SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("MethodDeclarator");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 2;
}

FormalParameterList : FormalParameter
{
     nodes.push_back("FormalParameterList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| FormalParameterList COMMA FormalParameter
{
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("FormalParameterList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

FormalParameter : Type VariableDeclaratorId
{
     nodes.push_back("FormalParameter");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| VariableModifier Type VariableDeclaratorId
{
     nodes.push_back("FormalParameter");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

Throws : THROWS ClassTypeList
{
     nodes.push_back(string("THROWS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Throws");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

ClassTypeList : ClassType
{
     nodes.push_back("ClassTypeList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ClassTypeList COMMA ClassType
{
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ClassTypeList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

MethodBody : MethodBlock
{
     nodes.push_back("MethodBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| SEMICOLON
{
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("MethodBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

StaticInitializer : STATIC Block
{
     nodes.push_back(string("STATIC"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("StaticInitializer");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

ConstructorDeclaration : Modifiers ConstructorDeclarator Throws ConstructorBody
{
     nodes.push_back("ConstructorDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     adj[node_count + 0].push_back($4);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| Modifiers ConstructorDeclarator ConstructorBody
{
     nodes.push_back("ConstructorDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| ConstructorDeclarator Throws ConstructorBody
{
     nodes.push_back("ConstructorDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| ConstructorDeclarator ConstructorBody
{
     nodes.push_back("ConstructorDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}

ConstructorDeclarator : SimpleName PAR_OPEN PAR_CLOSE
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ConstructorDeclarator");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| SimpleName PAR_OPEN FormalParameterList PAR_CLOSE
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ConstructorDeclarator");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

ConstructorBody : CURLY_OPEN ExplicitConstructorInvocation BlockStatements CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ConstructorBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| CURLY_OPEN BlockStatements CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ConstructorBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}
| CURLY_OPEN ExplicitConstructorInvocation CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ConstructorBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 2;
}
| CURLY_OPEN CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ConstructorBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 3;
}

ExplicitConstructorInvocation : THIS PAR_OPEN ArgumentList PAR_CLOSE SEMICOLON
{
     nodes.push_back(string("THIS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("ExplicitConstructorInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back($3);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back(node_count + 6);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 0;
}
| SUPER PAR_OPEN ArgumentList PAR_CLOSE SEMICOLON
{
     nodes.push_back(string("SUPER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("ExplicitConstructorInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back($3);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back(node_count + 6);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 1;
}
| THIS PAR_OPEN PAR_CLOSE SEMICOLON
{
     nodes.push_back(string("THIS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("ExplicitConstructorInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back(node_count + 6);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 2;
}
| SUPER PAR_OPEN PAR_CLOSE SEMICOLON
{
     nodes.push_back(string("SUPER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("ExplicitConstructorInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back(node_count + 6);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 3;
}

InterfaceDeclaration : Modifiers INTERFACE IDENTIFIER ExtendsInterfaces InterfaceBody
{
     nodes.push_back(string("INTERFACE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("InterfaceDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($4);
     adj[node_count + 4].push_back($5);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| Modifiers INTERFACE IDENTIFIER InterfaceBody
{
     nodes.push_back(string("INTERFACE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("InterfaceDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($4);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}
| INTERFACE IDENTIFIER ExtendsInterfaces InterfaceBody
{
     nodes.push_back(string("INTERFACE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("InterfaceDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back($4);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 2;
}
| INTERFACE IDENTIFIER InterfaceBody
{
     nodes.push_back(string("INTERFACE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("InterfaceDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($3);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 3;
}

ExtendsInterfaces : EXTENDS InterfaceType
{
     nodes.push_back(string("EXTENDS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ExtendsInterfaces");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| ExtendsInterfaces COMMA InterfaceType
{
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ExtendsInterfaces");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

InterfaceBody : CURLY_OPEN InterfaceMemberDeclarations CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("InterfaceBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| CURLY_OPEN CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("InterfaceBody");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

InterfaceMemberDeclarations : InterfaceMemberDeclaration
{
     nodes.push_back("InterfaceMemberDeclarations");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| InterfaceMemberDeclarations InterfaceMemberDeclaration
{
     nodes.push_back("InterfaceMemberDeclarations");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

InterfaceMemberDeclaration : ConstantDeclaration
{
     nodes.push_back("InterfaceMemberDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| AbstractMethodDeclaration
{
     nodes.push_back("InterfaceMemberDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

ConstantDeclaration : FieldDeclaration
{
     nodes.push_back("ConstantDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

AbstractMethodDeclaration : MethodHeader SEMICOLON
{
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("AbstractMethodDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

ArrayInitializer : CURLY_OPEN VariableInitializers COMMA CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("ArrayInitializer");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back($2);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}
| CURLY_OPEN VariableInitializers CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ArrayInitializer");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}
| CURLY_OPEN COMMA CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("ArrayInitializer");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 2;
}
| CURLY_OPEN CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ArrayInitializer");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 3;
}

VariableInitializers : VariableInitializer
{
     nodes.push_back("VariableInitializers");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| VariableInitializers COMMA VariableInitializer
{
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("VariableInitializers");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

Block : CURLY_OPEN CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("Block");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| CURLY_OPEN BlockStatements CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("Block");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

BlockStatements : BlockStatement
{
     nodes.push_back("BlockStatements");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| BlockStatements BlockStatement
{
     nodes.push_back("BlockStatements");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

BlockStatement : LocalVariableDeclarationStatement
{
     nodes.push_back("BlockStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| Statement
{
     nodes.push_back("BlockStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

MethodBlock : CURLY_OPEN CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("MethodBlock");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| CURLY_OPEN MethodBlockStatements CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("MethodBlock");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

MethodBlockStatements : MethodBlockStatement
{
     nodes.push_back("MethodBlockStatements");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| MethodBlockStatements MethodBlockStatement
{
     nodes.push_back("MethodBlockStatements");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

MethodBlockStatement : LocalVariableDeclarationStatement
{
     nodes.push_back("MethodBlockStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| Statement
{
     nodes.push_back("MethodBlockStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| MethodTypeDeclaration
{
     nodes.push_back("MethodBlockStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}

LocalVariableDeclarationStatement : LocalVariableDeclaration SEMICOLON
{
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("LocalVariableDeclarationStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

LocalVariableDeclaration : Type VariableDeclarators
{
     nodes.push_back("LocalVariableDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| VariableModifier Type VariableDeclarators
{
     nodes.push_back("LocalVariableDeclaration");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     adj[node_count + 0].push_back($3);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

VariableModifier : FINAL
{
     nodes.push_back(string("FINAL"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("VariableModifier");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

Statement : StatementWithoutTrailingSubstatement
{
     nodes.push_back("Statement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| LabeledStatement
{
     nodes.push_back("Statement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| IfThenStatement
{
     nodes.push_back("Statement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| IfThenElseStatement
{
     nodes.push_back("Statement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| WhileStatement
{
     nodes.push_back("Statement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}
| ForStatement
{
     nodes.push_back("Statement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 5;
}

StatementNoShortIf : StatementWithoutTrailingSubstatement
{
     nodes.push_back("StatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| LabeledStatementNoShortIf
{
     nodes.push_back("StatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| IfThenElseStatementNoShortIf
{
     nodes.push_back("StatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| WhileStatementNoShortIf
{
     nodes.push_back("StatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| ForStatementNoShortIf
{
     nodes.push_back("StatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}

StatementWithoutTrailingSubstatement : Block
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| EmptyStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| ExpressionStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| SwitchStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| DoStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}
| BreakStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 5;
}
| ContinueStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 6;
}
| ReturnStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 7;
}
| SynchronizedStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 8;
}
| ThrowStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 9;
}
| TryStatement
{
     nodes.push_back("StatementWithoutTrailingSubstatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 10;
}

EmptyStatement : SEMICOLON
{
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("EmptyStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

LabeledStatement : IDENTIFIER COLON Statement
{
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("COLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("LabeledStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($3);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}

LabeledStatementNoShortIf : IDENTIFIER COLON StatementNoShortIf
{
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("COLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("LabeledStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($3);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}

ExpressionStatement : StatementExpression SEMICOLON
{
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ExpressionStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

StatementExpression : Assignment
{
     nodes.push_back("StatementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| PreIncrementExpression
{
     nodes.push_back("StatementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| PreDecrementExpression
{
     nodes.push_back("StatementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| PostIncrementExpression
{
     nodes.push_back("StatementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| PostDecrementExpression
{
     nodes.push_back("StatementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}
| MethodInvocation
{
     nodes.push_back("StatementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 5;
}
| ClassInstanceCreationExpression
{
     nodes.push_back("StatementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 6;
}

IfThenStatement : IF PAR_OPEN Expression PAR_CLOSE Statement
{
     nodes.push_back(string("IF"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("IfThenStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back($3);
     adj[node_count + 6].push_back(node_count + 4);
     adj[node_count + 6].push_back($5);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}

IfThenElseStatement : IF PAR_OPEN Expression PAR_CLOSE StatementNoShortIf ELSE Statement
{
     nodes.push_back(string("IF"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("ELSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("IfThenElseStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back($3);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back($5);
     adj[node_count + 8].push_back(node_count + 6);
     adj[node_count + 8].push_back($7);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 0;
}

IfThenElseStatementNoShortIf : IF PAR_OPEN Expression PAR_CLOSE StatementNoShortIf ELSE StatementNoShortIf
{
     nodes.push_back(string("IF"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("ELSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("IfThenElseStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back($3);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back($5);
     adj[node_count + 8].push_back(node_count + 6);
     adj[node_count + 8].push_back($7);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 0;
}

SwitchStatement : SWITCH PAR_OPEN Expression PAR_CLOSE SwitchBlock
{
     nodes.push_back(string("SWITCH"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("SwitchStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back($3);
     adj[node_count + 6].push_back(node_count + 4);
     adj[node_count + 6].push_back($5);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}

SwitchBlock : CURLY_OPEN SwitchBlockStatementGroups SwitchLabels CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("SwitchBlock");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| CURLY_OPEN SwitchBlockStatementGroups CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("SwitchBlock");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}
| CURLY_OPEN SwitchLabels CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("SwitchBlock");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 2;
}
| CURLY_OPEN CURLY_CLOSE
{
     nodes.push_back(string("CURLY_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("CURLY_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("SwitchBlock");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 3;
}

SwitchBlockStatementGroups : SwitchBlockStatementGroup
{
     nodes.push_back("SwitchBlockStatementGroups");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| SwitchBlockStatementGroups SwitchBlockStatementGroup
{
     nodes.push_back("SwitchBlockStatementGroups");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

SwitchBlockStatementGroup : SwitchLabels BlockStatements
{
     nodes.push_back("SwitchBlockStatementGroup");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

SwitchLabels : SwitchLabel
{
     nodes.push_back("SwitchLabels");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| SwitchLabels SwitchLabel
{
     nodes.push_back("SwitchLabels");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

SwitchLabel : CASE ConstantExpression COLON
{
     nodes.push_back(string("CASE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("COLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("SwitchLabel");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| DEFAULT COLON
{
     nodes.push_back(string("DEFAULT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("COLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("SwitchLabel");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

WhileStatement : WHILE PAR_OPEN Expression PAR_CLOSE Statement
{
     nodes.push_back(string("WHILE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("WhileStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back($3);
     adj[node_count + 6].push_back(node_count + 4);
     adj[node_count + 6].push_back($5);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}

WhileStatementNoShortIf : WHILE PAR_OPEN Expression PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("WHILE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("WhileStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back($3);
     adj[node_count + 6].push_back(node_count + 4);
     adj[node_count + 6].push_back($5);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}

DoStatement : DO Statement WHILE PAR_OPEN Expression PAR_CLOSE SEMICOLON
{
     nodes.push_back(string("DO"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("WHILE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($7));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("DoStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back($2);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($5);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 0;
}

ForStatement : FOR PAR_OPEN ForInit SEMICOLON Expression SEMICOLON ForUpdate PAR_CLOSE Statement
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($8));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back($3);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($5);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($7);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($9);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 0;
}
| FOR PAR_OPEN ForInit SEMICOLON SEMICOLON ForUpdate PAR_CLOSE Statement
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($7));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back($3);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 1;
}
| FOR PAR_OPEN SEMICOLON Expression SEMICOLON ForUpdate PAR_CLOSE Statement
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($7));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 2;
}
| FOR PAR_OPEN ForInit SEMICOLON Expression SEMICOLON PAR_CLOSE Statement
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($7));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back($3);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($5);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 3;
}
| FOR PAR_OPEN SEMICOLON SEMICOLON ForUpdate PAR_CLOSE Statement
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($5);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($7);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 4;
}
| FOR PAR_OPEN SEMICOLON Expression SEMICOLON PAR_CLOSE Statement
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($7);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 5;
}
| FOR PAR_OPEN ForInit SEMICOLON SEMICOLON PAR_CLOSE Statement
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back($3);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($7);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 6;
}
| FOR PAR_OPEN SEMICOLON SEMICOLON PAR_CLOSE Statement
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($6);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 7;
}

ForStatementNoShortIf : FOR PAR_OPEN ForInit SEMICOLON Expression SEMICOLON ForUpdate PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($8));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back($3);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($5);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($7);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($9);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 0;
}
| FOR PAR_OPEN ForInit SEMICOLON SEMICOLON ForUpdate PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($7));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back($3);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 1;
}
| FOR PAR_OPEN SEMICOLON Expression SEMICOLON ForUpdate PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($7));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 2;
}
| FOR PAR_OPEN ForInit SEMICOLON Expression SEMICOLON PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($7));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back($3);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($5);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 3;
}
| FOR PAR_OPEN SEMICOLON SEMICOLON ForUpdate PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($5);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($7);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 4;
}
| FOR PAR_OPEN SEMICOLON Expression SEMICOLON PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back($4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($7);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 5;
}
| FOR PAR_OPEN ForInit SEMICOLON SEMICOLON PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back($3);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($7);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 6;
}
| FOR PAR_OPEN SEMICOLON SEMICOLON PAR_CLOSE StatementNoShortIf
{
     nodes.push_back(string("FOR"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("ForStatementNoShortIf");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     adj[node_count + 10].push_back($6);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 7;
}

ForInit : StatementExpressionList
{
     nodes.push_back("ForInit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| LocalVariableDeclaration
{
     nodes.push_back("ForInit");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

ForUpdate : StatementExpressionList
{
     nodes.push_back("ForUpdate");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

StatementExpressionList : StatementExpression
{
     nodes.push_back("StatementExpressionList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| StatementExpressionList COMMA StatementExpression
{
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("StatementExpressionList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

BreakStatement : BREAK IDENTIFIER SEMICOLON
{
     nodes.push_back(string("BREAK"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("BreakStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}
| BREAK SEMICOLON
{
     nodes.push_back(string("BREAK"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("BreakStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

ContinueStatement : CONTINUE IDENTIFIER SEMICOLON
{
     nodes.push_back(string("CONTINUE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("ContinueStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}
| CONTINUE SEMICOLON
{
     nodes.push_back(string("CONTINUE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ContinueStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

ReturnStatement : RETURN Expression SEMICOLON
{
     nodes.push_back(string("RETURN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ReturnStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| RETURN SEMICOLON
{
     nodes.push_back(string("RETURN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ReturnStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

ThrowStatement : THROW Expression SEMICOLON
{
     nodes.push_back(string("THROW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SEMICOLON"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ThrowStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}

SynchronizedStatement : SYNCHRONIZED PAR_OPEN Expression PAR_CLOSE Block
{
     nodes.push_back(string("SYNCHRONIZED"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("SynchronizedStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back($3);
     adj[node_count + 6].push_back(node_count + 4);
     adj[node_count + 6].push_back($5);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}

TryStatement : TRY Block Catches
{
     nodes.push_back(string("TRY"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("TryStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| TRY Block Finally
{
     nodes.push_back(string("TRY"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("TryStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| TRY Block Catches Finally
{
     nodes.push_back(string("TRY"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("TryStatement");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     adj[node_count + 2].push_back($4);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}

Catches : CatchClause
{
     nodes.push_back("Catches");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| Catches CatchClause
{
     nodes.push_back("Catches");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

CatchClause : CATCH PAR_OPEN FormalParameter PAR_CLOSE Block
{
     nodes.push_back(string("CATCH"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("CatchClause");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back($3);
     adj[node_count + 6].push_back(node_count + 4);
     adj[node_count + 6].push_back($5);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}

Finally : FINALLY Block
{
     nodes.push_back(string("FINALLY"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("Finally");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

Primary : PrimaryNoNewArray
{
     nodes.push_back("Primary");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ArrayCreationExpression
{
     nodes.push_back("Primary");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

PrimaryNoNewArray : Literal
{
     nodes.push_back("PrimaryNoNewArray");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| THIS
{
     nodes.push_back(string("THIS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("PrimaryNoNewArray");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| PAR_OPEN Expression PAR_CLOSE
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("PrimaryNoNewArray");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 2;
}
| ClassInstanceCreationExpression
{
     nodes.push_back("PrimaryNoNewArray");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| FieldAccess
{
     nodes.push_back("PrimaryNoNewArray");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}
| MethodInvocation
{
     nodes.push_back("PrimaryNoNewArray");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 5;
}
| ArrayAccess
{
     nodes.push_back("PrimaryNoNewArray");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 6;
}

ClassInstanceCreationExpression : NEW ClassType PAR_OPEN ArgumentList PAR_CLOSE
{
     nodes.push_back(string("NEW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("ClassInstanceCreationExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back($2);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back($4);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 0;
}
| NEW ClassType PAR_OPEN PAR_CLOSE
{
     nodes.push_back(string("NEW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("ClassInstanceCreationExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back($2);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 1;
}

ArgumentList : Expression
{
     nodes.push_back("ArgumentList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ArgumentList COMMA Expression
{
     nodes.push_back(string("COMMA"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ArgumentList");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

ArrayCreationExpression : NEW PrimitiveType DimExprs
{
     nodes.push_back(string("NEW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ArrayCreationExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}
| NEW ClassOrInterfaceType DimExprs
{
     nodes.push_back(string("NEW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ArrayCreationExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| NEW PrimitiveType DimExprs Dims
{
     nodes.push_back(string("NEW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ArrayCreationExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     adj[node_count + 2].push_back($4);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}
| NEW ClassOrInterfaceType DimExprs Dims
{
     nodes.push_back(string("NEW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ArrayCreationExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     adj[node_count + 2].push_back($4);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 3;
}
| NEW PrimitiveType Dims ArrayInitializer
{
     nodes.push_back(string("NEW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ArrayCreationExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     adj[node_count + 2].push_back($4);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 4;
}
| NEW ClassOrInterfaceType Dims ArrayInitializer
{
     nodes.push_back(string("NEW"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("ArrayCreationExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     adj[node_count + 2].push_back($3);
     adj[node_count + 2].push_back($4);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 5;
}

DimExprs : DimExpr
{
     nodes.push_back("DimExprs");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| DimExprs DimExpr
{
     nodes.push_back("DimExprs");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     adj[node_count + 0].push_back($2);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

DimExpr : SQUARE_OPEN Expression SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("DimExpr");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}

Dims : SQUARE_OPEN SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("Dims");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| Dims SQUARE_OPEN SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("Dims");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

FieldAccess : Primary DOT IDENTIFIER
{
     nodes.push_back(string("DOT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("FieldAccess");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| SUPER DOT IDENTIFIER
{
     nodes.push_back(string("SUPER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("DOT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back("FieldAccess");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 0);
     adj[node_count + 6].push_back(node_count + 2);
     adj[node_count + 6].push_back(node_count + 4);
     $$ = node_count + 6;
     node_count += 7;
     node_prod[nodes.size() - 1] = 1;
}

MethodInvocation : Name PAR_OPEN ArgumentList PAR_CLOSE
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("MethodInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| Primary DOT IDENTIFIER PAR_OPEN ArgumentList PAR_CLOSE
{
     nodes.push_back(string("DOT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("MethodInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back($1);
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back($5);
     adj[node_count + 8].push_back(node_count + 6);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 1;
}
| SUPER DOT IDENTIFIER PAR_OPEN ArgumentList PAR_CLOSE
{
     nodes.push_back(string("SUPER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("DOT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($6));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("MethodInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back($5);
     adj[node_count + 10].push_back(node_count + 8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 2;
}
| Name PAR_OPEN PAR_CLOSE
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("MethodInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 3;
}
| Primary DOT IDENTIFIER PAR_OPEN PAR_CLOSE
{
     nodes.push_back(string("DOT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back("MethodInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back($1);
     adj[node_count + 8].push_back(node_count + 0);
     adj[node_count + 8].push_back(node_count + 2);
     adj[node_count + 8].push_back(node_count + 4);
     adj[node_count + 8].push_back(node_count + 6);
     $$ = node_count + 8;
     node_count += 9;
     node_prod[nodes.size() - 1] = 4;
}
| SUPER DOT IDENTIFIER PAR_OPEN PAR_CLOSE
{
     nodes.push_back(string("SUPER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("DOT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back(string("IDENTIFIER"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 5);
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 6].push_back(node_count + 7);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($5));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 8].push_back(node_count + 9);
     nodes.push_back("MethodInvocation");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 10].push_back(node_count + 0);
     adj[node_count + 10].push_back(node_count + 2);
     adj[node_count + 10].push_back(node_count + 4);
     adj[node_count + 10].push_back(node_count + 6);
     adj[node_count + 10].push_back(node_count + 8);
     $$ = node_count + 10;
     node_count += 11;
     node_prod[nodes.size() - 1] = 5;
}

ArrayAccess : Name SQUARE_OPEN Expression SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ArrayAccess");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| PrimaryNoNewArray SQUARE_OPEN Expression SQUARE_CLOSE
{
     nodes.push_back(string("SQUARE_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("SQUARE_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("ArrayAccess");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back($1);
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back(node_count + 2);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}

PostfixExpression : Primary
{
     nodes.push_back("PostfixExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| Name
{
     nodes.push_back("PostfixExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| PostIncrementExpression
{
     nodes.push_back("PostfixExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| PostDecrementExpression
{
     nodes.push_back("PostfixExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}

PostIncrementExpression : PostfixExpression INCREMENT
{
     nodes.push_back(string("INCREMENT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("PostIncrementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

PostDecrementExpression : PostfixExpression DECREMENT
{
     nodes.push_back(string("DECREMENT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($2));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("PostDecrementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

UnaryExpression : PreIncrementExpression
{
     nodes.push_back("UnaryExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| PreDecrementExpression
{
     nodes.push_back("UnaryExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| PLUS UnaryExpression
{
     nodes.push_back(string("PLUS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("UnaryExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}
| MINUS UnaryExpression
{
     nodes.push_back(string("MINUS"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("UnaryExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 3;
}
| UnaryExpressionNotPlusMinus
{
     nodes.push_back("UnaryExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}

PreIncrementExpression : INCREMENT UnaryExpression
{
     nodes.push_back(string("INCREMENT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("PreIncrementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

PreDecrementExpression : DECREMENT UnaryExpression
{
     nodes.push_back(string("DECREMENT"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("PreDecrementExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 0;
}

UnaryExpressionNotPlusMinus : PostfixExpression
{
     nodes.push_back("UnaryExpressionNotPlusMinus");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| NEGATION UnaryExpression
{
     nodes.push_back(string("NEGATION"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("UnaryExpressionNotPlusMinus");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}
| EXCLAMATION UnaryExpression
{
     nodes.push_back(string("EXCLAMATION"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back("UnaryExpressionNotPlusMinus");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($2);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 2;
}
| CastExpression
{
     nodes.push_back("UnaryExpressionNotPlusMinus");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}

CastExpression : PAR_OPEN PrimitiveType Dims PAR_CLOSE UnaryExpression
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("CastExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($5);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 0;
}
| PAR_OPEN PrimitiveType PAR_CLOSE UnaryExpression
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("CastExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($4);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 1;
}
| PAR_OPEN Expression PAR_CLOSE UnaryExpressionNotPlusMinus
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($3));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("CastExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($4);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 2;
}
| PAR_OPEN Name Dims PAR_CLOSE UnaryExpressionNotPlusMinus
{
     nodes.push_back(string("PAR_OPEN"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($1));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back(node_count + 1);
     nodes.push_back(string("PAR_CLOSE"));
     line_no.push_back(yylineno);
     nodes.push_back(strdup($4));
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back(node_count + 3);
     nodes.push_back("CastExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 4].push_back(node_count + 0);
     adj[node_count + 4].push_back($2);
     adj[node_count + 4].push_back($3);
     adj[node_count + 4].push_back(node_count + 2);
     adj[node_count + 4].push_back($5);
     $$ = node_count + 4;
     node_count += 5;
     node_prod[nodes.size() - 1] = 3;
}

MultiplicativeExpression : UnaryExpression
{
     nodes.push_back("MultiplicativeExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| MultiplicativeExpression MULTIPLY UnaryExpression
{
     nodes.push_back(string("MULTIPLY") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| MultiplicativeExpression DIVIDE UnaryExpression
{
     nodes.push_back(string("DIVIDE") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| MultiplicativeExpression MODULO UnaryExpression
{
     nodes.push_back(string("MODULO") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}

AdditiveExpression : MultiplicativeExpression
{
     nodes.push_back("AdditiveExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| AdditiveExpression PLUS MultiplicativeExpression
{
     nodes.push_back(string("PLUS") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| AdditiveExpression MINUS MultiplicativeExpression
{
     nodes.push_back(string("MINUS") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}

ShiftExpression : AdditiveExpression
{
     nodes.push_back("ShiftExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ShiftExpression LEFT_SHIFT AdditiveExpression
{
     nodes.push_back(string("LEFT_SHIFT") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| ShiftExpression RIGHT_SHIFT AdditiveExpression
{
     nodes.push_back(string("RIGHT_SHIFT") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| ShiftExpression UNSIGNED_RIGHT_SHIFT AdditiveExpression
{
     nodes.push_back(string("UNSIGNED_RIGHT_SHIFT") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}

RelationalExpression : ShiftExpression
{
     nodes.push_back("RelationalExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| RelationalExpression LESS_THAN ShiftExpression
{
     nodes.push_back(string("LESS_THAN") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| RelationalExpression GREATER_THAN ShiftExpression
{
     nodes.push_back(string("GREATER_THAN") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| RelationalExpression LESS_THAN_OR_EQUAL_TO ShiftExpression
{
     nodes.push_back(string("LESS_THAN_OR_EQUAL_TO") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| RelationalExpression GREATER_THAN_OR_EQUAL_TO ShiftExpression
{
     nodes.push_back(string("GREATER_THAN_OR_EQUAL_TO") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}
| RelationalExpression INSTANCEOF ReferenceType
{
     nodes.push_back(string("INSTANCEOF") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 5;
}

EqualityExpression : RelationalExpression
{
     nodes.push_back("EqualityExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| EqualityExpression EQUAL_TO RelationalExpression
{
     nodes.push_back(string("EQUAL_TO") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| EqualityExpression NOT_EQUAL_TO RelationalExpression
{
     nodes.push_back(string("NOT_EQUAL_TO") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}

AndExpression : EqualityExpression
{
     nodes.push_back("AndExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| AndExpression BITWISE_AND EqualityExpression
{
     nodes.push_back(string("BITWISE_AND") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

ExclusiveOrExpression : AndExpression
{
     nodes.push_back("ExclusiveOrExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ExclusiveOrExpression BITWISE_XOR AndExpression
{
     nodes.push_back(string("BITWISE_XOR") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

InclusiveOrExpression : ExclusiveOrExpression
{
     nodes.push_back("InclusiveOrExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| InclusiveOrExpression BITWISE_OR ExclusiveOrExpression
{
     nodes.push_back(string("BITWISE_OR") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

ConditionalAndExpression : InclusiveOrExpression
{
     nodes.push_back("ConditionalAndExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ConditionalAndExpression AND_LOGICAL InclusiveOrExpression
{
     nodes.push_back(string("AND_LOGICAL") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

ConditionalOrExpression : ConditionalAndExpression
{
     nodes.push_back("ConditionalOrExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ConditionalOrExpression OR_LOGICAL ConditionalAndExpression
{
     nodes.push_back(string("OR_LOGICAL") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     adj[node_count].push_back($3);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

ConditionalExpression : ConditionalOrExpression
{
     nodes.push_back("ConditionalExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| ConditionalOrExpression QUESTION Expression COLON ConditionalExpression
{
     nodes.push_back(string("QUESTION") + "(" + strdup($2) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     nodes.push_back(string("COLON") + "(" + strdup($4) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     nodes.push_back("ConditionalExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 2].push_back($1);
     adj[node_count + 2].push_back(node_count + 0);
     adj[node_count + 2].push_back($3);
     adj[node_count + 2].push_back(node_count + 1);
     adj[node_count + 2].push_back($5);
     $$ = node_count + 2;
     node_count += 3;
     node_prod[nodes.size() - 1] = 1;
}

AssignmentExpression : ConditionalExpression
{
     nodes.push_back("AssignmentExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| Assignment
{
     nodes.push_back("AssignmentExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}

Assignment : LeftHandSide AssignmentOperator AssignmentExpression
{
     $$ = $2;
     adj[$2].push_back($1);
     adj[$2].push_back($3);
     node_prod[nodes.size() - 1] = 0;
}

LeftHandSide : Name
{
     nodes.push_back("LeftHandSide");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| FieldAccess
{
     nodes.push_back("LeftHandSide");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| ArrayAccess
{
     nodes.push_back("LeftHandSide");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}

AssignmentOperator : ASSIGN
{
     nodes.push_back(string("ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}
| MULTIPLY_ASSIGN
{
     nodes.push_back(string("MULTIPLY_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 1;
}
| DIVIDE_ASSIGN
{
     nodes.push_back(string("DIVIDE_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 2;
}
| MOD_ASSIGN
{
     nodes.push_back(string("MOD_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 3;
}
| PLUS_ASSIGN
{
     nodes.push_back(string("PLUS_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 4;
}
| MINUS_ASSIGN
{
     nodes.push_back(string("MINUS_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 5;
}
| LEFT_SHIFT_ASSIGN
{
     nodes.push_back(string("LEFT_SHIFT_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 6;
}
| RIGHT_SHIFT_ASSIGN
{
     nodes.push_back(string("RIGHT_SHIFT_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 7;
}
| UNSIGNED_RIGHT_SHIFT_ASSIGN
{
     nodes.push_back(string("UNSIGNED_LEFT_SHIFT_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 8;
}
| AND_ASSIGN
{
     nodes.push_back(string("AND_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 9;
}
| XOR_ASSIGN
{
     nodes.push_back(string("XOR_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 10;
}
| OR_ASSIGN
{
     nodes.push_back(string("OR_ASSIGN") + "(" + strdup($1) + ")");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 11;
}

Expression : AssignmentExpression
{
     nodes.push_back("Expression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count + 0].push_back($1);
     $$ = node_count + 0;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

ConstantExpression : Expression
{
     nodes.push_back("ConstantExpression");
     line_no.push_back(yylineno);
     adj.push_back(vector<int>());
     adj[node_count].push_back($1);
     $$ = node_count;
     node_count += 1;
     node_prod[nodes.size() - 1] = 0;
}

%%

void node_to_sym_assign_all(int src, int curr_ind) {
     if(node_to_sym_tab.find(src) == node_to_sym_tab.end()){
          node_to_sym_tab[src] = curr_ind;
     }
     for(auto ch: adj_copy[src]){
          node_to_sym_assign_all(ch, node_to_sym_tab[src]);
     }
}



int main(int argc, char* argv[]) {
	yydebug = 0;
     int help_flag = 0;
     string input_file = "";
     string output_file = "out.3AC";
     for(int i = 1 ; i < argc; i++) {
          string s = argv[i];
          if(s == "--help") {
               help_flag = 1;
               continue;
          }
          if(s == "--verbose") {
               yydebug = 1;
               continue;
          }
          string flag = s;
          if(s.length() <= 7) {
               cerr << "Wrong usage of flags" << endl;
               return 0;
          }
          flag = flag.substr(0, 8);
          if(flag == "--input=") {
               input_file = s.substr(8, s.length());
               continue;
          }
          flag = s;
          if(s.length() <= 8) {
               cerr << "Wrong usage of flags" << endl;
               return 0;
          }
          flag = flag.substr(0, 9);
          if(flag == "--output=") {
               output_file = s.substr(9, s.length());
               continue;
          }
          else{
               input_file = s;
               continue;
          }
          cerr << "Wrong flag" << endl;
          return 0;
     }

     if(help_flag) {
          cout << "Usage: ./parser --input=<input_file_path> --output=<output_file_path> [options]" << endl;
          cout << "or ./parser <input_file_path> [options]" << endl;
          cout << "The following options can be used" << endl;
          cout << "--input=<input_file_path> \t: Input file specification (default is command line)" << endl;
          cout << "--output=<output_file_path> \t: Output file specification (default is ast.dot)" << endl;
          cout << "--help \t\t\t\t: Instruction regarding usage instructions and options" << endl;
          cout << "--verbose \t\t\t: Prints the complete stack trace of the parser execution" << endl;
          return 0;
     }
     
     if(input_file != "") {
          freopen(input_file.c_str(), "r", stdin);
     }

     yyparse();

     type_size["byte"] = 1;
     type_size["short"] = 2;
     type_size["int"] = 4;
     type_size["long"] = 8;

     nodes_copy = nodes;
     adj_copy = adj;

     // ofstream ast;
     // ast.open("ast.dot");

     // for(int i =0;i<nodes.size();i++){
     //      ast << i << " [label=\"" << nodes[i] << "\"]" << endl;
     // }

     // for(int i=0;i<nodes.size();i++)
     //      for(int j=0; j<adj[i].size();j++)
     //           ast << i << " -> " << adj[i][j] << endl;

     // creation of symbol_table
     map<string, map<string, string>> nmap;
     sym_tab.push_back(nmap);
     int src = 0;
     for(int i = 0 ; i < nodes.size(); i++) {
          if(nodes[i] == "CompilationUnit"){
               src = i;
               break;
          }
     }
     parent[0] = -1;
     vector<string> ret = pt_travel(src, 0, "", "");
     for(auto entry: class_map) {
          class_map_2.insert({entry.second, entry.first});
     }
     print_sym_tab(0);
     node_to_sym_assign_all(src, 0);
     scope_check(src, 0);
     type_check(src);
     check_for_return();
     check_func_params(src);
     array_dims_check(src, 0);


     // creation of parse tree from ast
     // cout << nodes.size() << endl;

     int curr_size = nodes.size(); 
     for(int i = curr_size - 1 ;i >= 0; i--){
          if(nodes[i] == "VariableDeclarator"){ 
               if(adj[i].size() == 3)
                    nodes[adj[i][1]] = "A-S-S-I-G-N";
          }
          else if(nodes[i].find("ASSIGN") != string::npos){
               // cout << i << " " <<nodes[i] <<endl;
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               nodes[i] = "Assignment";
               swap(adj[i][1],adj[i][2]);
               nodes[nodes.size() - 2] = "AssignmentOperator";
               adj[nodes.size()-2].push_back(nodes.size()-1);
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
               parse_to_ast[nodes.size()-2] = -1;  
          }
          if((nodes[i].find("MULTIPLY") != string::npos) || (nodes[i].find("DIVIDE") != string::npos) || (nodes[i].find("MODULO") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "MultiplicativeExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          } 
          else if((nodes[i].find("PLUS") != string::npos) || (nodes[i].find("MINUS") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "AdditiveExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("LEFT_SHIFT") != string::npos) || (nodes[i].find("RIGHT_SHIFT") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "ShiftExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("LESS_THAN") != string::npos) || (nodes[i].find("GREATER_THAN") != string::npos) || (nodes[i].find("LESS_THAN_OR_EQUAL_TO") != string::npos) || (nodes[i].find("GREATER_THAN_OR_EQUAL_TO") != string::npos) || (nodes[i].find("INSTANCEOF") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "RelationalExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("EQUAL_TO") != string::npos) || (nodes[i].find("NOT_EQUAL_TO") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "EqualityExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("BITWISE_AND") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "AndExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("BITWISE_XOR") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "ExclusiveOrExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("BITWISE_OR") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "InclusiveOrExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("AND_LOGICAL") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "ConditionalAndExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("OR_LOGICAL") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "ConditionalOrExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          else if((nodes[i].find("LOGICAL_AND") != string::npos)){
               nodes.push_back(nodes[i]);
               adj.push_back(vector<int>());
               adj[i].push_back(nodes.size() - 1);
               swap(adj[i][1],adj[i][2]);
               nodes[i] = "ConditionalAndExpression";
               parse_to_ast[nodes.size()-1] = i;
               parse_to_ast[i] = -1;
          }
          
     }

     for(int i = 0 ; i < nodes.size(); i++){
          if(parse_to_ast.find(i) == parse_to_ast.end())
               parse_to_ast[i] = i;
     }

     // for(auto it = parse_to_ast.begin(); it != parse_to_ast.end();it++)
     //      cout << it->first << " " << it->second << endl;

     for(int i=curr_size-1;i>=0;i--){
          if(nodes[i] == "A-S-S-I-G-N")
               nodes[i] = "ASSIGN(=)";
     }

     ofstream parse;
     parse.open("parse.dot");

     for(int i =0;i<nodes.size();i++){
         parse << i << " [label=\"" << nodes[i] << "\"]" << endl;
     }

     for(int i=0;i<nodes.size();i++)
         for(int j=0; j<adj[i].size();j++)
              parse << i << " -> " << adj[i][j] << endl;
     
     post_order(curr_size - 1);
     ofstream x86;
     x86.open("out.s");

     x86 << ".section    .rodata\n.LC0:\n     .string    \"%d\\n\"\n     .text\n     .globl    main\n";

     x86 << node_attr_map[curr_size-1].code << endl;
     // generate_3AC(node_attr_map[curr_size-1].code, output_file.c_str());
     return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Line number:%d Error: %s\n",yylineno, s);
}