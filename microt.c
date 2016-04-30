#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>


char token_buffer[200];
FILE *archivo;
FILE *salida;

#define MAXIDLEN 33
typedef char string[MAXIDLEN];

extern void enter(string s);

typedef enum tipos_palabras{
	INCLUDE,DEFINE,FIN,X //X ES IGUAL A CUALQUIER VALOR.
} palabras;

//Variable para saber el temporal
int cont=0;

int total=3;


void clear_buffer(void){
	//Borra el buffer de token buffer.
	memset(token_buffer,'\0',strlen(token_buffer));
}

void buffer_char(int x){
	//Convierte el entero a caracter y lo agrega al token_buffer
	if (strlen(token_buffer)==0){
		char dato=(char)x;
		char auxiliar[]={(char)x,'\0'};
		strcat(token_buffer,auxiliar);
	}
	else{
	char dato=(char)x;
	 char auxiliar[]={dato,'\0'};
 	 strcat(token_buffer,auxiliar);
	}
	
}

palabras reservado(){
	//Revise el token_buffer y si este es una palabra reservada retorna el token al que pertenece

	if (strcmp(token_buffer,"#define")==0){
		return DEFINE;}
	if (strcmp(token_buffer,"#include")==0){
		return INCLUDE;}

	else{
	 return X;
  }
}



palabras escaner(void)
{
	
	int in_char,c;

	clear_buffer();
	if (feof(archivo))
		return FIN;

	while (feof(archivo)==0){
		in_char=fgetc(archivo);
		if (isspace(in_char))
			continue; /*do nothing */
		else if (isalpha(in_char)||isgraph(in_char)){

			buffer_char(in_char);
			for (c= fgetc(archivo);isalnum(c)||c=='='||c=='#';c=fgetc(archivo))
			{	
					buffer_char(c);}
					return reservado();
			

		}else if (isdigit(in_char)){
			buffer_char(in_char);
			for (c=fgetc(archivo);isdigit(c)||isspace(c);c=fgetc(archivo))
			 	if (isspace(c)){

			 		return reservado();

			}
				else{

					buffer_char(c);
				}
}
		
}
	
}


void asignar_nombre(char * nombre){
    
    escaner();
	strcpy(nombre,token_buffer);
}
void asignar_valor(char * valor){
	escaner();
	strcpy(valor,token_buffer);

	
}


void cambiador(char ** y,char **x){
	rewind(archivo);
	palabras palabras = escaner();
	int si=0;
	while (palabras!=FIN){
		switch(palabras){
			case DEFINE:
				escaner();
				escaner();
				break;
			case INCLUDE:
				printf("%s\n",token_buffer);
				break;

			case X:
				si=0;
				for (int i=0;i<cont;i++){
					if (strcmp(token_buffer,y[i])==0){
						printf("%s", x[i]);
						si=1;
						break;
					}
				}
			
				if (si==0){
					printf("%s",token_buffer);
					break;
				} 


		}
		palabras=escaner();


	}

}


void reconocedor(){
	cont =0;
	char guardar[33];
	char guardar2[33];
	char *nombre[total];
	char *valor[total];

	palabras palabras = escaner();


	while (palabras!=FIN){
	
		switch(palabras){
			case DEFINE:

				asignar_nombre(&guardar);
				nombre[cont]=strdup(guardar);
				//free(guardar);
				asignar_valor(&guardar2);

				valor[cont]=strdup(guardar2);
				cont ++;

				
				
				break;
			case INCLUDE:

				
				break;
		
			default:
				break;

		}


		
		palabras=escaner();


	}
		
		cambiador(nombre,valor);
		

}





int main(int argc, char const *argv[])
{
	archivo=fopen("prueba.txt","r+");

	
	reconocedor();


	
	
	
	return 0;
}









