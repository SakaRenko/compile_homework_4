//
// Created by YangYuqi on 2020/11/17.
//

//#include"main.tab.hh"
#include"common.h"
#include<iostream>
using std::cout;
using std::endl;
int TreeNode::count = 0;
TreeNode *root=nullptr;
field * rootf = new field();

void setfield(TreeNode * now, field * cur)
{
    if(now->type == VAR)
    {
        VarNode * var = now;
        var->def = cur;
    }
    if(now->type == STMT)
    {
        StmtNode * st = now;
        if(st->stmt == "Set the new Field")
        {
            cur = infield(cur);
        }
    }
    TreeNode::LinkNode begin = now->sons;
    while(begin != NULL)
    {
        setfield(begin->node, cur);
        begin = begin->next;
    }
    if(now->type == STMT)
    {
        StmtNode * st = now;
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
        root->printnode();
        root->printAST();
   }

int yyerror(char const* message)
{
    cout << message << endl;
    return -1;
}
