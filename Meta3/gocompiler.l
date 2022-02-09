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
    #include "symbol_table.h"
    #include "ASTnoted.h"
    extern struct Node* root;

    #define L_TAG 1
    #define T_TAG 2
    #define S_TAG 3
    #define NO_TAG 0
    #define NO_NEED 0
    #define NEED_S 1
    int column = 1;
    int line = 1;
    int temp_line = 0;
    int temp_column = 0;
    int tag = NO_TAG;
    int semicolon = NO_NEED;
    int in_comment = NO_NEED;
    int string_pos = 0;
    int put_semicolon();
    int column_no_semicolon();
    char string_buff[10000];
    int yydebug = 0;
    int erros = 0;
%}

%%

{RESERVED}                                              {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG) printf("RESERVED(%s)\n", yytext);
                                                        return RESERVED;
                                                        }
";"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("SEMICOLON\n");
                                                        return SEMICOLON;
                                                        }
","                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("COMMA\n");
                                                        return COMMA;
                                                        }
"_"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("BLANKID\n");
                                                        return BLANKID;
                                                        }
"*"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("STAR\n");
                                                        return STAR;
                                                        }
"/"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("DIV\n");
                                                        return DIV;
                                                        }
"-"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("MINUS\n");
                                                        return MINUS;
                                                        }
"+"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("PLUS\n");
                                                        return PLUS;
                                                        }
"=="                                                    {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("EQ\n");
                                                        return EQ;
                                                        }
">="                                                    {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("GE\n");
                                                        return GE;
                                                        }
"{"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("LBRACE\n");
                                                        return LBRACE;
                                                        }
"<="                                                    {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("LE\n");
                                                        return LE;
                                                        }
"("                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("LPAR\n");
                                                        return LPAR;
                                                        }
"["                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG){printf("LSQ\n");}
                                                        return LSQ;
                                                        }
"%"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("MOD\n");
                                                        return MOD;
                                                        }
"!="                                                    {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("NE\n");
                                                        return NE;
                                                        }
"!"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("NOT\n"); 
                                                        return NOT;
                                                        }
"&&"                                                    {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("AND\n");
                                                        
                                                        return AND;
                                                        }
"||"                                                    {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("OR\n");
                                                        return OR;
                                                        }
"}"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column+=yyleng; 
                                                        semicolon = NEED_S;
                                                        if(tag == L_TAG)printf("RBRACE\n");
                                                        return RBRACE;
                                                        }
")"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column+=yyleng; 
                                                        semicolon = NEED_S;
                                                        if(tag == L_TAG)printf("RPAR\n");
                                                        return RPAR;
                                                        }
"]"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column+=yyleng; semicolon = NEED_S;
                                                        if(tag == L_TAG)printf("RSQ\n");
                                                        return RSQ;
                                                        }
"package"                                               {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("PACKAGE\n");
                                                        return PACKAGE;
                                                        }
"return"                                                {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column+=yyleng; 
                                                        semicolon = NEED_S;
                                                        if(tag == L_TAG)printf("RETURN\n");
                                                        return RETURN;
                                                        }
"else"                                                  {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("ELSE\n");
                                                        return ELSE;
                                                        }
"for"                                                   {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("FOR\n");
                                                        return FOR;
                                                        }
"if"                                                    {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("IF\n");
                                                        return IF;
                                                        }
"var"                                                   {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("VAR\n");
                                                        return VAR;
                                                        }
"int"                                                   {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("INT\n");
                                                        return INT;
                                                        }
"float32"                                               {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("FLOAT32\n");
                                                        return FLOAT32;
                                                        }
"bool"                                                  {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("BOOL\n");
                                                        return BOOL;
                                                        }
"string"                                                {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("STRING\n");
                                                        return STRING;
                                                        }
"fmt.Println"                                           {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("PRINT\n");
                                                        return PRINT;
                                                        }
"strconv.Atoi"                                          {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("PARSEINT\n");
                                                        return PARSEINT;
                                                        }
"func"                                                  {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("FUNC\n");
                                                        return FUNC;
                                                        }
"os.Args"                                               {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("CMDARGS\n");
                                                        return CMDARGS;
                                                        }
"="                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("ASSIGN\n");
                                                        return ASSIGN;
                                                        }
">"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("GT\n");
                                                        return GT;
                                                        }
"<"                                                     {
                                                        yylval.data.line = line;
                                                        yylval.data.column = column;
                                                        column_no_semicolon();
                                                        if(tag == L_TAG)printf("LT\n");
                                                        return LT;
                                                        }
