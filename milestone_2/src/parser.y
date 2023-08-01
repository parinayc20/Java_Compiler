%{
#include<bits/stdc++.h>
#define YYDEBUG 1

extern int yylineno;
using namespace std;

vector<string> nodes;
vector<int> line_no;
vector<vector<int>> adj;
int node_count = 0;

map<int, int> node_prod;

class node_attr {
public:
    string code;
    string variable;
    string label;
    string type;
    string val;
    string arr_ptr;
    int true_goto, false_goto,size;
    string offset;
    vector<string> dims;
    int dim_count;
    node_attr() {
        this->code = "";
        this->variable = "";
        this->true_goto = -1;
        this->false_goto = -1;
        this->size = -1;
        this->label = "";
        this->type = "";
        this->val = "";
        this->dim_count = 0;
        this->dims = vector<string>();
        this->offset = "ZERO";
        this->arr_ptr = "";
    }
}; 

map<int, node_attr> node_attr_map;
string get_new_temp();
string get_new_label();
string return_reg = "RRE";

vector<map<string, map<string, string>>> sym_tab;
map<int, int> parent;
map<int, vector<int>> children;
// class name -> index of class in symbol table
map<string, int> class_map;
map<int, string> class_map_2;
map<int, int> node_to_sym_tab;
map<int, pair<string, int>> node_to_type;
vector<vector<pair<string, map<string, string>>>> func_params;
int curr_sym_tab = 0;
int func_param_ind = -1;
map<int,int> parse_to_ast;



extern int yylex(void);
void yyerror(const char*);
void postorder(int nodes);
void postorder_3AC(int n);
void generate_3AC(string s, string file);

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
     for(auto ch: adj[src]){
          node_to_sym_assign_all(ch, node_to_sym_tab[src]);
     }
}

pair<string, int> type_recur(int src) {
     string res="";
     int array_dims = 0;
     bool is_upper = true;
     for(auto letter: nodes[src]) {
          if(letter == '_')
               continue;
          int diff = letter - 'A';
          if(diff < 0 || diff >= 26) {
               is_upper = false;
               break;
          }
     }
     if(is_upper) {
          if(nodes[src] == "SQUARE_OPEN")
               array_dims ++;
          else if (nodes[src] == "SQUARE_CLOSE")
               return {"", 0};
          else
               res = nodes[adj[src][0]];
          return {res, array_dims};
     }
     for(auto child: adj[src]) {
          pair<string, int> ret = type_recur(child);
          res = res + ret.first;
          array_dims += ret.second;
     }
     return {res, array_dims};
}

vector<pair<string, int>> vars_recur(int src, pair<string, int> type) {
     if(nodes[src] == "VariableDeclaratorId")
          node_to_type[src] = type;
     vector<pair<string, int>> res;
     string iden_val="";
     int array_dims = 0;
     bool is_upper = true;
     for(auto letter: nodes[src]) {
          if(letter == '_')
               continue;
          int diff = letter - 'A';
          if(diff < 0 || diff >= 26) {
               is_upper = false;
               break;
          }
     }
     if(is_upper) {
          if(nodes[src] == "SQUARE_OPEN")
               array_dims ++;
          else if (nodes[src] == "SQUARE_CLOSE")
          {}
          else if (nodes[src] == "COMMA") 
          {}
          else
          {
               iden_val = nodes[adj[src][0]];
          }
          res.push_back({iden_val, array_dims});
          return res;
     }

     bool flag = false;
     for(auto child: adj[src]) {
          if(nodes[child] == "ASSIGN" || nodes[child] == "ASSIGN(=)") {
               break;
          }
          else if(nodes[child] == "COMMA") {
               continue;
          }
          else if(nodes[child] == "VariableDeclarators") {
               res = vars_recur(child, type);
          }
          else if(nodes[child] == "VariableDeclarator") {
               vector<pair<string, int>> ret = vars_recur(child, type);
               res.push_back(ret[0]);
          }
          else {
               vector<pair<string,int>> ret = vars_recur(child, type);
               for(auto ret_val: ret) {
                    iden_val = iden_val + ret_val.first;
                    array_dims += ret_val.second;
               }
               flag = true;
          }
     }
     if(nodes[src] == "VariableDeclaratorId")
          node_to_type[src].second += array_dims;
     if(flag) {
          res.push_back({iden_val, array_dims});
     }
     return res;
}

vector<pair<string, map<string, string>>> params_recur(int src) {
     vector<pair<string, map<string, string>>> res;
     for(auto child: adj[src]) {
          if(nodes[child] == "COMMA")
               continue;
          else if(nodes[child] == "FormalParameterList") {
               res = params_recur(child);
          }
          else if(nodes[child] == "FormalParameter") {
               map<string, string> param_attrs;
               for(auto ch_ : adj[child]) {
                    if(nodes[ch_] == "VariableModifier") {
                         param_attrs["Modifier_1"] = "final";
                    }
                    else if(nodes[ch_] == "Type") {
                         pair<string, int> type_ret = type_recur(ch_);
                         param_attrs["Type"] = type_ret.first;
                         param_attrs["Array_dims"] = to_string(type_ret.second);
                    }
                    else if(nodes[ch_] == "VariableDeclaratorId") {
                         vector<pair<string, int>> var_ret = vars_recur(ch_, {param_attrs["Type"], stoi(param_attrs["Array_dims"])});
                         pair<string, int> var = var_ret[0];
                         param_attrs["Array_dims"] = to_string(stoi(param_attrs["Array_dims"]) + var.second);
                         res.push_back({var.first, param_attrs});
                    }
               }
          }
     }
     return res;
}

bool check_var(int sym_tab_ind, string name) {
     // cerr << "Inside check var" << endl;
     if(sym_tab_ind == 0)
          return false;
     if(sym_tab[sym_tab_ind].find(name) != sym_tab[sym_tab_ind].end()) {
          if(sym_tab[sym_tab_ind][name].find("is_global") != sym_tab[sym_tab_ind][name].end()) {
               return false;
          }
          return true;
     }
     return check_var(parent[sym_tab_ind], name);
}

void print_sym_tab(int st) {
     if(sym_tab[st].size() > 0) {
          string output_file = "symbol_table_" + to_string(st) + ".csv";
          ofstream dotFile(output_file.c_str());
          for(auto x: sym_tab[st]) {
               dotFile << x.first << endl;
               for(auto y: x.second) {
                    dotFile << y.first << "," << y.second << endl;
               }
               dotFile << endl;
          }
     }
     for (auto child: children[st]) {
          print_sym_tab(child);
     }
}

