#ifndef TREE_H
#define TREE_H

#include<string>
#include<iostream>

using namespace std;


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
    int calsize()
    {
        int base = 0;
        if(name == "int")
            base = 4;
        else if(name == "char")
            base = 1;
        else if(name == "") return 0;
        else return -1;
        int num = 1;
        for(int i = 0; i < dim; i++)
            num *= len[i];
        return base * num;
    }
};

enum NodeType{TYPE, VAR,  STMT, EXPR};

class TreeNode
{
    public:
    static int count;
    static int line;
    NodeType type;
    int nodenum;
    int lineno;
    TreeNode * sons;
    TreeNode * endson;
    TreeNode * sibling;
    MyType valuetype;
    int nextlabel, beginlabel;
    int truelabel, falselabel;
    bool nexttrue, nextfalse;
    TreeNode(NodeType type);
    void addson(TreeNode * son);
    virtual void printnode(){};
    void printsons();
    void printAST();
};

class field
{
    public:
        int count;
        field * fa;
        field *next[100];
    field():count(0){};
};

field * infield(field * cur);
field * outfield(field * cur);
bool checkfield(field * tar, field * cur);

class VarNode: public TreeNode
{
    public:
        string name;
        bool ifconst;
        int def;
        bool ifarray;
        int length[10];
        int dim;
        VarNode(string n, bool c):TreeNode(VAR)
        {
            name = n;
            ifconst = c;
            def = -1;
            ifarray = false;
            length[0] = 1;
            dim = 1;
        };
        void printnode();
        void appenddim(int len);
};

class TypeNode: public TreeNode
{
    public:
        string t;
        TypeNode(string t):TreeNode(TYPE)
        {
            this->t = t;
        };
        void printnode();
};


class ExprNode: public TreeNode
{
    public:
        string op;
        int offset;
        ExprNode(string o):TreeNode(EXPR)
        {
            offset = 1;
            op = o;
        };
        void printnode();
};

class StmtNode: public TreeNode
{
    public:
        string stmt;
        bool newfield;
        StmtNode(string s, bool f):TreeNode(STMT)
        {
            stmt = s;
            newfield = f;
        };
        void printnode();
};
#endif
