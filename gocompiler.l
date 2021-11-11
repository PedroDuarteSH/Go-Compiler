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
    int in_str = 0;
    int put_semicolon();
    int collumn_no_semicolon();
    char string_buff[10000];
%}
%%

{RESERVED}                                              {if(tag == L_TAG) printf("RESERVED(%s)\n", yytext);
                                                        if(tag == T_TAG) return RESERVED;
                                                        collumn_no_semicolon();
                                                        }
";"                                                     {if(tag == L_TAG)printf("SEMICOLON\n");
                                                        if(tag == T_TAG){return SEMICOLON;}
                                                        collumn_no_semicolon();
                                                        }
","                                                     {if(tag == L_TAG)printf("COMMA\n");
                                                        if(tag == T_TAG){return COMMA;}
                                                        collumn_no_semicolon();
                                                        }
"_"                                                     {if(tag == L_TAG)printf("BLANKID\n");
                                                        if(tag == T_TAG){return BLANKID;}
                                                        collumn_no_semicolon();
                                                        }
"*"                                                     {if(tag == L_TAG)printf("STAR\n");
                                                        if(tag == T_TAG){return STAR;}
                                                        collumn_no_semicolon();
                                                        }
"/"                                                     {if(tag == L_TAG)printf("DIV\n");
                                                        if(tag == T_TAG){return DIV;}
                                                        collumn_no_semicolon();
                                                        }
"-"                                                     {if(tag == L_TAG)printf("MINUS\n");
                                                        if(tag == T_TAG){return MINUS;}
                                                        collumn_no_semicolon();
                                                        }
"+"                                                     {if(tag == L_TAG)printf("PLUS\n");
                                                        if(tag == T_TAG){return PLUS;}
                                                        collumn_no_semicolon();
                                                        }
"=="                                                    {if(tag == L_TAG)printf("EQ\n");
                                                        if(tag == T_TAG){return EQ;}
                                                        collumn_no_semicolon();
                                                        }
">="                                                    {if(tag == L_TAG)printf("GE\n");
                                                        if(tag == T_TAG){return GE;}
                                                        collumn_no_semicolon();
                                                        }
"{"                                                     {if(tag == L_TAG)printf("LBRACE\n");
                                                        if(tag == T_TAG){return LBRACE;}
                                                        collumn_no_semicolon();
                                                        }
"<="                                                    {if(tag == L_TAG)printf("LE\n");
                                                        if(tag == T_TAG){return LE;}
                                                        collumn_no_semicolon();
                                                        }
"("                                                     {if(tag == L_TAG)printf("LPAR\n");
                                                        if(tag == T_TAG){return LPAR;}
                                                        collumn_no_semicolon();
                                                        }
"["                                                     {if(tag == L_TAG){printf("LSQ\n");}
                                                        if(tag == T_TAG){return LSQ;}
                                                        collumn_no_semicolon();
                                                        }
"%"                                                     {if(tag == L_TAG)printf("MOD\n");
                                                        if(tag == T_TAG){return MOD;}
                                                        collumn_no_semicolon();
                                                        }
"!="                                                    {if(tag == L_TAG)printf("NE\n");
                                                        if(tag == T_TAG){return NE;}
                                                        collumn_no_semicolon();
                                                        }
"!"                                                     {if(tag == L_TAG)printf("NOT\n");
                                                        if(tag == T_TAG){return NOT;}
                                                        collumn_no_semicolon();
                                                        }
"&&"                                                    {if(tag == L_TAG)printf("AND\n");
                                                        if(tag == T_TAG){return AND;}
                                                        collumn_no_semicolon();
                                                        }
"||"                                                    {if(tag == L_TAG)printf("OR\n");
                                                        if(tag == T_TAG){return OR;}
                                                        collumn_no_semicolon();
                                                        }
"}"                                                     {if(tag == L_TAG)printf("RBRACE\n");
                                                        if(tag == T_TAG){return RBRACE;}
                                                        collumn+=yyleng; 
                                                        semicolon = NEED_S;
                                                        }
")"                                                     {if(tag == L_TAG)printf("RPAR\n");
                                                        if(tag == T_TAG){return RPAR;}
                                                        collumn+=yyleng; 
                                                        semicolon = NEED_S;
                                                        }