vector<string> pt_travel(int src, int curr_ind, string class_name, string func_name) {
     // cerr << "Inside" << endl;
     // cerr << nodes[src] << endl;
     // cerr << src << endl;
     node_to_sym_tab[src] = curr_ind;
     vector<string> no_ret;
     if(nodes[src] == "Modifiers") {
          vector<string> st;
          for(auto child: adj[src]) {
               if(nodes[child] == "Modifier") {
                    st.push_back(nodes[adj[adj[child][0]][0]]);
               }
               else if(nodes[child] == "Modifiers") {
                    vector<string> new_st = pt_travel(child, curr_ind, class_name, func_name);
                    for(auto mod: new_st)
                         st.push_back(mod);
               }
          }
          return st;
     }
     else if(nodes[src] == "ClassDeclaration") {
          curr_sym_tab++;
          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          map<string, string> class_attrs;
          for(auto child: adj[src]) {
               if(nodes[child] == "Modifiers") {
                    vector<string> mods = pt_travel(child,curr_ind, class_name, func_name);
                    for(int i=0; i<mods.size(); i++) {
                         class_attrs["Modifier_" + to_string(i+1)] = mods[i];
                    }
               }
               else if(nodes[child] == "IDENTIFIER") {
                    class_name = nodes[adj[child][0]];
                    class_map[class_name] = curr_sym_tab;
                    if(sym_tab[curr_ind].find(class_name) !=  sym_tab[curr_ind].end()) {
                         fprintf(stderr, "Line number:%d Error: Duplicate class %s\n", line_no[src], class_name.c_str());
                         exit(0);
                    }
                    class_attrs["is_class"] = "true";
                    class_attrs["line_no"] = to_string(line_no[src]) ;
                    sym_tab[curr_ind][class_name] = class_attrs;
               }
               else if(nodes[child] == "CLASS") {
                    continue;
               }
               else {
                    curr_ind = inserted_tab_ind;
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
               }
          }
          return no_ret;
     }
     else if(nodes[src] == "FieldDeclaration") {
          map<string, string> vars_attrs;       
          for(auto child: adj[src]) {
               if(nodes[child] == "Modifiers") {
                    vector<string> mods = pt_travel(child, curr_ind, class_name, func_name);
                    for(int i=0; i<mods.size(); i++) {
                         vars_attrs["Modifier_" + to_string(i+1)] = mods[i];
                    }
               }
               else if(nodes[child] == "Type") {
                    pair<string, int> res = type_recur(child);
                    vars_attrs["Type"] = res.first;
                    vars_attrs["Array_dims"] = to_string(res.second);
               }
               else if(nodes[child] == "VariableDeclarators") {
                    vector<pair<string, int>> ret = vars_recur(child, {vars_attrs["Type"], stoi(vars_attrs["Array_dims"])});
                    for(auto var: ret) {
                         if(sym_tab[curr_ind].find(var.first) !=  sym_tab[curr_ind].end()) {
                              fprintf(stderr, "Line number:%d Error: Duplicate global variable %s\n", line_no[src], (var.first).c_str());
                              exit(0);
                         }
                         map<string, string> var_attrs = vars_attrs;
                         var_attrs["Array_dims"] = to_string(stoi(var_attrs["Array_dims"]) + var.second);
                         var_attrs["is_global"] = "true";
                         var_attrs["line_no"] = to_string(line_no[src]) ;
                         var_attrs["class_name"] = class_name;
                         sym_tab[curr_ind][var.first] = var_attrs;
                    }
                    
               }
          }
          return no_ret;
     }
     else if(nodes[src] == "MethodDeclaration") {
          curr_sym_tab ++;
          func_param_ind ++;
          vector<pair<string, map<string, string>>> new_func;
          func_params.push_back(new_func);

          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          for(auto child : adj[src]) {
               if(nodes[child] == "MethodHeader") {
                    curr_ind = inserted_tab_ind;
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
                    func_name = res[0];
               }
               else {
                    curr_ind = inserted_tab_ind;
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
               }
          }
          return no_ret;
     }
     else if(nodes[src] == "MethodHeader") {
          map<string, string> func_attrs;
          for(auto child: adj[src]) {
               if(nodes[child] == "Modifiers") {
                    vector<string> mods = pt_travel(child, curr_ind, class_name, func_name);
                    for(int i=0; i<mods.size(); i++) {
                         func_attrs["Modifier_" + to_string(i+1)] = mods[i];
                    }
               }
               else if(nodes[child] == "Type") {
                    pair<string, int> res = type_recur(child);
                    func_attrs["Type"] = res.first;
                    func_attrs["Array_dims"] = to_string(res.second);
               }
               else if(nodes[child] == "VOID") {
                    func_attrs["Type"] = "None";
                    func_attrs["Array_dims"] = "0";
               }
               else if(nodes[child] == "MethodDeclarator") {
                    if(nodes[adj[child][0]] == "IDENTIFIER") {
                         func_name = nodes[adj[adj[child][0]][0]];
                    }
                    if(func_name == class_name) {
                         fprintf(stderr, "Line number:%d Error: Function name same as class name\n", line_no[child]);
                         exit(0);
                    }
                    if(sym_tab[parent[curr_ind]].find(func_name) !=  sym_tab[parent[curr_ind]].end()) {
                         fprintf(stderr, "Line number:%d Error: Duplicate method name\n", line_no[child]);
                         exit(0);
                    }
                    func_attrs["is_func"] = "true";
                    func_attrs["func_param_index"] = to_string(func_param_ind);
                    func_attrs["is_global"] = "true";
                    func_attrs["line_no"] = to_string(line_no[src]) ;
                    func_attrs["class_name"] = class_name;
                    func_attrs["sym_tab_ind"] = to_string(curr_ind);
                    sym_tab[parent[curr_ind]][func_name] = func_attrs;

                    for(int i = 1; i < adj[child].size(); i++) {
                         vector<string> res = pt_travel(adj[child][i], curr_ind, class_name, func_name);
                    }
               }
               else {
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
               }
          }
          vector<string> f_name;
          f_name.push_back(func_name);
          return f_name;
     }
     else if(nodes[src] == "FormalParameterList") {
          vector<pair<string, map<string, string>>> params_ret = params_recur(src);
          func_params[func_param_ind] = params_ret;
          for(auto param: params_ret) {
               if(sym_tab[curr_ind].find(param.first) !=  sym_tab[curr_ind].end()) {
                    fprintf(stderr, "Line number:%d Error: Duplicate parameters\n", line_no[src]);
                    exit(0);
               }
               param.second["line_no"] = to_string(line_no[src]) ;
               param.second["class_name"] = class_name;
               param.second["func_name"] = func_name;
               sym_tab[curr_ind][param.first] = param.second;
          }
          return no_ret;
     }
     else if(nodes[src] == "LocalVariableDeclaration") {
          map<string, string> vars_attrs;       
          for(auto child: adj[src]) {
               // cerr << nodes[child] << endl;
               if(nodes[child] == "VariableModifiers") {
                    vars_attrs["Modifier_1"] = "final";
               }
               else if(nodes[child] == "Type") {
                    pair<string, int> res = type_recur(child);
                    vars_attrs["Type"] = res.first;
                    vars_attrs["Array_dims"] = to_string(res.second);
               }
               else if(nodes[child] == "VariableDeclarators") {
                    vector<pair<string, int>> ret = vars_recur(child, {vars_attrs["Type"], stoi(vars_attrs["Array_dims"])});
                    for(auto var: ret) {
                         if(check_var(curr_ind, var.first)) {
                              fprintf(stderr, "Line number:%d Error: Duplicate Local Variable %s\n", line_no[child], (var.first).c_str());
                              exit(0);
                         }
                         map<string, string> var_attrs = vars_attrs;
                         var_attrs["Array_dims"] = to_string(stoi(var_attrs["Array_dims"]) + var.second);
                         var_attrs["line_no"] = to_string(line_no[src]) ;
                         var_attrs["class_name"] = class_name;
                         var_attrs["func_name"] = func_name;
                         sym_tab[curr_ind][var.first] = var_attrs;
                    }
                    
               }
          }
          return no_ret;
     }
     else if(nodes[src] == "ConstructorDeclaration") {
          curr_sym_tab ++;
          func_param_ind ++;
          vector<pair<string, map<string, string>>> new_func;
          func_params.push_back(new_func);

          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          map<string, string> func_attrs;
          for(auto child: adj[src]) {
               if(nodes[child] == "Modifiers") {
                    vector<string> mods = pt_travel(child, curr_ind, class_name, func_name);
                    for(int i=0; i<mods.size(); i++) {
                         func_attrs["Modifier_" + to_string(i+1)] = mods[i];
                    }
               }
               else if(nodes[child] == "ConstructorDeclarator") {
                    pair<string, int> const_name = type_recur(adj[child][0]);
                    if(const_name.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Wrong constructor initialization\n", line_no[child]);
                         exit(0);
                    }
                    if(const_name.first != class_name) {
                         fprintf(stderr, "Line number:%d Error: Constructor name not same as class name\n", line_no[child]);
                         exit(0);
                    }
                    func_attrs["is_func"] = "true";
                    func_attrs["Type"] = "None";
                    func_attrs["Array_dims"] = "0";
                    func_attrs["func_param_index"] = to_string(func_param_ind);
                    func_attrs["line_no"] = to_string(line_no[src]) ;
                    func_attrs["class_name"] = class_name;
                    func_attrs["sym_tab_ind"] = to_string(inserted_tab_ind);
                    func_name = const_name.first;
                    sym_tab[curr_ind][const_name.first] = func_attrs;
                    vector<string> res = pt_travel(child, inserted_tab_ind, class_name, func_name);
               }
               else {
                    curr_ind = inserted_tab_ind;
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
               }
          }
          return no_ret;
     }
     else if(nodes[src] == "ForStatement" || nodes[src] == "ForStatementNoShortIf") {
          curr_sym_tab ++;
          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          for(auto child: adj[src]) {
               curr_ind = inserted_tab_ind;
               vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
          }
          return no_ret;
     }
     else if(nodes[src] == "SwitchBlock") {
          curr_sym_tab ++;
          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          for(auto child: adj[src]) {
               curr_ind = inserted_tab_ind;
               vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
          }
          return no_ret;
     }
     else if(nodes[src] == "Block") {
          curr_sym_tab ++;
          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          for(auto child: adj[src]) {
               curr_ind = inserted_tab_ind;
               vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
          }
          return no_ret;
     }
     else {
          for(auto child : adj[src]) {
               vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
          }
          return no_ret;
     }
}

pair<string, int> var_scope_check(int sym_tab_ind, string name, int src){
     if(sym_tab_ind == 0)
     return {"", -1};
     if(sym_tab[sym_tab_ind].find(name) != sym_tab[sym_tab_ind].end()) {
          if(sym_tab[sym_tab_ind][name].find("is_func") == sym_tab[sym_tab_ind][name].end()) {
               if(sym_tab[sym_tab_ind][name].find("is_global") == sym_tab[sym_tab_ind][name].end()) {
                    return {sym_tab[sym_tab_ind][name]["Type"], stoi(sym_tab[sym_tab_ind][name]["Array_dims"])};
               }
               if(stoi(sym_tab[sym_tab_ind][name]["line_no"]) <= line_no[src]) {
                    return {sym_tab[sym_tab_ind][name]["Type"], stoi(sym_tab[sym_tab_ind][name]["Array_dims"])};
               }
          }
     }
     return var_scope_check(parent[sym_tab_ind], name, src);
}

string find_class(int sym_tab_ind) {
     if(class_map_2.find(sym_tab_ind) != class_map_2.end())
          return class_map_2[sym_tab_ind];
     return find_class(parent[sym_tab_ind]);
}

pair<string, int> find_func(int curr_tab_ind, int child_tab_ind) {
     if(curr_tab_ind == 0)
          return {"", -1};
     for(auto elems: sym_tab[curr_tab_ind]) {
          if(elems.second.find("is_func") != elems.second.end()) {
               if(stoi(elems.second["sym_tab_ind"]) == child_tab_ind)
                    return {elems.first, curr_tab_ind};
          }
     }
     return find_func(parent[curr_tab_ind], curr_tab_ind);
}

string var_data_type(string type) {
     if(type == "long" || type == "int" || type == "short" || type == "char" || type == "byte" || type == "lit")
          return "integer";
     else if(type == "float" || type == "double")
          return "decimal";
     else if(type == "boolean")
          return "boolean";
     else if(type == "String")
          return "String"; 
     else 
          return "object";
}

bool type_match(string type1, string type2) {
     if(type1 == "String" && type2 == "null")
          return true;
     if(type1 == "object" && type2 == "null")
          return true;
     if(type1 == "String" || type1 == "boolean" || type2 == "String" || type2 == "boolean")
     {
          if(var_data_type(type1) != var_data_type(type2))
               return false;
          return true;
     }

     if(var_data_type(type1) == "object" || var_data_type(type2) == "object"){
          return type1 == type2;
     }

     int num_type1 = 0, num_type2 = 0;
     if(var_data_type(type1) == "integer") {
          if(type1 == "long")
               num_type1 = 5;
          else if(type1 == "int")
               num_type1 = 4;
          else if(type1 == "short")
               num_type1 = 3;
          else if(type1 == "char")
               num_type1 = 2;
          else if(type1 == "byte")
               num_type1 = 1;

          if(type2 == "long")
               num_type2 = 5;
          else if(type2 == "int")
               num_type2 = 4;
          else if(type2 == "short")
               num_type2 = 3;
          else if(type2 == "char")
               num_type2 = 2;
          else if(type2 == "byte")
               num_type2 = 1;
     }
     else {
          if(type1 == "double")
               num_type1 = 7;
          else
               num_type1 = 6;

          if(type2 == "double")
               num_type2 = 7;
          else 
               num_type2 = 6;
     }

     if(type1 == "char" && (type2 == "short" || type2 == "byte")) 
          return false;
     if(type2 == "char" && (type1 == "short" || type1 == "byte"))
          return false;

     if(num_type1 >= num_type2)
          return true;
     else 
          return false;
}

