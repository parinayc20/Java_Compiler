%{
#include<bits/stdc++.h>
#define YYDEBUG 1

extern int yylineno;

std::vector<std::string> nodes;
std::vector<std::vector<int>> adj;
int node_count = 0;

typedef struct ast_node {
    char* type;
    char* value;
    struct ast_node* left;
    struct ast_node* right;
} ast_node;

ast_node* new_node(char* type, char* value, ast_node* left, ast_node* right) {
    ast_node* node = (ast_node*)malloc(sizeof(ast_node));
    node->type =  type;
    node->value = value;
    node->left = left;
    node->right = right;
    return node;
}

void print_ast(ast_node* node, FILE* fp) {
    if (node != NULL) {
        fprintf(fp, "\t\"%p\" [label=\"%s\"];\n", node, node->type);
        if (node->left != NULL) {
            fprintf(fp, "\t\"%p\" -> \"%p\";\n", node, node->left);
            print_ast(node->left, fp);
        }
        if (node->right != NULL) {
            fprintf(fp, "\t\"%p\" -> \"%p\";\n", node, node->right);
            print_ast(node->right, fp);
        }
    }
}

extern int yylex(void);
void yyerror(const char*);

ast_node* root;

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

Literal:
     INTEGER_LITERAL {nodes.push_back(std::string("INTEGER_LITERAL")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Literal");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    FLOATING_POINT_LITERAL {nodes.push_back(std::string("FLOATING_POINT_LITERAL")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Literal");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    CHARACTER_LITERAL {nodes.push_back(std::string("CHARACTER_LITERAL")+"(\\\'"+strdup($1)+"\\\')");adj.push_back(std::vector<int>());nodes.push_back("Literal");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    STRING_LITERAL {nodes.push_back(std::string("STRING_LITERAL")+"(\\\""+strdup($1)+"\\\")");adj.push_back(std::vector<int>());nodes.push_back("Literal");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    TEXT_BLOCK_LITERAL {nodes.push_back(std::string("TEXT_BLOCK_LITERAL")+"(\\\"\\\"\\\""+strdup($1)+"\\\"\\\"\\\")");adj.push_back(std::vector<int>());nodes.push_back("Literal");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    NULL_LITERAL {nodes.push_back(std::string("NULL_LITERAL")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Literal");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|	BOOLEAN_LITERAL {nodes.push_back(std::string("BOOLEAN_LITERAL")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Literal");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


Type:
     PrimitiveType {nodes.push_back("Type");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ReferenceType {nodes.push_back("Type");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


PrimitiveType:
     NumericType {nodes.push_back("PrimitiveType");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    BOOLEAN {nodes.push_back(std::string("BOOLEAN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("PrimitiveType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    STRING {nodes.push_back(std::string("STRING")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("PrimitiveType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


NumericType:
     IntegralType {nodes.push_back("NumericType");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    FloatingPointType {nodes.push_back("NumericType");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


IntegralType:
     BYTE {nodes.push_back(std::string("BYTE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("IntegralType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    SHORT {nodes.push_back(std::string("SHORT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("IntegralType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    INT {nodes.push_back(std::string("INT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("IntegralType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    LONG {nodes.push_back(std::string("LONG")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("IntegralType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    CHAR {nodes.push_back(std::string("CHAR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("IntegralType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


FloatingPointType:
     FLOAT {nodes.push_back(std::string("FLOAT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("FloatingPointType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    DOUBLE {nodes.push_back(std::string("DOUBLE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("FloatingPointType");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


ReferenceType:
     ClassOrInterfaceType {nodes.push_back("ReferenceType");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ArrayType {nodes.push_back("ReferenceType");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


ClassOrInterfaceType:
     Name {nodes.push_back("ClassOrInterfaceType");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


ClassType:
     ClassOrInterfaceType {nodes.push_back("ClassType");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


InterfaceType:
     ClassOrInterfaceType {nodes.push_back("InterfaceType");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


ArrayType:
     PrimitiveType SQUARE_OPEN SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayType");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    Name SQUARE_OPEN SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayType");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    ArrayType SQUARE_OPEN SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayType");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


Name:
     SimpleName {nodes.push_back("Name");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    QualifiedName {nodes.push_back("Name");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


SimpleName:
     IDENTIFIER {nodes.push_back(std::string("IDENTIFIER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("SimpleName");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


QualifiedName:
     Name DOT IDENTIFIER {nodes.push_back(std::string("DOT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("QualifiedName");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


CompilationUnit:
     PackageDeclaration ImportDeclarations TypeDeclarations {nodes.push_back("CompilationUnit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);$$ =node_count+0;node_count += 1;}
|    PackageDeclaration {nodes.push_back("CompilationUnit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ImportDeclarations {nodes.push_back("CompilationUnit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    TypeDeclarations {nodes.push_back("CompilationUnit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PackageDeclaration ImportDeclarations {nodes.push_back("CompilationUnit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;}
|    PackageDeclaration TypeDeclarations {nodes.push_back("CompilationUnit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;}
|    ImportDeclarations TypeDeclarations {nodes.push_back("CompilationUnit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


ImportDeclarations:
     ImportDeclaration {nodes.push_back("ImportDeclarations");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ImportDeclarations ImportDeclaration {nodes.push_back("ImportDeclarations");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


TypeDeclarations:
     TypeDeclaration {nodes.push_back("TypeDeclarations");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    TypeDeclarations TypeDeclaration {nodes.push_back("TypeDeclarations");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


PackageDeclaration:
     PACKAGE Name SEMICOLON {nodes.push_back(std::string("PACKAGE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("PackageDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


ImportDeclaration:
     SingleTypeImportDeclaration {nodes.push_back("ImportDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    TypeImportOnDemandDeclaration {nodes.push_back("ImportDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


SingleTypeImportDeclaration:
     IMPORT Name SEMICOLON {nodes.push_back(std::string("IMPORT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("SingleTypeImportDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


TypeImportOnDemandDeclaration:
     IMPORT Name DOT MULTIPLY SEMICOLON {nodes.push_back(std::string("IMPORT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("DOT")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("MULTIPLY")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("TypeImportOnDemandDeclaration");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back($2);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;};


TypeDeclaration:
     ClassDeclaration {nodes.push_back("TypeDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    InterfaceDeclaration {nodes.push_back("TypeDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    SEMICOLON {nodes.push_back(std::string("SEMICOLON")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("TypeDeclaration");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};

MethodTypeDeclaration:
     ClassDeclaration {nodes.push_back("MethodTypeDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    InterfaceDeclaration {nodes.push_back("MethodTypeDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


Modifiers:
     Modifier {nodes.push_back("Modifiers");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    Modifiers Modifier {nodes.push_back("Modifiers");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


Modifier:
     PUBLIC {nodes.push_back(std::string("PUBLIC")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    PROTECTED {nodes.push_back(std::string("PROTECTED")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    PRIVATE {nodes.push_back(std::string("PRIVATE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    STATIC {nodes.push_back(std::string("STATIC")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    ABSTRACT {nodes.push_back(std::string("ABSTRACT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    FINAL {nodes.push_back(std::string("FINAL")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    NATIVE {nodes.push_back(std::string("NATIVE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    SYNCHRONIZED {nodes.push_back(std::string("SYNCHRONIZED")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    TRANSIENT {nodes.push_back(std::string("TRANSIENT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    VOLATILE {nodes.push_back(std::string("VOLATILE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Modifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


ClassDeclaration:
     Modifiers CLASS IDENTIFIER Super Interfaces ClassBody {nodes.push_back(std::string("CLASS")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($4);adj[node_count+2].push_back($5);adj[node_count+2].push_back($6);$$ =node_count+2;node_count += 3;}
|    CLASS IDENTIFIER Super Interfaces ClassBody {nodes.push_back(std::string("CLASS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($3);adj[node_count+2].push_back($4);adj[node_count+2].push_back($5);$$ =node_count+2;node_count += 3;}
|    Modifiers CLASS IDENTIFIER Interfaces ClassBody {nodes.push_back(std::string("CLASS")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($4);adj[node_count+2].push_back($5);$$ =node_count+2;node_count += 3;}
|    Modifiers CLASS IDENTIFIER Super ClassBody {nodes.push_back(std::string("CLASS")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($4);adj[node_count+2].push_back($5);$$ =node_count+2;node_count += 3;}
|    CLASS IDENTIFIER Super ClassBody {nodes.push_back(std::string("CLASS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($3);adj[node_count+2].push_back($4);$$ =node_count+2;node_count += 3;}
|    CLASS IDENTIFIER Interfaces ClassBody {nodes.push_back(std::string("CLASS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($3);adj[node_count+2].push_back($4);$$ =node_count+2;node_count += 3;}
|    Modifiers CLASS IDENTIFIER ClassBody {nodes.push_back(std::string("CLASS")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($4);$$ =node_count+2;node_count += 3;}
|    CLASS IDENTIFIER ClassBody {nodes.push_back(std::string("CLASS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($3);$$ =node_count+2;node_count += 3;};


Super:
     EXTENDS ClassType {nodes.push_back(std::string("EXTENDS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Super");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;};


Interfaces:
     IMPLEMENTS InterfaceTypeList {nodes.push_back(std::string("IMPLEMENTS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Interfaces");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;};


InterfaceTypeList:
     InterfaceType {nodes.push_back("InterfaceTypeList");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    InterfaceTypeList COMMA InterfaceType {nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("InterfaceTypeList");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;};


ClassBody:
     CURLY_OPEN CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassBody");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN ClassBodyDeclarations CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassBody");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


ClassBodyDeclarations:
     ClassBodyDeclaration {nodes.push_back("ClassBodyDeclarations");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ClassBodyDeclarations ClassBodyDeclaration {nodes.push_back("ClassBodyDeclarations");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


ClassBodyDeclaration:
     ClassMemberDeclaration {nodes.push_back("ClassBodyDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    StaticInitializer {nodes.push_back("ClassBodyDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ConstructorDeclaration {nodes.push_back("ClassBodyDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    TypeDeclaration {nodes.push_back("ClassBodyDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}


ClassMemberDeclaration:
     FieldDeclaration {nodes.push_back("ClassMemberDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    MethodDeclaration {nodes.push_back("ClassMemberDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


FieldDeclaration:
     Modifiers Type VariableDeclarators SEMICOLON {nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("FieldDeclaration");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    Type VariableDeclarators SEMICOLON {nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("FieldDeclaration");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back($2);adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


VariableDeclarators:
     VariableDeclarator {nodes.push_back("VariableDeclarators");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    VariableDeclarators COMMA VariableDeclarator {nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("VariableDeclarators");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;};


VariableDeclarator:
     VariableDeclaratorId {nodes.push_back("VariableDeclarator");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    VariableDeclaratorId ASSIGN VariableInitializer {nodes.push_back(std::string("ASSIGN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("VariableDeclarator");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count);adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count+1;node_count += 2;};


VariableDeclaratorId:
     IDENTIFIER {nodes.push_back(std::string("IDENTIFIER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("VariableDeclaratorId");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    VariableDeclaratorId SQUARE_OPEN SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("VariableDeclaratorId");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


VariableInitializer:
     Expression {nodes.push_back("VariableInitializer");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ArrayInitializer {nodes.push_back("VariableInitializer");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


MethodDeclaration:
     MethodHeader MethodBody {nodes.push_back("MethodDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


MethodHeader:
     Modifiers Type MethodDeclarator Throws {nodes.push_back("MethodHeader");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);adj[node_count+0].push_back($4);$$ =node_count+0;node_count += 1;}
|    Modifiers VOID MethodDeclarator Throws {nodes.push_back(std::string("VOID")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodHeader");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);adj[node_count+1].push_back($4);$$ =node_count+1;node_count += 2;}
|    Type MethodDeclarator Throws {nodes.push_back("MethodHeader");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);$$ =node_count+0;node_count += 1;}
|    Modifiers Type MethodDeclarator {nodes.push_back("MethodHeader");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);$$ =node_count+0;node_count += 1;}
|    Type MethodDeclarator {nodes.push_back("MethodHeader");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;}
|    VOID MethodDeclarator Throws {nodes.push_back(std::string("VOID")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodHeader");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;}
|    Modifiers VOID MethodDeclarator {nodes.push_back(std::string("VOID")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodHeader");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;}
|    VOID MethodDeclarator {nodes.push_back(std::string("VOID")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodHeader");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;};


MethodDeclarator:
     IDENTIFIER PAR_OPEN FormalParameterList PAR_CLOSE {nodes.push_back(std::string("IDENTIFIER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodDeclarator");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back($3);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;}
|    IDENTIFIER PAR_OPEN PAR_CLOSE {nodes.push_back(std::string("IDENTIFIER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodDeclarator");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;}
|    MethodDeclarator SQUARE_OPEN SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodDeclarator");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


FormalParameterList:
     FormalParameter {nodes.push_back("FormalParameterList");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    FormalParameterList COMMA FormalParameter {nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("FormalParameterList");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;};


FormalParameter:
     Type VariableDeclaratorId {nodes.push_back("FormalParameter");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;}
|    VariableModifier Type VariableDeclaratorId {nodes.push_back("FormalParameter");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);$$ =node_count+0;node_count += 1;};


Throws:
     THROWS ClassTypeList {nodes.push_back(std::string("THROWS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Throws");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;};


ClassTypeList:
     ClassType {nodes.push_back("ClassTypeList");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ClassTypeList COMMA ClassType {nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassTypeList");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;};


MethodBody:
     MethodBlock {nodes.push_back("MethodBody");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    SEMICOLON {nodes.push_back(std::string("SEMICOLON")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodBody");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


StaticInitializer:
     STATIC Block {nodes.push_back(std::string("STATIC")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("StaticInitializer");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;};


ConstructorDeclaration:
     Modifiers ConstructorDeclarator Throws ConstructorBody {nodes.push_back("ConstructorDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);adj[node_count+0].push_back($4);$$ =node_count+0;node_count += 1;}
|    Modifiers ConstructorDeclarator ConstructorBody {nodes.push_back("ConstructorDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);$$ =node_count+0;node_count += 1;}
|    ConstructorDeclarator Throws ConstructorBody {nodes.push_back("ConstructorDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);$$ =node_count+0;node_count += 1;}
|    ConstructorDeclarator ConstructorBody {nodes.push_back("ConstructorDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


ConstructorDeclarator:
     SimpleName PAR_OPEN PAR_CLOSE {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ConstructorDeclarator");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    SimpleName PAR_OPEN FormalParameterList PAR_CLOSE {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ConstructorDeclarator");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


ConstructorBody:
     CURLY_OPEN ExplicitConstructorInvocation BlockStatements CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ConstructorBody");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN BlockStatements CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ConstructorBody");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN ExplicitConstructorInvocation CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ConstructorBody");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ConstructorBody");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


ExplicitConstructorInvocation:
     THIS PAR_OPEN ArgumentList PAR_CLOSE SEMICOLON {nodes.push_back(std::string("THIS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back("ExplicitConstructorInvocation");adj.push_back(std::vector<int>());adj[node_count+4].push_back(node_count+0);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back($3);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back(node_count+3);$$ =node_count+4;node_count += 5;}
|    SUPER PAR_OPEN ArgumentList PAR_CLOSE SEMICOLON {nodes.push_back(std::string("SUPER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back("ExplicitConstructorInvocation");adj.push_back(std::vector<int>());adj[node_count+4].push_back(node_count+0);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back($3);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back(node_count+3);$$ =node_count+4;node_count += 5;}
|    THIS PAR_OPEN PAR_CLOSE SEMICOLON {nodes.push_back(std::string("THIS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ExplicitConstructorInvocation");adj.push_back(std::vector<int>());adj[node_count+4].push_back(node_count+0);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back(node_count+3);$$ =node_count+4;node_count += 5;}
|    SUPER PAR_OPEN PAR_CLOSE SEMICOLON {nodes.push_back(std::string("SUPER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ExplicitConstructorInvocation");adj.push_back(std::vector<int>());adj[node_count+4].push_back(node_count+0);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back(node_count+3);$$ =node_count+4;node_count += 5;};


InterfaceDeclaration:
     Modifiers INTERFACE IDENTIFIER ExtendsInterfaces InterfaceBody {nodes.push_back(std::string("INTERFACE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("InterfaceDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($4);adj[node_count+2].push_back($5);$$ =node_count+2;node_count += 3;}
|    Modifiers INTERFACE IDENTIFIER InterfaceBody {nodes.push_back(std::string("INTERFACE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("InterfaceDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($4);$$ =node_count+2;node_count += 3;}
|    INTERFACE IDENTIFIER ExtendsInterfaces InterfaceBody {nodes.push_back(std::string("INTERFACE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("InterfaceDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($3);adj[node_count+2].push_back($4);$$ =node_count+2;node_count += 3;}
|    INTERFACE IDENTIFIER InterfaceBody {nodes.push_back(std::string("INTERFACE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("InterfaceDeclaration");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($3);$$ =node_count+2;node_count += 3;};


ExtendsInterfaces:
     EXTENDS InterfaceType {nodes.push_back(std::string("EXTENDS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("ExtendsInterfaces");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;}
|    ExtendsInterfaces COMMA InterfaceType {nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ExtendsInterfaces");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;};


InterfaceBody:
     CURLY_OPEN InterfaceMemberDeclarations CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("InterfaceBody");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("InterfaceBody");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


InterfaceMemberDeclarations:
     InterfaceMemberDeclaration {nodes.push_back("InterfaceMemberDeclarations");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    InterfaceMemberDeclarations InterfaceMemberDeclaration {nodes.push_back("InterfaceMemberDeclarations");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


InterfaceMemberDeclaration:
     ConstantDeclaration {nodes.push_back("InterfaceMemberDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    AbstractMethodDeclaration {nodes.push_back("InterfaceMemberDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


ConstantDeclaration:
     FieldDeclaration {nodes.push_back("ConstantDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


AbstractMethodDeclaration:
     MethodHeader SEMICOLON {nodes.push_back(std::string("SEMICOLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("AbstractMethodDeclaration");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


ArrayInitializer:
     CURLY_OPEN VariableInitializers COMMA CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("COMMA")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayInitializer");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back($2);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;}
|    CURLY_OPEN VariableInitializers CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayInitializer");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN COMMA CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayInitializer");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;}
|    CURLY_OPEN CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayInitializer");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


VariableInitializers:
     VariableInitializer {nodes.push_back("VariableInitializers");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    VariableInitializers COMMA VariableInitializer {nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("VariableInitializers");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;};


Block:
     CURLY_OPEN CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("Block");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN BlockStatements CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("Block");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


BlockStatements:
     BlockStatement {nodes.push_back("BlockStatements");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    BlockStatements BlockStatement {nodes.push_back("BlockStatements");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


BlockStatement:
     LocalVariableDeclarationStatement {nodes.push_back("BlockStatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    Statement {nodes.push_back("BlockStatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};

MethodBlock:
     CURLY_OPEN CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodBlock");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN MethodBlockStatements CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodBlock");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


MethodBlockStatements:
     MethodBlockStatement {nodes.push_back("MethodBlockStatements");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    MethodBlockStatements MethodBlockStatement {nodes.push_back("MethodBlockStatements");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


MethodBlockStatement:
     LocalVariableDeclarationStatement {nodes.push_back("MethodBlockStatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    Statement {nodes.push_back("MethodBlockStatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    MethodTypeDeclaration {nodes.push_back("MethodBlockStatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


LocalVariableDeclarationStatement:
     LocalVariableDeclaration SEMICOLON {nodes.push_back(std::string("SEMICOLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("LocalVariableDeclarationStatement");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


LocalVariableDeclaration:
     Type VariableDeclarators {nodes.push_back("LocalVariableDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;}
|    VariableModifier Type VariableDeclarators {nodes.push_back("LocalVariableDeclaration");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);adj[node_count+0].push_back($3);$$ =node_count+0;node_count += 1;};


VariableModifier:
     FINAL {nodes.push_back(std::string("FINAL")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("VariableModifier");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


Statement:
     StatementWithoutTrailingSubstatement {nodes.push_back("Statement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    LabeledStatement {nodes.push_back("Statement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    IfThenStatement {nodes.push_back("Statement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    IfThenElseStatement {nodes.push_back("Statement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    WhileStatement {nodes.push_back("Statement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ForStatement {nodes.push_back("Statement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


StatementNoShortIf:
     StatementWithoutTrailingSubstatement {nodes.push_back("StatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    LabeledStatementNoShortIf {nodes.push_back("StatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    IfThenElseStatementNoShortIf {nodes.push_back("StatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    WhileStatementNoShortIf {nodes.push_back("StatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ForStatementNoShortIf {nodes.push_back("StatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


StatementWithoutTrailingSubstatement:
     Block {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    EmptyStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ExpressionStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    SwitchStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    DoStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    BreakStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ContinueStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ReturnStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    SynchronizedStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ThrowStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    TryStatement {nodes.push_back("StatementWithoutTrailingSubstatement");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


EmptyStatement:
     SEMICOLON {nodes.push_back(std::string("SEMICOLON")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("EmptyStatement");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


LabeledStatement:
     IDENTIFIER COLON Statement {nodes.push_back(std::string("IDENTIFIER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("COLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("LabeledStatement");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($3);$$ =node_count+2;node_count += 3;};


LabeledStatementNoShortIf:
     IDENTIFIER COLON StatementNoShortIf {nodes.push_back(std::string("IDENTIFIER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("COLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("LabeledStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($3);$$ =node_count+2;node_count += 3;};


ExpressionStatement:
     StatementExpression SEMICOLON {nodes.push_back(std::string("SEMICOLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ExpressionStatement");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


StatementExpression:
     Assignment {nodes.push_back("StatementExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PreIncrementExpression {nodes.push_back("StatementExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PreDecrementExpression {nodes.push_back("StatementExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PostIncrementExpression {nodes.push_back("StatementExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PostDecrementExpression {nodes.push_back("StatementExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    MethodInvocation {nodes.push_back("StatementExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ClassInstanceCreationExpression {nodes.push_back("StatementExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


IfThenStatement:
     IF PAR_OPEN Expression PAR_CLOSE Statement {nodes.push_back(std::string("IF")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("IfThenStatement");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back($3);adj[node_count+3].push_back(node_count+2);adj[node_count+3].push_back($5);$$ =node_count+3;node_count += 4;};


IfThenElseStatement:
     IF PAR_OPEN Expression PAR_CLOSE StatementNoShortIf ELSE Statement {nodes.push_back(std::string("IF")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("ELSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("IfThenElseStatement");adj.push_back(std::vector<int>());adj[node_count+4].push_back(node_count+0);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back($3);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back($5);adj[node_count+4].push_back(node_count+3);adj[node_count+4].push_back($7);$$ =node_count+4;node_count += 5;};


IfThenElseStatementNoShortIf:
     IF PAR_OPEN Expression PAR_CLOSE StatementNoShortIf ELSE StatementNoShortIf {nodes.push_back(std::string("IF")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("ELSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("IfThenElseStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+4].push_back(node_count+0);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back($3);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back($5);adj[node_count+4].push_back(node_count+3);adj[node_count+4].push_back($7);$$ =node_count+4;node_count += 5;};


SwitchStatement:
     SWITCH PAR_OPEN Expression PAR_CLOSE SwitchBlock {nodes.push_back(std::string("SWITCH")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("SwitchStatement");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back($3);adj[node_count+3].push_back(node_count+2);adj[node_count+3].push_back($5);$$ =node_count+3;node_count += 4;};


SwitchBlock:
     CURLY_OPEN SwitchBlockStatementGroups SwitchLabels CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("SwitchBlock");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN SwitchBlockStatementGroups CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("SwitchBlock");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN SwitchLabels CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("SwitchBlock");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    CURLY_OPEN CURLY_CLOSE {nodes.push_back(std::string("CURLY_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("CURLY_CLOSE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("SwitchBlock");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


SwitchBlockStatementGroups:
     SwitchBlockStatementGroup {nodes.push_back("SwitchBlockStatementGroups");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    SwitchBlockStatementGroups SwitchBlockStatementGroup {nodes.push_back("SwitchBlockStatementGroups");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


SwitchBlockStatementGroup:
     SwitchLabels BlockStatements {nodes.push_back("SwitchBlockStatementGroup");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


SwitchLabels:
     SwitchLabel {nodes.push_back("SwitchLabels");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    SwitchLabels SwitchLabel {nodes.push_back("SwitchLabels");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


SwitchLabel:
     CASE ConstantExpression COLON {nodes.push_back(std::string("CASE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("COLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("SwitchLabel");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    DEFAULT COLON {nodes.push_back(std::string("DEFAULT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("COLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("SwitchLabel");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


WhileStatement:
     WHILE PAR_OPEN Expression PAR_CLOSE Statement {nodes.push_back(std::string("WHILE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("WhileStatement");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back($3);adj[node_count+3].push_back(node_count+2);adj[node_count+3].push_back($5);$$ =node_count+3;node_count += 4;};


WhileStatementNoShortIf:
     WHILE PAR_OPEN Expression PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("WHILE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("WhileStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back($3);adj[node_count+3].push_back(node_count+2);adj[node_count+3].push_back($5);$$ =node_count+3;node_count += 4;};


DoStatement:
     DO Statement WHILE PAR_OPEN Expression PAR_CLOSE SEMICOLON {nodes.push_back(std::string("DO")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("WHILE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($7)+")");adj.push_back(std::vector<int>());nodes.push_back("DoStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back($2);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($5);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);$$ =node_count+5;node_count += 6;};


ForStatement:
     FOR PAR_OPEN ForInit SEMICOLON Expression SEMICOLON ForUpdate PAR_CLOSE Statement {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($8)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back($3);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($5);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($7);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($9);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN ForInit SEMICOLON SEMICOLON ForUpdate PAR_CLOSE Statement {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($7)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back($3);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($6);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($8);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN SEMICOLON Expression SEMICOLON ForUpdate PAR_CLOSE Statement {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($7)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($4);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($6);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($8);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN ForInit SEMICOLON Expression SEMICOLON PAR_CLOSE Statement {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($7)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back($3);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($5);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($8);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN SEMICOLON SEMICOLON ForUpdate PAR_CLOSE Statement {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($5);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($7);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN SEMICOLON Expression SEMICOLON PAR_CLOSE Statement {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($4);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($7);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN ForInit SEMICOLON SEMICOLON PAR_CLOSE Statement {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back($3);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($7);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN SEMICOLON SEMICOLON PAR_CLOSE Statement {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($6);$$ =node_count+5;node_count += 6;}
|	 FOR PAR_OPEN Type VariableDeclaratorId COLON Expression PAR_CLOSE {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("COLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($7)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatement");adj.push_back(std::vector<int>());adj[node_count+4].push_back(node_count);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back($3);adj[node_count+4].push_back($4);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back($6);adj[node_count+4].push_back(node_count+3);$$ =node_count+4;node_count += 5;};


ForStatementNoShortIf:
     FOR PAR_OPEN ForInit SEMICOLON Expression SEMICOLON ForUpdate PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($8)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back($3);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($5);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($7);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($9);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN ForInit SEMICOLON SEMICOLON ForUpdate PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($7)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back($3);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($6);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($8);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN SEMICOLON Expression SEMICOLON ForUpdate PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($7)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($4);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($6);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($8);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN ForInit SEMICOLON Expression SEMICOLON PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($7)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back($3);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($5);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($8);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN SEMICOLON SEMICOLON ForUpdate PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($5);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($7);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN SEMICOLON Expression SEMICOLON PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back($4);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($7);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN ForInit SEMICOLON SEMICOLON PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back($3);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($7);$$ =node_count+5;node_count += 6;}
|    FOR PAR_OPEN SEMICOLON SEMICOLON PAR_CLOSE StatementNoShortIf {nodes.push_back(std::string("FOR")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back("ForStatementNoShortIf");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);adj[node_count+5].push_back($6);$$ =node_count+5;node_count += 6;};


ForInit:
     StatementExpressionList {nodes.push_back("ForInit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    LocalVariableDeclaration {nodes.push_back("ForInit");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


ForUpdate:
     StatementExpressionList {nodes.push_back("ForUpdate");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


StatementExpressionList:
     StatementExpression {nodes.push_back("StatementExpressionList");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    StatementExpressionList COMMA StatementExpression {nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("StatementExpressionList");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;};


BreakStatement:
     BREAK IDENTIFIER SEMICOLON {nodes.push_back(std::string("BREAK")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("BreakStatement");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;}
|    BREAK SEMICOLON {nodes.push_back(std::string("BREAK")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("BreakStatement");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


ContinueStatement:
     CONTINUE IDENTIFIER SEMICOLON {nodes.push_back(std::string("CONTINUE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ContinueStatement");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;}
|    CONTINUE SEMICOLON {nodes.push_back(std::string("CONTINUE")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ContinueStatement");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


ReturnStatement:
     RETURN Expression SEMICOLON {nodes.push_back(std::string("RETURN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ReturnStatement");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    RETURN SEMICOLON {nodes.push_back(std::string("RETURN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ReturnStatement");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


ThrowStatement:
     THROW Expression SEMICOLON {nodes.push_back(std::string("THROW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SEMICOLON")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("ThrowStatement");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


SynchronizedStatement:
     SYNCHRONIZED PAR_OPEN Expression PAR_CLOSE Block {nodes.push_back(std::string("SYNCHRONIZED")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("SynchronizedStatement");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back($3);adj[node_count+3].push_back(node_count+2);adj[node_count+3].push_back($5);$$ =node_count+3;node_count += 4;};


TryStatement:
     TRY Block Catches {nodes.push_back(std::string("TRY")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("TryStatement");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;}
|    TRY Block Finally {nodes.push_back(std::string("TRY")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("TryStatement");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;}
|    TRY Block Catches Finally {nodes.push_back(std::string("TRY")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("TryStatement");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);adj[node_count+1].push_back($4);$$ =node_count+1;node_count += 2;};


Catches:
     CatchClause {nodes.push_back("Catches");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    Catches CatchClause {nodes.push_back("Catches");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


CatchClause:
     CATCH PAR_OPEN FormalParameter PAR_CLOSE Block {nodes.push_back(std::string("CATCH")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("CatchClause");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back($3);adj[node_count+3].push_back(node_count+2);adj[node_count+3].push_back($5);$$ =node_count+3;node_count += 4;};


Finally:
     FINALLY Block {nodes.push_back(std::string("FINALLY")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("Finally");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;};


Primary:
     PrimaryNoNewArray {nodes.push_back("Primary");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ArrayCreationExpression {nodes.push_back("Primary");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


PrimaryNoNewArray:
     Literal {nodes.push_back("PrimaryNoNewArray");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    THIS {nodes.push_back(std::string("THIS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("PrimaryNoNewArray");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;}
|    PAR_OPEN Expression PAR_CLOSE {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("PrimaryNoNewArray");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    ClassInstanceCreationExpression {nodes.push_back("PrimaryNoNewArray");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    FieldAccess {nodes.push_back("PrimaryNoNewArray");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    MethodInvocation {nodes.push_back("PrimaryNoNewArray");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ArrayAccess {nodes.push_back("PrimaryNoNewArray");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


ClassInstanceCreationExpression:
     NEW ClassType PAR_OPEN ArgumentList PAR_CLOSE {nodes.push_back(std::string("NEW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassInstanceCreationExpression");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back($2);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back($4);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;}
|    NEW ClassType PAR_OPEN PAR_CLOSE {nodes.push_back(std::string("NEW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ClassInstanceCreationExpression");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back($2);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;};


ArgumentList:
     Expression {nodes.push_back("ArgumentList");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ArgumentList COMMA Expression {nodes.push_back(std::string("COMMA")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("ArgumentList");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;};


ArrayCreationExpression:
     NEW PrimitiveType DimExprs {nodes.push_back(std::string("NEW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayCreationExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;}
|    NEW ClassOrInterfaceType DimExprs {nodes.push_back(std::string("NEW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayCreationExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);$$ =node_count+1;node_count += 2;}
|    NEW PrimitiveType DimExprs Dims {nodes.push_back(std::string("NEW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayCreationExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);adj[node_count+1].push_back($4);$$ =node_count+1;node_count += 2;}
|    NEW ClassOrInterfaceType DimExprs Dims {nodes.push_back(std::string("NEW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayCreationExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);adj[node_count+1].push_back($4);$$ =node_count+1;node_count += 2;}
|    NEW PrimitiveType Dims ArrayInitializer {nodes.push_back(std::string("NEW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayCreationExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);adj[node_count+1].push_back($4);$$ =node_count+1;node_count += 2;}
|    NEW ClassOrInterfaceType Dims ArrayInitializer {nodes.push_back(std::string("NEW")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayCreationExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);adj[node_count+1].push_back($3);adj[node_count+1].push_back($4);$$ =node_count+1;node_count += 2;};


DimExprs:
     DimExpr {nodes.push_back("DimExprs");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    DimExprs DimExpr {nodes.push_back("DimExprs");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);adj[node_count+0].push_back($2);$$ =node_count+0;node_count += 1;};


DimExpr:
     SQUARE_OPEN Expression SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("DimExpr");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


Dims:
     SQUARE_OPEN SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("Dims");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    Dims SQUARE_OPEN SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("Dims");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


FieldAccess:
     Primary DOT IDENTIFIER {nodes.push_back(std::string("DOT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("FieldAccess");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    SUPER DOT IDENTIFIER {nodes.push_back(std::string("SUPER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("DOT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("FieldAccess");adj.push_back(std::vector<int>());adj[node_count+3].push_back(node_count+0);adj[node_count+3].push_back(node_count+1);adj[node_count+3].push_back(node_count+2);$$ =node_count+3;node_count += 4;};


MethodInvocation:
     Name PAR_OPEN ArgumentList PAR_CLOSE {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodInvocation");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    Primary DOT IDENTIFIER PAR_OPEN ArgumentList PAR_CLOSE {nodes.push_back(std::string("DOT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodInvocation");adj.push_back(std::vector<int>());adj[node_count+4].push_back($1);adj[node_count+4].push_back(node_count+0);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back($5);adj[node_count+4].push_back(node_count+3);$$ =node_count+4;node_count += 5;}
|    SUPER DOT IDENTIFIER PAR_OPEN ArgumentList PAR_CLOSE {nodes.push_back(std::string("SUPER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("DOT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($6)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodInvocation");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back($5);adj[node_count+5].push_back(node_count+4);$$ =node_count+5;node_count += 6;}
|    Name PAR_OPEN PAR_CLOSE {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodInvocation");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    Primary DOT IDENTIFIER PAR_OPEN PAR_CLOSE {nodes.push_back(std::string("DOT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodInvocation");adj.push_back(std::vector<int>());adj[node_count+4].push_back($1);adj[node_count+4].push_back(node_count+0);adj[node_count+4].push_back(node_count+1);adj[node_count+4].push_back(node_count+2);adj[node_count+4].push_back(node_count+3);$$ =node_count+4;node_count += 5;}
|    SUPER DOT IDENTIFIER PAR_OPEN PAR_CLOSE {nodes.push_back(std::string("SUPER")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("DOT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("IDENTIFIER")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_OPEN")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($5)+")");adj.push_back(std::vector<int>());nodes.push_back("MethodInvocation");adj.push_back(std::vector<int>());adj[node_count+5].push_back(node_count+0);adj[node_count+5].push_back(node_count+1);adj[node_count+5].push_back(node_count+2);adj[node_count+5].push_back(node_count+3);adj[node_count+5].push_back(node_count+4);$$ =node_count+5;node_count += 6;};


ArrayAccess:
     Name SQUARE_OPEN Expression SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayAccess");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;}
|    PrimaryNoNewArray SQUARE_OPEN Expression SQUARE_CLOSE {nodes.push_back(std::string("SQUARE_OPEN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("SQUARE_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ArrayAccess");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);$$ =node_count+2;node_count += 3;};


PostfixExpression:
     Primary {nodes.push_back("PostfixExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    Name {nodes.push_back("PostfixExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PostIncrementExpression {nodes.push_back("PostfixExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PostDecrementExpression {nodes.push_back("PostfixExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


PostIncrementExpression:
     PostfixExpression INCREMENT {nodes.push_back(std::string("INCREMENT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("PostIncrementExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


PostDecrementExpression:
     PostfixExpression DECREMENT {nodes.push_back(std::string("DECREMENT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back("PostDecrementExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back($1);adj[node_count+1].push_back(node_count+0);$$ =node_count+1;node_count += 2;};


UnaryExpression:
     PreIncrementExpression {nodes.push_back("UnaryExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PreDecrementExpression {nodes.push_back("UnaryExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    PLUS UnaryExpression {nodes.push_back(std::string("PLUS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("UnaryExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;}
|    MINUS UnaryExpression {nodes.push_back(std::string("MINUS")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("UnaryExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;}
|    UnaryExpressionNotPlusMinus {nodes.push_back("UnaryExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


PreIncrementExpression:
     INCREMENT UnaryExpression {nodes.push_back(std::string("INCREMENT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("PreIncrementExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;};


PreDecrementExpression:
     DECREMENT UnaryExpression {nodes.push_back(std::string("DECREMENT")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("PreDecrementExpression");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;};


UnaryExpressionNotPlusMinus:
     PostfixExpression {nodes.push_back("UnaryExpressionNotPlusMinus");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    NEGATION UnaryExpression {nodes.push_back(std::string("NEGATION")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("UnaryExpressionNotPlusMinus");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;}
|    EXCLAMATION UnaryExpression {nodes.push_back(std::string("EXCLAMATION")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back("UnaryExpressionNotPlusMinus");adj.push_back(std::vector<int>());adj[node_count+1].push_back(node_count+0);adj[node_count+1].push_back($2);$$ =node_count+1;node_count += 2;}
|    CastExpression {nodes.push_back("UnaryExpressionNotPlusMinus");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


CastExpression:
     PAR_OPEN PrimitiveType Dims PAR_CLOSE UnaryExpression {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("CastExpression");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($5);$$ =node_count+2;node_count += 3;}
|    PAR_OPEN PrimitiveType PAR_CLOSE UnaryExpression {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("CastExpression");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($4);$$ =node_count+2;node_count += 3;}
|    PAR_OPEN Expression PAR_CLOSE UnaryExpressionNotPlusMinus {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($3)+")");adj.push_back(std::vector<int>());nodes.push_back("CastExpression");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($4);$$ =node_count+2;node_count += 3;}
|    PAR_OPEN Name Dims PAR_CLOSE UnaryExpressionNotPlusMinus {nodes.push_back(std::string("PAR_OPEN")+"("+strdup($1)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("PAR_CLOSE")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("CastExpression");adj.push_back(std::vector<int>());adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($2);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($5);$$ =node_count+2;node_count += 3;};


MultiplicativeExpression:
     UnaryExpression {nodes.push_back("MultiplicativeExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    MultiplicativeExpression MULTIPLY UnaryExpression {nodes.push_back(std::string("MULTIPLY")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    MultiplicativeExpression DIVIDE UnaryExpression {nodes.push_back(std::string("DIVIDE")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    MultiplicativeExpression MODULO UnaryExpression {nodes.push_back(std::string("MODULO")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


AdditiveExpression:
     MultiplicativeExpression {nodes.push_back("AdditiveExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    AdditiveExpression PLUS MultiplicativeExpression {nodes.push_back(std::string("PLUS")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    AdditiveExpression MINUS MultiplicativeExpression {nodes.push_back(std::string("MINUS")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


ShiftExpression:
     AdditiveExpression {nodes.push_back("ShiftExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ShiftExpression LEFT_SHIFT AdditiveExpression {nodes.push_back(std::string("LEFT_SHIFT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    ShiftExpression RIGHT_SHIFT AdditiveExpression {nodes.push_back(std::string("RIGHT_SHIFT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    ShiftExpression UNSIGNED_RIGHT_SHIFT AdditiveExpression {nodes.push_back(std::string("UNSIGNED_RIGHT_SHIFT")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


RelationalExpression:
     ShiftExpression {nodes.push_back("RelationalExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    RelationalExpression LESS_THAN ShiftExpression {nodes.push_back(std::string("LESS_THAN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    RelationalExpression GREATER_THAN ShiftExpression {nodes.push_back(std::string("GREATER_THAN")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    RelationalExpression LESS_THAN_OR_EQUAL_TO ShiftExpression {nodes.push_back(std::string("LESS_THAN_OR_EQUAL_TO")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    RelationalExpression GREATER_THAN_OR_EQUAL_TO ShiftExpression {nodes.push_back(std::string("GREATER_THAN_OR_EQUAL_TO")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    RelationalExpression INSTANCEOF ReferenceType {nodes.push_back(std::string("INSTANCEOF")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


EqualityExpression:
     RelationalExpression {nodes.push_back("EqualityExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    EqualityExpression EQUAL_TO RelationalExpression {nodes.push_back(std::string("EQUAL_TO")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;}
|    EqualityExpression NOT_EQUAL_TO RelationalExpression {nodes.push_back(std::string("NOT_EQUAL_TO")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


AndExpression:
     EqualityExpression {nodes.push_back("AndExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    AndExpression BITWISE_AND EqualityExpression {nodes.push_back(std::string("BITWISE_AND")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


ExclusiveOrExpression:
     AndExpression {nodes.push_back("ExclusiveOrExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ExclusiveOrExpression BITWISE_XOR AndExpression {nodes.push_back(std::string("BITWISE_XOR")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


InclusiveOrExpression:
     ExclusiveOrExpression {nodes.push_back("InclusiveOrExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    InclusiveOrExpression BITWISE_OR ExclusiveOrExpression {nodes.push_back(std::string("BITWISE_OR")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


ConditionalAndExpression:
     InclusiveOrExpression {nodes.push_back("ConditionalAndExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ConditionalAndExpression AND_LOGICAL InclusiveOrExpression {nodes.push_back(std::string("AND_LOGICAL")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


ConditionalOrExpression:
     ConditionalAndExpression {nodes.push_back("ConditionalOrExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ConditionalOrExpression OR_LOGICAL ConditionalAndExpression{nodes.push_back(std::string("OR_LOGICAL")+"("+strdup($2)+")");adj.push_back(std::vector<int>());adj[node_count].push_back($1);adj[node_count].push_back($3);$$ = node_count;node_count += 1;};


ConditionalExpression:
     ConditionalOrExpression {nodes.push_back("ConditionalExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ConditionalOrExpression QUESTION Expression COLON ConditionalExpression {nodes.push_back(std::string("QUESTION")+"("+strdup($2)+")");adj.push_back(std::vector<int>());nodes.push_back(std::string("COLON")+"("+strdup($4)+")");adj.push_back(std::vector<int>());nodes.push_back("ConditionalExpression");adj.push_back(std::vector<int>());adj[node_count+2].push_back($1);adj[node_count+2].push_back(node_count+0);adj[node_count+2].push_back($3);adj[node_count+2].push_back(node_count+1);adj[node_count+2].push_back($5);$$ =node_count+2;node_count += 3;};


AssignmentExpression:
     ConditionalExpression {nodes.push_back("AssignmentExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    Assignment {nodes.push_back("AssignmentExpression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


Assignment:
     LeftHandSide AssignmentOperator AssignmentExpression {$$ = $2;adj[$2].push_back($1);adj[$2].push_back($3);};


LeftHandSide:
     Name {nodes.push_back("LeftHandSide");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    FieldAccess {nodes.push_back("LeftHandSide");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;}
|    ArrayAccess {nodes.push_back("LeftHandSide");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


AssignmentOperator:
     ASSIGN {nodes.push_back(std::string("ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    MULTIPLY_ASSIGN {nodes.push_back(std::string("MULTIPLY_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    DIVIDE_ASSIGN {nodes.push_back(std::string("DIVIDE_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    MOD_ASSIGN {nodes.push_back(std::string("MOD_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    PLUS_ASSIGN {nodes.push_back(std::string("PLUS_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    MINUS_ASSIGN {nodes.push_back(std::string("MINUS_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    LEFT_SHIFT_ASSIGN {nodes.push_back(std::string("LEFT_SHIFT_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    RIGHT_SHIFT_ASSIGN {nodes.push_back(std::string("RIGHT_SHIFT_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    UNSIGNED_RIGHT_SHIFT_ASSIGN {nodes.push_back(std::string("UNSIGNED_LEFT_SHIFT_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    AND_ASSIGN {nodes.push_back(std::string("AND_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    XOR_ASSIGN {nodes.push_back(std::string("XOR_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;}
|    OR_ASSIGN {nodes.push_back(std::string("OR_ASSIGN")+"("+strdup($1)+")");adj.push_back(std::vector<int>()); $$ = node_count;node_count+=1;};


Expression:
     AssignmentExpression {nodes.push_back("Expression");adj.push_back(std::vector<int>());adj[node_count+0].push_back($1);$$ =node_count+0;node_count += 1;};


ConstantExpression:
     Expression {nodes.push_back("ConstantExpression");adj.push_back(std::vector<int>());adj[node_count].push_back($1);$$ =node_count;node_count += 1;};



%%

int main(int argc, char* argv[]) {
	  yydebug = 0;
     int help_flag = 0;
     std::string input_file = "";
     std::string output_file = "ast.dot";
     for(int i = 1 ; i < argc; i++) {
          std::string s = argv[i];
          if(s == "--help") {
               help_flag = 1;
               continue;
          }
          if(s == "--verbose") {
               yydebug = 1;
               continue;
          }
          std::string flag = s;
          if(s.length() <= 7) {
               std::cerr << "Wrong usage of flags" << std::endl;
               return 0;
          }
          flag = flag.substr(0, 8);
          if(flag == "--input=") {
               input_file = s.substr(8, s.length());
               continue;
          }
          flag = s;
          if(s.length() <= 8) {
               std::cerr << "Wrong usage of flags" << std::endl;
               return 0;
          }
          flag = flag.substr(0, 9);
          if(flag == "--output=") {
               output_file = s.substr(9, s.length());
               continue;
          }
          std::cerr << "Wrong flag" << std::endl;
          return 0;
     }

     if(help_flag) {
          std::cout << "Usage: ./parser --input=<input_file_path> --output=<output_file_path> [options]" << std::endl;
          std::cout << "The following options can be used" << std::endl;
          std::cout << "--input=<input_file_path> \t: Input file specification (default is command line)" << std::endl;
          std::cout << "--output=<output_file_path> \t: Output file specification (default is ast.dot)" << std::endl;
          std::cout << "--help \t\t\t\t: Instruction regarding usage instructions and options" << std::endl;
          std::cout << "--verbose \t\t\t: Prints the complete stack trace of the parser execution" << std::endl;
          return 0;
     }

     if(input_file != "") {
          freopen(input_file.c_str(), "r", stdin);
     }
    

     yyparse();

     std::ofstream dotFile(output_file.c_str());

     dotFile << "digraph G {\n  ordering=\"out\"" << std::endl;
	
	std::vector<bool> valid(nodes.size(),true);
	for(int i=0;i<nodes.size();i++){
		for(int j=0; j<adj[i].size();j++){
			int k = adj[i][j];
			while(adj[k].size() == 1){
                valid[k] = false;
                k = adj[k][0];
            }
			adj[i][j] = k;
		}
	}


    for (int i = 0; i < nodes.size(); i++) {
		if(valid[i])
        	dotFile << "  " << i << " [label=\"" << nodes[i] << "\"];" << std::endl;
    }

    for (int i = 0; i < adj.size(); i++) {
        for (int j = 0; j < adj[i].size(); j++) {
			if(valid[i])
            	dotFile << "  " << i << " -> " << adj[i][j] << ";" << std::endl;
        }
    }

    dotFile << "}" << std::endl;

    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Line number:%d Error: %s\n",yylineno, s);
}