"]"                                                     {if(tag == L_TAG)printf("RSQ\n");
                                                        if(tag == T_TAG){return RSQ;}
                                                        collumn+=yyleng; semicolon = NEED_S;
                                                        }
"package"                                               {if(tag == L_TAG)printf("PACKAGE\n");
                                                        if(tag == T_TAG){return PACKAGE;}
                                                        collumn_no_semicolon();
                                                        }
"return"                                                {if(tag == L_TAG)printf("RETURN\n");
                                                        if(tag == T_TAG){return RETURN;}
                                                        collumn+=yyleng; 
                                                        semicolon = NEED_S;
                                                        }
"else"                                                  {if(tag == L_TAG)printf("ELSE\n");
                                                        if(tag == T_TAG){return ELSE;}
                                                        collumn_no_semicolon();
                                                        }
"for"                                                   {if(tag == L_TAG)printf("FOR\n");
                                                        if(tag == T_TAG){return FOR;}
                                                        collumn_no_semicolon();
                                                        }
"if"                                                    {if(tag == L_TAG)printf("IF\n");
                                                        if(tag == T_TAG){return IF;}
                                                        collumn_no_semicolon();
                                                        }
"var"                                                   {if(tag == L_TAG)printf("VAR\n");
                                                        if(tag == T_TAG){return VAR;}
                                                        collumn_no_semicolon();
                                                        }
"int"                                                   {if(tag == L_TAG)printf("INT\n");
                                                        if(tag == T_TAG){return INT;}
                                                        collumn_no_semicolon();
                                                        }
"float32"                                               {if(tag == L_TAG)printf("FLOAT32\n");
                                                        if(tag == T_TAG){return FLOAT32;}
                                                        collumn_no_semicolon();
                                                        }
"bool"                                                  {if(tag == L_TAG)printf("BOOL\n");
                                                        if(tag == T_TAG){return BOOL;}
                                                        collumn_no_semicolon();
                                                        }
"string"                                                {if(tag == L_TAG)printf("STRING\n");
                                                        if(tag == T_TAG){return STRING;}
                                                        collumn_no_semicolon();
                                                        }
"fmt.Println"                                           {if(tag == L_TAG)printf("PRINT\n");
                                                        if(tag == T_TAG){return PRINT;}
                                                        collumn_no_semicolon();
                                                        }
"strconv.Atoi"                                          {if(tag == L_TAG)printf("PARSEINT\n");
                                                        if(tag == T_TAG){return PARSEINT;}
                                                        collumn_no_semicolon();
                                                        }
"func"                                                  {if(tag == L_TAG)printf("FUNC\n");
                                                        if(tag == T_TAG){return FUNC;}
                                                        collumn_no_semicolon();
                                                        }
"os.Args"                                               {if(tag == L_TAG)printf("CMDARGS\n");
                                                        if(tag == T_TAG){return CMDARGS;}
                                                        collumn_no_semicolon();
                                                        }
"="                                                     {if(tag == L_TAG)printf("ASSIGN\n");
                                                        if(tag == T_TAG){return ASSIGN;}
                                                        collumn_no_semicolon();
                                                        }
">"                                                     {if(tag == L_TAG)printf("GT\n");
                                                        if(tag == T_TAG){return GT;}
                                                        collumn_no_semicolon();
                                                        }
"<"                                                     {if(tag == L_TAG)printf("LT\n");
                                                        if(tag == T_TAG){return LT;}
                                                        collumn_no_semicolon();
                                                        }
"/*"                                {BEGIN COMMENT_BLOCK;temp_collumn= 0 + yyleng;in_comment = NEED_S;temp_line = 0;}
<COMMENT_BLOCK>"*/"                 {BEGIN 0;line += temp_line;collumn += temp_collumn + yyleng;in_comment = NO_NEED;}
<COMMENT_BLOCK>"\r\n"|"\n"          {put_semicolon();temp_line++;temp_collumn = 1;temp_collumn += yyleng;}
<COMMENT_BLOCK>.                    {temp_collumn+=yyleng;}