int arithmetic_return(string type) {
     if(type == "String")
          return 8;
     if(type == "double")
          return 7;
     if(type == "float") 
          return 6;
     if(type == "long")
          return 5;
     if(type == "int")
          return 4;
     if(type == "short")
          return 3;
     if(type == "char")
          return 2;
     if(type == "byte")
          return 1;
     return 0;
}

string get_type(int src) {
     string iden_val = "";
     bool is_upper = true;
     for(auto letter: nodes[src]) {
          if(letter == '_')
               continue;
          int diff = letter - 'A';
          if(diff < 0 || diff >= 26) {
               is_upper = false;
               break;
          }
     }
     if(is_upper) {
          return nodes[adj[src][0]];
     }
     for(auto child: adj[src]) {
          iden_val += get_type(child);
     }
     return iden_val;
}

int get_dims(int src) {
     int dims = 0;
     if(nodes[src] == "SQUARE_OPEN")
          return 1;
     for(auto child: adj[src]) {
          dims += get_dims(child);
     }
     return dims;
}

string scope_check(int src, int type) {
     // cerr << nodes[src] << endl;
     if(nodes[src] == "PackageDeclaration")
          return "";
     if(nodes[src] == "ImportDeclarations")
          return "";
     if(nodes[src] == "IDENTIFIER") {
          return nodes[adj[src][0]];
     }
     else if(nodes[src] == "DOT") {
          return ".";
     }
     else if(nodes[src] == "THIS") {
          return "this";
     }
     else if(nodes[src] == "Name") {
          string name = "";
          int ntype = type;
          if(type == 0)
               ntype = 1;
          for(auto child : adj[src]) {
               name += scope_check(child, ntype);
          }
          if(ntype > type){
               vector<string> vars;
               string curr_name = "";
               for(auto letter : name) {
                    if(letter == '.') {
                         vars.push_back(curr_name);
                         curr_name = "";
                         continue;
                    }
                    curr_name += letter;
               }
               vars.push_back(curr_name);
               if(vars.size() > 2) {
                    cerr << "Constraints dissatisfied. Chain of accesses present : " << name << "\n";
                    exit(0); 
               }
               if(vars.size() == 1) {
                    pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
                    if(type.second == -1) {
                         if(class_map.find(vars[0]) == class_map.end()){
                              fprintf(stderr, "Line number:%d Error: Variable %s out of scope\n", line_no[src], (vars[0]).c_str());
                              exit(0);
                         }
                         node_to_type[src] = {vars[0], 0};
                    }
                    else {
                         node_to_type[src] = type;
                    }
               }
               else {
                    pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
                    string ref_type = type.first;
                    if(type.first == "")
                         ref_type = vars[0];
                    if(class_map.find(ref_type) == class_map.end()){
                         fprintf(stderr, "Line number:%d Error: Variable %s out of scope\n", line_no[src], (vars[0]).c_str());
                         exit(0);
                    }
                    int class_ind = class_map[ref_type];
                    vars[0] = ref_type;
                    if(sym_tab[class_ind].find(vars[1]) == sym_tab[class_ind].end()) {
                         fprintf(stderr, "Line number:%d Error: No member %s of class %s found\n", line_no[src], (vars[1]).c_str(), (vars[0]).c_str());
                         exit(0);
                    }
                    if(sym_tab[class_ind][vars[1]].find("is_func") != sym_tab[class_ind][vars[1]].end()) {
                         fprintf(stderr, "Line number:%d Error: No member %s of class %s found\n", line_no[src], (vars[1]).c_str(), (vars[0]).c_str());
                         exit(0);
                    }
                    string this_class = find_class(node_to_sym_tab[src]);
                    if(this_class != ref_type) {
                         bool is_private = false;
                         for(auto elem: sym_tab[class_ind][vars[1]]) {
                              if(elem.second == "private"){
                                   is_private = true;
                                   break;
                              }
                         }
                         if(is_private) {
                              fprintf(stderr, "Line number:%d Error: Member %s of class %s is private\n", line_no[src], (vars[1]).c_str(), (vars[0]).c_str());
                              exit(0);
                         }
                    }
                    node_to_type[src] = {sym_tab[class_ind][vars[1]]["Type"], stoi(sym_tab[class_ind][vars[1]]["Array_dims"])};
               }
               return "";
          }
          return name;
     }
     else if(nodes[src] == "FieldAccess") {
          string name = "";
          int ntype = type;
          if(type < 2)
               ntype = 2;
          for(auto child : adj[src]) {
               name += scope_check(child, ntype);
          }
          if(ntype > type){
               vector<string> vars;
               string curr_name = "";
               for(auto letter : name) {
                    if(letter == '.') {
                         vars.push_back(curr_name);
                         curr_name = "";
                         continue;
                    }
                    curr_name += letter;
               }
               vars.push_back(curr_name);
               if(vars.size() == 2) {
                    if(vars[0] == "this") {
                         string class_name = find_class(node_to_sym_tab[src]);
                         int class_ind = class_map[class_name];
                         if(sym_tab[class_ind].find(vars[1]) == sym_tab[class_ind].end()) {
                              fprintf(stderr, "Line number:%d Error: No member %s of class %s found\n", line_no[src], (vars[1]).c_str(), (class_name).c_str());
                              exit(0);
                         }
                         if(sym_tab[class_ind][vars[1]].find("is_func") != sym_tab[class_ind][vars[1]].end()) {
                              fprintf(stderr, "Line number:%d Error: No member %s of class %s found\n", line_no[src], (vars[1]).c_str(), (class_name).c_str());
                              exit(0);
                         }
                         node_to_type[src] = {sym_tab[class_ind][vars[1]]["Type"], stoi(sym_tab[class_ind][vars[1]]["Array_dims"])};
                    }
               }
               return "";
          }
          return name;
     }
     else if(nodes[src] == "MethodInvocation") {
          if(nodes[adj[src][0]] == "Primary") {
               string st = scope_check(adj[src][0], 3);
               if(st == "this") {
                    string iden_name = scope_check(adj[src][2], 3);
                    string class_name = find_class(node_to_sym_tab[src]);
                    int class_ind = class_map[class_name];
                    if(sym_tab[class_ind].find(iden_name) == sym_tab[class_ind].end()) {
                         fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                         exit(0);
                    }
                    if(sym_tab[class_ind][iden_name].find("is_func") == sym_tab[class_ind][iden_name].end()) {
                         fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                         exit(0);
                    }
                    node_to_type[src] = {sym_tab[class_ind][iden_name]["Type"], stoi(sym_tab[class_ind][iden_name]["Array_dims"])};
               }

               string str = "";
               for(int i = 3; i < adj[src].size(); i++) {
                    str += scope_check(adj[src][i], 0);
               }
          }
          else {
               string name = scope_check(adj[src][0], 3);
               if(name == "System.out.println") {
                    string str = "";
                    for(int i = 1; i < adj[src].size(); i++) {
                         str += scope_check(adj[src][i], 0);
                    }
                    return "";
               }
               vector<string> vars;
               string curr_name = "";
               for(auto letter : name) {
                    if(letter == '.') {
                         vars.push_back(curr_name);
                         curr_name = "";
                         continue;
                    }
                    curr_name += letter;
               }
               vars.push_back(curr_name);
               if(vars.size() > 2) {
                    cerr << "Constraints dissatisfied. Chain of accesses present : " << name << "\n";
                    exit(0); 
               }
               else {
                    string class_name = "";
                    string iden_name = "";
                    string this_class = find_class(node_to_sym_tab[src]);
                    if(vars.size() == 1) {
                         class_name = this_class;
                         iden_name = vars[0];
                         // cerr << class_name << endl;
                    }
                    else {
                         pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
                         string ref_type = type.first;
                         if(type.first == "")
                              ref_type = vars[0];
                         if(class_map.find(ref_type) == class_map.end()){
                              fprintf(stderr, "Line number:%d Error: Variable %s out of scope\n", line_no[src], (vars[0]).c_str());
                              exit(0);
                         }
                         class_name = ref_type;
                         iden_name = vars[1];
                    }
                    int class_ind = class_map[class_name];
                    if(sym_tab[class_ind].find(iden_name) == sym_tab[class_ind].end()) {
                         fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                         exit(0);
                    }
                    if(sym_tab[class_ind][iden_name].find("is_func") == sym_tab[class_ind][iden_name].end()) {
                         fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                         exit(0);
                    }
                    if(this_class != class_name) {
                         bool is_private = false;
                         for(auto elems : sym_tab[class_ind][iden_name]){
                              if(elems.second == "private")
                              {
                                   is_private = true;
                                   break;
                              }
                         }
                         if(is_private) {
                              fprintf(stderr, "Line number:%d Error: Member %s of class %s is private\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                              exit(0);
                         }
                    }
                    node_to_type[src] = {sym_tab[class_ind][iden_name]["Type"], stoi(sym_tab[class_ind][iden_name]["Array_dims"])};
               }

               string str = "";
               for(int i = 1; i < adj[src].size(); i++) {
                    str += scope_check(adj[src][i], 0);
               }
          }
          return "";
     }
     else {
          string st = "";
          for(auto child : adj[src]) 
               st += scope_check(child, type);
          return st;
     }
}

pair<string, int> type_check(int src) {
     // cerr << nodes[src] << " " << src << endl;
     if(node_to_type.find(src) != node_to_type.end())
          return node_to_type[src];
     else if(nodes[src] == "Literal") {
          if(nodes[adj[src][0]] == "INTEGER_LITERAL")
               return {"lit", 0};
          if(nodes[adj[src][0]] == "FLOATING_POINT_LITERAL")
               return {"float", 0};
          if(nodes[adj[src][0]] == "CHARACTER_LITERAL")
               return {"lit", 0};
          if(nodes[adj[src][0]] == "STRING_LITERAL")
               return {"String", 0};
          if(nodes[adj[src][0]] == "TEXT_BLOCK_LITERAL")
               return {"String", 0};
          if(nodes[adj[src][0]] == "BOOLEAN_LITERAL")
               return {"boolean", 0};
          if(nodes[adj[src][0]] == "NULL_LITERAL")
               return {"null", 0};
          return {"", 0};
     }
     else if(nodes[src] == "ArrayAccess") {
          pair<string, int> type = type_check(adj[src][2]);
          if(var_data_type(type.first) != "integer") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          type = type_check(adj[src][0]);
          type.second = 0;
          return type;
     } 
     else if(nodes[src] == "VariableDeclarator") {
          pair<string, int> type = type_check(adj[src][0]);
          // cerr << type.first << " " << type.second << endl;
          if(adj[src].size() == 3) {
               pair<string, int> type2 = type_check(adj[src][2]);
               // cerr << type2.first << " " << type2.second << endl;
               if(type.second != type2.second) {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
               if(type_match(type.first, type2.first) == false) {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
          }
          return type;
     }
     else if(nodes[src] == "ArrayCreationExpression") {
          string type = get_type(adj[src][1]);
          int dims = get_dims(adj[src][2]);
          if(adj[src].size() > 3) {
               dims += get_dims(adj[src][3]);
          }
          return {type, dims};
     }
     else if(nodes[src] == "ForStatement" || nodes[src] == "ForStatementNoShortIf") {
          for(auto child : adj[src]) {
               if(nodes[child] == "COLON")
                    break;
               if(nodes[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    if(type.first != "boolean" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes[src] == "IfThenStatement" || nodes[src] == "IfThenElseStatement" || nodes[src] == "IfThenElseStatementNoShortIf") {
          for(auto child : adj[src]) {
               if(nodes[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    if(type.first != "boolean" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes[src] == "WhileStatement" || nodes[src] == "WhileStatementNoShortIf"){
          for(auto child : adj[src]) {
               if(nodes[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    if(type.first != "boolean" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes[src] == "DoStatement") {
          for(auto child : adj[src]) {
               if(nodes[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    if(type.first != "boolean" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes[src] == "SwitchStatement") {
          for(auto child : adj[src]) {
               if(nodes[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    string data_type = var_data_type(type.first);
                    if(type.first == "boolean" || type.first == "object" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes[src] == "ConditionalExpression") {
          if(adj[src].size() == 5) {
               pair<string, int> type = type_check(adj[src][0]);
               if(type.first != "boolean" || type.second != 0) {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
               type = type_check(adj[src][2]);
               pair<string, int> type2 = type_check(adj[src][4]);
               if(type.second != type2.second) {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
               string t1 = var_data_type(type.first);
               string t2 = var_data_type(type2.first);
               if(t1 != t2) {
                    if((t1 == "integer" && t2 == "decimal") || (t1 == "decimal" && t2 == "integer")) {
                         if(arithmetic_return(type.first) > arithmetic_return(type2.first)) {
                              return type;
                         }
                         else
                              return type2;
                    }
                    else {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               if(t1 == "integer") {
                    if(arithmetic_return(type.first) > arithmetic_return(type2.first)) {
                         return type;
                    }
                    else
                         return type2;
               }
               if(t1 == "decimal") {
                    if(arithmetic_return(type.first) > arithmetic_return(type2.first)) {
                         return type;
                    }
                    else
                         return type2;
               }
               return type;
          }
          return type_check(adj[src][0]);
     }
     else if(nodes[src] == "ASSIGN" || nodes[src] == "ASSIGN(=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         // cerr << "Mismatch here" << endl;
                         exit(0);
                    }
                    if(type_match(ptype.first, type.first) == false) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         // cerr << "Mismatch here 2" << endl;
                         exit(0);
                    }
               }
          }
          return ptype;
     }
     else if(nodes[src] == "LESS_THAN" || nodes[src] ==  "LESS_THAN_OR_EQUAL_TO" || nodes[src] == "GREATER_THAN" || nodes[src] == "GREATER_THAN_OR_EQUAL_TO" || nodes[src] == "LESS_THAN(<)" || nodes[src] ==  "LESS_THAN_OR_EQUAL_TO(<=)" || nodes[src] == "GREATER_THAN(>)" || nodes[src] == "GREATER_THAN_OR_EQUAL_TO(>=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if((t1 != "integer" && t1 != "decimal") || (t2 != "integer" && t2 != "decimal")){
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          return {"boolean", 0};
     }
     else if(nodes[src] == "EQUAL_TO" || nodes[src] == "NOT_EQUAL_TO" || nodes[src] == "EQUAL_TO(==)" || nodes[src] == "NOT_EQUAL_TO(!=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if(t1 == "String" && t2 != "String") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    else if(t1 == "boolean" && t2 != "boolean") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    else if(t1 == "object" && t2 != "object") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    else if(t1 == "integer" && (t2 != "integer" && t2 != "decimal")) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    else if(t1 == "decimal" && (t2 != "integer" && t2 != "decimal")) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          return {"boolean", 0};
     }
     else if(nodes[src] == "BITWISE_AND" || nodes[src] == "BITWISE_OR" || nodes[src] == "BITWISE_XOR" || nodes[src] == "BITWISE_AND(&)" || nodes[src] == "BITWISE_OR(|)" || nodes[src] == "BITWISE_XOR(^)" || nodes[src] == "LEFT_SHIFT" || nodes[src] == "RIGHT_SHIFT" || nodes[src] == "UNSIGNED_RIGHT_SHIFT" || nodes[src] == "LEFT_SHIFT(<<)" || nodes[src] == "RIGHT_SHIFT(>>)" || nodes[src] == "UNSIGNED_RIGHT_SHIFT(>>>)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if(t1 != "integer" || t2 != "integer") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          return ptype;
     }
     else if(nodes[src] == "OR_LOGICAL" || nodes[src] == "AND_LOGICAL" || nodes[src] == "OR_LOGICAL(||)" || nodes[src] == "AND_LOGICAL(&&)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if(t1 != "boolean" || t2 != "boolean") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          return {"boolean", 0};
     }
     else if(nodes[src] == "PLUS" || nodes[src] == "PLUS(+)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if((t1 != "integer" && t1 != "decimal" && t1 != "String") || (t2 != "integer" && t2 != "decimal" && t2 != "String")) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(arithmetic_return(ptype.first) < arithmetic_return(type.first)) {
                         ptype = type;
                    }
               }
          }
          return ptype;
     }
     else if(nodes[src] == "MINUS" || nodes[src] == "MULTIPLY" || nodes[src] == "DIVIDE" || nodes[src] == "MODULO" || nodes[src] == "MINUS(-)" || nodes[src] == "MULTIPLY(*)" || nodes[src] == "DIVIDE(/)" || nodes[src] == "MODULO(%)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if((t1 != "integer" && t1 != "decimal") || (t2 != "integer" && t2 != "decimal")) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(arithmetic_return(ptype.first) < arithmetic_return(type.first)) {
                         ptype = type;
                    }
               }
          }
          return ptype;
     }
     else if(nodes[src] == "PLUS_ASSIGN" || nodes[src] == "PLUS_ASSIGN(+=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(type_match(ptype.first, type.first) == false) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          string data_type = var_data_type(ptype.first);
          if(data_type != "String" && data_type != "integer" && data_type != "decimal") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return ptype;
     }
     else if(nodes[src] == "MULTIPLY_ASSIGN" || nodes[src] == "DIVIDE_ASSIGN" || nodes[src] == "MOD_ASSIGN" || nodes[src] == "MINUS_ASSIGN" || nodes[src] == "MULTIPLY_ASSIGN(*=)" || nodes[src] == "DIVIDE_ASSIGN(/=)" || nodes[src] == "MOD_ASSIGN(%=)" || nodes[src] == "MINUS_ASSIGN(-=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(type_match(ptype.first, type.first) == false) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          string data_type = var_data_type(ptype.first);
          if(data_type != "integer" && data_type != "decimal") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return ptype;
     }
     else if(nodes[src] == "LEFT_SHIFT_ASSIGN" || nodes[src] == "RIGHT_SHIFT_ASSIGN" || nodes[src] == "UNSIGNED_RIGHT_SHIFT_ASSIGN" || nodes[src] == "AND_ASSIGN" || nodes[src] == "OR_ASSIGN" || nodes[src] == "XOR_ASSIGN" || nodes[src] == "LEFT_SHIFT_ASSIGN(<<=)" || nodes[src] == "RIGHT_SHIFT_ASSIGN(>>=)" || nodes[src] == "UNSIGNED_RIGHT_SHIFT_ASSIGN(>>>=)" || nodes[src] == "AND_ASSIGN(&=)" || nodes[src] == "OR_ASSIGN(|=)" || nodes[src] == "XOR_ASSIGN(^=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(type_match(ptype.first, type.first) == false) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          string data_type = var_data_type(ptype.first);
          if(data_type != "integer") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return ptype;
     } 
     else if(nodes[src] == "PostIncrementExpression" || nodes[src] == "PostDecrementExpression") {
          pair<string, int> type = type_check(adj[src][0]);
          string t = var_data_type(type.first);
          if(type.second != 0 || t != "integer") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return type;
     }
     else if(nodes[src] == "PreIncrementExpression" || nodes[src] == "PreDecrementExpression") {
          pair<string, int> type = type_check(adj[src][0]);
          string t = var_data_type(type.first);
          if(type.second != 0 || t != "integer") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return type;
     }
     else if(nodes[src] == "UnaryExpressionNotPlusMinus") {
          if(adj[src].size() > 1) {
               pair<string, int> type = type_check(adj[src][1]);
               string t = var_data_type(type.first);
               if(type.second != 0 || t != "integer") {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
               return type;
          }
          return type_check(adj[src][0]);
     }
     else if(nodes[src] == "ReturnStatement") {
          pair<string, int> type;
          if(adj[src].size() == 2) {
               type = {"None", 0};
          }
          else {
               type = type_check(adj[src][1]);
          }
          pair<string, int> func = find_func(node_to_sym_tab[src], node_to_sym_tab[src]);
          pair<string, int> ret_type = {sym_tab[func.second][func.first]["Type"], stoi(sym_tab[func.second][func.first]["Array_dims"])};
          if(ret_type.second != type.second) {
               fprintf(stderr, "Line number:%d Error: Wrong return type\n", line_no[src]);
               exit(0);
          }
          if(type_match(ret_type.first, type.first) == false) {
               fprintf(stderr, "Line number:%d Error: Wrong return type\n", line_no[src]);
               exit(0);
          } 
          sym_tab[func.second][func.first]["return"] = "True";
          return {"", 0};
     }
     else if(nodes[src] == "Type"){
          return {"", 0};
     }
     else if(nodes[src] == "ClassInstanceCreationExpression")
     {
          pair<string, int> type = type_check(adj[src][1]);
          for(auto child : adj[src]){
               pair<string, int> type2 = type_check(child);
          }
          return type;
     }
     else {
          pair<string, int> type = {"", 0};
          for(auto child : adj[src]) {
               pair<string, int> ntype = type_check(child);
               if(type.first == "")
                    type = ntype;
               else if(ntype.first == "")
                    continue;
               else {
                    // cerr << nodes[src] << " " << src << endl;
                    return {"", 0};
               }
          }
          // cerr << nodes[src] << " " << src << endl;
          return type;
     }
}

void check_for_return() {
     for(auto class_name : class_map) {
          for(auto elem : sym_tab[class_name.second]) {
               if(elem.second.find("is_func") != elem.second.end()) {
                    if(elem.second.find("return") == elem.second.end()) {
                         if(elem.second["Type"] != "None") {
                              fprintf(stderr, "Line number:%d Error: Function did not return anything\n", stoi(elem.second["line_no"]));
                              exit(0);
                         }
                    }
               }
          }
     }
}

vector<pair<string, int>> arguments_fetch(int src) {
     vector<pair<string, int>> args;
     if(nodes[src] == "Expression") {
          args.push_back(type_check(src));
     }
     else {
          args = arguments_fetch(adj[src][0]);
          if(adj[src].size() > 1) {
               vector<pair<string, int>> oth_args = arguments_fetch(adj[src][2]);
               args.push_back(oth_args[0]);
          }
     }
     return args;
}

void check_func_params(int src) {
     if(nodes[src] == "MethodInvocation") {
          string iden_name = "", class_name = "";
          vector<pair<string, int>> params;
          if(nodes[adj[src][0]] == "Primary") {
               string st = scope_check(adj[src][0], 3);
               if(st == "this") {
                    iden_name = scope_check(adj[src][2], 3);
                    class_name = find_class(node_to_sym_tab[src]);
                    int class_ind = class_map[class_name];

                    for(auto child : adj[src]) {
                         if(nodes[child] == "ArgumentList")
                         {
                              params = arguments_fetch(child);
                              break;
                         }
                    }
               }
          }
          else {
               string name = scope_check(adj[src][0], 3);
               if(name == "System.out.println") {
                    iden_name = name;
                    for(auto child : adj[src]) {
                         if(nodes[child] == "ArgumentList")
                         {
                              params = arguments_fetch(child);
                              break;
                         }
                    }
               }
               else {
                    vector<string> vars;
                    string curr_name = "";
                    for(auto letter : name) {
                         if(letter == '.') {
                              vars.push_back(curr_name);
                              curr_name = "";
                              continue;
                         }
                         curr_name += letter;
                    }
                    vars.push_back(curr_name);
                    if(vars.size() > 2) {
                         cerr << "Constraints dissatisfied. Chain of accesses present : " << name << "\n";
                         exit(0); 
                    }
                    else {
                         string this_class = find_class(node_to_sym_tab[src]);
                         if(vars.size() == 1) {
                              class_name = this_class;
                              iden_name = vars[0];
                              // cerr << class_name << endl;
                         }
                         else {
                              pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
                              string ref_type = type.first;
                              if(type.first == "")
                                   ref_type = vars[0];
                              class_name = ref_type;
                              iden_name = vars[1];
                         }
                         int class_ind = class_map[class_name];

                         for(auto child : adj[src]) {
                              if(nodes[child] == "ArgumentList")
                              {
                                   params = arguments_fetch(child);
                                   break;
                              }
                         }
                    }
               }
          }

          if(iden_name == "System.out.println") {
               if(params.size() != 1 || var_data_type(params[0].first) == "object" || params[0].second != 0) {
                    fprintf(stderr, "Line number:%d Error: Wrong function parameters\n", line_no[src]);
                    exit(0);
               }
          }
          else {
               int class_ind = class_map[class_name];
               int func_index = stoi(sym_tab[class_ind][iden_name]["func_param_index"]);
               if(params.size() != func_params[func_index].size()) {
                    fprintf(stderr, "Line number:%d Error: Wrong function parameters\n", line_no[src]);
                    exit(0);
               }
               for(int i = 0; i < params.size() ; i++) {
                    if(type_match(func_params[func_index][i].second["Type"], params[i].first) == false) {
                         fprintf(stderr, "Line number:%d Error: Wrong function parameters\n", line_no[src]);
                         exit(0);
                    }
                    if(stoi(func_params[func_index][i].second["Array_dims"]) != params[i].second) {
                         fprintf(stderr, "Line number:%d Error: Wrong function parameters\n", line_no[src]);
                         exit(0);
                    } 
               } 
          }
     }
     for(auto child : adj[src]) {
          check_func_params(child);
     }
}

int array_dims_check(int src, int flag) {
     int total_dims = 0;
     if(nodes[src] == "ArrayAccess") {
          if(nodes[adj[src][0]] == "Name") {
               pair<string, int> type = type_check(adj[src][0]);
               total_dims = type.second;
          }
          else
               total_dims = array_dims_check(adj[src][0], 1);
          for(int i = 1; i < adj[src].size() ; i++)
               total_dims -= array_dims_check(adj[src][i], 1);
          if(flag == 0 && total_dims != 0) {
               fprintf(stderr, "Line number:%d Error: Wrong number of array dimensions accessed\n", line_no[src]);
               exit(0);
          }
          return total_dims;
     }
     if(flag == 1) {
          if(nodes[src] == "SQUARE_OPEN")
               return 1;
     }
     for(auto child: adj[src])
          total_dims += array_dims_check(child, flag);
     return total_dims;
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
          else if(nodes[i] == "VariableDeclarator"){ 
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
     
     postorder(curr_size - 1);
    // cout << node_attr_map[curr_size-1].code << endl;
     generate_3AC(node_attr_map[curr_size-1].code, output_file.c_str());
     return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Line number:%d Error: %s\n",yylineno, s);
}

int temp_count = 0;
string get_new_temp(){
     string temp = "t";
     temp += to_string(temp_count);
     temp_count++;
     return temp;
}

int label_count = 0;
string get_new_label(){
     string label = "L";
     label += to_string(label_count);
     label_count++;
     return label;
}
void postorder_3AC(int n){
    int reducer = node_prod[n];
     string name = nodes[n];
     if(name == "Literal"){
          node_attr_map[n].variable = get_new_temp();
          node_attr_map[n].val = nodes[adj[adj[n][0]][0]];
          node_attr_map[n].code = node_attr_map[n].variable + " = " + node_attr_map[n].val + "\n";
          switch(reducer){
               case 0:
                    node_attr_map[n].type = "int";
                    node_attr_map[n].size = 4;
                    break;
               case 1:
                    node_attr_map[n].type = "float";
                    node_attr_map[n].size = 8;
                    break;
               case 2:
                    node_attr_map[n].size = 2;
                    break;
               case 3:
                    node_attr_map[n].size = 2048;
                    break;
               case 4:
                    node_attr_map[n].size = 2048;
                    break;
               case 5:
                    node_attr_map[n].size = 1;
                    break;
               case 6:
                    node_attr_map[n].size = 1;
                    break;
          }
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code += node_attr_map[n].label;
          node_attr_map[n].code += " : ";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you in  literal\n";
          return;
     }
     if (name == "Type"){
          node_attr_map[n].size = node_attr_map[adj[n][0]].size;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "PrimitiveType"){
          node_attr_map[n].size = node_attr_map[adj[n][0]].size;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "NumericType"){
          node_attr_map[n].size = node_attr_map[adj[n][0]].size;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "IntegralType"){
          switch (reducer){
               case 0:
                    node_attr_map[n].size = 1;
                    break;
               case 1:
                    node_attr_map[n].size = 2;
                    break;
               case 2:
                    node_attr_map[n].size = 4;
                    break;
               case 3:
                    node_attr_map[n].size = 8;
                    break;
               case 4:
                    node_attr_map[n].size = 2;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "FloatingPointType"){
          switch (reducer){
               case 0:
                    node_attr_map[n].size = 4;
                    break;
               case 1:
                    node_attr_map[n].size = 8;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ReferenceType"){
          node_attr_map[n].size = node_attr_map[adj[n][0]].size;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassOrInterfaceType"){
          node_attr_map[n].type = node_attr_map[adj[n][0]].variable;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassType"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceType"){
          node_attr_map[n].size = -1;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ArrayType"){
          node_attr_map[n].size = -1;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Name"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
           string type = var_data_type(node_to_type[parse_to_ast[n]].first);
          if(type == "integer") {
               node_attr_map[n].type = "int";
          }
          else if(type == "decimal"){
          node_attr_map[n].type = "float";}
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
     //    cout<< type << " " << node_attr_map[n].variable << " " << node_attr_map[n].size << endl;
          return;
     }
     if (name == "SimpleName"){
          node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "QualifiedName"){
          node_attr_map[n].variable = node_attr_map[adj[n][0]].variable + "." + nodes[adj[adj[n][2]][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "CompilationUnit"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ImportDeclarations"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "TypeDeclarations"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "PackageDeclaration"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SingleTypeImportDeclaration"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "TypeImportOnDemandDeclaration"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "TypeDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "MethodTypeDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Modifiers"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Modifier"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassDeclaration"){
          string class_name;
          string extension = ".class\n";
          switch(reducer){
               case 0: 
                    class_name = nodes[adj[adj[n][2]][0]];
                    break;
               case 1:
                    class_name = nodes[adj[adj[n][1]][0]];
                    break;
               case 2:
                    class_name = nodes[adj[adj[n][2]][0]];
                    break;
               case 3:
                    class_name = nodes[adj[adj[n][2]][0]];
                    break;
               case 4:
                    class_name = nodes[adj[adj[n][1]][0]];
                    break;
               case 5:
                    class_name = nodes[adj[adj[n][1]][0]];
                    break;
               case 6:
                    class_name = nodes[adj[adj[n][2]][0]];
                    break;
               case 7:
                    class_name = nodes[adj[adj[n][1]][0]];
                    break;
          }
          class_name = class_name + extension;
          node_attr_map[n].code = class_name;
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].code  += "endclass\n";
          return;     
     }
     if (name == "Super") {
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Interfaces"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceTypeList"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          return;          
     }
     if (name == "ClassBody"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassBodyDeclarations"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }   
     if (name == "ClassBodyDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }  
     if (name == "ClassMemberDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }  
     if (name == "FieldDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                         node_attr_map[n].label = node_attr_map[adj[n][2]].label;
                         break;
               case 1:   
                         node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                         break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }  
     if (name == "VariableDeclarators"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code += node_attr_map[n].label;
          node_attr_map[n].code += " : ";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }  
     if (name == "VariableDeclarator"){
          switch(reducer){
               case 0:
                    break;
               case 1:
                    string var0 = node_attr_map[adj[n][0]].variable;   
                    string var1 = node_attr_map[adj[n][2]].variable;
                    string code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    if (!node_attr_map[adj[n][2]].dims.empty()){
                         for (int ii = 0; ii < node_attr_map[adj[n][2]].dims.size(); ii++){
                              code += "add symboltable(" + var0 + "." + "dim" + to_string(ii) + "," + node_attr_map[adj[n][2]].dims[ii] + ")\n";
                         }
                         code +="call allocmem size(" + var0 + ")\n";
                         code += var0 + " = pop stack\n";
                         // add all dimensions
          
                    }
                    else{
                         code += var0 + " = " + var1 + "\n";
                    }
                    // if (!node_attr_map[adj[n][2]].dims.empty()){
                    //      code += "add symtable(" + var0 + ", " + var1 + ".dims)\n";
                    // }
                    node_attr_map[n].code = code;
                    break;
          }
          // cout << node_attr_map[n].code;

          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     } 
     if (name == "VariableDeclaratorId"){
          switch(reducer){
               case 0:
                    node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                    break;
               case 1:
                    node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "VariableInitializer"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodDeclaration"){
          switch(reducer){
               case 0:
                    string code = "func " + node_attr_map[adj[n][0]].variable + "\n" + node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].code = code;
                    node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                    node_attr_map[n].code = node_attr_map[n].code + "goto top(stack)\n";
                    node_attr_map[n].code = node_attr_map[n].code + "pop stack\nendfunc\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
    
     if (name == "MethodHeader"){
        switch(reducer){
            case 0:
                    node_attr_map[n].variable = node_attr_map[adj[n][2]].variable;
                    break;
          case 1:
                    node_attr_map[n].variable = node_attr_map[adj[n][2]].variable;
                    break;
          case 2:
                    node_attr_map[n].variable = node_attr_map[adj[n][1]].variable;
                    break;
           case 3:
                    node_attr_map[n].variable = node_attr_map[adj[n][2]].variable;
                    break;
           case 4:
                    node_attr_map[n].variable = node_attr_map[adj[n][1]].variable;
                    break;
           case 5:
                    node_attr_map[n].variable = node_attr_map[adj[n][1]].variable;
                    break;
           case 6:
                    node_attr_map[n].variable = node_attr_map[adj[n][2]].variable;
                    break;
          case 7:
                    node_attr_map[n].variable = node_attr_map[adj[n][1]].variable;
                    break;    
        }
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
     if (name == "MethodDeclarator"){
          switch(reducer){
               case 0:
                    node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                    break;
               case 1:
                    node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                    break;
               case 2:
                    node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                    break;
          }
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "FormalParametersList"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "FormalParameter"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          string code;
          switch(reducer){
               case 0:
                    code += node_attr_map[adj[n][1]].variable + " = pop param\n";
                    break;
               case 1:
                    code += node_attr_map[adj[n][2]].variable + " = pop param\n";
                    break;
          }
          node_attr_map[n].code += code;
          // cout << node_attr_map[n].code;
          return;
     }

     if (name == "Throws"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ClassTypeList"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodBody"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StaticInitializer"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ConstructorDeclaration"){
          string code = "constructor\n";
          code += "this = pop param\n";
          for (int i = 0; i < adj[n].size(); i++) {
               code = code + node_attr_map[adj[n][i]].code;
          }
          code = code + "endconstructor\n";
          node_attr_map[n].code = code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ConstructorDeclarator"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ConstructorBody"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ExplicitConstructorInvocation"){
          // Parinay: This and super are for inheritance and blah blah blah hence ignored
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "InterfaceDeclaration"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ExtendsInterfaces"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceBody"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceMemberDeclarations"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceMemberDeclaration"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ConstantDeclaration"){
          node_attr_map[n] = node_attr_map[adj[n][0]];       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "AbstractMethodDeclaration"){
           switch(reducer){
               case 0:
                    string code = "func" + node_attr_map[adj[n][0]].variable + "\n" + node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code + "endfunc\n";
                    node_attr_map[n].code = code;
                    // node_attr_map[n].variable = node_atVariableInitializer:tr_map[adj[n][0]].variable;
                    break;
          }     
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ArrayInitializer"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    break;
               case 2:
                    node_attr_map[n].variable = get_new_temp();
                    break;
               case 3:
                    node_attr_map[n].variable = get_new_temp();
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "VariableInitializers"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].size = node_attr_map[adj[n][0]].size + node_attr_map[adj[n][2]].size;
                    string temp = get_new_temp();
                    node_attr_map[n].code += temp + " = " + node_attr_map[n].variable + " + " + to_string(node_attr_map[n].size) + "\n";
                    node_attr_map[n].code += "*" + temp + " = " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Block"){
          switch(reducer){
               case 0:
                    node_attr_map[n].label = get_new_label();
                    node_attr_map[n].code = node_attr_map[n].label + " : ";
                    break;
               case 1:
                    node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                    node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }     
     if (name == "BlockStatements"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][adj[n].size()-1]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "BlockStatement"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodBlock"){
          switch(reducer){
               case 0:
                    node_attr_map[n].label = get_new_label();
                    node_attr_map[n].code = node_attr_map[n].label + " : ";
                    break;
               case 1:
                    node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                    node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                    break;
          }
         // cout << node_attr_map[n].code << endl;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodBlockStatements"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][adj[n].size()-1]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodBlockStatement"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "LocalVariableDeclarationStatement"){  
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "LocalVariableDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].type = node_attr_map[adj[n][0]].type;
                    node_attr_map[n].size = node_attr_map[adj[n][0]].size;
                    break;
               case 1:
                    node_attr_map[n].type = node_attr_map[adj[n][1]].type;
                    node_attr_map[n].size = node_attr_map[adj[n][1]].size;
                    break;
          }
          node_attr_map[n].label = node_attr_map[adj[n][adj[n].size()-1]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "VariableModifier"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Statement"){
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;                    
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StatementNoShortIf"){
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;        
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StatementWithoutTrailingSubstatement"){
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;        
          // cout << "PostIncrementexpression\n" << node_attr_map[n].code << "kahtm\n";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "EmptyStatement"){
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = node_attr_map[n].label + " : ";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "LabeledStatement"){
          // pick label from symbol table
          node_attr_map[n].label = node_attr_map[adj[n][2]].label;
          node_attr_map[n].code = nodes[adj[adj[n][0]][0]]+ " : " +node_attr_map[adj[n][2]].code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "LabeledStatementNoShortIf"){
          // pick label from symbol table
          node_attr_map[n].label = node_attr_map[adj[n][2]].label;
          node_attr_map[n].code = nodes[adj[adj[n][0]][0]]+ " : " +node_attr_map[adj[n][2]].code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ExpressionStatement"){
          node_attr_map[n].variable = get_new_temp();
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[n].label + " : ";
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StatementExpression"){
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "IfThenStatement"){
          string label = get_new_label();
          node_attr_map[n].label = node_attr_map[adj[n][4]].label;
          node_attr_map[n].code = node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + label + "\n" + "goto " + node_attr_map[adj[n][4]].label + "\n" + label + " : " + node_attr_map[adj[n][4]].code;                  
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "IfThenElseStatement"){
         string label1 = get_new_label();
         string label2 = get_new_label();

         node_attr_map[n].label = node_attr_map[adj[n][6]].label;

         node_attr_map[n].code = node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + label1 + "\n" + "goto " + label2 + "\n" + label1 + " : " + node_attr_map[adj[n][4]].code + "goto " + node_attr_map[adj[n][6]].label + "\n" + label2 + " : " + node_attr_map[adj[n][6]].code;                  
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "IfThenElseStatementNoShortIf"){
         string label1 = get_new_label();
         string label2 = get_new_label();

         node_attr_map[n].label = node_attr_map[adj[n][6]].label;
         
         node_attr_map[n].code = node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + label1 + "\n" + "goto " + label2 + "\n" + label1 + " : " + node_attr_map[adj[n][4]].code + "goto " + node_attr_map[adj[n][6]].label + "\n" + label2 + " : " + node_attr_map[adj[n][6]].code;                  
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SwitchStatement"){
          node_attr_map[n].label = node_attr_map[adj[n][4]].label;
          node_attr_map[n].code = node_attr_map[adj[n][2]].code + node_attr_map[adj[n][4]].code;

          while(node_attr_map[n].code.find("s-w-i-t-c-h") != string::npos)
               node_attr_map[n].code.replace(node_attr_map[n].code.find("s-w-i-t-c-h"), 11, node_attr_map[adj[n][2]].variable);

          while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
               node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
          return;

     }
     if (name == "SwitchBlock"){
          switch(reducer){
               case 0:
                         node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                         node_attr_map[n].code = node_attr_map[adj[n][1]].code;                         
                         break;
               case 1:
                         node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                         node_attr_map[n].code = node_attr_map[adj[n][1]].code;                         
                         break;   
               case 2:   
                         node_attr_map[n].label = get_new_label();
                         node_attr_map[n].code = node_attr_map[n].label + " : ";
                         break;
               case 3:
                         node_attr_map[n].label = get_new_label();
                         node_attr_map[n].code = node_attr_map[n].label + " : ";
                         break;
          }
     }
     if (name == "SwitchBlockStatementGroups"){
          for(auto i : adj[n]){
               if(node_attr_map[i].variable == "")
                    node_attr_map[n].code = node_attr_map[i].code + node_attr_map[n].code;
               else{
                    node_attr_map[n].code = node_attr_map[n].code + node_attr_map[i].code;
                    node_attr_map[n].label = node_attr_map[i].label;
               }
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SwitchBlockStatementGroup"){
          string label = get_new_label();
          string child_label = node_attr_map[adj[n][0]].label;
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;

          string variable = "";
          bool flag = false;
          
          for(int it = 0; it != child_label.size();it++){
               if(child_label[it] != ',')
                    variable.push_back(child_label[it]);
               else{
                    if(variable[0] == 't')
                         node_attr_map[n].code += string("if") + " s-w-i-t-c-h == " + variable + " goto " + label + "\n";
                    if(variable[0] == 'D')
                         flag = true;
                    variable = "";
               }
          }
          node_attr_map[n].code += "goto "; 
          node_attr_map[n].code += node_attr_map[adj[n][1]].label;
          node_attr_map[n].code += "\n";
          node_attr_map[n].code += label;
          node_attr_map[n].code += " : ";
          node_attr_map[n].code += node_attr_map[adj[n][1]].code;

          if(!flag)
               node_attr_map[n].label = node_attr_map[adj[n][1]].label;
          else{
               string new_label = get_new_label();
               string code = node_attr_map[adj[n][1]].code;
               while((code.size() != 0) && (*code.rbegin() != '\n'))
                    code.pop_back();
               node_attr_map[n].code += code;
               node_attr_map[n].code += new_label;
               node_attr_map[n].code += " : ";
               node_attr_map[n].label = new_label;
               node_attr_map[n].variable = "True";
          }
          // cout << "statgroup\n" << node_attr_map[n].code <<"\nfinish\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SwitchLabels"){
          for(auto i : adj[n]){
               node_attr_map[n].label += (node_attr_map[i].label + ",");
               node_attr_map[n].code += (node_attr_map[i].code);
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SwitchLabel"){
          switch(reducer){
               case 0:   node_attr_map[n].label = node_attr_map[adj[n][1]].variable;
                         node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                         break;

               case 1:   node_attr_map[n].label = string("D");
                         break;
          }
     }
     if (name == "WhileStatement"){
          string stat_label = get_new_label();
          string cond_label = get_new_label();
          node_attr_map[n].label = get_new_label();

          node_attr_map[n].code = cond_label + " : " + node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + stat_label + "\ngoto " + node_attr_map[n].label + "\n" + stat_label + " : " + node_attr_map[adj[n][4]].code + "goto " + cond_label + "\n" + node_attr_map[n].label + " : ";

          while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, cond_label);
          while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "WhileStatementNoShortIf"){
          string stat_label = get_new_label();
          string cond_label = get_new_label();
          node_attr_map[n].label = get_new_label();

          node_attr_map[n].code = cond_label + " : " + node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + stat_label + "\ngoto " + node_attr_map[n].label + "\n" + stat_label + " : " + node_attr_map[adj[n][4]].code + "goto " + cond_label + "\n" + node_attr_map[n].label + " : ";

          while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, cond_label);
          while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "DoStatement"){
          string label1 = get_new_label();
          string label2 = get_new_label();

          node_attr_map[n].label = label2;
          node_attr_map[n].code = label1 + " : " + node_attr_map[adj[n][1]].code + node_attr_map[adj[n][4]].code + "if " + node_attr_map[adj[n][4]].variable + " goto " + label1 + "\n" + label2 + " : ";

          while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, node_attr_map[adj[n][1]].label);
          while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, label2);

          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ForStatement"){
          string L1 = get_new_label();
          string L2 = get_new_label();
          string L3 = get_new_label();
          string code = "";
          // cout << "ForStatement\n";

          switch(reducer){
               case 0:          
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                          code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][8]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;
               case 1:   
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += "goto " + L1 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 2:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 3:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 4:
                         node_attr_map[n].label = get_new_label();
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][4]].code;
                         code += " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 5:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 6:
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += "goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 7:
                         node_attr_map[n].label = get_new_label();
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += L2 + " : ";
                         code += "goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;
          }
     }
     if (name == "ForStatementNoShortIf"){
          string L1 = get_new_label();
          string L2 = get_new_label();
          string L3 = get_new_label();
          string code = "";
          // cout << "ForStatement\n";

          switch(reducer){
               case 0:          
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                          code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][8]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;
               case 1:   
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += "goto " + L1 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 2:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 3:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 4:
                         node_attr_map[n].label = get_new_label();
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][4]].code;
                         code += " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 5:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 6:
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += "goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 7:
                         node_attr_map[n].label = get_new_label();
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += L2 + " : ";
                         code += "goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;
          }
     }
     if (name == "ForInit"){
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ForUpdate"){
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = node_attr_map[n].label + " : " + node_attr_map[adj[n][0]].code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StatementExpressionList"){
          for(auto i : adj[n])
               node_attr_map[n].code = (node_attr_map[i].code + "\n");
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "BreakStatement"){
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = string("goto ") + "b-r-e-a-k" + "\n" + node_attr_map[n].label + " : ";
     }
     if (name == "ContinueStatement"){
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = string("goto ") + "c-o-n-t-i-n-u-e" + "\n" + node_attr_map[n].label + " : ";
     }
     if (name == "ReturnStatement"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].variable = return_reg;
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][1]].variable + "\n";
                    break;
               case 1:
                    break;
          }
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code += node_attr_map[n].label;
          node_attr_map[n].code += " : ";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ThrowStatement"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SynchronizedStatement"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if(name == "TryStatement"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Catches"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "CatchClause"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Finally"){
          node_attr_map[n] = node_attr_map[adj[n][1]];
     }

     if (name == "Primary"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
     }
     if (name == "PrimaryNoNewArray"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 4:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 5:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 6:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;               
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassInstanceCreationExpression"){
          node_attr_map[n].variable = get_new_temp();
          string t = get_new_temp();
          switch(reducer){
               case 0:
                    node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].code += "call allocmem size(" + node_attr_map[adj[n][1]].type + ")\n";
                    node_attr_map[n].code += node_attr_map[n].variable + " = pop stack \n";        
                    node_attr_map[n].code += "param " + node_attr_map[n].variable + "\n";
                    node_attr_map[n].code += node_attr_map[adj[n][3]].code;
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].code += "call allocmem size(" + node_attr_map[adj[n][1]].type + ")\n";
                    node_attr_map[n].code += node_attr_map[n].variable + " = pop stack \n";  
                    node_attr_map[n].code += "param " + node_attr_map[n].variable + "\n";
                    break;
          }
          node_attr_map[n].code += "call" + node_attr_map[adj[n][0]].variable + " " + node_attr_map[adj[n][1]].type + ".constructor\n";
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "ArgumentList"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].code += "param " + node_attr_map[adj[n][0]].variable + "\n";
                    break;
               case 1:
                    node_attr_map[n].code += "param " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ArrayCreationExpression"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size = node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    break;
               case 1:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size += node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    break;
               case 2:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size += node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    node_attr_map[n].dims.push_back("ZERO");
                    break;
               case 3:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size += node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    for (int i = 0; i < node_attr_map[adj[n][3]].dims.size(); i++) {
                         node_attr_map[n].dims.push_back(node_attr_map[adj[n][3]].dims[i]);
                    }
                    break;
               case 4:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size += node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    for (int i = 0; i < node_attr_map[adj[n][3]].dims.size(); i++) {
                         node_attr_map[n].dims.push_back(node_attr_map[adj[n][3]].dims[i]);
                    }
                    node_attr_map[n].dims.push_back("ZERO");
                    break;
          }
          
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "DimExprs"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].dims = node_attr_map[adj[n][0]].dims;
                    break;
               case 1:
                    node_attr_map[n].dims = node_attr_map[adj[n][0]].dims;
                    node_attr_map[n].dims.push_back(node_attr_map[adj[n][1]].dims[0]);
                    break;
          }
          return;
     }
     if (name == "DimExpr"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].dims.push_back(node_attr_map[adj[n][1]].variable);
          return;
     }
     if (name == "Dims"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].dims = node_attr_map[adj[n][0]].dims;
          node_attr_map[n].dims.push_back("ZERO");
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "FieldAccess"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }

          switch(reducer){
               case 0:
                    node_attr_map[n].variable = "this." + nodes[adj[adj[n][2]][0]];
                    break;
               case 1:
                    node_attr_map[n].variable = "*" + nodes[adj[adj[n][0]][0]] + "." + node_attr_map[adj[adj[n][1]][0]].variable;
                    break;
          }
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "MethodInvocation"){
          string code = "";
          for (int i = 0; i < adj[n].size(); i++) {
               code = code + node_attr_map[adj[n][i]].code;
          }
          code += "push stack ra\n";
          switch(reducer){
               case 0:
                    code += "call " + node_attr_map[adj[n][0]].variable  + "\n";
                    break;         
               case 1:
                    code += "call " + node_attr_map[adj[n][0]].variable + "." + nodes[adj[n][2]] + "\n";
                    break;
               case 2:
                    code += "call super." + nodes[adj[n][2]] + "\n";
                    break;
               case 3:
                    code += "call " + node_attr_map[adj[n][0]].variable  + "\n";
                    break;         
               case 4:
                    code += "call " + node_attr_map[adj[n][0]].variable + "." + nodes[adj[n][2]] + "\n";
                    break;
               case 5:
                    code += "call super." + nodes[adj[n][2]] + "\n";
                    break;
          }
          node_attr_map[n].code = code;
          node_attr_map[n].variable = return_reg;
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "ArrayAccess"){
          node_attr_map[n].type = node_attr_map[adj[n][0]].type;
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }       
          string temp1 = get_new_temp();
          string temp2 = get_new_temp();
          string temp3 = get_new_temp();
          string temp4 = get_new_temp();
          string temp5 = get_new_temp();
          switch(reducer){
               case 0:
                    node_attr_map[n].code += temp1 + " = " + node_attr_map[adj[n][0]].offset + "*"+"symtable(" + node_attr_map[adj[n][0]].variable+".dim" + to_string(node_attr_map[adj[n][0]].dim_count)+")\n";
                    node_attr_map[n].code += temp2 + " = " + temp1 + "+" + node_attr_map[adj[n][2]].variable + "\n";
                    node_attr_map[n].code += temp3 + " = " + temp2 + "*" + "size(element of " + node_attr_map[adj[n][0]].variable + ")\n";
                    node_attr_map[n].code += temp4 + " = " + temp3 + "+" + node_attr_map[adj[n][0]].variable + "\n";
                    node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].variable;
                    node_attr_map[n].dim_count += 1;
                    node_attr_map[n].offset = temp2;
                    node_attr_map[n].variable ="*" + temp4;
                    break;
               case 1:
                    node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].arr_ptr;
                    node_attr_map[n].code += temp1 + " = " + node_attr_map[adj[n][0]].offset + "*"+"symtable(" + node_attr_map[adj[n][0]].arr_ptr+".dim" + to_string(node_attr_map[adj[n][0]].dim_count)+")\n";
                    node_attr_map[n].code += temp2 + " = " + temp1 + "+" + node_attr_map[adj[n][2]].variable + "\n";
                    node_attr_map[n].code += temp3 + " = " + temp2 + "*" + "size(element of " + node_attr_map[adj[n][0]].arr_ptr + ")\n";
                    node_attr_map[n].code += temp4 + " = " + temp3 + "+" + node_attr_map[adj[n][0]].arr_ptr + "\n";
                    // node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].variable;
                    node_attr_map[n].dim_count += 1;
                    node_attr_map[n].offset = temp2;
                    node_attr_map[n].variable ="*" + temp4;
                    break;
          } 
          return;
     }

     if (name == "PostfixExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you in postfix\n";
          return;
     }
     if (name == "PostIncrementExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          node_attr_map[n].variable = get_new_temp();
          if (node_attr_map[n].type == "int"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +int 1\n";
          }
          else if (node_attr_map[n].type == "float"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +float 1.0\n";
          }
          node_attr_map[n].code += node_attr_map[adj[n][0]].variable + " = " + node_attr_map[n].variable + "\n";
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "PostDecrementExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          node_attr_map[n].variable = get_new_temp();
          if (node_attr_map[n].type == "int"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -int 1\n";
          }
          else if (node_attr_map[n].type == "float"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -float 1.0\n";
          }         
          node_attr_map[n].code += node_attr_map[adj[n][0]].variable  + " = " + node_attr_map[n].variable + "\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "UnaryExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = -" + node_attr_map[adj[n][1]].variable + "\n";
                    break;
               case 4:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
          }
          
          // if(node_attr_map[n].label ==  "L3")
          // cout << node_attr_map[n].code;
          // cout << "found you in unary\n";
          return;
     }
     if (name == "PreIncrementExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          node_attr_map[n].variable = get_new_temp();
          if (node_attr_map[n].type == "int"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +int 1\n";
          }
          else if (node_attr_map[n].type == "float"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +float 1.0\n";
          }
          node_attr_map[n].code += node_attr_map[adj[n][0]].variable + " = " + node_attr_map[n].variable + "\n";
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "PreDecrementExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          node_attr_map[n].variable = get_new_temp();
          if (node_attr_map[n].type == "int"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -int 1\n";
          }
          else if (node_attr_map[n].type == "float"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -float 1.0\n";
          }         
          node_attr_map[n].code += node_attr_map[adj[n][0]].variable  + " = " + node_attr_map[n].variable + "\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "UnaryExpressionNotPlusMinus"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = -" + node_attr_map[adj[n][0]].variable + "\n";
                    break;
               case 2:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = !" + node_attr_map[adj[n][1]].variable + "\n";
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code += node_attr_map[n].variable + " = 0 -" + node_attr_map[adj[n][1]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "CastExpression"){
          // unimplemented
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MultiplicativeExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if (node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type)
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " *" + node_attr_map[adj[n][0]].type + " " +node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 +  " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " *float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " *float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if (node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type)
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " /"+node_attr_map[adj[n][0]].type + " "  + node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " /float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " /float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if (node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type)
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " %" +node_attr_map[adj[n][0]].type + " "+  node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " %float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " %float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }


     if (name == "AdditiveExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if ((node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type) ||(node_attr_map[adj[n][0]].type == "int" && node_attr_map[adj[n][2]].type == "float") || (node_attr_map[adj[n][0]].type == "") ||( node_attr_map[adj[n][2]].type == ""))
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +" + node_attr_map[adj[n][0]].type + " " + node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " +float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if (node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type)
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -"+node_attr_map[adj[n][0]].type + " "  + node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " -float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 +" = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ShiftExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " << " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " >> " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " >>> " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "RelationalExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " < " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " > " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " <= " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 4:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " >= " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 5: 
                    // instanceof unimplemented
                    break;
          }
          node_attr_map[n].type = "boolean";
          node_attr_map[n].size = 1;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "EqualityExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " == " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 2:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " != " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          node_attr_map[n].type = "boolean";
          node_attr_map[n].size = 1;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "AndExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " & " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ExclusiveOrExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " ^ " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InclusiveOrExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " | " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ConditionalAndExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " && " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ConditionalOrExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " || " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ConditionalExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    string code;

                    string true_label = get_new_label();
                    string false_label = get_new_label();
                    node_attr_map[n].label = get_new_label();

                    code += "if " + node_attr_map[adj[n][0]].variable + " goto " + true_label + "\n";
                    code += "goto " + false_label + "\n";
                    code += true_label + " : " + node_attr_map[adj[n][2]].code;
                    code += "goto " + node_attr_map[n].label;
                    code += false_label + " : " + node_attr_map[adj[n][4]].code;
                    code += "goto " + node_attr_map[n].label;
                    code += node_attr_map[n].label + " : ";

                    node_attr_map[n].code = code;
                    node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "AssignmentExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Assignment"){
          node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code ; 
          if ((node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type) || (node_attr_map[adj[n][0]].type == "") || (node_attr_map[adj[n][2]].type == ""))
               node_attr_map[n].code += node_attr_map[adj[n][0]].variable + " = " + node_attr_map[adj[n][2]].variable + "\n";
          else{
               string temp = get_new_temp();
               node_attr_map[n].code += temp + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
               node_attr_map[n].code += node_attr_map[adj[n][0]].variable + " = " + node_attr_map[adj[n][2]].variable + "\n";
          }
          node_attr_map[n].type = node_attr_map[adj[n][0]].type;
          node_attr_map[adj[n][0]].variable + " = " + node_attr_map[adj[n][2]].variable + "\n";
          node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "LeftHandSide"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "AssignmentOperator"){
          node_attr_map[n].variable = nodes[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Expression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ConstantExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
}
void postorder(int nodes) {
    for (int i = 0; i < adj[nodes].size(); i++) {
        postorder(adj[nodes][i]);
    }
    postorder_3AC(nodes);
}
void generate_3AC(string s, string file){
     map<string,int> m;
     ofstream myfile;
     myfile.open(file);
     // myfile << s;
     // myfile << "END : " << endl;
     int line_count = 1;

     for(auto it = s.begin(); it != s.end();){
          if(*it == '\n'){
               while(it!=s.end() && *it == '\n'){
                    it++;
                    if(*it == '\n')
                         it = s.erase(it);
               }
               line_count++;
               // cout << line_count << endl;
          }
          else if(*it == 'L'){
               while(it != s.end() && *it == 'L'){
                    string label = "";
                    while(it != s.end() && *it != ' '){
                         label += *it;
                         it++;
                    }
                    // cout << label << " " << line_count << endl;
                    m[label] = line_count;
                    it += 3;
                    if(it != s.end() && *it == '\n')
                         line_count--;
               }
          }
          else{
               while(it != s.end() && *it != '\n')
                    it++;
          }

     }

     for(auto it = m.begin(); it != m.end(); it++){
          while(s.find(it->first + " : ") != string::npos){
               // myfile << "found ya" << it->first << endl;
               s.erase(s.find(it->first + " : "), it->first.length() + 3);
          }
     }

     for(auto it = m.rbegin(); it != m.rend(); it++)
          while(s.find(it->first) != string::npos)
               s.replace(s.find(it->first), (it->first).length(), to_string(it->second));

     // myfile << "map begins" << endl;
     // for(auto it = m.begin(); it != m.end(); it++)
     //      myfile << it->first << " : " << it->second << endl;
     myfile << s;
}
     