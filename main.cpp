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


struct MyType
{
    string name;
    bool isarray;
    int len;
    MyType(string name, int len, bool isarray)
    {
        this->name = name;
        this->len = len;
        this->isarray = isarray;
    }
    MyType()
    {
        this->name = "";
        this->len = 0;
        this->isarray = false;
    }
};


struct sign{
    string name;
    MyType type;
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

void addsign(string name, field *cur, MyType type)
{
    signlist[signcount].name = name;
    signlist[signcount].def = cur;
    signlist[signcount].type = type;
    signcount++;
}

void delcaresign(StmtNode * destmt, field *cur)
{
    TreeNode * now = destmt->sons;
    MyType type;
    TypeNode *t;
    VarNode *var;
    ExprNode *exp;
    while(now != NULL)
    {
        switch(now->type)
        {
            case TYPE:
                t = (TypeNode *)now;
                type.name = t->t;
                break;
            case VAR:
                var = (VarNode *)now;
                type.isarray = var->ifarray;
                type.len = var->length;
                addsign(var->name, cur, type);
                break;
            case EXPR:
                exp = (ExprNode *)now;
                if(exp->op == "=")
                {
                    var = (VarNode *)(now->sons);
                    type.isarray = var->ifarray;
                    type.len = var->length;
                    addsign(var->name, cur, type);
                }
                break;
        };
        now = now->sibling;
    }
}


struct StructMem
{
    string name;
    MyType type;
    StructMem *next;
    StructMem(string name, string type, int len, bool isarray)
    {
        this->name = name;
        this->type = MyType(type, len, isarray);
        next = NULL;
    }
};

StructMem *altype[MAXN];
StructMem *alfunc[MAXN];
int countstruct = 0;
int countfunc = 0;

void setfunc(StmtNode *funcdec)
{
    TreeNode * memdec = funcdec->sons;
    string type = "";
    TypeNode *t;
    VarNode *var, *na;
    string curtype;
    var = (VarNode *)memdec;
    memdec = memdec->sibling;
    na = (VarNode *)memdec;
    StructMem *struc = new StructMem(na->name, var->name, var->length, var->ifarray);
    alfunc[countfunc++] = struc;
    memdec = memdec->sibling;
    while(memdec != NULL)
    {
        StmtNode * st = (StmtNode *)memdec;
        if(st->stmt == "FUNCST")
            break;
        TreeNode * now = memdec->sons;
        while(now != NULL)
        {
            switch(now->type)
            {
                case TYPE:
                    t = (TypeNode *)now;
                    curtype = t->t;
                    break;
                case VAR:
                    var = (VarNode *)now;
                    struc->next = new StructMem(var->name, curtype, var->length, var->ifarray);
                    struc = struc->next;
                    break;
            };
            now = now->sibling;
        }
        memdec = memdec->sibling;
    }
}

void settype(StmtNode *strucdec)
{
    TreeNode * memdec = strucdec->sons;
    string type = "";
    TypeNode *t;
    VarNode *var;
    string curtype;
    var = (VarNode *)memdec;
    StructMem *struc = new StructMem(var->name, var->name, var->length, var->ifarray);
    altype[countstruct++] = struc;
    memdec = memdec->sibling;
    while(memdec != NULL)
    {
        TreeNode * now = memdec->sons;
        while(now != NULL)
        {
            switch(now->type)
            {
                case TYPE:
                    t = (TypeNode *)now;
                    curtype = t->t;
                    break;
                case VAR:
                    var = (VarNode *)now;
                    struc->next = new StructMem(var->name, curtype, var->length, var->ifarray);
                    struc = struc->next;
                    break;
            };
            now = now->sibling;
        }
        memdec = memdec->sibling;
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
        if(st->newfield)
            cur = infield(cur);
        if(st->stmt == "DECLARE")
            delcaresign(st, cur);
        else if(st->stmt == "TYPEDECLARE")
            settype(st);
        else if(st->stmt == "FUNCDEC")
        {
            setfunc(st);
            delcaresign(st, cur);
        }
    }
    TreeNode *begin = now->sons;
    while(begin != NULL)
    {
        setfield(begin, cur);
        begin = begin->sibling;
    }
    if(now->type == STMT)
    {
        StmtNode * st = (StmtNode *)now;
        if(st->newfield)
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
