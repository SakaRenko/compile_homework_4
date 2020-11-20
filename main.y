%{
    #include"common.h"
    extern TreeNode * root;
    int yylex();
    int yyerror( char const * );
%}
%defines

%start program

%token ID INTEGER CHAR STRING
%token IF ELSE WHILE FOR RETURN
%token CHAR INT VOID
%token COMMA LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK SEMICOLON
%token TRUE FALSE
%token ASSIGN
%token ADD MINUS TIMES DEVIDE MOD
%token NOT AND OR EQUAL LESS MORE LESSE MOREE
%token PRINTF SCANF
%token UMINUS UADD

%token MAIN

%right ASSIGN
%left OR
%left AND
%left EQUAL LESS MORE
%left LESSE MOREE
%left PLUS MINUS
%left TIMES DEVIDE MOD
%right NOT UMINUS UADD
%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE 
%%
program
    : VOID MAIN LBRACE statements RBRACE{root=new StmtNode("main function");root->addChild($4);}
    ;
statements
    : statement {$$=$1;}
    | statements statement{$$=$1;$$->sibling = $2;}
    ;
statement
    : declare {$$=$1;}
    | assign {$$=$1;}
    | if_else {$$=$1;}
    | while {$$=$1;}
    | for {$$=$1;}
    | printf SEMICOLON {$$=$1;}
    | scanf SEMICOLON {$$=$1;}
    ;
fieldstatement
    : statement {
        TreeNode *node = new StmtNode("Set the new Field", 1);
        node->addson($1);
        $$ = node;
    }
    | LBRACE statements RBRACE{
        TreeNode *node = new StmtNode("Set the new Field", 1);
        node->addson($2);
        $$ = node;
    }
    ;
if_else
    : IF LPAREN bool_expr RPAREN fieldstatement %prec LOWER_THEN_ELSE {
        TreeNode *node=new StmtNode("IF_ELSE", 0);
        node->addson($3);
        node->addson($5);
        $$=node;
    }
    | IF LPAREN bool_expr RPAREN fieldstatement ELSE fieldstatement {
        TreeNode *node=new StmtNode("IF_ELSE", 0);
        node->addson($3);
        node->addson($5);
        node->addson($7);
        $$=node;
    }
    ;
while
    : WHILE LPAREN bool_expr RPAREN fieldstatement {
        TreeNode *node=new StmtNode("WHILE", 0);
        node->addson($3);
        node->addson($5);
        $$=node;
    }
    ;
for
    : FOR LPAREN statement bool_statment statement RPAREN fieldstatement{
        TreeNode *node = new StmtNode("FOR", 0);
        node->addson($3);
        node->addson($4);
        node->addson($5);
        $$ = node;
    }
    ;
bool_statment
    : bool_expr SEMICOLON {$$=$1;}
    ;
declare
    : type instructions SEMICOLON{
        TreeNode *node = new StmtNode("DECLARE", 0);
        node->addson($1);
        node->addson($2);
        $$ = node;
    }
    ;
assign
    : instructions SEMICOLON{
        TreeNode *node = new StmtNode("ASSIGN", 0);
        node->addson($1);
        $$ = node;
    }
    ;
instructions
    : instructions COMMA instruction {$$ = $1; $$->sibling = $2;}
    | instruction {$$ = $1;}
    ;
instruction
    : ID ASSIGN expr {
        TreeNode *node=new ExprNode("=");
        node->addson($1);
        node->addson($3);
        $$=node;  
    }
    | ID {$$ = $1;}
    | expr{$$=$1;}
    ;
string
    : STRING {
        TreeNode * node = new ArrayNode(yytext, 0);
        $$=node;
    }
    ;
printf
    : PRINTF LPAREN string RPAREN {
        TreeNode *node=new StmtNode("printf", 0);
        node->addson($3);
        $$=node;
    }
    ;
scanf
    : SCANF LPAREN string RPAREN {
        TreeNode *node=new StmtNode("scanf", 0);
        node->addson($3);
        $$=node;
    }
    ;
bool_expr
    : TRUE {$$=$1;}
    | FALSE {$$=$1;}
    | expr EQUAL expr {
        TreeNode *node=new ExprNode("==");
        node->addson($1);
        node->addson($3);
        $$=node;
    }
    | expr LESS expr {
        TreeNode *node=new ExprNode("<");
        node->addson($1);
        node->addson($3);
        $$=node;
    }
    | expr MORE expr {
        TreeNode *node=new ExprNode(">");
        node->addson($1);
        node->addson($3);
        $$=node;
    }
    | expr LESSE expr {
        TreeNode *node=new ExprNode("<=");
        node->addson($1);
        node->addson($3);
        $$=node;
    }
    | expr MOREE expr {
        TreeNode *node=new ExprNode(">=");
        node->addson($1);
        node->addson($3);
        $$=node;
    }
    | bool_expr AND bool_expr{
        TreeNode *node = new ExprNode("&&");
        node->addson($1);
        node->addson($3);
        $$=node;
    }
    | bool_expr OR bool_expr{
        TreeNode *node = new ExprNode("||");
        node->addson($1);
        node->addson($3);
        $$=node;
    }
    | NOT bool_expr {
        TreeNode *node=new TreeNode("!");
        node->addson($2);
        $$=node; 
    }
    ;
expr
    : ID {$$=$1;}
    | INTEGER {$$=$1;}
    | expr ADD expr {
        TreeNode *node=new ExprNode("+");
        node->addson($1);
        node->addson($3);
        $$=node;   
    }
    | expr MINUS expr {
        TreeNode *node=new ExprNode("-");
        node->addson($1);
        node->addson($3);
        $$=node;   
    }
    | expr TIMES expr {
        TreeNode *node=new ExprNode("*");
        node->addson($1);
        node->addson($3);
        $$=node;   
    }
    | expr DEVIDE expr {
        TreeNode *node=new ExprNode("/");
        node->addson($1);
        node->addson($3);
        $$=node;   
    }
    | expr MOD expr {
        TreeNode *node=new ExprNode("%");
        node->addson($1);
        node->addson($3);
        $$=node;   
    }
    | MINUS expr %prec UMINS {
        TreeNode *node=new ExprNode("-");
        node->addson($2);
        $$=node;   
    }
    | ADD expr %prec UADD {
        TreeNode *node=new ExprNode("+");
        node->addson($2);
        $$=node;   
    }
    ;
type
    : INT {
        TreeNode *node=new TypeNode("int");
        $$=node; 
    }
    | VOID {
        TreeNode *node=new TypeNode("void");
        $$=node;        
    }
    | CHAR {
        TreeNode *node=new TypeNode("char");
        $$=node;        
    }
    ;

%%