/*      
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/

/*
 - Atoi não pode ser chamado sem dar assign a uma string, só com expressoes, não é possível ter um strlit numa expressão -
 */
 
#include "code_generation.h"

Table *global_table;
Strings *program_strings;
int tab_count;
int print_bool;

//------------ UnUsed ---------------//
int atoi_declare;

void generateCode(Node *root, Table *root_table){
    Node *aux = root->son;
    global_table = root_table;
    program_strings = NULL;
    print_bool = 0;
    atoi_declare = 0;
    //DECLARE PRINT
    Table *current_table = root_table->next;
    while(aux != NULL){
        if(!strcmp(aux->nodeClass, "FuncDecl")){
            generateFuncDecl(aux, current_table);
            current_table = current_table->next;
        }
        else generateVarDecl(aux, global_table, NULL);
        aux=aux->brother;
    }

    generateStrings();
    //------------ UnUsed ---------------//
    if(atoi_declare == 1){
        printf("declare i32 @atoi(i8*)");
    }
}

void generateStrings(){
    if(program_strings == NULL) return;
    printf("declare i32 @printf(i8*, ...)\n");
    while(program_strings != NULL){
        char *temp = strdup(program_strings->text);

        temp[strlen(program_strings->text) - 1] = '\0';
       
        printf("%s = constant [%d x i8] c%s\\0A\\00\", align 1\n", program_strings->id, program_strings->size,temp);
        program_strings = program_strings->next;
    }
    if(print_bool != 0){
        printf("@true = constant [5 x i8] c\"true\\00\", align 1\n");
        printf("@false = constant [6 x i8] c\"false\\00\", align 1\n");
    }
}


void generateFuncDecl(Node *node, Table *func_table){
    Node *FuncId = node->son->son;
    //Find func in global table
    
    TableElem *func = global_table->elements_list;
    while(func != NULL){
        if(func->is_funcDecl)
            if(!strcmp(func->id, FuncId->nodeValue))
                break;
        func = func->next;
    }

    //Init Registry
    FuncRegElems *func_regs = malloc(sizeof(FuncRegElems));
    func_regs->number = -1;
    if(!strcmp(func->id, "main")){
        printf("define i32 @%s (%s) {\n", func->id, getParams(FuncId, func, func_regs));
    }
    else printf("define %s @%s (%s) {\n", genGetType(func->type), func->id, getParams(FuncId, func, func_regs));
    addReg(func_regs, func->id, "FUNC");    
    generateParameters(FuncId, func, func_regs);
    Node *funcBody = node->son->brother;
    genFuncBody(funcBody, func_table, func_regs);
    printf("}\n");
}
void generateParameters(Node *node, TableElem *func_elem, FuncRegElems *func_regs){
    Parameters *funcParameters = func_elem->parameters;
    funcParameters = func_elem->parameters;
    char *temp =  malloc(sizeof(char) * BUFFLEN);
    while (funcParameters != NULL){
        snprintf(temp, BUFFLEN, "@param.%s", funcParameters->id);
        FuncRegElems *param  = searchReg(func_regs, temp);
        FuncRegElems *new = addReg(func_regs, funcParameters->id, param->type);
        printf("\t%%%d = alloca %s, align %d\n", new->number, new->type, alignByType(genGetType(param->type)));
        printf("\tstore %s %%%d, %s* %%%d\n", param->type, param->number, param->type, new->number);
        funcParameters = funcParameters->next;
    }
}

char *getParams(Node *node, TableElem *func_elem, FuncRegElems *func_regs){
    char *output = malloc(sizeof(char) * BUFFLEN);
    output = strdup("");
    char *temp =  malloc(sizeof(char) * BUFFLEN);
    Parameters *funcParameters = func_elem->parameters;
    while (funcParameters != NULL){
        char *type = genGetType(funcParameters->type);
        snprintf(temp, BUFFLEN, "%s, ", type);
        strcat(output, temp);
        snprintf(temp, BUFFLEN, "@param.%s", funcParameters->id);
        addReg(func_regs, temp, type);
        funcParameters = funcParameters->next;
    }
    output[strlen(output) - 2] = '\0';
    return output;
}

