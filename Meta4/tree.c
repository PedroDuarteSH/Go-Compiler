/*
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/

#include "tree.h"

Node *new_node(char *type, char *value, Node *son){
    Node *new = (Node *) malloc(sizeof(Node));
    new->nodeClass = type;
  	new->nodeValue = value;
	new->nodeType = NULL;
	new->line = 0;
	new->column = 0;
    new->son = son;
    new->brother = NULL;
    return new;
}

Node *new_node_CL(char *type, char *value, Node *son, int line, int column){
    Node *new = (Node *) malloc(sizeof(Node));
    new->nodeClass = type;
  	new->nodeValue = value;
	new->nodeType = NULL;
	
	new->column = column;
	new->line = line;
    new->son = son;
    new->brother = NULL;
    return new;
}

Node * new_brother(Node *brother, Node *brother_to_add){
	if(brother == NULL) return NULL;
	Node *aux = brother;
    while(brother->brother != NULL){
		brother = brother->brother;
	}
	brother->brother = brother_to_add;
    return aux;
}

void print_tree(Node * node, int depth)
{
	if (node == NULL)
		return;
	for (int i = 0; i < depth; ++i)
		printf("..");
	if (node->nodeValue != NULL)
		printf("%s(%s)\n", node -> nodeClass, node->nodeValue);
	else
		printf("%s\n", node->nodeClass);
	print_tree(node->son, depth+1);
	print_tree(node->brother, depth);
}
/*
void print_tree_withLC(Node * node, int depth)
{
	if (node == NULL)
		return;
	for (int i = 0; i < depth; ++i)
		printf("..");
	if (node->nodeValue != NULL)
		printf("%s(%s) %d - %d\n", node -> nodeClass, node->nodeValue, node->colunm, node->line);
	else
		printf("%s %d - %d\n", node->nodeClass, node->colunm, node->line);
	print_tree_withLC(node->son, depth+1);
	print_tree_withLC(node->brother, depth);
}*/

void cleanTree(Node * node){
	if(node == NULL)
		return;
	cleanTree(node->brother);
	cleanTree(node->son);
	free(node);
}