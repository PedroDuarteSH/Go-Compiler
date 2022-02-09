/*
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/

#include "ASTnoted.h"

/////////////////////////////////////////////////////////
//TODO VERIFY PARAM DECL
//Print new tree
void print_noted_tree(Node * node, int depth){
	if (node == NULL)
		return;
    for (int i = 0; i < depth; ++i)
		printf("..");
    if(node->nodeType != NULL &&  strcmp(node->nodeType, "none")){
        if(node->is_func){
            if (node->nodeValue != NULL) printf("%s(%s) - (%s)\n", node -> nodeClass, node->nodeValue, node->nodeType);
	        else printf("%s - (%s)\n", node->nodeClass, node->nodeType);
        }
        else{
            if (node->nodeValue != NULL) printf("%s(%s) - %s\n", node -> nodeClass, node->nodeValue, node->nodeType);
	        else printf("%s - %s\n", node->nodeClass, node->nodeType);
        }
    }
    else{
        if (node->nodeValue != NULL) printf("%s(%s)\n", node -> nodeClass, node->nodeValue);
	    else printf("%s\n", node->nodeClass);
    }
	print_noted_tree(node->son, depth+1);
	print_noted_tree(node->brother, depth);
}

/////////////////////////////////////////////////////////

Table *global_table;

TableElem *searchDeclared(Table *current_table, char *id){
    if (global_table == NULL)
        return NULL;

    //Own Function Table
    TableElem *func_table_elem = current_table->elements_list;
    while (func_table_elem != NULL){
        if (!strcmp(func_table_elem->id, id) && (func_table_elem->declared == 1 || func_table_elem->is_param))
            return func_table_elem;
        func_table_elem = func_table_elem->next;
    }

    //Global
    TableElem *global_table_elem = global_table->elements_list;

    while(global_table_elem != NULL){
        if(!strcmp(global_table_elem->id, id) && (global_table_elem->declared == 1 || global_table_elem->is_param))
            return global_table_elem;
        global_table_elem = global_table_elem->next;
    }
    return NULL;

}

TableElem *search_globalFirst(Table *current_table, char *id){
    if (global_table == NULL)
        return NULL;

    //Global
    
    TableElem *global_table_elem = global_table->elements_list;
    while(global_table_elem != NULL){
        if(!strcmp(global_table_elem->id, id) )
            return global_table_elem;
        global_table_elem = global_table_elem->next;
    }

    //Own Function Table
    TableElem *func_table_elem = current_table->elements_list;
    while (func_table_elem != NULL){
        if (!strcmp(func_table_elem->id, id) )
            return func_table_elem;
        func_table_elem = func_table_elem->next;
    }
    return NULL;
}

TableElem *search(Table *current_table, char *id){
    if (global_table == NULL)
        return NULL;

    //Own Function Table
    TableElem *func_table_elem = current_table->elements_list;
    while (func_table_elem != NULL){
        if (!strcmp(func_table_elem->id, id))
            return func_table_elem;
        func_table_elem = func_table_elem->next;
    }

    //Global
    TableElem *global_table_elem = global_table->elements_list;
    while(global_table_elem != NULL){
        if(!strcmp(global_table_elem->id, id))
            return global_table_elem;
        global_table_elem = global_table_elem->next;
    }
    return NULL;
}

TableElem *searchFunc(Table *current_table, char *id){
   if (global_table == NULL)
        return NULL;

    //Own Function Table
    TableElem *func_table_elem = current_table->elements_list;
    while (func_table_elem != NULL){
        if (!strcmp(func_table_elem->id, id) && func_table_elem->is_funcDecl)
            return func_table_elem;
        func_table_elem = func_table_elem->next;
    }

    //Global
    TableElem *global_table_elem = global_table->elements_list;
    while(global_table_elem != NULL){
        if(!strcmp(global_table_elem->id, id) && global_table_elem->is_funcDecl)
            return global_table_elem;
        global_table_elem = global_table_elem->next;
    }
    return NULL;
}

int verify_program(Node * node, Table *global){
    if (node == NULL)
		return 0;
    global_table = global;
    Node * aux = node->son;
    int errorcount = 0;
    Table *func_table = global;
    while(aux != NULL){
        if(!strcmp(aux->nodeClass, "FuncDecl")){
            errorcount += verify_funcDecl(aux, func_table->next);
            func_table = func_table->next;
        }
        else if(!strcmp(aux->nodeClass, "VarDecl"))
            errorcount += verify_varDecl(aux, global);
        aux = aux->brother;
    }
    errorcount += verify_unused(global);
    return errorcount;
}

int verify_unused(Table *table){
    int errorcount = 0;
    table = table->next;
    while(table != NULL){
        TableElem *aux = table->elements_list;
        while(aux != NULL){
            if((aux->used == 0 && strcmp(aux->id, "return") && !aux->is_funcDecl && aux->declared == 1) || (aux->declared == 1 && aux->used == 0  && !aux->is_funcDecl)){
                char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
                snprintf(error_message, BUFFLEN, "Symbol %s declared but never used", aux->id);
                print_error(error_message,  aux->line, aux->column);
                errorcount++;
            }
            aux = aux->next;
        }
        table = table->next;
    }
    return errorcount;
}

int verify_funcDecl(Node * node, Table *table){
    int errorcount = 0;
    Node *id_Node = node->son->son;
    TableElem *check = search(global_table, id_Node->nodeValue);

    check->line = node->son->son->line;
    check->column = node->son->son->column;
    
    if(check->declared == 1){
        char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
        snprintf(error_message, BUFFLEN, "Symbol %s already defined", check->id);
        print_error(error_message,  id_Node->line, id_Node->column);
        errorcount++;
    }
    else{
        check->declared = 1;
        TableElem *temp = table->elements_list;
        while(temp != NULL){
            if(temp->is_param){
                temp->used = 1;
            } 
            temp = temp->next;
        }
   
        if(!strcmp("main", check->id))
            check->used = 1;
        errorcount += verify_funcParams(node->son->son->brother, table);
        errorcount += verify_funcBody(node->son->brother, table);
    }
    return errorcount;
}

int verify_funcParams(Node *node, Table *table){
    int errorcount = 0;

    if(strcmp(node->nodeClass, "FuncParams")){
        node = node->brother;
    }
    Node *param_decl = node->son;
    while(param_decl != NULL){
        errorcount += verify_varDecl(param_decl, table);
        param_decl = param_decl->brother;
    }
    return errorcount;
}

int verify_varDecl(Node *node, Table *table){
    int errorcount = 0;
    if(node == NULL)return 0;
    Node *id_Node = node->son->brother;
    TableElem *check = search(table, id_Node->nodeValue);
    TableElem *is_func = searchFunc(global_table, id_Node->nodeValue);
    
    if(is_func != NULL && is_func->declared == 1){
        char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
        snprintf(error_message, BUFFLEN, "Symbol %s already defined", id_Node->nodeValue);
        print_error(error_message,  id_Node->line, id_Node->column);
        errorcount++;
        return errorcount;
    }

    check->line = id_Node->line;
    check->column = id_Node->column;
    if(check->declared == 1){
        char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
        snprintf(error_message, BUFFLEN, "Symbol %s already defined", id_Node->nodeValue);
        print_error(error_message,  id_Node->line, id_Node->column);
        errorcount++;
    }
    else(check->declared = 1);
    return errorcount;
}

int verify_funcBody(Node *node, Table *table){
    int errorcount = 0;
    if(node->son == NULL) return errorcount;
    node = node->son;
    while(node != NULL){
        
        if(!strcmp(node->nodeClass, "VarDecl"))
            errorcount += verify_varDecl(node, table);
        //TODO
        else if(!strcmp(node->nodeClass, "Assign"))
            errorcount += verify_assign(node, table);
        else if(!strcmp(node->nodeClass, "Call"))
            errorcount += verify_call(node, table);
        else if(!strcmp(node->nodeClass, "Block"))
            errorcount += verify_funcBody(node, table);
        

        else if(!strcmp(node->nodeClass, "If"))
            errorcount += verify_if(node, table);
        else if(!strcmp(node->nodeClass, "For"))
            errorcount += verify_for(node, table);
        else if(!strcmp(node->nodeClass, "ParseArgs"))
            errorcount += verify_parseArgs(node, table);
        else if(!strcmp(node->nodeClass, "Print"))
            errorcount += verify_print(node, table);       
        else if(!strcmp(node->nodeClass, "Return"))
            errorcount += verify_return(node, table);
        
        node = node->brother;

    }
    return errorcount;
}

int verify_assign(Node *node, Table *table){
    int errorcount = 0;
    Node* to_assign = node->son;
    TableElem *to_assign_elem = searchDeclared(table, to_assign->nodeValue);
    errorcount += verify_expression(to_assign->brother, table);
    if(to_assign_elem == NULL){
        char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
        snprintf(error_message, BUFFLEN, "Cannot find symbol %s", to_assign->nodeValue);
        print_error(error_message,  to_assign->line, to_assign->column);
        snprintf(error_message, BUFFLEN, "Operator = cannot be applied to types %s, %s", "undef", to_assign->brother->nodeType);
        print_error(error_message,  node->line, node->column);
        free(error_message);
        errorcount++;
        errorcount++;
        
    }
    else{
        if(to_assign->brother->is_func){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Cannot find symbol %s", to_assign->brother->nodeValue);
            print_error(error_message,  to_assign->brother->line, to_assign->brother->column);
            snprintf(error_message, BUFFLEN, "Operator = cannot be applied to types %s, undef", to_assign_elem->type);
            print_error(error_message,  node->line, node->column);
            
            free(error_message);
            errorcount++;
            node->nodeType = "undef";
        }
        if(strcmp(to_assign_elem->type, to_assign->brother->nodeType)
        || !strcmp(to_assign_elem->type, "undef")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator = cannot be applied to types %s, %s", to_assign_elem->type, to_assign->brother->nodeType);
            print_error(error_message,  node->line, node->column);
            free(error_message);
            errorcount++;
            node->nodeType = "undef";
        }
        else node->nodeType = strdup(to_assign_elem->type);
        to_assign->nodeType = strdup(to_assign_elem->type);

        
        to_assign_elem->used = 1;
    }

    return errorcount;
}

int verify_call(Node *node, Table *table){
    int errorcount = 0, exp_error = 0;
    Node *id_node = node->son;
    
    //Get Called Parameters types string
    Node * param_nodes = id_node->brother;
    char *params_nodes_string = (char *)malloc(sizeof(char) * BUFFLEN);
    while (param_nodes != NULL){
        exp_error += verify_expression(param_nodes, table);
        strcat(params_nodes_string, param_nodes->nodeType);
        strcat(params_nodes_string, ",");
        param_nodes = param_nodes->brother;
    }
    params_nodes_string[strlen(params_nodes_string) - 1] = '\0';
    
    TableElem *check = searchFunc(table, id_node->nodeValue);
    
    if(check == NULL){
        node->nodeType = "undef";
        char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
        snprintf(error_message, BUFFLEN, "Cannot find symbol %s(%s)", id_node->nodeValue, params_nodes_string);
        print_error(error_message,  id_node->line, id_node->column);
        free(error_message);
        errorcount++;
    }

    else{
        
        node->nodeType = strdup(check->type);
        Parameters *check_params = check->parameters;
        
        char *params_types_string = (char *)malloc(sizeof(char) * BUFFLEN);
        while(check_params != NULL){
            strcat(params_types_string, check_params->type);
            strcat(params_types_string, ",");
            check_params = check_params->next;
        }
        params_types_string[strlen(params_types_string) - 1] = '\0';

        if(strcmp(params_nodes_string, params_types_string)){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Cannot find symbol %s(%s)", node->son->nodeValue, params_nodes_string);
            print_error(error_message,  node->son->line, node->son->column);
            free(error_message);
            errorcount++;
            node->nodeType = "undef";
        }

        else{
            TableElem *used_params = table->elements_list;
            while(used_params != NULL){
                if(used_params->is_param)used_params->used = 1;
                used_params = used_params->next;
            }
            id_node->is_func = check->is_funcDecl;
            id_node->nodeType = params_types_string;
            check->used = 1;
        }
    }
    return errorcount + exp_error;
}

int verify_if(Node *node, Table *table){
    int errorcount = 0;
    errorcount += verify_expression(node->son, table);

    if(strcmp(node->son->nodeType, "bool")){
                char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
                snprintf(error_message, BUFFLEN, "Incompatible type %s in if statement", node->son->nodeType);
                print_error(error_message,  node->son->line, node->son->column);
                errorcount++;
    }

    Node *temp = node->son->brother;
    //VERIFY "BLOCK"
    while(temp != NULL){
        errorcount += verify_funcBody(temp, table);
        temp = temp->brother;
    }
        

    return errorcount;
}

int verify_for(Node *node, Table *table){
    int errorcount = 0;

    if(!strcmp(node->son->nodeClass, "Block")){
        errorcount += verify_funcBody(node->son, table);
    }

    else{
        errorcount += verify_expression(node->son, table);
        errorcount += verify_funcBody(node->son->brother, table);
        if(strcmp(node->son->nodeType, "bool")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Incompatible type %s in for statement", node->son->nodeType);
            print_error(error_message,  node->son->line, node->son->column);
            errorcount++;
        }
    }
    return errorcount;
}

int verify_parseArgs(Node *node, Table *table){
    int errorcount = 0;
    TableElem *to_assign = search(table, node->son->nodeValue);
    errorcount += verify_expression(node->son->brother, table);

    if(to_assign == NULL){
        char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
        snprintf(error_message, BUFFLEN, "Cannot find symbol %s", node->son->nodeValue);
        print_error(error_message,  node->son->line, node->son->column);
        free(error_message);
        errorcount++;
        node->son->nodeType = "undef";
        node->nodeType = "undef";
    }

    else{
        node->son->nodeType = strdup(to_assign->type);
        if(strcmp(node->son->nodeType, node->son->brother->nodeType)
        || strcmp(node->son->nodeType, "int")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator strconv.Atoi cannot be applied to types %s, %s", node->son->nodeType, node->son->brother->nodeType);
            print_error(error_message,  node->line, node->column);
            free(error_message);
            errorcount++;
        }
        to_assign->used = 1;
        node->nodeType = strdup(node->son->nodeType);
    }
    return errorcount;
}

int verify_print(Node *node, Table *table){
    if(!strcmp(node->son->nodeClass, "StrLit")){
        return 0;
    }

    int errorcount = 0;
    Node *aux = node->son;
    errorcount += verify_expression(aux, table);

    if(!strcmp(aux->nodeType, "undef")){
        char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
        snprintf(error_message, BUFFLEN, "Incompatible type %s in fmt.Println statement", aux->nodeType);
        print_error(error_message,  aux->son->line, aux->son->column);
        errorcount++;
        free(error_message);
    }
    return errorcount;
}

int verify_return(Node *node, Table *table){
    int errorcount = 0;
    if(node->son != NULL){
        errorcount += verify_expression(node->son, table);
        if(strcmp(node->son->nodeType, table->elements_list->type)){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Incompatible type %s in return statement", node->son->nodeType);
            print_error(error_message,  node->son->line, node->son->column);
            free(error_message);
            errorcount++;
        }
    } 
    return errorcount;
}

int verify_expression(Node *node, Table *table){
    int errorcount = 0;
    TableElem *aux;

    if(!strcmp(node->nodeClass, "IntLit")){
        node->nodeType = "int";
    }

    else if(!strcmp(node->nodeClass, "RealLit")){
        node->nodeType = "float32";
    }

    else if(!strcmp(node->nodeClass, "Id")){
        aux = search(table, node->nodeValue);
        if(aux == NULL){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Cannot find symbol %s", node->nodeValue);
            print_error(error_message,  node->line, node->column);
            errorcount++;
            free(error_message);
            node->nodeType = "undef";
        }
        else if(aux->is_funcDecl){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Cannot find symbol %s", node->nodeValue);
            print_error(error_message,  node->line, node->column);
            errorcount++;
            free(error_message);
            node->nodeType = "undef";
        }
        
        else{
            node->is_func = aux->is_funcDecl;
            node->nodeType = strdup(aux->type);
            aux->used = 1;
        } 
    }

    else if(!strcmp(node->nodeClass, "Not")){
        node->nodeType = "bool";
        errorcount += verify_expression(node->son, table);
        if(strcmp(node->son->nodeType, "bool")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator ! cannot be applied to type %s",node->son->nodeType);
            print_error(error_message,  node->line, node->column);
            errorcount++;
        }
    }

    //TODO
    else if(!strcmp(node->nodeClass, "Or") || !strcmp(node->nodeClass, "And")){
        node->nodeType = "bool";
        char symbol[3];
        if(!strcmp(node->nodeClass, "Or")){symbol[0] = '|';symbol[1] = '|';symbol[2] = '\0';}
        if(!strcmp(node->nodeClass, "And")){symbol[0] = '&';symbol[1] = '&';symbol[2] = '\0';}
        
        errorcount += verify_expression(node->son, table);
        errorcount += verify_expression(node->son->brother, table);
        if(strcmp(node->son->nodeType, node->son->brother->nodeType) 
        || (strcmp(node->son->nodeType, "bool")) || !strcmp(node->son->nodeType, "undef")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator %s cannot be applied to types %s, %s",symbol, node->son->nodeType, node->son->brother->nodeType);
            print_error(error_message,  node->line, node->column);
            errorcount++;
        }
    }

    //????????????
    else if(!strcmp(node->nodeClass, "Minus") || !strcmp(node->nodeClass, "Plus")){
       errorcount += verify_expression(node->son, table);
       node->nodeType = strdup(node->son->nodeType);
       char symbol;
       if(!strcmp(node->nodeClass, "Minus"))symbol = '+';
       else symbol = '-';
       if(!strcmp(node->son->nodeType, "undef") || !strcmp(node->son->nodeType, "bool")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator %c cannot be applied to types %s",symbol, node->son->nodeType);
            print_error(error_message,  node->line, node->column);
            errorcount++;
        }
    }

    //TODO
    else if(!strcmp(node->nodeClass, "Eq") || !strcmp(node->nodeClass, "Ne")){
        node->nodeType = "bool";
        errorcount += verify_expression(node->son, table);
        errorcount += verify_expression(node->son->brother, table);
        char symbol[3];
        if(!strcmp(node->nodeClass, "Eq")){symbol[0] = '=';symbol[1] = '=';symbol[3] = '\0';}
        else {symbol[0] = '!';symbol[1] = '=';symbol[3] = '\0';};
        if(strcmp(node->son->nodeType, node->son->brother->nodeType) 
        || !strcmp(node->son->nodeType, "undef")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator %s cannot be applied to types %s, %s",symbol, node->son->nodeType, node->son->brother->nodeType);
            print_error(error_message,  node->line, node->column);
            errorcount++;
        }
    }

    else if(!strcmp(node->nodeClass, "Lt") || !strcmp(node->nodeClass, "Gt")
    || !strcmp(node->nodeClass, "Le") || !strcmp(node->nodeClass, "Ge")){
        char symbol[3];
        if(!strcmp(node->nodeClass, "Lt")){symbol[0] = '<';symbol[1] = '\0';}
        else if(!strcmp(node->nodeClass, "Gt")){symbol[0] = '>';symbol[1] = '\0';}
        else if(!strcmp(node->nodeClass, "Le")){symbol[0] = '<';symbol[1] = '=';symbol[2] = '\0';}
        else if(!strcmp(node->nodeClass, "Ge")){symbol[0] = '>';symbol[1] = '=';symbol[2] = '\0';}
        
        node->nodeType = "bool";
        errorcount += verify_expression(node->son, table);
        errorcount += verify_expression(node->son->brother, table);
        
        //If types are different or different from int or float
        if(strcmp(node->son->nodeType, node->son->brother->nodeType) 
        || (strcmp(node->son->nodeType, "int") && strcmp(node->son->nodeType, "float32"))){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator %s cannot be applied to types %s, %s",
                    symbol, node->son->nodeType, node->son->brother->nodeType);
            print_error(error_message,  node->line, node->column);
            errorcount++;
        }
    }

    else if(!strcmp(node->nodeClass, "Add") || !strcmp(node->nodeClass, "Sub") 
    || !strcmp(node->nodeClass, "Mul") || !strcmp(node->nodeClass, "Div")){
        char symbol;
        if(!strcmp(node->nodeClass, "Add"))symbol = '+';
        else if(!strcmp(node->nodeClass, "Sub"))symbol = '-';
        else if(!strcmp(node->nodeClass, "Mul"))symbol = '*';
        else if(!strcmp(node->nodeClass, "Div"))symbol = '/';

        errorcount += verify_expression(node->son, table);
        errorcount += verify_expression(node->son->brother, table);

        //TODO COMPLETE
        if(strcmp(node->son->nodeType, node->son->brother->nodeType) || !strcmp(node->son->nodeType, "bool")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator %c cannot be applied to types %s, %s",symbol, node->son->nodeType, node->son->brother->nodeType);
            print_error(error_message,  node->line, node->column);
            errorcount++;
            node->nodeType = "undef";
            free(error_message);
        }
        else node->nodeType = strdup(node->son->nodeType);
    }
    
    //Mod only works with Integers
    else if(!strcmp(node->nodeClass, "Mod")){
        char symbol = '%';
        errorcount += verify_expression(node->son, table);
        errorcount += verify_expression(node->son->brother, table);
        //If types are different or not Integers
        if(strcmp(node->son->nodeType, node->son->brother->nodeType)
        || strcmp(node->son->nodeType, "int")){
            char *error_message = (char *)malloc(sizeof(char) * BUFFLEN);
            snprintf(error_message, BUFFLEN, "Operator %c cannot be applied to types %s, %s",symbol, node->son->nodeType, node->son->brother->nodeType);
            print_error(error_message,  node->line, node->column);
            errorcount++;
            node->nodeType = "undef";
        }
        else  node->nodeType = "int";
    }
    else if(!strcmp(node->nodeClass, "Call"))
        errorcount += verify_call(node, table);
    else{
        node->nodeType = "undef";
    }
    return errorcount;
}

void print_error(char * message, int line, int column){
    printf("Line %d, column %d: %s\n", line, column, message);
}