void genFuncBody(Node *node, Table *func_table, FuncRegElems *func_regs){
    Node *operation = node->son;
    int had_returned = 0;
    while (operation != NULL){
        if(!strcmp("Return", operation->nodeClass)){
            generateReturn(operation, func_table, func_regs);
            had_returned = 1;
        }
        else if(!strcmp("VarDecl", operation->nodeClass)){
            generateVarDecl(operation, func_table, func_regs);
        }
        else if(!strcmp("Assign", operation->nodeClass)){
            generateAssign(operation, func_table, func_regs);
        }
        else if(!strcmp("Print", operation->nodeClass)){
            generatePrint(operation, func_table, func_regs);
        }
        else if(!strcmp("Call", operation->nodeClass)){
            generateCall(operation, func_table, func_regs);
        }
         else if(!strcmp("Block", operation->nodeClass)){
            genFuncBody(operation, func_table, func_regs);
        }
        else if(!strcmp("ParseArgs", operation->nodeClass)){
            generateParseArgs(operation, func_table, func_regs);
        }
        operation = operation->brother;
    }
    if(had_returned == 0){
        if(!strcmp(func_table->id, "main"))
            printf("\tret i32 0\n");
        else printf("\tret void\n");
    }
        
}

//------------ UnUsed ---------------//
void generateParseArgs(Node *node, Table *func_table, FuncRegElems *func_regs){
    FuncRegElems * out = addReg(func_regs, node->son->nodeValue, genGetType(node->nodeType));

    printf("%%%d = call i32 @atoi(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0))", out->number);
}

void generateReturn(Node *node, Table *func_table, FuncRegElems *func_regs){
    if(!strcmp(func_table->id, "main"))
        printf("\tret i32 0\n");
    else if(node->son != NULL){
        FuncRegElems *expr = generateExpression(node->son, func_table, func_regs);
        if(expr != NULL){
            printf("\tret %s %%%d\n", genGetType(expr->type), expr->number);
        }
        else printf("\tret void\n");
    }
    else printf("\tret void\n");
}

FuncRegElems * generateCall(Node *node, Table *func_table, FuncRegElems *func_regs){
    char *output = malloc(sizeof(char) * BUFFLEN);
    output[0] = '\0';
    char *temp =  malloc(sizeof(char) * BUFFLEN);
    Node *params = node->son->brother;
    while (params != NULL){
        
        FuncRegElems *this_param = generateExpression(params, func_table, func_regs);
        snprintf(temp, BUFFLEN, "%s %%%d, ", genGetType(params->nodeType), this_param->number);
        strcat(output, temp);
        params = params->brother;
    }
    output[strlen(output) - 2] = '\0';
    FuncRegElems *out = NULL;
    if(!strcmp( genGetType(node->nodeType), "void"))
        printf("\tcall %s @%s(%s)\n", genGetType(node->nodeType), node->son->nodeValue, output);
    else{
        out = addReg(func_regs, node->son->nodeValue, genGetType(node->nodeType));
        printf("\t%%%d = call %s @%s(%s)\n", out->number,  genGetType(node->nodeType), out->id, output);
    }
    return out;
}

Strings *addString(char *text){
    Strings *to_add = malloc(sizeof(Strings));
    to_add->text = strdup(text);
    to_add->size = strlen(text) - (tab_count);
    if(program_strings == NULL){
        program_strings = to_add;
        to_add->number = 0;
        program_strings->next = NULL;
    }
    else{
        Strings *temp = program_strings;
        while(temp->next != NULL){
            temp = temp->next;
            if(!strcmp(temp->text, text)){
                return temp;
            }
        }
        temp->next = to_add;
        to_add->number = temp->number + 1;
    }
    char *temp = malloc(sizeof(char) * BUFFLEN);
    snprintf(temp, BUFFLEN, "@str.%d", to_add->number);
    to_add->id = strdup(temp);
    return to_add;
}

