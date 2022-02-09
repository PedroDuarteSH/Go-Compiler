/*
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/

%{
    #include <stdio.h>
    #include "tree.h"
    Node *root;
    Node *auxNode;
    Node *auxNode2;
    int yylex(void);
    void yyerror (char *s);
    int i =  0;
    extern char* yytext;

    typedef struct data{
        char *string;
        int line;
        int column;
    }data;

%}
//Reserved words
%token <data> RESERVED
%token <data> SEMICOLON
%token <data> COMMA
%token <data> BLANKID
%token <data> STAR
%token <data> DIV
%token <data> MINUS
%token <data> PLUS
%token <data> EQ
%token <data> GE
%token <data> LBRACE
%token <data> LE
%token <data> LPAR
%token <data> LSQ
%token <data> MOD
%token <data> NE
%token <data> NOT
%token <data> AND
%token <data> OR
%token <data> RBRACE
%token <data> RPAR
%token <data> RSQ
%token <data> PACKAGE
%token <data> RETURN
%token <data> ELSE
%token <data> FOR
%token <data> IF
%token <data> VAR
%token <data> INT
%token <data> FLOAT32
%token <data> BOOL
%token <data> STRING
%token <data> PRINT
%token <data> PARSEINT
%token <data> FUNC
%token <data> CMDARGS
%token <data> ASSIGN
%token <data> GT
%token <data> LT

%token <data> ID STRLIT REALLIT INTLIT
%type <tree> program declarations varDeclaration varSpec commaID type funcDeclaration parameters comma_ID_Type funcBody varsAndStatements statement state_SEMI parseArgs funcInvocation comma_Expr expr


//Temporary
%token END

//Variables
%right ASSIGN
%left OR
%left AND
%left EQ NE LT LE GT GE
%left PLUS MINUS
%left STAR DIV MOD
%right NOT

%union{
	struct Node *tree;
    struct{
        char *string;
        int line;
        int column;
    }data;
}

%%
program: PACKAGE ID SEMICOLON declarations {root = new_node("Program", NULL, $4);}
;

declarations: /*empty*/ {$$ = NULL;}
| declarations varDeclaration SEMICOLON  {if($1 == NULL)$$ = $2;    
                                            else $$ = new_brother($1, $2);}
| declarations funcDeclaration SEMICOLON {if($1 == NULL)$$ = $2;
                                            else $$ = new_brother($1, $2);}
;
varDeclaration: VAR varSpec {
                            //main node
                            auxNode = new_node("VarDecl", NULL, $2);
                            auxNode2 = $2->brother;
                            Node *next = auxNode2;
                            while(auxNode2->brother != NULL){
                                new_brother(auxNode, new_node("VarDecl", NULL, new_brother(new_node(auxNode->son->nodeClass, NULL, NULL), auxNode2->brother)));
                                auxNode2 = auxNode2->brother;
                                next->brother = NULL;
                                next = auxNode2;
                            }
                            $$ = auxNode;
                            }
| VAR LPAR varSpec SEMICOLON RPAR {auxNode = new_node("VarDecl", NULL, $3);
                                    auxNode2 = $3->brother;
                                    Node *next = auxNode2;
                                    while(auxNode2->brother != NULL){
                                        new_brother(auxNode, new_node("VarDecl", NULL, new_brother(new_node(auxNode->son->nodeClass, NULL, NULL), auxNode2->brother)));
                                        auxNode2 = auxNode2->brother;
                                        next->brother = NULL;
                                        next = auxNode2;
                                    }
                                    $$ = auxNode;
                                    }
;

varSpec: ID commaID type    {
                            $$ = new_brother($3, new_brother(new_node_CL("Id", $1.string, NULL , $1.line, $1.column), $2));
                            };
commaID: /*empty*/ {$$ = NULL;}
| commaID COMMA ID  {if($1 == NULL)$$ = new_brother(new_node_CL("Id", $3.string, NULL,$3.line, $3.column), NULL);
                    else $$ = new_brother($1, new_node_CL("Id", $3.string, NULL,$3.line, $3.column));}
;

type: INT {$$=new_node("Int", NULL, NULL);}
| FLOAT32 {$$=new_node("Float32", NULL, NULL);}
| BOOL {$$=new_node("Bool", NULL, NULL);}
| STRING {$$=new_node("String", NULL, NULL);}
;

