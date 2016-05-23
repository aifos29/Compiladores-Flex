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
FILE* beamerFile;
int totalKeyword;
int totalOperation;
int totalSymbol;
int totalConstant;
int totalIdentificator;
int totalTokens;
%}

%%

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

"+" { return OPERATION; }
"-" { return OPERATION; }
"*" { return OPERATION; }
"/" { return OPERATION; }
"<" { return OPERATION; }
">" { return OPERATION; }
"=" { return OPERATION; }
"==" { return OPERATION; }
"<=" { return OPERATION; }
">=" { return OPERATION; }
"!=" { return OPERATION; }


"(" { return SYMBOL; }
")" { return SYMBOL; }
"[" { return SYMBOL; }
"]" { return SYMBOL; }
";" { return SYMBOL; }
"{" { return SYMBOL; }
"}" { return SYMBOL; }
"|" { return SYMBOL; }

[0-9]+ { yylval = atoi(yytext); return CONSTANT; }

"_"*[A-z]+"_"*[0-9]* {return IDENTIFICATOR;}

\n { return SALTO; }

[ \t] { return BLANCO; }

<<EOF>> { return EOL;}

%%

void startBeamer(){
  beamerFile = fopen( "beamer.tex", "w+" );
  fprintf(beamerFile,"\\documentclass{beamer} \n");
  fprintf(beamerFile, "\\usepackage{color} \n" );
  fprintf(beamerFile, "\\usepackage[utf8]{inputenc} \n" );
  fprintf(beamerFile,"\\title{Primer Semestre - Proyecto 2 Analizador Lexico} \n");
  fprintf(beamerFile,"\\author { \\texttt { Amanda Solano Astorga } \\texttt { Yasiell Vallejos Gómez } } \n");
  fprintf(beamerFile,"\\date{\\today}\n");
  fprintf(beamerFile,"\\date{\\today}\n");
  fprintf(beamerFile,"\\begin{document} \n");
  fprintf(beamerFile,"\\maketitle \n");
  fprintf(beamerFile,"\\begin{frame} \n");
  fprintf(beamerFile,"\\frametitle{Programa Fuente} \n");
}

void endBeamer(){
  fprintf(beamerFile,"\\end{frame} \n");
  fprintf(beamerFile,"\\end{document}");
  fclose(beamerFile);
  system("pdflatex beamer.tex");
  system("evince beamer.pdf");
}

void writeBeamer(char *_color, char *_word){
  fprintf(beamerFile, "\\textcolor{%s}{ %s } ", _color, _word);
}

void main(int argc, char **argv)
{
	int tok;
	yyin = fopen ("prueba.c","r+");
  startBeamer();
	tok = yylex();
	while(tok!=EOL){
		switch (tok){

			case CONSTANT:
				writeBeamer("blue", yytext);
        totalConstant++;
				break;
			case KEYWORD:
				writeBeamer("green", yytext);
        totalKeyword++;
				break;
			case OPERATION:
        if (strcmp(yytext,"<") == 0){
          writeBeamer("black", "$<$");
        }
        if (strcmp(yytext,">") == 0){
          writeBeamer("black", "$>$");
        }
        else{
          writeBeamer("black", yytext);
        }
        totalOperation++;
        break;
			case SALTO:
        fprintf(beamerFile,"\\newline");
				break;
			case IDENTIFICATOR:
        writeBeamer("orange", yytext);
        totalIdentificator++;
        break;
			case SYMBOL:
        writeBeamer("red", yytext);
        totalSymbol++;
        break;
			default:
				break;
		}
    totalTokens++;
		tok = yylex();

	}
  endBeamer();
}
