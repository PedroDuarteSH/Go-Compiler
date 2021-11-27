/*
Adriana Bernardo 2019218086
Pedro Henriques 2019217793
*/
%X COMMENT_BLOCK STRING_STATE STRING_ERROR
 //Variables
newline                     "\n"

 //Letters and digits
letter                      ([a-z]|[A-Z]|_)
decimal_digit               [0-9]
octal_digit                 [0-7]
hex_digit                   ([0-9]|[A-F]|[a-f])
exponent                    ("e"|"E")("+"|"-")?({decimal_digit}+)

RESERVED                    "--"|"++"|"break"|"case"|"chan"|"const"|"continue"|"default"|"defer"|"fallthrough"|"go"|"goto"|"import"|"interface"|"map"|"range"|"select"|"struct"|"switch"|"type"

%{
    #include "y.tab.h"
    #include "tree.h"
    extern struct Node* root;
    #define L_TAG 1
    #define T_TAG 2
    #define NO_TAG 0
    #define NO_NEED 0
    #define NEED_S 1
    int collumn = 1;
    int line = 1;
    int temp_line = 0;
    int temp_collumn = 0;
    int tag = NO_TAG;
    int semicolon = NO_NEED;
    int in_comment = NO_NEED;
    int string_pos = 0;
    int put_semicolon();
    int collumn_no_semicolon();
    char string_buff[10000];
    int yydebug = 0;
    int erros = 0;
%}

%%

{RESERVED}                                              {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG) printf("RESERVED(%s)\n", yytext);
                                                        return RESERVED;
                                                        }
";"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("SEMICOLON\n");
                                                        return SEMICOLON;
                                                        }
","                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("COMMA\n");
                                                        return COMMA;
                                                        }
"_"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("BLANKID\n");
                                                        return BLANKID;
                                                        }
"*"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("STAR\n");
                                                        return STAR;
                                                        }
"/"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("DIV\n");
                                                        return DIV;
                                                        }
"-"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("MINUS\n");
                                                        return MINUS;
                                                        }
"+"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("PLUS\n");
                                                        return PLUS;
                                                        }
"=="                                                    {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("EQ\n");
                                                        return EQ;
                                                        }
">="                                                    {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("GE\n");
                                                        return GE;
                                                        }
"{"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("LBRACE\n");
                                                        return LBRACE;
                                                        }
"<="                                                    {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("LE\n");
                                                        return LE;
                                                        }
"("                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("LPAR\n");
                                                        return LPAR;
                                                        }
"["                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG){printf("LSQ\n");}
                                                        return LSQ;
                                                        }
"%"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("MOD\n");
                                                        return MOD;
                                                        }
"!="                                                    {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("NE\n");
                                                        return NE;
                                                        }
"!"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("NOT\n");
                                                        return NOT;
                                                        }
"&&"                                                    {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("AND\n");
                                                        return AND;
                                                        }
"||"                                                    {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("OR\n");
                                                        return OR;
                                                        }
"}"                                                     {
                                                        collumn+=yyleng; 
                                                        semicolon = NEED_S;
                                                        if(tag == L_TAG)printf("RBRACE\n");
                                                        return RBRACE;
                                                        }
")"                                                     {
                                                        collumn+=yyleng; 
                                                        semicolon = NEED_S;
                                                        if(tag == L_TAG)printf("RPAR\n");
                                                        return RPAR;
                                                        
                                                        }
"]"                                                     {
                                                        collumn+=yyleng; semicolon = NEED_S;
                                                        if(tag == L_TAG)printf("RSQ\n");
                                                        return RSQ;
                                                        
                                                        }
"package"                                               {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("PACKAGE\n");
                                                        return PACKAGE;
                                                        }
"return"                                                {
                                                        collumn+=yyleng; 
                                                        semicolon = NEED_S;
                                                        if(tag == L_TAG)printf("RETURN\n");
                                                        return RETURN;
                                                        }
"else"                                                  {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("ELSE\n");
                                                        return ELSE;
                                                        }
"for"                                                   {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("FOR\n");
                                                        return FOR;
                                                        }
"if"                                                    {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("IF\n");
                                                        return IF;
                                                        }
"var"                                                   {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("VAR\n");
                                                        return VAR;
                                                        }
"int"                                                   {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("INT\n");
                                                        return INT;
                                                        }
"float32"                                               {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("FLOAT32\n");
                                                        return FLOAT32;
                                                        }
