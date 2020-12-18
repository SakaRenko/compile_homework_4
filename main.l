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
CHAR \'\'
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
    TreeNode *node = new VarNode("true", 1);
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new VarNode("false", 1);
    yylval = node;
    return FALSE;
}

"int" return INT;
"char" return CHAR;
"void" return VOID;
"bool" return BOOL;

"struct" return STRUCT;


"if" return IF;
"while" return WHILE;
"else" return ELSE;
"for" return FOR;
"return" return RETURN;

"cin" return CIN;
"cout" return COUT;

"<<" return LM;
">>" return RM;

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
"!=" return NEQUAL;

";" return SEMICOLON;
"(" return LPAREN;
")" return RPAREN;
"{" return LBRACE;
"}" return RBRACE;
"[" return LBRACK;
"]" return RBRACK;

"," return COMMA;
"." return POINT;

{EOL} {TreeNode::line++;}


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
    node->length[0] = node->name.length();
    yylval = node;
    return ID;
}
{CHAR} {
    VarNode * node = new VarNode(yytext, true);
    yylval = node;
    return ID;
}
{EOL}
{WHITE}

%%