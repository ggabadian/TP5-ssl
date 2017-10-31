%code top{
#include <stdio.h>
#include "scanner.h"
#include "semantic.h"
#include "symbol.h"
}
%code provides{
void yyerror(const char *);
extern int yylexerrs;
extern int yyerrs;
extern int nerrssem;
}
%defines "parser.h"
%output "parser.c"
%token IDENTIFICADOR CONSTANTE PROGRAMA LEER ESCRIBIR DEFINIR FIN VARIABLES CODIGO ASIGNACION
%left '+' '-'
%left '*' '/'
%precedence NEG 
%define api.value.type {char *}
%define parse.error verbose
%%
todo			: {inicio();} PROGRAMA VARIABLES listaVariables CODIGO bloqueCodigo FIN {fin();} {if (yynerrs || yylexerrs || nerrsem) YYABORT;}
			;
listaVariables 		: listaVariables definicionID
			| definicionID
			| error ';'
			;
definicionID		: DEFINIR IDENTIFICADOR ';'  {agregarAlDiccionario($2);}
			;
bloqueCodigo		: bloqueCodigo sentencia ';'
			| sentencia ';'
			;
sentencia		: LEER '(' listaIdentificadores ')'
			| ESCRIBIR '(' listaExpresiones ')'
			| IDENTIFICADOR ASIGNACION expresion {asignacion($3,$1);}
			| error
			;
listaIdentificadores	: listaIdentificadores ',' IDENTIFICADOR {leer($3);}
			| IDENTIFICADOR {leer($1);}
			;
listaExpresiones	: expresion ',' listaExpresiones {escribir($1);}
			| expresion {escribir($1);}
			;
expresion		: expresion '+' expresion {$$=strdup(generarInfijo($1,"ADD",$3));}
			| expresion '-' expresion {$$=strdup(generarInfijo($1,"SUBS",$3));}
			| expresion '*' expresion {$$=strdup(generarInfijo($1,"MULT",$3));}
			| expresion '/' expresion {$$=strdup(generarInfijo($1,"DIV",$3));}
			| '-' expresion %prec NEG {$$=strdup(invertir($2));}
			| IDENTIFICADOR {verificarID($1);}
			| CONSTANTE
			| '(' expresion ')' {$$=strdup($2);}
			;
%%