"bool"                                                  {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("BOOL\n");
                                                        return BOOL;
                                                        }
"string"                                                {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("STRING\n");
                                                        return STRING;
                                                        }
"fmt.Println"                                           {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("PRINT\n");
                                                        return PRINT;
                                                        }
"strconv.Atoi"                                          {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("PARSEINT\n");
                                                        return PARSEINT;
                                                        }
"func"                                                  {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("FUNC\n");
                                                        return FUNC;
                                                        }
"os.Args"                                               {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("CMDARGS\n");
                                                        return CMDARGS;
                                                        }
"="                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("ASSIGN\n");
                                                        return ASSIGN;
                                                        }
">"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("GT\n");
                                                        return GT;
                                                        }
"<"                                                     {
                                                        collumn_no_semicolon();
                                                        if(tag == L_TAG)printf("LT\n");
                                                        return LT;
                                                        }
"/*"                                {BEGIN COMMENT_BLOCK;
                                    temp_collumn = 0 + yyleng;
                                    temp_line = 0;
                                    }
<COMMENT_BLOCK>"*/"                 {BEGIN 0;
                                    line += temp_line;
                                    collumn += temp_collumn + yyleng;
                                    }
<COMMENT_BLOCK>"\r\n"|"\n"          {if(tag == L_TAG)put_semicolon();
                                    temp_line++;
                                    temp_collumn = 1;
                                    temp_collumn += yyleng;
                                    if(semicolon == NEED_S){
                                        semicolon = NO_NEED;
                                        return SEMICOLON;
                                    }
                                    }
<COMMENT_BLOCK><<EOF>>              {printf("Line %d, column %d: unterminated comment\n", line, collumn); return 0;}                                  
<COMMENT_BLOCK>.                    {temp_collumn+=yyleng;}


\"                                                    {string_pos = 0;BEGIN STRING_STATE;string_buff[string_pos++] = '"';string_buff[string_pos] = '\0';temp_collumn=0 + yyleng;}
<STRING_STATE>\"                                            {
                                                            BEGIN 0;
                                                            collumn += temp_collumn + yyleng;
                                                            semicolon = NEED_S;
                                                            string_buff[string_pos++] = '"';
                                                            string_buff[string_pos] = '\0';
                                                            if(tag == L_TAG) printf("STRLIT(%s)\n", string_buff);
                                                           
                                                            yytext = string_buff;
                                                            yylval.string = strdup(yytext);
                                                            return STRLIT;
                                                            
                                                            }
<STRING_STATE>"\r\n"|"\n"|"\r"                              {BEGIN 0; string_buff[string_pos] = 0; printf("Line %d, column %d: unterminated string literal\n", line, collumn);collumn_no_semicolon();line++;collumn = 1;}
<STRING_STATE>\\\"|\\"n"|\\"f"|\\"r"|\\"t"|\\\\|\\\"        {string_buff[string_pos++] = yytext[0];string_buff[string_pos++] = yytext[1]; string_buff[string_pos] = 0;temp_collumn+= 2;}
<STRING_STATE>\\.|\\                                        {BEGIN STRING_ERROR;printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn + temp_collumn, yytext);temp_collumn+=yyleng;semicolon = NO_NEED;}
<STRING_STATE><<EOF>>                                       {printf("Line %d, column %d: unterminated string literal\n", line, collumn);BEGIN 0; collumn += temp_collumn + yyleng;}
<STRING_STATE>.                                             {string_buff[string_pos++] = yytext[0]; string_buff[string_pos] = 0;temp_collumn+= yyleng;}


<STRING_ERROR>"\r\n"|"\n"                                       {BEGIN 0;  string_buff[string_pos] = 0; printf("Line %d, column %d: unterminated string literal\n", line, collumn);collumn_no_semicolon();line++;collumn = 1;}
<STRING_ERROR>\"                                                {BEGIN 0; collumn += temp_collumn + yyleng;string_buff[string_pos++] = yytext[0];}
<STRING_ERROR>\\\"|\\"n"|\\"f"|\\"r"|\\"t"|\\\\|\\\"            {string_buff[string_pos++] = yytext[0];string_buff[string_pos++] = yytext[1]; string_buff[string_pos] = 0;temp_collumn+= yyleng;}
<STRING_ERROR>\\.|\\                                            {printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn + temp_collumn, yytext);temp_collumn+=yyleng;semicolon = NO_NEED;}
<STRING_ERROR><<EOF>>                                           {printf("Line %d, column %d: unterminated string literal\n", line, collumn);BEGIN 0; collumn += temp_collumn + yyleng;}
<STRING_ERROR>.                                                 {temp_collumn+= yyleng;}

