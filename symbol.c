#include <stdio.h>
#include <string.h>
#include "parser.h"
#include "symbol.h"

char* diccionario[200];

int cont = 0;

char buffer[100];

void agregarAlDiccionario(char* id){
	if(!(estaDeclarada(id))){
		agregar(id);
	}
	else {
		sprintf(buffer,"Error semantico: identificador %s ya declarado",id);
		yyerror(buffer);
		nerrsem++;
	}
}

int estaDeclarada(char *id){
	int i;
	for (i=0;i<cont;i++){
		if(!strcmp(diccionario[i],id))
			return 1;
	}
	return 0;
}

void agregar (char* id){
	if (cont<200){
		diccionario[cont]=strdup(id);
		cont++;
		printf("Declare %s,Integer\n",id);
	}
	else {
	printf("Espacio insuficiente en el diccionario");
	}
}

void verificarID(char *id){
	if(!estaDeclarada(id)){
		sprintf(buffer,"Error semántico: identificador %s NO declarado",id);
		yyerror(buffer);
		nerrsem++;
	}
}
