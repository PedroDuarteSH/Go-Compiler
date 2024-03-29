/*
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/

#include "symbol_table.h"

Table *global_table = NULL;

Table *create_tables(Node *node){  
     if(node == NULL)
        return NULL;
    Table *new_table = (Table *) malloc(sizeof(Table));
    
    //Program Table
    if(!strcmp(node->nodeClass, "Program")){
        new_table->type = "Global";
        new_table->id = NONE;
        new_table->parameters = NULL;
        new_table->elements_list = insert_elem(new_table, node->son);
        new_table->next = create_tables(node->son);

        global_table = new_table;
        return new_table;
    }

    //FuncDeclaration Table 
    else if(!strcmp(node->nodeClass, "FuncDecl")){
        Node *aux = node->son->son;
        new_table->type = "Function";
        
        new_table->id = strdup(aux->nodeValue);
        while(strcmp(aux->nodeClass, "FuncParams")){
            aux = aux->brother;
        }
        new_table->parameters = insert_param(new_table, aux->son);
        new_table->next = create_tables(node->brother); //Go to other VarDecl/FuncDecl
        new_table->elements_list = insert_elem(new_table, node->son); //Func_Header
        return new_table;
    }
    else if(!strcmp(node->nodeClass, "VarDecl")){
        return create_tables(node->brother);
    }

    return NULL;
}

Parameters *insert_param(Table *current_table, Node *node){
    if(node == NULL)
        return NULL;

    Parameters *parameters = (Parameters *) malloc(sizeof(Parameters));
    parameters->type = get_type(node->son->nodeClass);
    
    parameters->id = strdup(node->son->brother->nodeValue);
    if(node->brother != NULL)
        parameters->next = insert_param(current_table, node->brother);
    return parameters;
}

//Insert elements in table
TableElem *insert_elem(Table *to_insert, Node *node){
    if(node == NULL)
        return NULL;
    TableElem *elem = NULL;

    //If node is a VarDecl
    if(!strcmp("VarDecl", node->nodeClass))
        elem =  insert_varDecl(to_insert, node);
    
    //If node is a FuncDecl
    else if(!strcmp("FuncDecl", node->nodeClass))
        elem = insert_funcDecl(to_insert, node);
    
    else if(!strcmp("FuncHeader", node->nodeClass))
        elem = insert_funcHeader(to_insert, node);

    else if(!strcmp("FuncBody", node->nodeClass))
        elem = insert_elem(to_insert, node->son);

    else{
        elem = insert_elem(to_insert, node->brother);
        
    }
    if(elem !=NULL)
        elem->declared = 0;
    if(to_insert->elements_list == NULL){
        to_insert->elements_list = elem;
    }

    return elem;
}

//To insert a VarDecl
TableElem *insert_varDecl(Table *to_insert, Node *node){
    TableElem *new_symbol = (TableElem *) malloc(sizeof(TableElem));
    Node *aux = node->son;
    new_symbol->used = 0;
    //VarDecl has no parameters
    new_symbol->parameters = NULL;
    
    //Get VarDecl TYPE
    new_symbol->type = get_type(aux->nodeClass);
    
    //Get VarDecl ID (aux = type)
    new_symbol->id = strdup(aux->brother->nodeValue);
    
    if(node->brother != NULL)
        new_symbol->next = insert_elem(to_insert, node->brother);
        
    return new_symbol;
}

//Insert Function Declarations
TableElem *insert_funcDecl(Table *to_insert, Node *node){
    TableElem *new_symbol = (TableElem *) malloc(sizeof(TableElem));
    Node *aux = node->son->son;

    if(strcmp(aux->brother->nodeClass, "FuncParams"))
        new_symbol->type = get_type(aux->brother->nodeClass);
    else new_symbol->type = NONE;

    new_symbol->used = 0;
    new_symbol->id = strdup(aux->nodeValue);
    while(strcmp(aux->nodeClass, "FuncParams")){
        aux = aux->brother;
    }
    new_symbol->parameters = insert_param(to_insert, aux->son);
    new_symbol->next = insert_elem(to_insert, node->brother); //Go to other VarDecl/FuncDecl
    new_symbol->is_funcDecl = TRUE;
    return new_symbol;
}

//Insert Function Headers
TableElem *insert_funcHeader(Table *to_insert, Node *node){
    TableElem *new_symbol = (TableElem *) malloc(sizeof(TableElem));
    Node *aux = node->son->brother;

    //FuncHeader has no parameters
    new_symbol->parameters = NULL;
    
    //Get Func TYPE
    new_symbol->type = get_type(aux->nodeClass);
    
    //Get FuncHeader ID (return)
    new_symbol->id = strdup("return");
    new_symbol->used = 0;
    
    while(strcmp(aux->nodeClass, "FuncParams")){
        aux = aux->brother;
    }
    aux = aux->son;
    
    //If function has parameters
    TableElem *temp = new_symbol;
    while(aux != NULL){
        temp->next = insert_paramDecl(to_insert, aux->son);
        aux = aux->brother;
        temp = temp->next;
    }
    
    temp->next = insert_elem(to_insert, node->brother);
    return new_symbol;
}

//Insert Function Parameters
TableElem *insert_paramDecl(Table *to_insert, Node *node){
    TableElem *new_symbol = (TableElem *) malloc(sizeof(TableElem));
    Node *aux = node;

    //ParamDecl has no parameters
    new_symbol->parameters = NULL;
    
    //Get Parameter
    new_symbol->type = get_type(aux->nodeClass);
    new_symbol->used = 0;
    //Get Parameter ID
    new_symbol->id = strdup(aux->brother->nodeValue);

    new_symbol->is_param = TRUE;
    return new_symbol;
}

//Get type conversion CamelCase to lower case string
char* get_type(char *node_type){
    if(!strcmp(node_type, "Int"))
        return strdup("int");
    else if(!strcmp(node_type, "Float32"))
        return strdup("float32");    
    else if(!strcmp(node_type, "Bool"))
        return strdup("bool");
    else if(!strcmp(node_type, "String"))
        return strdup("string");
    return strdup(NONE);
}

void print_table(Table *table){
    if(table == NULL)
        return;

    if(!strcmp(table->type, "Function")){
        char *params_types_string = (char *) malloc(sizeof(char) * BUFFLEN);
        params_types_string[0] = '\0';
        Parameters *auxiliar = table->parameters;
        while(auxiliar != NULL){
            strcat(params_types_string, auxiliar->type);
            strcat(params_types_string, ",");
            auxiliar = auxiliar->next;
        }
        params_types_string[strlen(params_types_string) - 1] = '\0';
        printf("\n===== Function %s(%s) Symbol Table =====\n", table->id, params_types_string);
        print_table_elem(table->elements_list);
    }
    else{
        printf("===== Global Symbol Table =====\n");
        print_table_elem(table->elements_list);
    } 
    
    print_table(table->next);
}

void print_table_elem(TableElem *table_elem){
    if(table_elem == NULL){
        return;
    }
    char *params_types_string = (char *) malloc(sizeof(char) * BUFFLEN);
    params_types_string[0] = '\0';
    Parameters *auxiliar = table_elem->parameters;
    while(auxiliar != NULL){
        strcat(params_types_string, auxiliar->type);
        strcat(params_types_string, ",");
        auxiliar = auxiliar->next;
    }
    params_types_string[strlen(params_types_string) - 1] = '\0';
    if(table_elem->is_funcDecl == TRUE){
        printf("%s\t(%s)\t%s\n", table_elem->id, params_types_string, table_elem->type);
    }
    else if(table_elem->is_param == TRUE){
        printf("%s\t\t%s\tparam\n", table_elem->id, table_elem->type);
    }
    else{
        printf("%s\t\t%s\n", table_elem->id, table_elem->type);
    }    
    print_table_elem(table_elem->next);
}