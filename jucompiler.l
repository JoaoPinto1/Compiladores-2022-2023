%{//Trabalho realizado por: Andre Filipe de Oliveira Moreira n. 2020239416 Joao Pedro Ventura Pinto n. 2020220907
%}

number [0-9]
not_zero [1-9]
letter [a-zA-Z_$]
invalid_escape [^\n\rtnfr\\\"]
valid_escape [tnfr\\\"]

%X COMMENT1 STR ERROR


%{
#include "struct.h"
#include "y.tab.h"
#include "tree.h"
#include <string.h>
#include "semantics.h"   
int option = 0;
int yacc_option = 0;   
extern int line; 
int line_start = 1; 
extern int yacc_print;
extern int coluna;
int coluna_start = 1;
char STR1[32654];
int i = 0;
extern tnode* arvore;
extern table* tabela;
extern int second_phase;
int error = 0;
new_struct* aux;
%}


%%

"\n"|"\r\n"|"\r"    {line++;coluna = 1;}
"/*"                {BEGIN (COMMENT1);line_start = line;coluna_start=coluna;coluna+=yyleng;}
"//"[^\r\n]*        {coluna += yyleng;}
\"                  {STR1[i] = '\"';i++;coluna_start = coluna;coluna+=yyleng;line_start = line;BEGIN (STR);}
[\t\f ]+            {coluna+=yyleng;}


({number}+("_"*{number}+)*"."({number}+("_"*{number}+)*)*|"."{number}+("_"*{number}+)*)(("e"|"E")("+"|"-")?({number}+("_"*{number}+)*))?   {if(option) printf("REALLIT(%s)\n",yytext);aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;yylval.n->str1=(char*)strdup(yytext); if(yacc_option) return REALLIT;}
{number}+("_"*{number}+)*(("e"|"E")("+"|"-")?({number}+("_"*{number}+)*))   {if(option) printf("REALLIT(%s)\n",yytext);aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;yylval.n->str1=(char*)strdup(yytext);if(yacc_option) return REALLIT;}


"true"                      {if(option) printf("BOOLLIT(%s)\n",yytext);aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;yylval.n->str1=(char*)strdup(yytext);coluna+=yyleng; if(yacc_option) return BOOLLIT;}
"false"                     {if(option) printf("BOOLLIT(%s)\n",yytext);aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;yylval.n->str1=(char*)strdup(yytext);coluna+=yyleng; if(yacc_option) return BOOLLIT;}
"&&"                        {if(option) printf("AND\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;yylval.n->str1=(char*)strdup(yytext);coluna+=yyleng;if(yacc_option)return AND;}


"="                         {if(option) printf("ASSIGN\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return ASSIGN;}
"*"                         {if(option) printf("STAR\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return STAR;}
","                         {if(option) printf("COMMA\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return COMMA;}
"/"                         {if(option) printf("DIV\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return DIV;}
"=="                        {if(option) printf("EQ\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return EQ;}
">="                        {if(option) printf("GE\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return GE;}
">"                         {if(option) printf("GT\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return GT;}
"{"                         {if(option) printf("LBRACE\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return LBRACE;}
"<="                        {if(option) printf("LE\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return LE;}
"<"                         {if(option) printf("LT\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return LT;}
"("                         {if(option) printf("LPAR\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return LPAR;}
"["                         {if(option) printf("LSQ\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return LSQ;}
"-"                         {if(option) printf("MINUS\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return MINUS;}
"%"                         {if(option) printf("MOD\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return MOD;}
"!="                        {if(option) printf("NE\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return NE;}
"!"                         {if(option) printf("NOT\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return NOT;}
"||"                        {if(option) printf("OR\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return OR;}
"+"                         {if(option) printf("PLUS\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return PLUS;}
"}"                         {if(option) printf("RBRACE\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return RBRACE;}
")"                         {if(option) printf("RPAR\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return RPAR;}
"]"                         {if(option) printf("RSQ\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return RSQ;}
";"                         {if(option) printf("SEMICOLON\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return SEMICOLON;}
"->"                        {if(option) printf("ARROW\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return ARROW;}
"<<"                        {if(option) printf("LSHIFT\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return LSHIFT;}
">>"                        {if(option) printf("RSHIFT\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return RSHIFT;}
"^"                         {if(option) printf("XOR\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return XOR;} 

"int"                       {if(option) printf("INT\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return INT;}
"boolean"                   {if(option) printf("BOOL\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return BOOL;}
"class"                     {if(option) printf("CLASS\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return CLASS;}
".length"                   {if(option) printf("DOTLENGTH\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return DOTLENGTH;}
"double"                    {if(option) printf("DOUBLE\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return DOUBLE;}
"else"                      {if(option) printf("ELSE\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return ELSE;}
"if"                        {if(option) printf("IF\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return IF;}
"System.out.print"          {if(option) printf("PRINT\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return PRINT;}
"Integer.parseInt"          {if(option) printf("PARSEINT\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return PARSEINT;}
"public"                    {if(option) printf("PUBLIC\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return PUBLIC;}
"return"                    {if(option) printf("RETURN\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return RETURN;}
"static"                    {if(option) printf("STATIC\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return STATIC;}
"String"                    {if(option) printf("STRING\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return STRING;}
"void"                      {if(option) printf("VOID\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line; coluna+=yyleng;if(yacc_option) return VOID;}
"while"                     {if(option) printf("WHILE\n");aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;if(yacc_option) return WHILE;}


"++"|"--"|"null"|"Integer"|"System"|"abstract"|"continue"|"for"|"new"|"switch"|"assert"|"default"|"package"|"synchronized"|"do"|"goto"|"private"|"this"|"break"|"implements"|"protected"|"throw"|"byte"|"import"|"throws"|"case"|"enum"|"instanceof"|"transient"|"catch"|"extends"|"short"|"try"|"char"|"final"|"interface"|"finally"|"long"|"strictfp"|"volatile"|"const"|"float"|"native"|"super"|"System"|"Integer"|"null" {if(option) printf("RESERVED(%s)\n" , yytext);coluna+=yyleng;if(yacc_option) return RESERVED;}
{letter}+({number}|{letter})*                             {if(option) printf("ID(%s)\n",yytext);aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;yylval.n->str1=(char*)strdup(yytext);if(yacc_option) return ID;}
{number}|"_"*{not_zero}({number}*"_"*{number}*)*{number}  {if(option) printf("INTLIT(%s)\n" , yytext);aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;yylval.n->str1=(char*)strdup(yytext);if(yacc_option) return INTLIT;}

<STR><<EOF>>                            {printf("Line %d, col %d: unterminated string literal\n" , line_start,coluna_start);BEGIN 0;}
<STR>\\{valid_escape}                   {STR1[i] = '\\';i++;STR1[i] = yytext[1];i++ ;coluna += yyleng;}
<STR>\"                                 {if(option) printf("STRLIT(%s\")\n",STR1);i = 0;aux = malloc(sizeof(new_struct));yylval.n=aux;yylval.n->coluna = coluna;yylval.n->linha = line;coluna+=yyleng;strcat(STR1,"\""); ;yytext = strdup(STR1);yyleng = strlen(STR1); yylval.n->str1 = strdup(STR1); memset(STR1,0,strlen(STR1));BEGIN 0;if(yacc_option) return STRLIT;}
<STR>"\n"|"\r\n"|"\r"                   {printf("Line %d, col %d: unterminated string literal\n" , line_start,coluna_start);coluna = 1 ;memset(STR1,0,strlen(STR1));i = 0; line++;BEGIN 0;}
<STR>\\{invalid_escape}?                {printf("Line %d, col %d: invalid escape sequence (%s)\n",line , coluna  ,yytext);coluna += yyleng;BEGIN ERROR;}
<STR>.                                  {STR1[i] = yytext[0];i++;coluna+=yyleng;}


<ERROR><<EOF>>                          {printf("Line %d, col %d: unterminated string literal\n" , line_start,coluna_start);memset(STR1,0,strlen(STR1));i = 0;coluna+=yyleng;BEGIN 0;}
<ERROR>\"                               {memset(STR1,0,strlen(STR1));i = 0;coluna+=yyleng;BEGIN 0;}
<ERROR>\\{valid_escape}                 {coluna += yyleng;}
<ERROR>"\n"|"\r\n"|"\r"                 {printf("Line %d, col %d: unterminated string literal\n" , line_start,coluna_start);coluna = 1; line++;memset(STR1,0,strlen(STR1));i = 0;BEGIN 0;}
<ERROR>\\{invalid_escape}?              {printf("Line %d, col %d: invalid escape sequence (%s)\n",line , coluna  ,yytext);coluna += yyleng;}
<ERROR>.                                {coluna += yyleng;}


<COMMENT1>"\n"|"\r\n"|"\r"               {coluna = 1;line++;}
<COMMENT1><<EOF>>                        {BEGIN 0;printf("Line %d, col %d: unterminated comment\n" , line_start,coluna_start);}
<COMMENT1>"*/"                           {BEGIN 0;coluna+=yyleng;}
<COMMENT1>.                              {coluna+=yyleng;}

<<EOF>>             {coluna += yyleng;return 0;}
.                   {printf("Line %d, col %d: illegal character (%s)\n" , line , coluna , yytext);coluna+=yyleng;}

%%
int main(int argc, char *argv[])
{   
    if(argc == 2){
        if(!(strcmp(argv[1] , "-l"))){
            option = 1;
            yylex();
        }
        if(!(strcmp(argv[1] , "-t"))){
            yacc_print = 1;
            yacc_option = 1;
            yyparse();
            if(!error){
                printTree(arvore,0);
            }
        }
        if(!(strcmp(argv[1] , "-e2"))){
            yacc_option=1;
            yyparse();
        }
        if(!(strcmp(argv[1] , "-e1"))){
            yylex();
        }
        if(!(strcmp(argv[1], "-s"))){
            yacc_print = 1;
            yacc_option = 1;
            yyparse();
            check_program(arvore);
            show_table(tabela);
            printTree(arvore,0);

            
        }
    }
    else{
        yacc_print = 1;
        yacc_option = 1;
        yyparse();
        check_program(arvore);
    }
    return 0;
}

int yywrap()
{

return 1;

}
