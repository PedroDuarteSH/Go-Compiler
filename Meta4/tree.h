/*
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TREEH

//Structs
typedef struct Node
{
	char* nodeClass;
	char* nodeValue;
	char* nodeType;
	int line;
	int column;
	int is_func;
	struct Node *son;
	struct Node *brother;
} Node;

Node *new_node(char *type, char *value, Node *son);
Node *new_node_CL(char *type, char *value, Node *son, int line, int column);
Node *new_brother(Node *brother, Node *brother_to_add);

void print_tree(Node * node, int aux);
void print_tree_withLC(Node * node, int depth);
void cleanTree(Node * node);