char *verifyString(char *string){
    tab_count = 0;
    char *temp = malloc(sizeof(char) * BUFFLEN);
    char *out = malloc(sizeof(char) * BUFFLEN);
    char *token;
    char *aux = NULL;
    token = strtok_r(string, "%", &aux);
    do{
        strcat(temp, token);
        strcat(temp, "%%");
    }while((token = strtok_r(NULL, "%", &aux)) != NULL);
    temp[strlen(temp) - 2] = '\0';    
    token = strtok_r(temp, "\\", &aux);
    do{
        tab_count += 2;
        strcat(out, token);
        if(aux != NULL){
            if(aux[0] == 't') strcat(out, "\\09");
            else if(aux[0] == 'n') strcat(out, "\\0A");
            else if(aux[0] == 'f') strcat(out, "\\0C");
            else if(aux[0] == 'r') strcat(out, "\\0D");
            else if(aux[0] == '"') strcat(out, "\\22");
            else if(aux[0] == '\\') strcat(out, "\\5C");
            aux[0] = '\\';
        }
    }while((token = strtok_r(NULL, "\\", &aux)) != NULL);
    tab_count =  tab_count - 4;
    out[strlen(out)-1] = '\0';
    return out;
}

char *generatePrintByType(Node *node){
    if(!strcmp(node->nodeType, "int"))
        return "\"%d\"";
    else if(!strcmp(node->nodeType, "bool")){
        print_bool = 1;
        return "\"%s\"";
    }   
    else if(!strcmp(node->nodeType, "float") || !strcmp(node->nodeType, "float32"))
        return "\"%.08f\"";
    else if(!strcmp(node->nodeType, "none") )
        return "void";    
    else return "\"\"";
}

void generatePrint(Node *node, Table *func_table, FuncRegElems *func_regs){
    Strings *string;
    if(!strcmp(node->son->nodeClass, "StrLit")){
        char *out = verifyString(node->son->nodeValue);
        string = addString(out);
        FuncRegElems *print = addReg(func_regs, "@printf", "PRINT");
        printf("\t%%%d = call i32 (i8*, ...) @printf(i8* getelementptr ([%d x i8], [%d x i8]* %s, i32 0, i32 0))\n", print->number, string->size, string->size, string->id);  
    }
    else{   
        //Is an expression
        tab_count = 0;
        FuncRegElems *to_print = generateExpression(node->son, func_table, func_regs);
        char *temp = generatePrintByType(node->son);
        if(!strcmp(genGetType(to_print->type), "i1")){
            FuncRegElems *temp = addReg(func_regs, "@bool_to_print", "i8*");
            printf("\t%%%d = select i1 %%%d, i8* getelementptr ([5 x i8], [5 x i8]* @true, i32 0, i32 0), i8* getelementptr ([6 x i8], [6 x i8]* @false, i32 0, i32 0)\n", temp->number, to_print->number);
            to_print = temp;
        }
        string = addString(temp);
        FuncRegElems *print = addReg(func_regs, "@printf", "PRINT");
        printf("\t%%%d = call i32 (i8*, ...) @printf(i8* getelementptr ([%d x i8], [%d x i8]* %s, i32 0, i32 0), %s %%%d)\n", print->number, string->size, string->size, string->id, genGetType(to_print->type), to_print->number);
    }
}

void generateAssign(Node *node, Table *func_table, FuncRegElems *func_regs){
    FuncRegElems *elem = searchReg(func_regs, node->son->nodeValue);
    FuncRegElems *out = generateExpression(node->son->brother, func_table, func_regs);
    if(elem != NULL){
        printf("\tstore %s %%%d, %s* %%%d, align %d\n", genGetType(elem->type), out->number, genGetType(elem->type), elem->number, alignByType(genGetType(node->nodeType)));
    }
    else{
        printf("\tstore %s %%%d, %s* @%s, align %d\n", genGetType(node->nodeType), out->number, genGetType(node->nodeType), node->son->nodeValue, alignByType(genGetType(node->nodeType)));
    }
}

