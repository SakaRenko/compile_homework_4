%option noyywrap
%{
    #include"common.h"
%}

INTEGER [0-9]+
ID [[:alpha:]_][[:alpha:][:digit:]_]*

EOL (\r\n|\n)
WHITE [\t ]
STRING "[^"]"
%x COMMENT
%x LINECOMMENT
commentelement . | \n
linecommentelement .
%%

"/*" BEGIN COMMENT;
<COMMENT> {commentelement}
<COMMENT> "*/" BEGIN INITIAL;

"//" BEGIN LINECOMMENT;
<LINECOMMENT> {linecommentelement}
<LINECOMMENT> {EOL} {BEGIN INITIAL;}

"true" {
    TreeNode *node = new VarNode("1", 1);
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new VarNode("0", 1);
    yylval = node;
    return FALSE;
}

"int" return INT;
"char" return CHAR;
"void" return VOID;

"main" return MAIN;

""

"if" return IF;
"while" return WHILE;
"else" return ELSE;
"for" return FOR;
"return" return RETURN;

"printf" return PRINTF;
"scanf" return SCANF;

"=" return ASSIGN;

"+" return ADD;
"-" return MINUS;
"*" return TIMES;
"/" return DEVIDE;
"%" return MOD;

"!" return NOT;
"&&" return AND;
"||" return OR;
"==" return EQUAL;
"<" return LESS;
">" return MORE;
"<=" return LESSE;
">=" return MOREE;

";" return SEMICOLON;
"(" return LPAREN;
")" return RPAREN;
"{" return LBRACE;
"}" return RBRACE;
"[" return LBRACK;
"]" return RBRACK;

"," return COMMA;


{INTEGER} {
    TreeNode *node = new VarNode(yytext, true);
    yylval = node;
    return INTEGER;
}
{ID} {
    TreeNode *node = new VarNode(yytext, true);
    yylval = node;
    return ID;
}
{STRING} return STRING;
{EOL}
{WHITE}

%%