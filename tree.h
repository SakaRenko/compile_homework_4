#ifndef TREE_H
#define TREE_H

#include<string>

using namespace std;

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
        ExprNode(string o):TreeNode(EXPR)
        {
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