"/*"                                {BEGIN COMMENT_BLOCK;
                                    temp_column = 0 + yyleng;
                                    temp_line = 0;
                                    }
<COMMENT_BLOCK>"*/"                 {BEGIN 0;
                                    line += temp_line;
                                    column += temp_column + yyleng;
                                    }
<COMMENT_BLOCK>"\r\n"|"\n"          {if(tag == L_TAG)put_semicolon();
                                    temp_line++;
                                    temp_column = 1;
                                    temp_column += yyleng;
                                    if(semicolon == NEED_S){
                                        semicolon = NO_NEED;
                                        yylval.data.line = line;
                                        yylval.data.column = column;
                                        return SEMICOLON;
                                    }
                                    }
<COMMENT_BLOCK><<EOF>>              {printf("Line %d, column %d: unterminated comment\n", line, column); return 0;}                                  
<COMMENT_BLOCK>.                    {temp_column+=yyleng;}


\"                                                    {yylval.data.line = line;yylval.data.column = column;string_pos = 0;BEGIN STRING_STATE;string_buff[string_pos++] = '"';string_buff[string_pos] = '\0';temp_column=0 + yyleng;}

<STRING_STATE>\"                                            {
                                                            BEGIN 0;
                                                            column += temp_column + yyleng;
                                                            semicolon = NEED_S;
                                                            string_buff[string_pos++] = '"';
                                                            string_buff[string_pos] = '\0';
                                                            if(tag == L_TAG) printf("STRLIT(%s)\n", string_buff);
                                                            yytext = string_buff;
                                                            yylval.data.string = strdup(yytext);
                                                            return STRLIT;
                                                            }

<STRING_STATE>"\r\n"|"\n"|"\r"                              {BEGIN 0; string_buff[string_pos] = 0; printf("Line %d, column %d: unterminated string literal\n", line, column);column_no_semicolon();line++;column = 1;}
<STRING_STATE>\\\"|\\"n"|\\"f"|\\"r"|\\"t"|\\\\|\\\"        {string_buff[string_pos++] = yytext[0];string_buff[string_pos++] = yytext[1]; string_buff[string_pos] = 0;temp_column+= 2;}
<STRING_STATE>\\.|\\                                        {BEGIN STRING_ERROR;printf("Line %d, column %d: invalid escape sequence (%s)\n", line, column + temp_column, yytext);temp_column+=yyleng;semicolon = NO_NEED;}
<STRING_STATE><<EOF>>                                       {printf("Line %d, column %d: unterminated string literal\n", line, column);BEGIN 0; column += temp_column + yyleng;}
<STRING_STATE>.                                             {string_buff[string_pos++] = yytext[0]; string_buff[string_pos] = 0;temp_column+= yyleng;}


<STRING_ERROR>"\r\n"|"\n"                                       {BEGIN 0;  string_buff[string_pos] = 0; printf("Line %d, column %d: unterminated string literal\n", line, column);column_no_semicolon();line++;column = 1;}
<STRING_ERROR>\"                                                {BEGIN 0; column += temp_column + yyleng;string_buff[string_pos++] = yytext[0];}
<STRING_ERROR>\\\"|\\"n"|\\"f"|\\"r"|\\"t"|\\\\|\\\"            {string_buff[string_pos++] = yytext[0];string_buff[string_pos++] = yytext[1]; string_buff[string_pos] = 0;temp_column+= yyleng;}
<STRING_ERROR>\\.|\\                                            {printf("Line %d, column %d: invalid escape sequence (%s)\n", line, column + temp_column, yytext);temp_column+=yyleng;semicolon = NO_NEED;}
<STRING_ERROR><<EOF>>                                           {printf("Line %d, column %d: unterminated string literal\n", line, column);BEGIN 0; column += temp_column + yyleng;}
<STRING_ERROR>.                                                 {temp_column+= yyleng;}

"0"({octal_digit}*("8"|"9")+{octal_digit}*)+                                                {printf("Line %d, column %d: invalid octal constant (%s)\n", line, column, yytext);
                                                                                            column+=yyleng;
                                                                                            }
{letter}({letter}|{decimal_digit})*                                                         {
                                                                                            yylval.data.line = line;
                                                                                            yylval.data.column = column;
                                                                                            semicolon = NEED_S;
                                                                                            column+=yyleng; 
                                                                                            if(tag == L_TAG)printf("ID(%s)\n", yytext);
                                                                                            yylval.data.string = strdup(yytext);
                                                                                            return ID;
                                                                                            }
