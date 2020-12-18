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
int TreeNode::line = 0;
TreeNode *root=nullptr;
field * rootf = new field();

const int MAXN = 100000;

string ErrorMessage[MAXN];
int errorcount = 0;

void TypeError(string msg, TreeNode * node)
{
    ErrorMessage[errorcount++] = msg + " at line " + to_string(node->lineno);
}

struct MyType
{
    string name;
    bool isarray;
    int len[10];
    int dim;
    MyType(string name, int len, bool isarray)
    {
        this->name = name;
        this->len[0] = len;
        this->dim = 1;
        this->isarray = isarray;
    }
    MyType(string name, int * len, int dim, bool isarray)
    {
        this->name = name;
        this->dim = dim;
        for(int i = 0; i < dim; i++)
            this->len[i] = len[i];
        this->isarray = isarray;
    }
    MyType()
    {
        this->name = "";
        this->len[0] = 0;
        this->dim = 1;
        this->isarray = false;
    }
    void appenddim(int l)
    {
        this->len[dim++] = l;
    }
    bool operator==(const MyType& tar)
    {
        if(this->name != tar.name || this->isarray != tar.isarray || this->dim != tar.dim)
            return false;
        for(int i = 0; i < this->dim; i++)
            if(this->len[i] != tar.len[i])
                return false;
        return true;
    }
    bool operator!=(const MyType& tar)
    {
        return !(*this == tar);
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
    int j;
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
                type.len[0] = var->length[0];
                for(j = 1; j < var->dim; j++)
                    type.appenddim(var->length[j]);
                if(findsign(var->name, cur) > -1)
                {
                    TypeError(var->name + " is already declared", var);
                }
                addsign(var->name, cur, type);
                break;
            case EXPR:
                exp = (ExprNode *)now;
                if(exp->op == "=")
                {
                    var = (VarNode *)(now->sons);
                    type.isarray = var->ifarray;
                    type.len[0] = var->length[0];
                    for(j = 1; j < var->dim; j++)
                        type.appenddim(var->length[j]);
                    if(findsign(var->name, cur) > -1)
                    {
                        TypeError(var->name + " is already declared", var);
                    }
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
    StructMem(string name, string type, int* len, int dim, bool isarray)
    {
        this->name = name;
        this->type = MyType(type, len, dim, isarray);
        next = NULL;
    }
    StructMem(string name, string type, int len, bool isarray)
    {
        this->name = name;
        this->type = MyType(type, len,isarray);
        next = NULL;
    }
};

StructMem *altype[MAXN];
StructMem *alfunc[MAXN];
int countstruct = 0;
int countfunc = 0;

MyType * findmem(string name, StructMem *st)
{
    st = st->next;
    while(st)
    {
        if(st->name == name)
            return &(st->type);
        st = st->next;
    }
    return NULL;
}

int findstruct(string name)
{
    int now = countstruct - 1;
    while(now >= 0)
    {
        if(altype[now]->name == name)
            return now;
        now--;
    }
    return now;
}

int findfunc(string name)
{
    int now = countfunc - 1;
    while(now >= 0)
    {
        if(alfunc[now]->name == name)
            return now;
        now--;
    }
    return now;
}

void setfunc(StmtNode *funcdec)
{
    TreeNode * memdec = funcdec->sons;
    string type = "";
    TypeNode *t;
    VarNode  *na, *var;
    string curtype;
    t = (TypeNode *)memdec;
    memdec = memdec->sibling;
    na = (VarNode *)memdec;
    if(findfunc(na->name) != -1)
    {
        TypeError(na->name + " is already declared", var);
    }
    StructMem *struc = new StructMem(na->name, t->t, 1,  false);
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
                    struc->next = new StructMem(var->name, curtype, var->length, var->dim,  var->ifarray);
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
    StructMem *struc = new StructMem(var->name, var->name, var->length, var->dim, var->ifarray);
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
                    if(findstruct(var->name) != -1)
                    {
                        TypeError(var->name + " is already declared", var);
                    }
                    struc->next = new StructMem(var->name, curtype, var->length, var->dim, var->ifarray);
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
        {
            cur = infield(cur);
        }
        if(st->stmt == "DECLARE")
            delcaresign(st, cur);
        else if(st->stmt == "TYPEDECLARE")
        {
            settype(st);
            return;
        }
        else if(st->stmt == "FUNCDEC")
        {
            setfunc(st);
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

MyType typecheck(TreeNode *);

void checkreturn(MyType retype, TreeNode *funcdec)
{
    if(funcdec->type == STMT)
    {
        StmtNode *stmt = (StmtNode *)funcdec;
        if(stmt->stmt == "RETURN")
        {
            if(retype != typecheck(stmt->sons))
            {
                TypeError("Wrong return type", stmt);
            }
        }
        else
        {
            TreeNode *tnode = funcdec->sons;
            while(tnode != NULL)
            {
                checkreturn(retype, tnode);
                tnode = tnode->sibling;
            }
        }
    }
    
}


MyType typecheck(TreeNode *node)
{
    if(!node)
        return MyType();
    TreeNode *tnode;
    TypeNode *type;
    VarNode * var;
    ExprNode * expr;
    StmtNode *stmt;
    MyType temp[3];
    MyType *tempp;
    int i;
    StructMem *st;
    switch(node->type)
    {
        case TYPE:
            type = (TypeNode *)node;
            if(type->t != "char" && type->t != "int" && type->t != "void" && type->t != "bool")
            {
                if(findstruct(type->t) < 0)
                {
                    TypeError(type->t + " not declared", type);
                    return MyType();
                }
            }
            return MyType(type->t, 1, false);
            break;
        case VAR:
            var = (VarNode *)node;
            if(!var->ifconst)
            {
                if(var->def == -1)
                {
                    TypeError(var->name + " not declared", var);
                   return MyType();
                }
                // cout<<signlist[var->def].name<<" "<<signlist[var->def].type.name<<endl;
                return signlist[var->def].type;
            }
            else if(var->name == "true" || var->name == "false")
                return MyType("bool", 1, false);
            else if(var->name[0] <= '9' && var->name[0] >= '0')
                    return MyType("int", 1, false);
            else return MyType("char", var->name.length() - 2, var->ifarray);
            break;
        case EXPR:
            expr = (ExprNode *)node;
            temp[0] = typecheck(expr->sons);
            if(expr->op == ".")
            {
                i = findstruct(temp[0].name);
                if(temp[0].isarray || i == -1)
                {
                    TypeError("It's not a structure", expr);
                }
                var = (VarNode *)(node->endson);
                tempp = findmem(var->name, altype[i]);
                if(!tempp)
                {
                    TypeError("Member does not exist", expr);
                    return MyType();
                }
                return *tempp;
            }
            temp[1] = typecheck(expr->endson);
            if(expr->op == "=")
            {   
                // cout<<"temp0"<<temp[0].len[0]<<" "<<"temp1"<<temp[1].len[0]<<endl;
                if(temp[0] != temp[1])
                {
                    TypeError("Assignment not of same type", expr);
                }
                return temp[0];
            } 
            else if(expr->op == "+" ||  expr->op == "*" || expr->op == "/" || expr->op == "%")
            {
                if((temp[0].name != "int" && temp[0].name != "char")||(temp[0].name != "int" && temp[0].name != "char")||(temp[0].isarray || temp[1].isarray))
                {
                    TypeError("Operand is not int/char", expr);
                }
                return MyType("int", 1, false);
            }
            else if(expr->op == "-")
            {
                if(expr->sons != expr->endson)
                {
                    if((temp[0].name != "int" && temp[0].name != "char")||(temp[0].name != "int" && temp[0].name != "char")||(temp[0].isarray || temp[1].isarray))
                    {
                        TypeError("Operand is not int/char", expr);
                    }
                }
                else if((temp[0].name != "int" && temp[0].name != "char")||(temp[0].isarray))
                {
                        TypeError("Operand is not int/char", expr);
                }
                return MyType("int", 1, false);
            }
            else if(expr->op == ">=" || expr->op == "<=" || expr->op == "<" || expr->op == ">" || expr->op == "==" || expr->op == "!=")
            {
                if((temp[0].name != "int" && temp[0].name != "char")||(temp[0].name != "int" && temp[0].name != "char")||(temp[0].isarray || temp[1].isarray))
                {
                    TypeError("Operand is not int/char", expr);
                }
                if(temp[0] != temp[1])
                {
                    TypeError("Operand not of same type", expr);
                }
                return MyType("bool", 1, false);
            }
            else if(expr->op == "-=" || expr->op == "+=")
            {
                if((temp[0].name != "int" && temp[0].name != "char")||(temp[0].name != "int" && temp[0].name != "char")||(temp[0].isarray || temp[1].isarray))
                {
                    TypeError("Operand is not int/char", expr);
                }
                if(temp[0] != temp[1])
                {
                    TypeError("Operand not of same type", expr);
                }
                return MyType("int", 1, false);
            }
            else if(expr->op == "||" || expr->op == "&&")
            {
                if((temp[0].name != "bool" )||(temp[1].name != "bool")||(temp[0].isarray || temp[1].isarray))
                {
                    TypeError("Operand is not bool", expr);
                }
                return MyType("bool", 1, false);
            }
            else if(expr->op == "!")
            {
                if((temp[0].name != "bool" )||(temp[0].name != "bool")||temp[0].isarray)
                {
                    TypeError("Operand is not bool", expr);
                }
                return MyType("bool", 1, false);
            }
            else if(expr->op == "[]")
            {
                if(!temp[0].isarray)
                {
                    TypeError("Operand is not an array", expr);
                }
                if(temp[1].name != "int" || temp[1].isarray)
                {
                    TypeError("Operand is not an integer", expr);
                }
                temp[2] = MyType(temp[0].name, 1, false);
                if(temp[0].dim >= 2)
                {
                    temp[2].len[0] = temp[0].len[1];
                    temp[2].isarray = true;
                    for(i = 2; i < temp[0].dim; i++)
                        temp[2].appenddim(temp[0].len[i]);
                }
                return temp[2];
            }
            else
            {
                i = findfunc(expr->op);
                if(i == -1)
                {
                    TypeError("Function does not exist", expr);
                    return MyType();
                }
                st = alfunc[i]->next;
                tnode = expr->sons;
                while(tnode != NULL)
                {
                    temp[0] = typecheck(tnode);
                    if(temp[0] != st->type || st == NULL)
                    {
                        TypeError("The type of paramter is wrong", expr);
                    }
                    tnode = tnode->sibling;
                    if(st != NULL)
                        st = st->next;
                }
                return alfunc[i]->type;
            }
            break;
        case STMT:
            stmt = (StmtNode *)node;
            if(stmt->stmt == "FOR")
            {
                tnode = node->sons;
                temp[0] = typecheck(tnode);
                if(temp[0].name != "int" || temp[0].isarray)
                {
                    TypeError("For loop's first child should be an int", stmt);
                }
                tnode = tnode->sibling;
                temp[0] = typecheck(tnode);
                if(temp[0].name != "bool" || temp[0].isarray)
                {
                    TypeError("For loop's second child should be an bool", stmt);
                }
                tnode = tnode->sibling;
                temp[0] = typecheck(tnode);
                if(temp[0].name != "int" || temp[0].isarray)
                {
                    TypeError("For loop's third child should be an int", stmt);
                }
                tnode = tnode->sibling;
                return typecheck(tnode);
            }
            else if(stmt->stmt == "WHILE")
            {
                tnode = node->sons;
                temp[0] = typecheck(tnode);
                if(temp[0].name != "bool" || temp[0].isarray)
                {
                    TypeError("While loop's first child should be an bool", stmt);
                }
                tnode = tnode->sibling;
                return typecheck(tnode);
            }
            else if(stmt->stmt == "IF")
            {
                tnode = node->sons;
                temp[0] = typecheck(tnode);
                if(temp[0].name != "bool" || temp[0].isarray)
                {
                    TypeError("If's first child should be an bool", stmt);
                }
                tnode = tnode->sibling;
                return typecheck(tnode);
            }
            else if(stmt->stmt == "IF_ELSE")
            {
                tnode = node->sons;
                temp[0] = typecheck(tnode);
                if(temp[0].name != "bool" || temp[0].isarray)
                {
                    TypeError("If_else's first child should be an bool", stmt);
                }
                tnode = tnode->sibling;
                temp[0] = typecheck(tnode);
                tnode = tnode->sibling;
                temp[0] = typecheck(tnode);
                return temp[0];
            }
            else if(stmt->stmt == "cin")
            {
                tnode = node->sons;
                temp[0] = typecheck(tnode);
                if((temp[0].name != "bool" && temp[0].name != "int" && temp[0].name != "char") || temp[0].isarray)
                {
                    TypeError("cin invalid ", stmt);
                }
                return MyType();
            }
            else if(stmt->stmt == "cout")
            {
                tnode = node->sons;
                temp[0] = typecheck(tnode);
                if((temp[0].name != "bool" && temp[0].name != "int" && temp[0].name != "char") || (temp[0].isarray && temp[0].name != "char"))
                {
                    TypeError("cout invalid ", stmt);
                }
                tnode = tnode->sibling;
                return MyType();
            }
            else if(stmt->stmt == "DECLARE MEMBERS")
            {
                tnode = node->sons;
                return typecheck(tnode);
            }
            else if(stmt->stmt == "TYPEDECLARE")
            {
                tnode = node->sons;
                tnode = tnode->sibling;
                while(tnode != NULL)
                {
                    temp[0] = typecheck(tnode);
                    tnode = tnode->sibling;
                }
                return temp[0];
            }
            else if(stmt->stmt == "FUNCDEC")
            {
                type = (TypeNode *)node->sons;
                checkreturn(MyType(type->t, 1, false), stmt);
                tnode = node->sons;
                tnode = tnode->sibling->sibling;
                while(tnode != NULL)
                {
                    temp[0] = typecheck(tnode);
                    tnode = tnode->sibling;
                }
                return temp[0];
            }
            else{
                tnode = node->sons;
                while(tnode != NULL)
                {
                    temp[0] = typecheck(tnode);
                    tnode = tnode->sibling;
                }
                return temp[0];
            }
            break;
    };
}


int main ()
{
    yyparse();
    if(root){
        setfield(root, rootf);
        // root->printAST();
        typecheck(root);
    }
    for(int i = 0; i < errorcount; i++)
        cout<<ErrorMessage[i]<<endl;
}
int yyerror(char const* message)
{
    cout << message << endl;
    return -1;
}