funcDeclaration: FUNC ID LPAR RPAR funcBody {
                                            auxNode = new_node("FuncHeader", NULL, auxNode2 = new_node_CL("Id", $2.string, NULL, $2.line, $2.column));
                                            new_brother(auxNode2, new_node("FuncParams", NULL, NULL));
                                            new_brother(auxNode, $5);
                                            $$=new_node("FuncDecl", NULL, auxNode);
                                            }
| FUNC ID LPAR RPAR type funcBody   {
                                    auxNode = new_node("FuncHeader", NULL, auxNode2 = new_node_CL("Id", $2.string, NULL, $2.line, $2.column));
                                    new_brother(auxNode2, $5);
                                    new_brother(auxNode2, new_node("FuncParams", NULL, NULL));
                                    new_brother(auxNode, $6);
                                    $$=new_node("FuncDecl", NULL, auxNode);}
| FUNC ID parameters funcBody   {
                                auxNode = new_node("FuncHeader", NULL, auxNode2 = new_node_CL("Id", $2.string, NULL, $2.line, $2.column));
                                new_brother(auxNode2, new_node("FuncParams", NULL, $3));
                                new_brother(auxNode, $4);
                                $$=new_node("FuncDecl", NULL, auxNode);
                                }
| FUNC ID parameters type funcBody {auxNode = new_node("FuncHeader", NULL, auxNode2 = new_node_CL("Id", $2.string, NULL, $2.line, $2.column));
                                    new_brother(auxNode2, $4);
                                    new_brother(auxNode2, new_node("FuncParams", NULL, $3));
                                    new_brother(auxNode, $5);
                                    $$=new_node("FuncDecl", NULL, auxNode);
                                    }
;


parameters: LPAR ID type comma_ID_Type RPAR{
                            auxNode2 = new_node_CL("Id", $2.string, NULL, $2.line, $2.column);
                            auxNode = new_node("ParamDecl", NULL, new_brother($3, auxNode2));
                            auxNode2 = $4;
                            Node *next = auxNode2;
                            while(auxNode2 != NULL){
                                new_brother(auxNode, new_node("ParamDecl", NULL, auxNode2));
                                auxNode2 = auxNode2->brother;
                                next->brother = next->son;
                                next->son = NULL;
                                next = auxNode2;
                            }
                            $$ = auxNode;
                            }
;
comma_ID_Type: /*empty*/ {$$ = NULL;}
| comma_ID_Type COMMA ID type  {
                                if($1 != NULL){
                                    auxNode = new_node_CL("Id", $3.string, NULL, $3.line, $3.column);
                                    $4->son = auxNode;
                                    $$ = new_brother($1, $4);
                                }
                                else{
                                    auxNode = new_node_CL("Id", $3.string, NULL, $3.line, $3.column);
                                    $4->son = auxNode;
                                    $$ = $4;
                                }
                                
}
;

funcBody:LBRACE varsAndStatements RBRACE {$$=new_node("FuncBody", NULL, $2);}
;

varsAndStatements: /*empty*/    {$$ = NULL;}
| varsAndStatements SEMICOLON {$$=$1;}
| varsAndStatements statement SEMICOLON    {if($1 != NULL) new_brother($1, $2);else $$ = $2;}
| varsAndStatements varDeclaration SEMICOLON  {if($1 != NULL) new_brother($1, $2); else $$ = $2;}
;


statement: ID ASSIGN expr {
                            $$ = new_node_CL("Assign", NULL, auxNode=new_node_CL("Id", $1.string, NULL, $1.line, $1.column), $2.line, $2.column); 
                            new_brother(auxNode, $3);
                            }
| LBRACE state_SEMI RBRACE {
                            if($2 != NULL)
                                if($2->brother != NULL)$$=new_node("Block", NULL, $2);
                                else $$ = $2;
                            else $$ = $2;
                            }
| IF expr LBRACE state_SEMI RBRACE {
                                    $$ = new_node("If", NULL, $2); 
                                    new_brother($2, new_node("Block", NULL, $4));
                                    new_brother($2, new_node("Block", NULL, NULL));
                                    }
| IF expr LBRACE state_SEMI RBRACE ELSE LBRACE state_SEMI RBRACE {
                                    $$ = new_node("If", NULL, $2);
                                    new_brother($2, new_node("Block", NULL, $4));
                                    new_brother($2, new_node("Block", NULL, $8));
                                    }
| FOR expr LBRACE state_SEMI RBRACE {
                                    new_brother($2, new_node("Block", NULL, $4)); 
                                    $$ = new_node("For", NULL, $2); 
                                    }