\"                                                    {in_str = 1;string_pos = 0;BEGIN STRING_STATE;string_buff[string_pos++] = '"';string_buff[string_pos] = '\0';temp_collumn=0 + yyleng;}
<STRING_STATE>\"                                            {in_str = 0;BEGIN 0; collumn += temp_collumn + yyleng;string_buff[string_pos++] = yytext[0];string_buff[string_pos] = 0;if(tag)printf("STRLIT(%s)\n", string_buff);semicolon = NEED_S;}
<STRING_STATE>"\r\n"|"\n"|"\r"                                   {in_str = 0;BEGIN 0; string_buff[string_pos] = 0; printf("Line %d, column %d: unterminated string literal\n", line, collumn);collumn_no_semicolon();line++;collumn = 1;}
<STRING_STATE>\\\"|\\"n"|\\"f"|\\"r"|\\"t"|\\\\|\\\"        {string_buff[string_pos++] = yytext[0];string_buff[string_pos++] = yytext[1]; string_buff[string_pos] = 0;temp_collumn+= 2;}
<STRING_STATE>\\.|\\                                          {BEGIN STRING_ERROR;printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn + temp_collumn, yytext);temp_collumn+=yyleng;semicolon = NO_NEED;}
<STRING_STATE>.                                             {string_buff[string_pos++] = yytext[0]; string_buff[string_pos] = 0;temp_collumn+= yyleng;}


<STRING_ERROR>"\r\n"|"\n" {in_str = 0;BEGIN 0;  string_buff[string_pos] = 0; printf("Line %d, column %d: unterminated string literal\n", line, collumn);collumn_no_semicolon();line++;collumn = 1;}
<STRING_ERROR>\"          {in_str = 0;BEGIN 0; collumn += temp_collumn + yyleng;string_buff[string_pos++] = yytext[0];}
<STRING_ERROR>\\\"|\\"n"|\\"f"|\\"r"|\\"t"|\\\\|\\\"        {string_buff[string_pos++] = yytext[0];string_buff[string_pos++] = yytext[1]; string_buff[string_pos] = 0;temp_collumn+= yyleng;}
<STRING_ERROR>\\.|\\                                            {printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn + temp_collumn, yytext);temp_collumn+=yyleng;semicolon = NO_NEED;}
<STRING_ERROR>.                       {temp_collumn+= yyleng;}

"0"({octal_digit}*("8"|"9")+{octal_digit}*)+                                                {printf("Line %d, column %d: invalid octal constant (%s)\n", line, collumn, yytext);collumn+=yyleng;}
{letter}({letter}|{decimal_digit})*                                                         {if(tag)printf("ID(%s)\n", yytext);collumn+=yyleng; semicolon = NEED_S;}
({decimal_digit}+"."{decimal_digit}*{exponent}?)|{decimal_digit}+{exponent}|({decimal_digit}*"."{decimal_digit}+{exponent}?)                 {if(tag)printf("REALLIT(%s)\n", yytext);collumn+=yyleng; semicolon = NEED_S;}
{decimal_digit}*|("0"("x"|"X"){hex_digit}+)|("0"{octal_digit}+)                             {if(tag)printf("INTLIT(%s)\n", yytext);collumn+=yyleng; semicolon = NEED_S;}

"\n"|"\r\n"                                                                             {put_semicolon();line++;collumn = 1;}
"//"(.)*                                                                                  {put_semicolon();collumn_no_semicolon();}
" "|"\t"                                                                                         {collumn+=yyleng;}
\\("a"|"b"|"'"|"v")                                             {printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn, yytext);semicolon = NO_NEED;}
.                                                                                           {printf("Line %d, column %d: illegal character (%s)\n", line, collumn, yytext);collumn_no_semicolon();}

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
        }
    }
    else{
        yylex();
    }
    
    put_semicolon();
    if(in_comment == 1){
        printf("Line %d, column %d: unterminated comment\n", line, collumn);
    }
    if(in_str == 1){
        printf("Line %d, column %d: unterminated string literal\n", line, collumn);
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
if(tag == L_TAG){
    if(semicolon == 1){
        printf("SEMICOLON\n");
    }
}
else if(tag == T_TAG){
    return SEMICOLON;
}
semicolon = NO_NEED;
return 0;
}
