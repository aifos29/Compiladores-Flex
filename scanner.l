%{
enum yytokentype {
	CONSTANT =1,
	KEYWORD =2,
	OPERATION=3,
	IDENTIFICATOR=4,
	STRING = 5,
	SYMBOL =6,
	SALTO = 7,
	BLANCO=8,
	EOL = 9

};
int yylval;



%}
%%


"+"|"-"|"*"|"/" { return OPERATION;}

"auto" {return KEYWORD;}
"break" {return KEYWORD;}
"case" {return KEYWORD;}
"char" {return KEYWORD;}
"const" {return KEYWORD;}
"continue" {return KEYWORD;}
"default" {return KEYWORD;}
"do"  {return KEYWORD;}
"double" {return KEYWORD;}
"enum" {return KEYWORD;}
"else" {return KEYWORD;}
"extern" {return KEYWORD;}
"float" {return KEYWORD;}
"for"  {return KEYWORD;}
"goto" {return KEYWORD;}
"if"  {return KEYWORD;}
"int"  {return KEYWORD;}
"long" {return KEYWORD;}
"register" {return KEYWORD;}
"return" {return KEYWORD;}
"short" {return KEYWORD;}
"signed" {return KEYWORD;}
"sizeof" {return KEYWORD;}
"static" {return KEYWORD;}
"struct"  {return KEYWORD;}
"switch" {return KEYWORD;}
"typedef" {return KEYWORD;}
"union" {return KEYWORD;}
"unsigned" {return KEYWORD;}
"void" {return KEYWORD;}
"volatile" {return KEYWORD;}
"while"    {return KEYWORD;}


"(" | ")" |"[" |"]"|";"|"<"|">"|"="|"=="|"<="|">="|"!=" {return SYMBOL;}


[0-9]+ { yylval = atoi(yytext);return CONSTANT; }

"_"*[A-z]+"_"*[0-9]* {return IDENTIFICATOR;}





\n { return SALTO; }
[ \t] { return BLANCO; }

<<EOF>> { return EOL;}

%%

void latex(char * ide){
	printf ("Esto es  %s Valor = %s ",ide,yytext);


}

void main(int argc, char **argv)
{
	int tok;
	yyin = fopen ("prueba.txt","r+");
	tok =yylex();
	while(tok!=EOL){
		switch (tok){
			
			case 1:
				latex("CONSTANT");
				break;
			case 2:
				printf("KEYWORD %s",yytext);
				break;
			case 3:
				latex("OPERATION");
			case SALTO:
				printf("\n");
				break;
			case IDENTIFICATOR:
				latex("IDENTIFICATOR");
				break;
			case SYMBOL:
				latex("SPECIAL SYMBOL");
		
			default:
				break;





	
	}
	tok = yylex();
}
}