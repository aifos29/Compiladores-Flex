#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>


char token_buffer[200];
FILE *archivo;
FILE *salida;


//Se definen los diferentes tipos a tratar
typedef enum tipos_palabras{
	//ANYWORD ES IGUAL A CUALQUIER VALOR.
	INCLUDE,DEFINE,FIN, ANYWORD 
} palabras;


//Variable para saber el temporal
int cont=0;

//Define el tamanno de los vectores nombre,valor
int total=3;


void clear_buffer(void){
	//Borra el buffer de token buffer.
	memset(token_buffer,'\0',strlen(token_buffer));
}

void buffer_char(int _val){
	//Convierte el entero a caracter y lo agrega al token_buffer
	if (strlen(token_buffer)==0){
		char dato=(char)_val;
		char auxiliar[]={(char)_val,'\0'};
		strcat(token_buffer,auxiliar);
	}
	else{
		char dato=(char)_val;
		char auxiliar[]={dato,'\0'};
		strcat(token_buffer,auxiliar);
	}
}

palabras reservado(){
	//Revise el token_buffer y si este es una palabra reservada retorna el token al que pertenece
	if (strcmp(token_buffer,"#define")==0){
		return DEFINE;
	}
	if (strcmp(token_buffer,"#include")==0){
		return INCLUDE;
	}
	else{
		return ANYWORD;
	}
}

palabras escaner(void){
	//Obtiene los tokens del texto
	int in_char,c;

	clear_buffer();
	if (feof(archivo))
		return FIN;

	while (feof(archivo)==0){
		//Leemos del archivo
		in_char=fgetc(archivo);

		//Si el token es espacio lo ignoro
		if (isspace(in_char))
			continue; /*do nothing */

		//Si el token es un digito,minuscula,mayuscula o de puntuacion se agregan al buffer_char para imprimirlos
		else if (isgraph(in_char)){
			buffer_char(in_char);
			for (c= fgetc(archivo);isalnum(c);c=fgetc(archivo)){
				buffer_char(c);
			}
			return reservado();
		}else if (isdigit(in_char)){
			buffer_char(in_char);
			for (c=fgetc(archivo);isdigit(c)||isspace(c);c=fgetc(archivo)){
			 	if (isspace(c)){
			 		return reservado();
			 	}
				else{
					buffer_char(c);
				}
			}
		}	
	}
}

void asignar_nombre(char * nombre){
	//Almacena el nombre de la variable definida por el #define
    escaner();
	strcpy(nombre,token_buffer);
}

void asignar_valor(char * valor){
	//Almacena el valor de la variable definida por el #define
	escaner();
	strcpy(valor,token_buffer);	
}


void cambiador(char **_nombre,char **_valor){
	//Se encarga de leer el archivo de nuevo y asignar los valores almacenados segun el #define 
	rewind(archivo);

	palabras palabras = escaner();
	int _estaDefinido=0;

	while (palabras!=FIN){
		switch(palabras){
			case DEFINE:
				escaner();
				escaner();
				break;
			case INCLUDE:
				printf("%s\n",token_buffer);
				break;

			//Si es cualquier palabra busca alguna coincidencia con los valores definidos para sustituir
			case ANYWORD:
				_estaDefinido = 0;
				int _indice;
				for (_indice=0;_indice<cont;_indice++){
					if (strcmp(token_buffer,_nombre[_indice])==0){
						printf("%s", _valor[_indice]);
						_estaDefinido = 1;
						break;
					}
				}
				//Si no esta definido solo imprimo
				if (_estaDefinido == 0){
					printf("%s",token_buffer);
					break;
				} 
		}
		palabras=escaner();
	}
}


void reconocedor(){
	//Se encarga de obtener los nombres y valores definidos por el #define
	cont =0;
	char guardar[33];
	char guardar2[33];
	char *nombre[total];
	char *valor[total];

	palabras palabras = escaner();


	while (palabras!=FIN){
	
		switch(palabras){
			case DEFINE:
				//No se pasa con el & debido a que la estructura ya es *guardar
				asignar_nombre(guardar);
				nombre[cont]=strdup(guardar);
				
				asignar_valor(guardar2);
				valor[cont]=strdup(guardar2);

				cont ++;
				break;
			case INCLUDE:
				break;
		
			default:
				break;
		}	
		palabras = escaner();
	}
	
	//Llamamos a cambiador para reescribir el texto por su respectivo valor	
	cambiador(nombre,valor);
}


int main(int argc, char const *argv[])
{
	archivo=fopen("prueba.txt","r+");

	reconocedor();
	
	return 0;
}









