%{
#include <stdio.h>
#include "parser.h"
char mensaje[200];
%}
%option header-file="scanner.h"
%option outfile="scanner.c"
%option yylineno
%option noinput
%option nounput

letra [a-zA-Z]
digito [0-9]
invalido [[:punct:]]{-}[;,()+*/-]

%%
programa			return PROGRAMA;
leer				return LEER;
escribir			return ESCRIBIR;
variables			return VARIABLES;
codigo				return CODIGO;
fin				return FIN;
definir				return DEFINIR;
{digito}+			{yylval=strdup(yytext); return CONSTANTE;}
{letra}({letra}|{digito})*	{yylval=strdup(yytext); return IDENTIFICADOR;}
:=				return ASIGNACION;
"+"				return '+';
-				return '-';
"*"				return '*';
"/"				return '/';
;				return ';';
,				return ',';
"("				return '(';
")"				return ')';		
{digito}+{letra}({digito}|{letra})*		{sprintf(mensaje,"Error léxico: constante con sufijo inválido: %s",yytext); yyerror(mensaje); yylexerrs++;}
{letra}({letra}|{digito})*{invalido}({invalido}|{letra}|{digito})*	{sprintf(mensaje,"Error léxico: identificador invalido: %s", yytext); yyerror(mensaje); yylexerrs++;}
{invalido}+				{sprintf(mensaje,"Error léxico: cadena desconocida: %s", yytext); yyerror(mensaje); yylexerrs++;}
"//".*			;
[[:space:]]   			;

%%
