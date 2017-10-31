#include <stdio.h>
#include <string.h>
#include "semantic.h"
#include "symbol.h"

int contTemp = 1;
char bufferTemp[10];
char* resultado;

void inicio(){
	printf ("Load rtlib,\n");
}

void fin(){
	printf ("Stop,\n");
}

void leer(char *id){
	printf("Read %s,Integer\n",id);
}

void escribir(char *e){
	printf("Write %s,Integer\n",e);
}

char* invertir(char *s){
	resultado = strdup(nuevoTemp());
	printf("INV %s,,%s\n",s,resultado);
	return resultado;
}

char* generarInfijo(char *opIzq, char* op, char* opDer){
	resultado = strdup(nuevoTemp());
	printf("%s %s,%s,%s\n",op,opIzq,opDer,resultado);
	return resultado;
}

char* asignacion(char* origen, char* destino){
	printf("Store %s,%s\n",origen,destino);
	return destino;
}

char* nuevoTemp(void){
	sprintf(bufferTemp,"Temp#%d",contTemp);
	agregar (bufferTemp);
	contTemp++;
	return bufferTemp;
}