int alignByType(char *type){
    if(!strcmp(type, "i32"))
        return 4;
    else if(!strcmp(type, "double")){
        return 8;
    }
    else if(!strcmp(type, "i8*"))
        return 2;
    return 1;
}

FuncRegElems *generateExpression(Node *node, Table *func_table, FuncRegElems *func_regs){
    FuncRegElems *out = NULL;
    //Int - Real - Id
    if(!strcmp(node->nodeClass, "IntLit")){
        out = addRegConst(func_regs, node->nodeValue, "i32");
        if(out->cons_decl == 0){
            printf("\t%%%d = add i32 %s, 0\n", out->number, node->nodeValue);
            out->cons_decl = 1;
        }
    }
    if(!strcmp(node->nodeClass, "RealLit")){
        out = addRegConst(func_regs, node->nodeValue, "double");
        if(out->cons_decl == 0){
            if(node->nodeValue[0] == '.'){
                printf("\t%%%d = fadd double 0%s, 0.000000e+00\n", out->number, node->nodeValue);
            }
            else printf("\t%%%d = fadd double %s, 0.000000e+00\n", out->number, node->nodeValue);
            out->cons_decl = 1;
        }
    }
    else if(!strcmp(node->nodeClass, "Id")){
        FuncRegElems *elem = searchReg(func_regs, node->nodeValue);
        if(elem != NULL){
            out = addReg(func_regs, node->nodeValue, node->nodeType);
            printf("\t%%%d = load %s, %s* %%%d, align %d\n", out->number, genGetType(node->nodeType), genGetType(node->nodeType), elem->number, alignByType(genGetType(node->nodeType)));
        }
        else{
            //GlobalRegs *find = searchGReg(node->nodeValue, node->nodeType);
            char* temp = malloc(sizeof(char) * BUFFLEN);
            temp[0] = '\0';
            strcat(temp, "@global.");
            strcat(temp, node->nodeValue);
            out = addReg(func_regs, temp, node->nodeType);
            printf("\t%%%d = load %s, %s* @%s, align %d\n", out->number, genGetType(node->nodeType), genGetType(node->nodeType), node->nodeValue,alignByType(genGetType(node->nodeType)));
        }
    }

    //-------------- OPERATIONS -------------------//
    else if(!strcmp(node->nodeClass, "Add")){
        FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@add", node->nodeType);
        if(!strcmp(genGetType(node->nodeType), "double")) 
            printf("\t%%%d = fadd %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
        if(!strcmp(genGetType(node->nodeType), "i32")) 
            printf("\t%%%d = add %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
    }
    
    else if(!strcmp(node->nodeClass, "Sub")){
        FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@sub", node->nodeType);
        if(!strcmp(genGetType(node->nodeType), "double")) 
            printf("\t%%%d = fsub %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
        if(!strcmp(genGetType(node->nodeType), "i32")) 
            printf("\t%%%d = sub %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
    }

    else if(!strcmp(node->nodeClass, "Mul")){
        FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@mul", node->nodeType);
        if(!strcmp(genGetType(node->nodeType), "double")) 
            printf("\t%%%d = fmul %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
        if(!strcmp(genGetType(node->nodeType), "i32")) 
            printf("\t%%%d = mul %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
    }

    else if(!strcmp(node->nodeClass, "Div")){
        FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@div", node->nodeType);
        if(!strcmp(genGetType(node->nodeType), "double")) 
            printf("\t%%%d = fdiv %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
        if(!strcmp(genGetType(node->nodeType), "i32")) 
            printf("\t%%%d = sdiv %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
    }

    else if(!strcmp(node->nodeClass, "Mod")){
        FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@mod", node->nodeType);
        printf("\t%%%d = srem %s %%%d, %%%d\n", out->number, genGetType(node->nodeType), left->number, right->number);
    }

    //-------------- UNITARY OPERATIONS -------------------//
    else if(!strcmp(node->nodeClass, "Minus")){
        FuncRegElems *elem = generateExpression(node->son, func_table, func_regs);
        out = addReg(func_regs, "@minus", node->nodeType);
        if(!strcmp(genGetType(node->nodeType), "double")) 
            printf("\t%%%d = fmul %s -1.000000e+00, %%%d\n", out->number, genGetType(node->nodeType), elem->number);
        if(!strcmp(genGetType(node->nodeType), "i32")) 
            printf("\t%%%d = mul %s -1, %%%d\n", out->number, genGetType(node->nodeType), elem->number);
    }

    else if(!strcmp(node->nodeClass, "Plus")){
        FuncRegElems *elem = generateExpression(node->son, func_table, func_regs);
        out = addReg(func_regs, "@plus", node->nodeType);
        if(!strcmp(genGetType(node->nodeType), "double")) 
            printf("\t%%%d = fadd %s 0.000000e+00, %%%d\n", out->number, genGetType(node->nodeType), elem->number);
        if(!strcmp(genGetType(node->nodeType), "i32")) 
            printf("\t%%%d = add %s 0, %%%d\n", out->number, genGetType(node->nodeType), elem->number);
    }
    
    else if(!strcmp(node->nodeClass, "Not")){
        FuncRegElems *elem = generateExpression(node->son, func_table, func_regs);
        out = addReg(func_regs, "@not", node->nodeType);
        printf("\t%%%d = xor i1 %%%d, true\n", out->number, elem->number);
    }
    
    //-------------- BOOLEAN OPERATIONS -------------------//
    else if(!strcmp(node->nodeClass, "Eq") || !strcmp(node->nodeClass, "Ne")){
        FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@boolOp", node->nodeType);
        char *temp = strdup(node->nodeClass);
        temp[0] = temp[0] + 32;
        if(!strcmp(genGetType(node->son->nodeType), "double")) 
            printf("\t%%%d = fcmp o%s %s %%%d, %%%d\n", out->number,  temp, genGetType(left->type), left->number, right->number);
        if(!strcmp(genGetType(node->son->nodeType), "i32"))
            printf("\t%%%d = icmp %s %s %%%d, %%%d\n", out->number,  temp, genGetType(left->type), left->number, right->number);
        if(!strcmp(genGetType(node->son->nodeType), "i1"))
            printf("\t%%%d = icmp %s %s %%%d, %%%d\n", out->number,  temp, genGetType(left->type), left->number, right->number);
    }

    else if(!strcmp(node->nodeClass, "Gt") || !strcmp(node->nodeClass, "Lt")
    || !strcmp(node->nodeClass, "Ge") || !strcmp(node->nodeClass, "Le")){
         FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@boolOp", node->nodeType);
        char *temp = strdup(node->nodeClass);
        temp[0] = temp[0] + 32;
        if(!strcmp(genGetType(node->son->nodeType), "double"))
            printf("\t%%%d = fcmp o%s %s %%%d, %%%d\n", out->number,  temp, genGetType(left->type), left->number, right->number);
        if(!strcmp(genGetType(node->son->nodeType), "i32"))
            printf("\t%%%d = icmp s%s %s %%%d, %%%d\n", out->number,  temp, genGetType(left->type), left->number, right->number);
        if(!strcmp(genGetType(node->son->nodeType), "i1"))
            printf("\t%%%d = icmp s%s %s %%%d, %%%d\n", out->number,  temp, genGetType(left->type), left->number, right->number);
    }

    else if(!strcmp(node->nodeClass, "And")){
        FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@and", node->nodeType);
        printf("\t%%%d = and i1 %%%d, %%%d\n", out->number,  left->number, right->number);
    }

    else if(!strcmp(node->nodeClass, "Or")){
        FuncRegElems *left = generateExpression(node->son, func_table, func_regs);
        FuncRegElems *right = generateExpression(node->son->brother, func_table, func_regs);
        out = addReg(func_regs, "@or", node->nodeType);
        printf("\t%%%d = or i1 %%%d, %%%d\n", out->number,  left->number, right->number);
    }

    else if(!strcmp(node->nodeClass, "Call"))
        out = generateCall(node, func_table, func_regs);
    return out;
}

void generateVarDecl(Node *node, Table *current_table, FuncRegElems* func_regs){
    //Is global Variable
    if(func_regs == NULL){
        if(!strcmp(genGetType(node->son->nodeClass), "i32") || !strcmp(genGetType(node->son->nodeClass), "i1"))
            printf("@%s = global %s 0, align 4\n", node->son->brother->nodeValue, genGetType(node->son->nodeClass));
        if(!strcmp(genGetType(node->son->nodeClass), "i8*"))
            printf("@%s = global %s null, align 2\n", node->son->brother->nodeValue, genGetType(node->son->nodeClass));
        if(!strcmp(genGetType(node->son->nodeClass), "double"))
            printf("@%s = global %s 0.0000000e+0, align 8\n", node->son->brother->nodeValue, genGetType(node->son->nodeClass));
    }
    else{
        FuncRegElems*aux = addReg(func_regs, node->son->brother->nodeValue, genGetType(node->son->nodeClass));
        printf("\t%%%d = alloca %s, align %d\n", aux->number, aux->type, alignByType(genGetType(aux->type)));

        if(!strcmp(genGetType(node->son->nodeClass), "i32") || !strcmp(genGetType(node->son->nodeClass), "i1"))
            printf("\tstore %s 0, %s* %%%d, align %d\n", genGetType(aux->type),  genGetType(aux->type), aux->number, alignByType(genGetType(aux->type)));
        if(!strcmp(genGetType(node->son->nodeClass), "double"))
            printf("\tstore %s 0.0000000e+0, %s* %%%d, align %d\n", genGetType(aux->type), genGetType(aux->type), aux->number, alignByType(genGetType(aux->type)));
    }
    return;
}

char *genGetType(char *type){
    if(!strcmp(type, "FuncParams") || !strcmp(type, "none"))
        return "void";
    else if(!strcmp(type, "int") || !strcmp(type, "Int"))
        return "i32";
    else if(!strcmp(type, "bool")|| !strcmp(type, "Bool"))
        return "i1";
    else if(!strcmp(type, "float") || !strcmp(type, "float32") || !strcmp(type, "Float32"))
        return "double";
    else if(!strcmp(type, "string") || !strcmp(type, "String"))
        return "i8*";
    else return type;
}

FuncRegElems *addReg(FuncRegElems *func_regs, char *id, char*type){
    FuncRegElems *regs = func_regs;
    if(func_regs->number == -1){
        func_regs->number = 0;
        func_regs->id = strdup(id);
        func_regs->type = strdup(type);
        func_regs->next_elem = NULL;
        func_regs->cons_decl = 0;
        return func_regs;
    }
    FuncRegElems *to_add = malloc(sizeof(FuncRegElems));
    to_add->id = strdup(id);
    to_add->type = strdup(type);
    to_add->next_elem = NULL;
    to_add->cons_decl = 0;
    while(regs->next_elem != NULL) {
        regs = regs->next_elem;
    }
    regs->next_elem = to_add;
    to_add->number = regs->number + 1;
    return to_add;
}

FuncRegElems *addRegConst(FuncRegElems *func_regs, char *id, char *type){
    FuncRegElems *regs = func_regs;
    char *temp = malloc(sizeof(char) * BUFFLEN);
    temp[0] = '\0';
    strcat(temp, "@const.");
    strcat(temp, id);
    while(regs != NULL){
        if(!strcmp(temp, regs->id) && !strcmp(type, regs->type))
            return regs;
        regs = regs->next_elem;
    }
    return addReg(func_regs, temp, type);
}

FuncRegElems *searchReg(FuncRegElems *func_regs, char *id){
    FuncRegElems *regs = func_regs;
    while(regs != NULL){
        if(!strcmp(id, regs->id)) return regs;
        regs = regs->next_elem;
    }
    return regs;
}