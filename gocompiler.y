%{
    #include <stdio.h>
    int yylex(void);
    void yyerror (char *msg);
%}

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

%type <string> calc

%union{
    double value;
    char* string;
}

%right '='
%left '+' '-'
%left '/' '*'

%%

calc:   SEMICOLON   '\n'  {printf("SS\n");};
        |calc SEMICOLON           {printf("SS\n");};


%%


void yyerror(char *msg) {
    printf("%s", msg);
}