//
// Created by YangYuqi on 2020/11/17.
//

#include"main.tab.hh"
#include"common.h"
#include<iostream>
#include<fstream>
using std::cout;
using std::endl;
int TreeNode::count = 0;
TreeNode *root=nullptr;
field * rootf = new field();

const int MAXN = 100000;
struct sign{
    string name;
    string type;
    field * def;
}signlist[MAXN];
int signcount = 0;

int findsign(string name, field *cur)
{
    int now = signcount - 1;
    while(now >= 0)
    {
        if(signlist[now].name == name && checkfield(signlist[now].def, cur))
            return now;
        now--;
    }
    return now;
}

void addsign(string name, field *cur, string type)
{
    signlist[signcount].name = name;
    signlist[signcount].def = cur;
    signlist[signcount].type = type;
    signcount++;
}

void delcaresign(StmtNode * destmt, field *cur)
{
    TreeNode::LinkNode * link = destmt->sons;
    string type = "";
    TypeNode *t;
    VarNode *var;
    ExprNode *exp;
    while(link != NULL)
    {
        TreeNode * now = link->node;
        switch(now->type)
        {
            case TYPE:
                t = (TypeNode *)now;
                type = t->t;
                break;
            case VAR:
                var = (VarNode *)now;
                addsign(var->name, cur, type);
                break;
            case EXPR:
                exp = (ExprNode *)now;
                if(exp->op == "=")
                {
                    var = (VarNode *)(now->sons);
                    addsign(var->name, cur, type);
                }
                break;
        };
        link = link->next;
    }
}

void setfield(TreeNode * now, field * cur)
{
    if(now->type == VAR)
    {
        VarNode * var = (VarNode *)now;
        if(!var->ifconst)
            var->def = findsign(var->name, cur);
    }
    if(now->type == STMT)
    {
        StmtNode * st = (StmtNode *)now;
        if(st->stmt == "Set the new Field")
            cur = infield(cur);
        else if(st->stmt == "DECLARE")
            delcaresign(st, cur);
    }
    TreeNode::LinkNode *begin = now->sons;
    while(begin != NULL)
    {
        setfield(begin->node, cur);
        begin = begin->next;
    }
    if(now->type == STMT)
    {
        StmtNode * st = (StmtNode *)now;
        if(st->stmt == "Set the new Field")
        {
            cur = outfield(cur);
        }
    }
}

int main ()
{
    yyparse();
    if(root){
        setfield(root, rootf);
        root->printAST();
    }
}
int yyerror(char const* message)
{
    cout << message << endl;
    return -1;
}
