#define MAXIDLEN 33
typedef char string[MAXIDLEN];

typedef struct operator
{
	enum op{ PLUS, MINUS } operator;
}oprec;

enum expr { IDEXPR, LITERALEXPR, TEMPEXPR};

typedef struct expression
{
	enum expr kind;
	union{
		string name; 
		int val; 
	};
}exprrec;

typedef enum tokentypes{
	BEGIN,END,READ,WRITE,ID,INTLITERAL,
	LPAREN,RPAREN,SEMICOLON,COMMA,ASSIGNOP,
	PLUSOP,MINUSOP,SCANEOF
} token;

char tokenbuffer[200];
FILE *archivo;
token currenttoken=SCANEOF;
token next;
int flagnexttoken=0;

void clearbuffer(void){
	memset(tokenbuffer,'\0',strlen(tokenbuffer));
}

void bufferchar(int x){
	if (strlen(tokenbuffer)==0){
		char dato=(char)x;
		char auxiliar[]={(char)x,'\0'};
		strcat(tokenbuffer,auxiliar);
	}
	else{
	char dato=(char)x;
	 char auxiliar[]={dato,'\0'};
 	 strcat(tokenbuffer,auxiliar);
	}
} 

void lexicalerror(int x){
	printf("Caracter no encontrado %d\n",x);
}