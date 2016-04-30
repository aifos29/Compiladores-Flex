/* Scanner para obtener total de veces que aparece el define */

%{
/* lleva el total */
int _totalDefine=0;
char n_archivo[25];
char vector[5];
%}


%%
"#define" {
        _totalDefine ++;		
          }
 
. {
        printf(" ");
  }
%%


void contar(){
  /*Se encarga de contar el total de define que aparecen*/

	yylex();
  	int i;

  	printf("Total de #define en el archivo:%d \n",_totalDefine);
}


int main(int argc, char **argv )
{
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 ){
    	strcpy(n_archivo,argv[0]);
        yyin = fopen( argv[0], "r" );
    }
  contar();
}



