%X COMMENT_BLOCK STRING STRING_ERROR
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
    #define L_TAG 1;
    #define NO_TAG 0;
    #define NO_NEED 0;
    #define NEED_S 1;
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
    char string_buff[10000];
%}
%%

{RESERVED}                                              {if(tag)printf("RESERVED(%s)\n", yytext);collumn+=yyleng;semicolon = NO_NEED;}
";"                                                     {if(tag)printf("SEMICOLON\n");collumn+=yyleng;semicolon = NO_NEED;}
","                                                     {if(tag)printf("COMMA\n");collumn+=yyleng;semicolon = NO_NEED;}
"_"                                                     {if(tag)printf("BLANKID\n");collumn+=yyleng;semicolon = NO_NEED;}
"*"                                                     {if(tag)printf("STAR\n");collumn+=yyleng;semicolon = NO_NEED;}
"/"                                                     {if(tag)printf("DIV\n");collumn+=yyleng;semicolon = NO_NEED;}
"-"                                                     {if(tag)printf("MINUS\n");collumn+=yyleng;semicolon = NO_NEED;}
"+"                                                     {if(tag)printf("PLUS\n");collumn+=yyleng;semicolon = NO_NEED;}
"=="                                                    {if(tag)printf("EQ\n");collumn+=yyleng;semicolon = NO_NEED;}
">="                                                    {if(tag)printf("GE\n");collumn+=yyleng;semicolon = NO_NEED;}
"{"                                                     {if(tag)printf("LBRACE\n");collumn+=yyleng;semicolon = NO_NEED;}
"<="                                                    {if(tag)printf("LE\n");collumn+=yyleng;semicolon = NO_NEED;}
"("                                                     {if(tag)printf("LPAR\n");collumn+=yyleng;semicolon = NO_NEED;}
"["                                                     {if(tag)printf("LSQ\n");collumn+=yyleng;semicolon = NO_NEED;}
"%"                                                     {if(tag)printf("MOD\n");collumn+=yyleng;semicolon = NO_NEED;}
"!="                                                    {if(tag)printf("NE\n");collumn+=yyleng;semicolon = NO_NEED;}
"!"                                                     {if(tag)printf("NOT\n");collumn+=yyleng;semicolon = NO_NEED;}
"&&"                                                    {if(tag)printf("AND\n");collumn+=yyleng;semicolon = NO_NEED;}
"||"                                                    {if(tag)printf("OR\n");collumn+=yyleng;semicolon = NO_NEED;}
"}"                                                     {if(tag)printf("RBRACE\n");collumn+=yyleng; semicolon = NEED_S;}
")"                                                     {if(tag)printf("RPAR\n");collumn+=yyleng; semicolon = NEED_S;}
"]"                                                     {if(tag)printf("RSQ\n");collumn+=yyleng; semicolon = NEED_S;}
"package"                                               {if(tag)printf("PACKAGE\n");collumn+=yyleng;semicolon = NO_NEED;}
"return"                                                {if(tag)printf("RETURN\n");collumn+=yyleng; semicolon = NEED_S;}
"else"                                                  {if(tag)printf("ELSE\n");collumn+=yyleng;semicolon = NO_NEED;}
"for"                                                   {if(tag)printf("FOR\n");collumn+=yyleng;semicolon = NO_NEED;}
"if"                                                    {if(tag)printf("IF\n");collumn+=yyleng;semicolon = NO_NEED;}
"var"                                                   {if(tag)printf("VAR\n");collumn+=yyleng;semicolon = NO_NEED;}
"int"                                                   {if(tag)printf("INT\n");collumn+=yyleng;semicolon = NO_NEED;}
"float32"                                               {if(tag)printf("FLOAT32\n");collumn+=yyleng;semicolon = NO_NEED;}
"bool"                                                  {if(tag)printf("BOOL\n");collumn+=yyleng;semicolon = NO_NEED;}
"string"                                                {if(tag)printf("STRING\n");collumn+=yyleng;semicolon = NO_NEED;}
"fmt.Println"                                           {if(tag)printf("PRINT\n");collumn+=yyleng;semicolon = NO_NEED;}
"strconv.Atoi"                                          {if(tag)printf("PARSEINT\n");collumn+=yyleng;semicolon = NO_NEED;}
"func"                                                  {if(tag)printf("FUNC\n");collumn+=yyleng;semicolon = NO_NEED;}
"os.Args"                                               {if(tag)printf("CMDARGS\n");collumn+=yyleng;collumn+=yyleng;semicolon = NO_NEED;}
"="                                                     {if(tag)printf("ASSIGN\n");collumn+=yyleng;semicolon = NO_NEED;}
">"                                                     {if(tag)printf("GT\n");collumn+=yyleng;semicolon = NO_NEED;}
"<"                                                     {if(tag)printf("LT\n");collumn+=yyleng;semicolon = NO_NEED;}

