#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>



char token_buffer[33];
FILE *archivo;
FILE *salida;
int in_char,c;


//Se definen los diferentes tipos a tratar
typedef enum tipos_palabras{
	//ANYWORD ES IGUAL A CUALQUIER VALOR.
	INCLUDE,DEFINE,FIN, ANYWORD, PUNTUACTION
} palabras;


//Variable para saber el temporal
int cont=0;

//Define el tamanno de los vectores nombre,valor
int _totalDefine =0;
int _totalIncludeUsuario=0;
int _totalInclude=0;
//Variable de control
int estado=0;

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
		else if (in_char==35){
			buffer_char(in_char);
			c=fgetc(archivo);
			while (c==32){
				c=fgetc(archivo);
			}
			buffer_char(c);
			for (c=fgetc(archivo);isalnum(c)||isspace(c)||isgraph(c);c=fgetc(archivo)){

					if (isspace(c)){
						return reservado();
					}
					
					buffer_char(c);
			}

		}
		else if (isgraph(in_char)){
			
			if (in_char >= 33 && in_char <=47 || in_char >= 58 && in_char <=64 || in_char >= 91 && in_char <=96 || in_char >= 123 && in_char <=126 ){
				c = in_char;
				return PUNTUACTION;
			}
			else{
				buffer_char(in_char);
			}

			for (c= fgetc(archivo);isalnum(c)||isspace(c)||isgraph(c);c=fgetc(archivo)){
				if (isspace(c)){
					return reservado();
				}

				if (c >= 33 && c <=47 || c >= 58 && c <=64 || c >= 91 && c <=96 || c >= 123 && c <=126 ){
				   //buffer_char(c);
				   return PUNTUACTION;
			}
				buffer_char(c);

				}
				return reservado();
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

void adjuntar(char * valor){

	char aux[33];
	strcpy(aux,token_buffer);

	
	strcat(valor,aux);
	strcat(valor,"\0");

}


void cambiador(char **_nombre,char **_valor){
	//Se encarga de leer el archivo de nuevo y asignar los valores almacenados segun el #define

	rewind(archivo);
	int not_define=0;
	palabras palabras = escaner();
	int _estaDefinido=0;

	while (palabras!=FIN){
		switch(palabras){
			case DEFINE:
				not_define=1;
				escaner();
				escaner();
				break;
			case INCLUDE:
				printf("%s ",token_buffer);
				break;

			//Si es cualquier palabra busca alguna coincidencia con los valores definidos para sustituir
			case ANYWORD:
				not_define=0;
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
				break;
			case PUNTUACTION:
				not_define=0;
				if (strlen(token_buffer)==0){
					buffer_char(c);
					printf("%s",token_buffer);
					break;
				}
				else{
					_estaDefinido = 0;
				int _indice;
				for (_indice=0;_indice<cont;_indice++){
					if (strcmp(token_buffer,_nombre[_indice])==0){
						printf("%s", _valor[_indice]);
						_estaDefinido = 1;
						
					}
				}
				//Si no esta definido solo imprimo
				if (_estaDefinido == 0){
					printf("%s",token_buffer);
					
				}
					clear_buffer();
					buffer_char(c);
					printf("%s", token_buffer);
					break;

				}

		}
			if (not_define==0){
				if (c==10){
					printf("\n");
				}
				if (c==32){
					printf(" ");
				}}

		palabras=escaner();
	}
}

int copiar(char **_usuario,char **_locales){
	int continuar=0;
	char buffer[2048];               /* El buffer para guardar lo que leo */ 
	int cantidad;
	FILE * nuevo =fopen("primer.txt","wb");
	int u=0;
	for (int i=0;i<_totalInclude;i++){
		//fprintf(nuevo, "#include<%s>\n",_locales[i]);
	}
	while (continuar==0){
		FILE * actual = fopen(_locales[u],"rb");
  	    while (! feof(actual) )
    	{
      /* Leo datos: cada uno de 1 byte, todos los que me caben */
     	 cantidad = fread( buffer, 1, sizeof(buffer),actual);
      /* Escribo tantos como haya leído */
     	 fwrite(buffer, 1, cantidad, nuevo);
    	}
 
 	 	fclose(actual);
 	 	u++;
 	 	if (u==_totalIncludeUsuario){
 	 		continuar=1;
 	 	}
	}
	fclose(nuevo);
	
	_totalIncludeUsuario=0;

}


void reconocedor(){
	//Se encarga de obtener los nombres y valores definidos por el #define
	rewind(archivo);
	char guardar[33];
	char guardar2[33];
	char fichero[33];
	char guardar_include[33];
	char *nombre[_totalDefine];
	char *valor[_totalDefine];
	char *locales[_totalInclude];
	char *externos[_totalIncludeUsuario];
	int contdefine=0;
	int continclude1=0;
	int continclude2=0;
//	char *archivo_include[include];

	palabras palabras = escaner();


	while (palabras!=FIN){

		switch(palabras){
			case DEFINE:
				//No se pasa con el & debido a que la estructura ya es *guardar
				asignar_nombre(guardar);
				nombre[contdefine]=strdup(guardar);

				asignar_valor(guardar2);
				valor[contdefine]=strdup(guardar2);

				contdefine ++;

				break;
			case INCLUDE:
				memset(fichero, '\0', sizeof(fichero));
				palabras = escaner();
				int continuar =0;
				if (c==34){
					
					palabras=escaner();
					while (continuar==0){


						adjuntar(fichero);
						if (c==46){
							clear_buffer();
							buffer_char(c);
							adjuntar(fichero);
						}
						palabras=escaner();
						if (c==34){
							adjuntar(fichero);
							continuar=1;
						}
						
						
					}
					
					locales[continclude1]=strdup(fichero);
					printf("Locales %s\n",locales[continclude1] );
					continclude1++;

				
				}
				if (c==60){
					while (continuar==0){
						adjuntar(fichero);
						if (c==46){
							clear_buffer();
							buffer_char(c);
							adjuntar(fichero);
						}
						palabras=escaner();
						if (c==62){
							adjuntar(fichero);
							continuar=1;
						}

						
					}
					externos[continclude2]=strdup(fichero);
					printf("Externos %s\n",externos[continclude2] );
					continclude2 ++;
				}



				break;

			default:
				break;
		}
		palabras = escaner();
	}

	
	copiar(externos,locales);
	//cambiador(nombre,valor);

}

void contador (){
	palabras palabras = escaner();
	while (palabras!=FIN){
		switch(palabras){
		case DEFINE:
			_totalDefine ++;
			break;
		case INCLUDE:
			palabras=escaner();
			if (palabras==PUNTUACTION){
				if (c==60){
					_totalInclude ++;
				}
				if (c==34){
					_totalIncludeUsuario ++;
				}
			}
			break;
		}
		palabras=escaner();

	}   }






int main(int argc, char const *argv[])
{
	archivo=fopen("prueba.txt","r+");
	contador();
	reconocedor();
	int conta=1;
	/*while (_totalIncludeUsuario>0){
		printf("Corrida%d\n",conta);
		reconocedor();
	
		contador();
		conta ++;

	}*/
	
	
	//reconocedor();

	return 0;
}









