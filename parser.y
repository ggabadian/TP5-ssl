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
			| ESCRIBIR '(' listaExpresiones ')' {printf("Escribir\n");}
			| IDENTIFICADOR ASIGNACION expresion {printf("Asignacion\n");}
			| error
			;
listaIdentificadores	: listaIdentificadores ',' IDENTIFICADOR
			| IDENTIFICADOR {leer($1);}
			;
listaExpresiones	: expresion ',' listaExpresiones
			| expresion 
			;
expresion		: expresion '+' expresion {printf("Suma\n");}
			| expresion '-' expresion {printf("Resta\n");}
			| expresion '*' expresion {printf("Multiplicacion\n");}
			| expresion '/' expresion {printf("Division\n");}
			| '-' expresion %prec NEG {$$=strdup(invertir($2));}
			| IDENTIFICADOR {verificarID($1);}
			| CONSTANTE
			| '(' expresion ')' {printf("Paréntesis\n");}
			;
%%