"/*"                     {BEGIN COMMENT_BLOCK;temp_collumn=0 + yyleng;in_comment = NEED_S;temp_line = 0;}
<COMMENT_BLOCK>"*/"      {BEGIN 0;line += temp_line;collumn += temp_collumn + yyleng;in_comment =NO_NEED;}
<COMMENT_BLOCK>"\r\n"|"\n"        {put_semicolon();temp_line++;temp_collumn = 1;temp_collumn += yyleng;}
<COMMENT_BLOCK>.        {temp_collumn+=yyleng;}


\"                                                    {in_str = 1;string_pos = 0;BEGIN STRING;string_buff[string_pos++] = '"';string_buff[string_pos] = '\0';temp_collumn=0 + yyleng;}
<STRING>\"                                            {in_str = 0;BEGIN 0; collumn += temp_collumn + yyleng;string_buff[string_pos++] = yytext[0];string_buff[string_pos] = 0;if(tag)printf("STRLIT(%s)\n", string_buff);semicolon = NEED_S;}
<STRING>"\r\n"|"\n"|"\r"                                   {in_str = 0;BEGIN 0; string_buff[string_pos] = 0; printf("Line %d, column %d: unterminated string literal\n", line, collumn);collumn+=yyleng;semicolon = NO_NEED;line++;collumn = 1;}
<STRING>\\\"|\\"n"|\\"f"|\\"r"|\\"t"|\\\\|\\\"        {string_buff[string_pos++] = yytext[0];string_buff[string_pos++] = yytext[1]; string_buff[string_pos] = 0;temp_collumn+= 2;}
<STRING>\\.|\\                                          {BEGIN STRING_ERROR;printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn + temp_collumn, yytext);temp_collumn+=yyleng;semicolon = NO_NEED;}
<STRING>.                                             {string_buff[string_pos++] = yytext[0]; string_buff[string_pos] = 0;temp_collumn+= yyleng;}


<STRING_ERROR>"\r\n"|"\n" {in_str = 0;BEGIN 0;  string_buff[string_pos] = 0; printf("Line %d, column %d: unterminated string literal\n", line, collumn);collumn+=yyleng;semicolon = NO_NEED;line++;collumn = 1;}
<STRING_ERROR>\"          {in_str = 0;BEGIN 0; collumn += temp_collumn + yyleng;string_buff[string_pos++] = yytext[0];}
<STRING_ERROR>\\\"|\\"n"|\\"f"|\\"r"|\\"t"|\\\\|\\\"        {string_buff[string_pos++] = yytext[0];string_buff[string_pos++] = yytext[1]; string_buff[string_pos] = 0;temp_collumn+= yyleng;}
<STRING_ERROR>\\.|\\                                            {printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn + temp_collumn, yytext);temp_collumn+=yyleng;semicolon = NO_NEED;}
<STRING_ERROR>.                       {temp_collumn+= yyleng;}

"0"({octal_digit}*("8"|"9")+{octal_digit}*)+                                                {printf("Line %d, column %d: invalid octal constant (%s)\n", line, collumn, yytext);collumn+=yyleng;}
{letter}({letter}|{decimal_digit})*                                                         {if(tag)printf("ID(%s)\n", yytext);collumn+=yyleng; semicolon = NEED_S;}
({decimal_digit}+"."{decimal_digit}*{exponent}?)|{decimal_digit}+{exponent}|({decimal_digit}*"."{decimal_digit}+{exponent}?)                 {if(tag)printf("REALLIT(%s)\n", yytext);collumn+=yyleng; semicolon = NEED_S;}
{decimal_digit}*|("0"("x"|"X"){hex_digit}+)|("0"{octal_digit}+)                             {if(tag)printf("INTLIT(%s)\n", yytext);collumn+=yyleng; semicolon = NEED_S;}

"\n"|"\r\n"                                                                             {put_semicolon();line++;collumn = 1;}
"//"(.)*                                                                                  {put_semicolon();collumn+=yyleng;semicolon = NO_NEED;}
" "|"\t"                                                                                         {collumn+=yyleng;}
\\("a"|"b"|"'"|"v")                                             {printf("Line %d, column %d: invalid escape sequence (%s)\n", line, collumn, yytext);semicolon = NO_NEED;}
.                                                                                           {printf("Line %d, column %d: illegal character (%s)\n", line, collumn, yytext);collumn+=yyleng;semicolon = NO_NEED;}



%%

int main(int argc, char **argv)
{
    string_buff[0] = 0;
    if(argc == 2)
        if(argv[1][0] == '-' && argv[1][1] == 'l')
          tag = L_TAG;
    yylex();
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


int put_semicolon()
{
    if(tag){
        if(semicolon == 1){
            printf("SEMICOLON\n");
        }
    }

semicolon = NO_NEED;
return 0;
}
