#include"tree.h"
#include<iostream>

using namespace std;

TreeNode::TreeNode(NodeType type)
{
    this->type = type;
    this->nodenum = TreeNode::count++;
    sons = endson = NULL;
    sibling = NULL;
}

void TreeNode::addson(TreeNode * son)
{
    while(son != NULL)
    {
        if(endson == NULL)
        {
            sons = endson = son;
        }
        else
        {
            endson->sibling = son;
            endson = endson->sibling;
        }
        son = son->sibling;
    }
}

void TreeNode::printsons()
{
    TreeNode * now = sons;
    while(now != NULL)
    {
        cout<<now->nodenum<<",";
        now = now->sibling;
    }
    cout<<endl;
}

void TreeNode::printAST()
{
    this->printnode();
    TreeNode * now = this->sons;
    while(now != NULL)
    {
        now->printAST();
        now = now->sibling;
    }
}

void VarNode::printnode()
{
    cout<<nodenum<<"\t";
    if(!ifarray)
    {
        if(this->ifconst)
            cout<<"Constant Variable\t"<<"symbol:"<<this->name<<"\tnumbered as:"<<this->def;
        else
            cout<<"Variable\t"<<"symbol:"<<this->name<<"\tnumbered as:"<<this->def;
    }
    else
    {
        if(this->ifconst)
            cout<<"Constant Array\t"<<"symbol:"<<this->name<<"\tnumbered as:"<<this->def;
        else
            cout<<"Array\t"<<"symbol:"<<this->name<<"\tnumbered as:"<<this->def;
    }
    cout<<"\tChildren:";
    this->printsons();
}

void TypeNode::printnode()
{
    cout<<nodenum<<"\t";
    cout<<"Type Indication\top:"<<this->t<<"\tChildren:";
    this->printsons();
}


void ExprNode::printnode()
{
    cout<<nodenum<<"\t";
    cout<<"Expression\top:"<<this->op<<"\tChildren:";
    this->printsons();
}

void StmtNode::printnode()
{
    cout<<nodenum<<"\t";
    cout<<"Statement:"<<this->stmt<<"\tChildren:";
    this->printsons();
}

field * infield(field * cur)
{
    cur->next[cur->count] = new field();
    cur->next[cur->count]->fa = cur;
    return cur->next[cur->count++];
}

field * outfield(field * cur)
{
    return cur->fa;
}

bool checkfield(field *tar, field *cur)
{
    field *now = cur;
    while(now != NULL)
    {
        if(tar == now)
            return true;
        now = now->fa;
    }
    return false;
}