"0"({octal_digit}*("8"|"9")+{octal_digit}*)+                                                {printf("Line %d, column %d: invalid octal constant (%s)\n", line, collumn, yytext);
                                                                                            collumn+=yyleng;
                                                                                            }
{letter}({letter}|{decimal_digit})*                                                         {
                                                                                            semicolon = NEED_S;
                                                                                            collumn+=yyleng; 
                                                                                            if(tag == L_TAG)printf("ID(%s)\n", yytext);
                                                                                            yylval.string = strdup(yytext);
                                                                                            return ID;
                                                                                            }
({decimal_digit}+"."{decimal_digit}*{exponent}?)|{decimal_digit}+{exponent}|({decimal_digit}*"."{decimal_digit}+{exponent}?) {
                                                                                                                            collumn+=yyleng;
                                                                                                                            semicolon = NEED_S;
                                                                                                                            if(tag == L_TAG)printf("REALLIT(%s)\n", yytext);
                                                                                                                            yylval.string = strdup(yytext);
                                                                                                                            return REALLIT; //TODO
                                                                                                                            }
{decimal_digit}*|("0"("x"|"X"){hex_digit}+)|("0"{octal_digit}+)                 {
                                                                                collumn+=yyleng;
                                                                                semicolon = NEED_S;
                                                                                if(tag == L_TAG)printf("INTLIT(%s)\n", yytext);
                                                                                yylval.string = strdup(yytext);
                                                                                return INTLIT; //TODO
                                                                                }
<<EOF>>                                                                         {
                                                                                if(tag == L_TAG) put_semicolon();
                                                                                if(semicolon == NEED_S){
                                                                                    semicolon = NO_NEED;
                                                                                    return SEMICOLON; 

                                                                                }
                                                                                yyterminate();
                                                                                return 0;
                                                                                }
"\n"|"\r\n"                                                                     {
                                                                                temp_collumn = collumn;
                                                                                collumn=1;
                                                                                line++;
                                                                                if(tag == L_TAG)put_semicolon();
                                                                                
                                                                                if(semicolon == NEED_S){
                                                                                    semicolon = NO_NEED;
                                                                                    return SEMICOLON;
                                                                                }
                                                                                }
"//".*                                                                         {
                                                                                collumn+=yyleng;
                                                                                if(tag == L_TAG)put_semicolon();
                                                                                if(semicolon == NEED_S){
                                                                                    semicolon = NO_NEED;
                                                                                    return SEMICOLON;
                                                                                }
                                                                                }
" "|"\t"                                                                        {collumn+=yyleng;}
\\("a"|"b"|"'"|"v")                                                             {printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn, yytext);
                                                                                collumn+=yyleng;    
                                                                                semicolon = NO_NEED;
                                                                                }
.                                                                               {
                                                                                printf("Line %d, column %d: illegal character (%s)\n", line, collumn, yytext);
                                                                                collumn_no_semicolon();
                                                                                }

%%

int main(int argc, char **argv)
{
    string_buff[0] = 0;
    if(argc == 2){
        if(argv[1][0] == '-' && argv[1][1] == 'l'){
            tag = L_TAG;
            yylex();   
        }
        if(argv[1][0] == '-' && argv[1][1] == 't'){
            tag = T_TAG;
            yyparse();
            if(!erros) print_tree(root, 0);
        }
    }
    else yyparse();
    if(root != NULL){
        cleanTree(root);
    }
    return 0;
}

int yywrap()
{
return 1;
}

int collumn_no_semicolon(){
    collumn+=yyleng;
    semicolon = NO_NEED;
    return 0;
}


int put_semicolon(){
    if(semicolon == NEED_S){
        if(tag == L_TAG)
            printf("SEMICOLON\n");
    }
    semicolon = NO_NEED;
    return 0;
}

void yyerror (char *s) {
    erros++;
    int c = collumn - strlen(yytext);
    if(yytext[0] == '\n'){
        printf ("Line %d, column %d: %s: %s\n", line - 1, temp_collumn, s, yytext);
    }
    else printf ("Line %d, column %d: %s: %s\n", line, c , s, yytext);
}


