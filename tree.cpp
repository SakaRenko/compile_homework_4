#include<tree.h>
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
            sons = endson = new LinkNode(son);
        }
        else
        {
            endson->next = new LinkNode(son);
            endson = endson->next;
        }
        son = son->sibling;
    }
}

void TreeNode::printsons()
{
    LinkNode * now = sons;
    while(now != NULL)
    {
        cout<<now->node->nodenum<<",";
        now = now->next;
    }
    cout<<endl;
}

void TreeNode::printAST()
{
    this->printnode();
    LinkNode * now = sons;
    while(now != NULL)
    {
        now->printAST();
        now = now->next;
    }
}

void VarNode::printnode()
{
    if(this->ifconst)
    cout<<"Constant Variable\t"<<"symbol:"<<this->name<<"\tat field:"<<this->def;
    else
    cout<<"Variable\t"<<"symbol:"<<this->name<<"\tat field:"<<this->def;
    cout<<"\tchildren:";
    this->printsons();
}

void ArrayNode::printnode()
{
    if(this->ifconst)
    cout<<"Constant Array\t"<<"symbol:"<<this->name<<"\tat field:"<<this->def;
    else
    cout<<"Array\t"<<"symbol:"<<this->name<<"\tat field:"<<this->def;
    cout<<"\tchildren:";
    this->printsons();
}

void TypeNode::printnode()
{
    cout<<"Type Indication\top:"<<this->type<<"\tChildren:";
    this->printsons();
}


void ExprNode::printnode()
{
    cout<<"Expression\top:"<<this->op<<"\tChildren:";
    this->printsons();
}

void StmtNode::printnode()
{
    cout<<"Statement:"<<this->stmt<<"\tChildren";
    this->printsons();
}

field * infield(field * cur)
{
    cur->next[cur->count] = new field();
    return cur->next[cur->count++];
}

field * outfield(field * cur)
{
    return cur->fa;
}