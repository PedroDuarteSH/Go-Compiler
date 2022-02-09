/*
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/

#define SYMBOLH
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#ifndef TREEH
    #include "tree.h"
#endif

#define TRUE 1
#define NONE "none"
#define BUFFLEN 1000


typedef struct Parameters{
    char *id;
    char *type;
    struct Parameters *next;
}Parameters;

typedef struct TableElem{
    char *id;
    char *type;
    int is_param;
    int is_funcDecl;
    
    int line;
    int column;
    int used;
    int declared;
    Parameters *parameters;
    struct TableElem *next;
}TableElem;

typedef struct Table{
    char* type; //Type (Global or func)
    char* id; //If func, id of func
    Parameters *parameters;
    TableElem *elements_list;
    struct Table *next;
}Table;

Table *create_tables(Node *node);
Parameters *insert_param(Table *current_table, Node *node);
TableElem *insert_elem(Table *to_insert, Node *node);
TableElem *insert_program(Table *to_insert, Node *node);
TableElem *insert_varDecl(Table *to_insert, Node *node);
TableElem *insert_funcDecl(Table *to_insert, Node *node);
TableElem *insert_funcHeader(Table *to_insert, Node *node);
TableElem *insert_paramDecl(Table *to_insert, Node *node);
char* get_type(char *node_type);
void print_table(Table *table);
void print_table_elem(TableElem *table_elem);
