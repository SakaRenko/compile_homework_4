%{
    #include"common.h"
    extern TreeNode * root;
    int yylex();
    int yyerror( char const * );
%}
%defines

%start program

%token ID INTEGER STRING
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

%right ASSIGN MASSIGN AASSIGN
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
    : VOID MAIN LPAREN RPAREN LBRACE statements RBRACE{root=new StmtNode("Main function", 0);root->addson($6);}
    ;
statements
    : statement {$$=$1;}
    | statement statements{$1->sibling = $2;$$=$1;}
    ;
statement
    : declare {$$=$1;}
    | assign {$$=$1;}
    | if_else {$$=$1;}
    | while {$$=$1;}
    | for {$$=$1;}
    | printf SEMICOLON {$$=$1;}
    | scanf SEMICOLON {$$=$1;}
    | RETURN expr SEMICOLON {
        TreeNode *node = new StmtNode("Return", false);
        node->addson($2);
        $$=node;
    }
    | SEMICOLON {}
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
    : FOR LPAREN instruction SEMICOLON bool_expr SEMICOLON instruction RPAREN fieldstatement{
        TreeNode *node = new StmtNode("FOR", 0);
        node->addson($3);
        node->addson($5);
        node->addson($7);
        node->addson($9);
        $$ = node;
    }
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
    : notdeinstructions SEMICOLON{
        TreeNode *node = new StmtNode("ASSIGN", 0);
        node->addson($1);
        $$ = node;
    }
    ;
notdeinstructions
    : notdeinstruction COMMA notdeinstructions {$1->sibling = $3;$$=$1;}
    | notdeinstruction {$$ = $1;}
    | instruction COMMA notdeinstructions {$1->sibling = $3;$$=$1;}
    | instruction {$$ = $1;}
    ;
instructions
    : instruction COMMA instructions {$1->sibling = $3;$$=$1;}
    | instruction {$$ = $1;}
    ;
notdeinstruction
    :ID MASSIGN expr {
        TreeNode *node=new ExprNode("-=");
        node->addson($1);
        node->addson($3);
        $$=node;  
    }
    | ID AASSIGN expr {
        TreeNode *node=new ExprNode("+=");
        node->addson($1);
        node->addson($3);
        $$=node;  
    }
    | expr{$$=$1;}
    ;
instruction
    : ID ASSIGN expr {
        TreeNode *node=new ExprNode("=");
        node->addson($1);
        node->addson($3);
        $$=node;  
    }
    | ID {$$ = $1;}
    ;
string
    : STRING {
        $$=$1;
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
        TreeNode *node=new ExprNode("!");
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
    | MINUS expr %prec UMINUS {
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