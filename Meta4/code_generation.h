#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef TREEH
    #include "tree.h"
#endif
#ifndef SYMBOLH
    #include "symbol_table.h"
#endif


// Correspondecy Between Func elems and registry number
// number -1 = func id
typedef struct func_regs_elems{
    int number;
    char *id;
    char *type;
    int cons_decl;
    struct func_regs_elems *next_elem;
}FuncRegElems;

typedef struct strings{
    char *text;
    char *id;
    int number;
    int size;
    struct strings *next;
}Strings;



void generateCode(Node *root, Table *root_table);

//-----------FUNC DECLS----------------//
void generateFuncDecl(Node *node, Table *func_table);
    //-----------FUNC PARAMETERS----------------//
    char *getParams(Node *node, TableElem *func_elem, FuncRegElems *func_regs);
    //-----------FUNC BODY----------------//
    void genFuncBody(Node *node, Table *func_elem, FuncRegElems *func_regs);
        void generateParameters(Node *node, TableElem *func_elem, FuncRegElems *func_regs);
        void generatePrint(Node *node, Table *func_table, FuncRegElems *func_regs);
            char *generatePrintByType(Node *node);
        void generateAssign(Node *node, Table *func_table, FuncRegElems *func_regs);
        void generateReturn(Node *node, Table *func_table, FuncRegElems *func_regs);
        void generateParseArgs(Node *node, Table *func_table, FuncRegElems *func_regs);
        FuncRegElems *generateCall(Node *node, Table *func_table, FuncRegElems *func_regs);
        FuncRegElems *generateExpression(Node *node, Table *func_table, FuncRegElems *func_regs);
        
//-----------VAR DECL----------------//
void generateVarDecl(Node *node, Table *current_table, FuncRegElems* func_regs);

char *genGetType(char *type);


//----------- AUXILIAR ----------------//

//----------- STRINGS ----------------//
void generateStrings();
Strings *addString(char *text);


//----------- REGISTRY ----------------//
FuncRegElems *addReg(FuncRegElems *func_regs, char *id, char *type);
FuncRegElems *addRegConst(FuncRegElems *func_regs, char *id, char *type);
FuncRegElems *searchReg(FuncRegElems *func_regs, char *id);

// -------------- ALIGN ---------//
int alignByType(char *type);