%{
    #include"common.h"
    extern TreeNode * root;
    int yylex();
    int yyerror( char const * );
%}
%defines

%start program

%token ID INTEGER STRING CHARA
%token IF ELSE WHILE FOR RETURN
%token CHAR INT VOID BOOL
%token COMMA LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK SEMICOLON
%token TRUE FALSE
%token ASSIGN
%token ADD MINUS TIMES DEVIDE MOD
%token NOT AND OR EQUAL NEQUAL LESS MORE LESSE MOREE
%token SCANF PRINTF
%token UMINUS UADD
%token MASSIGN AASSIGN
%token STRUCT

%left OR
%left AND
%left EQUAL LESS MORE
%left LESSE MOREE
%right NOT 
%left ADD MINUS
%left TIMES DEVIDE MOD
%right UMINUS UADD
%left POINT LBRACK RBRACK
%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE 
%%
program
    : decs{root=new StmtNode("PROGRAM", 0);root->addson($1);}
    ;
decs
    : dec{$$=$1;}
    | dec decs{$1->sibling = $2;$$=$1;}
dec 
    : typedeclare{$$=$1;}
    | funcdec{$$=$1;}
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
        TreeNode *node = new StmtNode("RETURN", false);
        node->addson($2);
        $$=node;
    }
    | RETURN SEMICOLON {
        TreeNode *node = new StmtNode("RETURN", false);
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
    : IF LPAREN all_expr RPAREN fieldstatement %prec LOWER_THEN_ELSE {
        TreeNode *node=new StmtNode("IF_ELSE", 0);
        node->addson($3);
        node->addson($5);
        $$=node;
    }
    | IF LPAREN all_expr RPAREN fieldstatement ELSE fieldstatement {
        TreeNode *node=new StmtNode("IF_ELSE", 0);
        node->addson($3);
        node->addson($5);
        node->addson($7);
        $$=node;
    }
    ;
while
    : WHILE LPAREN all_expr RPAREN fieldstatement {
        TreeNode *node=new StmtNode("WHILE", 0);
        node->addson($3);
        node->addson($5);
        $$=node;
    }
    ;
for
    : FOR LPAREN notdeinstruction SEMICOLON all_expr SEMICOLON notdeinstruction RPAREN fieldstatement{
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
    ;
instructions
    : instruction COMMA instructions {$1->sibling = $3;$$=$1;}
    | instruction {$$ = $1;}
    ;
notdeinstruction
    :
    lval ASSIGN all_expr {
        TreeNode *node=new ExprNode("=");
        node->addson($1);
        node->addson($3);
        $$=node;  
    }
    | all_expr{$$ = $1;}
    | lval {$$ = $1;}
    ;
instruction
    : ID ASSIGN all_expr {
        TreeNode *node=new ExprNode("=");
        node->addson($1);
        node->addson($3);
        $$=node;  
    }
    | array {$$ = $1;}
array
    : ID{$$=$1;}
    | ID LBRACK INTEGER RBRACK
    {
        VarNode * i = (VarNode *)$1;
        VarNode * num = (VarNode *)$3;
        i->ifarray = true;
        i->length[0] = stoi(num->name);
        $$ = i;
    }
    | array LBRACK INTEGER RBRACK{
        VarNode * i = (VarNode *)$1;
        VarNode * num = (VarNode *)$3;
        i->appenddim(stoi(num->name));
        $$ = i;
    }
    ;
exprs
    : expr COMMA exprs{$1->sibling = $3;$$=$1;}
    | expr{$$=$1;} 
    ;
lvals 
    : lval{$$=$1;}
    | lval COMMA lvals{$1->sibling = $3; $$=$1;}
    ;
printf
    : PRINTF LPAREN STRING COMMA exprs RPAREN {
        TreeNode *node=new StmtNode("printf", 0);
        node->addson($3);
        node->addson($5);
        $$=node;
    }
    | PRINTF LPAREN STRING RPAREN {
        TreeNode *node=new StmtNode("printf", 0);
        node->addson($3);
        $$=node;
    }
    ;
scanf
    : SCANF LPAREN STRING COMMA lvals RPAREN {
        TreeNode *node=new StmtNode("scanf", 0);
        node->addson($3);
        node->addson($5);
        $$=node;
    }
    | SCANF LPAREN STRING RPAREN {
        TreeNode *node=new StmtNode("scanf", 0);
        node->addson($3);
        $$=node;
    }
    ;
all_expr
    : bool_expr {$$=$1;}
    | expr{$$=$1;}
    ;
bool_expr
    : 
     LPAREN bool_expr RPAREN
    {
        $$ = $2;
    }
    | expr NEQUAL expr {
        TreeNode *node=new ExprNode("!=");
        node->addson($1);
        node->addson($3);
        $$=node;
    }
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
lval
    :
    ID{$$=$1;}
    | LPAREN lval RPAREN {$$=$2;}
    | lval LBRACK expr RBRACK
    {
        TreeNode *node = new ExprNode("[]");
        node->addson($1);
        node->addson($3);
        $$ = node;
    }
    | lval POINT ID{
        TreeNode *node=new ExprNode(".");
        node->addson($1);
        node->addson($3);
        $$=node; 
    }
    ;
realp
    : all_expr{$$=$1;}
    | all_expr COMMA realp{
        $1->sibling = $3;
        $$ = $1;
    }
expr
    : lval {$$=$1;}
    | INTEGER {$$=$1;}
    | CHARA{$$=$1;}
    | ID LPAREN realp RPAREN{
        VarNode * i = (VarNode *)$1;
        TreeNode *node = new ExprNode(i->name);
        node->addson($3);
        $$ = node;
    }
    | ID LPAREN RPAREN{
        VarNode * i = (VarNode *)$1;
        TreeNode *node = new ExprNode(i->name);
        $$ = node;
    }
    | LPAREN expr RPAREN
    {
        $$ = $2;
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
        TreeNode *node=new TypeNode("");
        $$=node;        
    }
    | CHAR {
        TreeNode *node=new TypeNode("char");
        $$=node;        
    }
    | STRUCT ID{
        VarNode * var = (VarNode *)$2;
        TreeNode *node = new TypeNode(var->name);
        $$ = node;
    }
    ;
typedeclare
    : STRUCT ID LBRACE strdeclares RBRACE SEMICOLON{
        TreeNode *node = new StmtNode("TYPEDECLARE", 0);
        node->addson($2);
        node->addson($4);
        $$ = node;
    }  
    ;
strdeclares
    :strdeclare{
        $$ = $1;
    }
    | strdeclare strdeclares
    {
        $$ = $1;
        $1->sibling = $2;
    }
    ;
strdeclare
    :type idlist SEMICOLON
    {
        TreeNode *node = new StmtNode("DECLARE MEMBERS", 0);
        node->addson($1);
        node->addson($2);
        $$ = node;
    }
    ;
idlist 
    :
     array
    {
        $$ = $1;
    }
    | array COMMA idlist
    {
        $1->sibling = $3;
        $$ = $1;
    }
    ;
funcdec
    :type ID LPAREN formalps RPAREN LBRACE statements RBRACE
    {
        TreeNode *node = new StmtNode("FUNCDEC", 1);
        node->addson($1);
        node->addson($2);
        node->addson($4);
        TreeNode *st = new StmtNode("FUNCST", 0);
        st->addson($7);
        node->addson(st);
        $$ = node;
    }
    |type ID LPAREN RPAREN LBRACE statements RBRACE
    {
        TreeNode *node = new StmtNode("FUNCDEC", 1);
        node->addson($1);
        node->addson($2);
        TreeNode *st = new StmtNode("FUNCST", 0);
        st->addson($6);
        node->addson(st);
        $$ = node;
    }
    ;
formalps
    :formalp{$$ = $1;}
    |formalp COMMA formalps{
        $1->sibling = $3;
        $$ = $1;
    }
formalp
    :type ID{
        TreeNode *node = new StmtNode("DECLAREP", 0);
        node->addson($1);
        node->addson($2);
        $$ = node;
    }
%%