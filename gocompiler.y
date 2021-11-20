%{
    #include <stdio.h>
    #include "tree.h"
    Node *root;
    Node *auxNode;
    Node *auxNode2;
    int yylex(void);
    void yyerror (char *s);
    int i =  0;
%}
//Reserved words
%token RESERVED
%token SEMICOLON
%token COMMA
%token BLANKID
%token STAR
%token DIV
%token MINUS
%token PLUS
%token EQ
%token GE
%token LBRACE
%token LE
%token LPAR
%token LSQ
%token MOD
%token NE
%token NOT
%token AND
%token OR
%token RBRACE
%token RPAR
%token RSQ
%token PACKAGE
%token RETURN
%token ELSE
%token FOR
%token IF
%token VAR
%token INT
%token FLOAT32
%token BOOL
%token STRING
%token PRINT
%token PARSEINT
%token FUNC
%token CMDARGS
%token ASSIGN
%token GT
%token LT

%token <string> ID STRLIT REALLIT INTLIT
%type <tree> program declarations varDeclaration varSpec commaID type funcDeclaration parameters comma_ID_Type funcBody varsAndStatements statement state_SEMI parseArgs funcInvocation comma_Expr expr


//Temporario
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
	char *string;
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
                                new_brother(auxNode, new_node("VarDecl", NULL, new_brother(new_node(auxNode->son->nodeType, NULL, NULL), auxNode2->brother)));
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
                                        new_brother(auxNode, new_node("VarDecl", NULL, new_brother(new_node(auxNode->son->nodeType, NULL, NULL), auxNode2->brother)));
                                        auxNode2 = auxNode2->brother;
                                        next->brother = NULL;
                                        next = auxNode2;
                                    }
                                    $$ = auxNode;
                                    }
;

varSpec: ID commaID type    {
                            $$ = new_brother($3, new_brother(new_node("Id", $1, NULL), $2));
                            };
commaID: /*empty*/ {$$ = NULL;}
| commaID COMMA ID  {if($1 == NULL)$$ = new_brother(new_node("Id", $3, NULL), NULL);
                    else $$ = new_brother($1, new_node("Id", $3, NULL));}
;

type: INT {$$=new_node("Int", NULL, NULL);}
| FLOAT32 {$$=new_node("Float32", NULL, NULL);}
| BOOL {$$=new_node("Bool", NULL, NULL);}
| STRING {$$=new_node("String", NULL, NULL);}
;

funcDeclaration: FUNC ID LPAR RPAR funcBody {
                                            auxNode = new_node("FuncHeader", NULL, auxNode2 = new_node("Id", $2, NULL));
                                            new_brother(auxNode2, new_node("FuncParams", NULL, NULL));
                                            new_brother(auxNode, $5);
                                            $$=new_node("FuncDecl", NULL, auxNode);
                                            }
| FUNC ID LPAR RPAR type funcBody   {
                                    auxNode = new_node("FuncHeader", NULL, auxNode2 = new_node("Id", $2, NULL));
                                    new_brother(auxNode2, $5);
                                    new_brother(auxNode2, new_node("FuncParams", NULL, NULL));
                                    new_brother(auxNode, $6);
                                    $$=new_node("FuncDecl", NULL, auxNode);}
| FUNC ID parameters funcBody   {
                                auxNode = new_node("FuncHeader", NULL, auxNode2 = new_node("Id", $2, NULL));
                                new_brother(auxNode2, new_node("FuncParams", NULL, $3));
                                new_brother(auxNode, $4);
                                $$=new_node("FuncDecl", NULL, auxNode);
                                }
| FUNC ID parameters type funcBody {auxNode = new_node("FuncHeader", NULL, auxNode2 = new_node("Id", $2, NULL));
                                    new_brother(auxNode2, $4);
                                    new_brother(auxNode2, new_node("FuncParams", NULL, $3));
                                    
                                    new_brother(auxNode, $5);
                                    $$=new_node("FuncDecl", NULL, auxNode);
                                    }
;


parameters: LPAR ID type comma_ID_Type RPAR{
                            auxNode2 = new_node("Id", $2, NULL);
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
                                    auxNode = new_node("Id", $3, NULL);
                                    $4->son = auxNode;
                                    $$ = new_brother($1, $4);
                                }
                                else{
                                    auxNode = new_node("Id", $3, NULL);
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
                            $$ = new_node("Assign", NULL, auxNode=new_node("Id", $1, NULL)); 
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
| parseArgs {$$ = new_node("ParseArgs", NULL, $1);}
| PRINT LPAR STRLIT RPAR {$$ = new_node("Print", NULL, new_node("StrLit", $3, NULL));}
| PRINT LPAR expr RPAR {$$ = new_node("Print", NULL, $3);}
| error {$$ = NULL;}
;

state_SEMI: statement SEMICOLON state_SEMI {if($1 == NULL)$$ = $3;
                                            else $$ = new_brother($1, $3);}
| /*empty*/ {$$ = NULL;}
;

parseArgs: ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ expr RSQ RPAR {$$ = new_brother(new_node("Id", $1, NULL),$9);}
| ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR {$$ = NULL;}
;

funcInvocation: ID LPAR RPAR {$$ = new_node("Id", $1, NULL);}
| ID LPAR expr comma_Expr RPAR {$$ = new_brother(new_node("Id", $1, NULL), new_brother($3, $4));}
| ID LPAR error RPAR {$$ = NULL;}
;
comma_Expr: /*empty*/ {$$ = NULL;}
| comma_Expr COMMA expr{if($1 != NULL)$$ = new_brother($1, $3);
                        else $$ = $3;}
;

expr: expr OR expr              {$$ = new_node("Or", NULL, $1);     new_brother($1, $3);}
|expr AND expr                  {$$ = new_node("And", NULL, $1);    new_brother($1, $3);}
|expr LT expr                   {$$ = new_node("Lt", NULL, $1);     new_brother($1, $3);}
|expr GT expr 					{$$ = new_node("Gt", NULL, $1);     new_brother($1, $3);}
|expr EQ expr 					{$$ = new_node("Eq", NULL, $1);     new_brother($1, $3);}
|expr NE expr 					{$$ = new_node("Ne", NULL, $1);     new_brother($1, $3);}
|expr LE expr 					{$$ = new_node("Le", NULL, $1);     new_brother($1, $3);}
|expr GE expr					{$$ = new_node("Ge", NULL, $1);     new_brother($1, $3);}
|expr PLUS expr 				{$$ = new_node("Add", NULL, $1);    new_brother($1, $3);}
|expr MINUS expr 				{$$ = new_node("Sub", NULL, $1);    new_brother($1, $3);}
|expr STAR expr 				{$$ = new_node("Mul", NULL, $1);    new_brother($1, $3);}
|expr DIV expr 					{$$ = new_node("Div", NULL, $1);    new_brother($1, $3);}
|expr MOD expr 					{$$ = new_node("Mod", NULL, $1);    new_brother($1, $3);}
|NOT expr 						{$$ = new_node("Not", NULL, $2);}
|MINUS expr %prec NOT			{$$ = new_node("Minus", NULL, $2);}
|PLUS expr %prec NOT			{$$ = new_node("Plus", NULL, $2);}
|INTLIT                         {$$ = new_node("IntLit", $1, NULL);}
|REALLIT                        {$$ = new_node("RealLit", $1, NULL);}
|ID                             {$$ = new_node("Id", $1, NULL);}
|funcInvocation                 {$$ = new_node("Call", NULL, $1);}
|LPAR expr RPAR                 {$$ = $2;}
|LPAR error RPAR                {$$ = NULL;}
;


%%

