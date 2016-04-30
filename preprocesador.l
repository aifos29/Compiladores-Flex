/* scanner for a toy Pascal-like language */

%{
/* need this for the call to atof() below */
#include <math.h>
int define=0;
char n_archivo[25];
char vector[5];


%}

DIGIT    [0-9]
ID       [A-Z][a-z][a-z0-9]*

%%


"#define" {

		define ++;		
             }
 

  . {
  	printf(" ");

  }







%%

void contar(){
	 yylex();
	 
    printf("%d \n",define);
    for (int i=0;i<define;i++){
    	strcpy(vector[i],"hola");
    }

    for (int i=0;i<define;i++){
    	printf("%s\n",vector[i]);
    }

}

int main( argc, argv )
int argc;
char **argv;
    {
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 ){
    		strcpy(n_archivo,argv[0]);
            yyin = fopen( argv[0], "r" );
    }
           

   contar();


    }



