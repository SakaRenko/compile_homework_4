%option noyywrap
%{
    #include"common.h"
    #include"main.tab.hh"
%}
INTEGER [0-9]+
ID [[:alpha:]_][[:alpha:][:digit:]_]*

endcomment "*/"
EOL (\r\n|\n)
WHITE [\t ]
STRING \"[^\"]*\"
commentelement .|\n
linecommentelement .
%x COMMENT
%x LINECOMMENT
%%

"/*" BEGIN COMMENT;
<COMMENT>{commentelement} 
<COMMENT>{endcomment} {BEGIN INITIAL;}

"//" BEGIN LINECOMMENT;
<LINECOMMENT>{linecommentelement} 
<LINECOMMENT>{EOL} {BEGIN INITIAL;}

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

"struct" return STRUCT;


"if" return IF;
"while" return WHILE;
"else" return ELSE;
"for" return FOR;
"return" return RETURN;

"printf" return PRINTF;
"scanf" return SCANF;

"=" return ASSIGN;
"-=" return MASSIGN;
"+=" return AASSIGN;

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
"." return POINT;


{INTEGER} {
    TreeNode *node = new VarNode(yytext, true);
    yylval = node;
    return INTEGER;
}
{ID} {
    TreeNode *node = new VarNode(yytext, false);
    yylval = node;
    return ID;
}
{STRING} {
    VarNode * node = new VarNode(yytext, true);
    node->ifarray = true;
    node->length = node->name.length();
    yylval = node;
    return STRING;
}
{EOL}
{WHITE}

%%