| FOR LBRACE state_SEMI RBRACE {$$ = new_node("For", NULL, new_node("Block", NULL, $3));}
| RETURN {$$ = new_node("Return", NULL, NULL);}
| RETURN expr {$$ = new_node("Return", NULL, $2);}
| funcInvocation {$$ = new_node("Call", NULL, $1);}
| parseArgs {$$ = $1;}
| PRINT LPAR STRLIT RPAR {$$ = new_node("Print", NULL, new_node("StrLit", $3.string, NULL));}
| PRINT LPAR expr RPAR {$$ = new_node("Print", NULL, $3);}
| error {$$ = NULL;}
;

state_SEMI: statement SEMICOLON state_SEMI {if($1 == NULL)$$ = $3;
                                            else $$ = new_brother($1, $3);}
| /*empty*/ {$$ = NULL;}
;

parseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ expr RSQ RPAR {
    $$ = new_node_CL("ParseArgs", NULL, new_brother(new_node_CL("Id", $1.string, NULL, $1.line, $1.column),$9), $5.line, $5.column);}
| ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR {$$ = NULL;}
;

funcInvocation: ID LPAR RPAR {$$ = new_node_CL("Id", $1.string, NULL, $1.line, $1.column);}
| ID LPAR expr comma_Expr RPAR {$$ = new_brother(new_node_CL("Id", $1.string, NULL, $1.line, $1.column), new_brother($3, $4));}
| ID LPAR error RPAR {$$ = NULL;}
;
comma_Expr: /*empty*/ {$$ = NULL;}
| comma_Expr COMMA expr{if($1 != NULL)$$ = new_brother($1, $3);
                        else $$ = $3;}
;

expr: expr OR expr              {$$ = new_node_CL("Or", NULL, $1, $2.line, $2.column);     new_brother($1, $3);}
|expr AND expr                  {$$ = new_node_CL("And", NULL, $1, $2.line, $2.column);    new_brother($1, $3);}
|expr LT expr                   {$$ = new_node_CL("Lt", NULL, $1, $2.line, $2.column);     new_brother($1, $3);}
|expr GT expr 					{$$ = new_node_CL("Gt", NULL, $1, $2.line, $2.column);     new_brother($1, $3);}
|expr EQ expr 					{$$ = new_node_CL("Eq", NULL, $1, $2.line, $2.column);     new_brother($1, $3);}
|expr NE expr 					{$$ = new_node_CL("Ne", NULL, $1, $2.line, $2.column);     new_brother($1, $3);}
|expr LE expr 					{$$ = new_node_CL("Le", NULL, $1, $2.line, $2.column);     new_brother($1, $3);}
|expr GE expr					{$$ = new_node_CL("Ge", NULL, $1, $2.line, $2.column);     new_brother($1, $3);}
|expr PLUS expr 				{$$ = new_node_CL("Add", NULL, $1, $2.line, $2.column);    new_brother($1, $3);}
|expr MINUS expr 				{$$ = new_node_CL("Sub", NULL, $1, $2.line, $2.column);    new_brother($1, $3);}
|expr STAR expr 				{$$ = new_node_CL("Mul", NULL, $1, $2.line, $2.column);    new_brother($1, $3);}
|expr DIV expr 					{$$ = new_node_CL("Div", NULL, $1, $2.line, $2.column);    new_brother($1, $3);}
|expr MOD expr 					{$$ = new_node_CL("Mod", NULL, $1, $2.line, $2.column);    new_brother($1, $3);}
|NOT expr 						{$$ = new_node_CL("Not", NULL, $2, $1.line, $1.column);}
|MINUS expr %prec NOT			{$$ = new_node_CL("Minus", NULL, $2, $1.line, $1.column);}
|PLUS expr %prec NOT			{$$ = new_node_CL("Plus", NULL, $2, $1.line, $1.column);}
|INTLIT                         {$$ = new_node_CL("IntLit", $1.string, NULL, $1.line, $1.column);}
|REALLIT                        {$$ = new_node_CL("RealLit", $1.string, NULL, $1.line, $1.column);}
|ID                             {$$ = new_node_CL("Id", $1.string, NULL, $1.line, $1.column);}
|funcInvocation                 {$$ = new_node("Call", NULL, $1);}
|LPAR expr RPAR                 {$$ = $2;}
|LPAR error RPAR                {$$ = NULL;}
;


%%