({decimal_digit}+"."{decimal_digit}*{exponent}?)|{decimal_digit}+{exponent}|({decimal_digit}*"."{decimal_digit}+{exponent}?) {
                                                                                                                            yylval.data.line = line;
                                                                                                                            yylval.data.column = column;
                                                                                                                            column+=yyleng;
                                                                                                                            semicolon = NEED_S;
                                                                                                                            if(tag == L_TAG)printf("REALLIT(%s)\n", yytext);
                                                                                                                            yylval.data.string = strdup(yytext);
                                                                                                                            return REALLIT; //TODO
                                                                                                                            }
{decimal_digit}*|("0"("x"|"X"){hex_digit}+)|("0"{octal_digit}+)                 {
                                                                                yylval.data.line = line;
                                                                                yylval.data.column = column;
                                                                                column+=yyleng;
                                                                                semicolon = NEED_S;
                                                                                if(tag == L_TAG)printf("INTLIT(%s)\n", yytext);
                                                                                yylval.data.string = strdup(yytext);
                                                                                return INTLIT; //TODO
                                                                                }
<<EOF>>                                                                         {
                                                                                if(tag == L_TAG) put_semicolon();
                                                                                if(semicolon == NEED_S){
                                                                                    semicolon = NO_NEED;
                                                                                    yylval.data.line = line;
                                                                                    yylval.data.column = column;
                                                                                    return SEMICOLON; 

                                                                                }
                                                                                yyterminate();
                                                                                return 0;
                                                                                }
"\n"|"\r\n"                                                                     {
                                                                                yylval.data.line = line;
                                                                                yylval.data.column = column;
                                                                                temp_column = column;
                                                                                column=1;
                                                                                line++;
                                                                                if(tag == L_TAG)put_semicolon();
                                                                                
                                                                                if(semicolon == NEED_S){
                                                                                semicolon = NO_NEED;
                                                                                return SEMICOLON;
                                                                                }
                                                                                }
"//".*                                                                          {
                                                                                yylval.data.line = line;
                                                                                yylval.data.column = column;
                                                                                column+=yyleng;
                                                                                if(tag == L_TAG)put_semicolon();
                                                                                if(semicolon == NEED_S){
                                                                                semicolon = NO_NEED;
                                                                                return SEMICOLON;
                                                                                }
                                                                                }
" "|"\t"                                                                        {column+=yyleng;}
\\("a"|"b"|"'"|"v")                                                             {printf("Line %d, column %d: invalid escape sequence (%s)\n", line, column, yytext);
                                                                                column+=yyleng;    
                                                                                semicolon = NO_NEED;
                                                                                }
.                                                                               {
                                                                                printf("Line %d, column %d: illegal character (%s)\n", line, column, yytext);
                                                                                column_no_semicolon();
                                                                                }

%%

int main(int argc, char **argv){
    string_buff[0] = 0;
    if(argc == 2){

        //Lexical analisys
        if(argv[1][0] == '-' && argv[1][1] == 'l' && argv[1][2] == '\0'){
            tag = L_TAG;
            yylex();   
        }

        //Sintatical analisys
        if(argv[1][0] == '-' && argv[1][1] == 't' && argv[1][2] == '\0'){
            tag = T_TAG;
            yyparse();
            if(!erros) print_tree(root, 0);
        }

        //Semantic analisys
        if(argv[1][0] == '-' && argv[1][1] == 's' && argv[1][2] == '\0'){
            tag = S_TAG;
            yyparse();
        }
    }
    else{
        yyparse();
    }

    Table *global_table = create_tables(root);
    int errorcount = verify_program(root, global_table);


    if(tag == S_TAG && errorcount == 0){
        //if(errorcount > 0)printf("\n");
        print_table(global_table);
        printf("\n");
        print_noted_tree(root, 0);
    }

    if(root != NULL){
        cleanTree(root);
    }
    
    yylex_destroy();
    return 0;
}

int yywrap(){
    return 1;
}

int column_no_semicolon(){
    column+=yyleng;
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
    int c = column - strlen(yytext);
    if(yytext[0] == '\n'){
        printf ("Line %d, column %d: %s: %s\n", line - 1, temp_column, s, yytext);
    }
    else printf ("Line %d, column %d: %s: %s\n", line, c , s, yytext);
}