/*
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/

#ifndef TREEH
    #include "tree.h"
#endif

#ifndef SYMBOLH
    #include "symbol_table.h"
#endif
void print_noted_tree(Node * node, int depth);


TableElem *search(Table *current_table, char *id);
TableElem *searchDeclared(Table *current_table, char *id);
TableElem *search_globalFirst(Table *current_table, char *id);
TableElem *searchFunc(Table *current_table, char *id);

int verify_program(Node * node, Table *global);

int verify_varDecl(Node *node, Table *global);

int verify_funcDecl(Node * node, Table *global);
int verify_funcParams(Node *node, Table *table);
int verify_funcBody(Node *node, Table *table);
int verify_assign(Node *node, Table *table);
int verify_call(Node *node, Table *table);
int verify_if(Node *node, Table *table);
int verify_for(Node *node, Table *table);
int verify_parseArgs(Node *node, Table *table);
int verify_expression(Node *node, Table *table);
int verify_print(Node *node, Table *table); 
int verify_return(Node *node, Table *table);

int verify_unused(Table *table);

void print_error(char * message, int line, int column);