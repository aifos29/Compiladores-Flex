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
  fprintf(beamerFile, "\\usepackage{pgfplots}\n" );
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
  fprintf(beamerFile,"\\end{document}");
  fclose(beamerFile);
  system("pdflatex beamer.tex");
  system("evince beamer.pdf");
}

void writeBeamer(char *_color, char *_word){
  fprintf(beamerFile, "\\textcolor{%s}{ %s } ", _color, _word);
}

void createHistogram(){
  fprintf(beamerFile,"\\end{frame} \n");
  fprintf(beamerFile,"\\begin{frame} \n");
  fprintf(beamerFile,"\\frametitle{Histograma} \n");
  fprintf(beamerFile,"\\pgfplotsset{compat=1.6} \n");
  fprintf(beamerFile,"\\begin{figure}");
  fprintf(beamerFile,"\\centering");
  fprintf(beamerFile,"\\begin{tikzpicture}");
  fprintf(beamerFile,"\\begin{axis}[");
  fprintf(beamerFile,"ybar,enlargelimits=0.15,");
  fprintf(beamerFile,"legend style={at={(0.5,-0.2)}, anchor=north,legend columns=-1}, ylabel={Lexemas},");
  fprintf(beamerFile,"symbolic x coords={Keyword,Operation,Symbol,Constant,Identificator},");
  fprintf(beamerFile,"xtick=data,nodes near coords,nodes near coords align={vertical},");
  fprintf(beamerFile,"x tick label style={rotate=45,anchor=east},]");
  fprintf(beamerFile,"\\addplot coordinates {(Keyword,%i) (Operation,%i)",totalKeyword,totalOperation);
  fprintf(beamerFile,"(Symbol,%i) (Constant,%i) (Identificator,%i)};",totalSymbol,totalConstant,totalIdentificator);
  fprintf(beamerFile,"\\end{axis}");
  fprintf(beamerFile,"\\end{tikzpicture}");
  fprintf(beamerFile,"\\end{figure}");
  fprintf(beamerFile,"\\end{frame} \n");
}


void createPastel(float _symbol,float _keyword,float _operation,float _constant,float _identificator){
  fprintf(beamerFile,"\\begin{frame}{Diagrama Pastel} \n");
	fprintf(beamerFile,"\\pgfplotsset{compat=1.6} \n");
	fprintf(beamerFile,"\\def\\angle{0}");
	fprintf(beamerFile,"\\def\\radius{3}");
	fprintf(beamerFile,"\\def\\cyclelist{{\"purple\",\"green\",\"red\",\"blue\",\"orange\"}}");
	fprintf(beamerFile,"\\newcount\\cyclecount \\cyclecount=-1");
	fprintf(beamerFile,"\\newcount\\ind \\ind=-1");
	fprintf(beamerFile,"\\begin{tikzpicture}");
	fprintf(beamerFile,"\\foreach \\percent/ \\name in {");
	fprintf(beamerFile,"%.2f/Keyword,",_keyword);
	fprintf(beamerFile,"%.2f/Operation,",_operation);
	fprintf(beamerFile,"%.2f/Symbol,",_symbol);
	fprintf(beamerFile,"%.2f/Constant,",_constant);
	fprintf(beamerFile,"%.2f/Identificator",_identificator);
	fprintf(beamerFile,"} {\\ifx\\percent\\empty\\else");
	fprintf(beamerFile,"\\global\\advance\\cyclecount by 1");
	fprintf(beamerFile,"\\global\\advance\\ind by 1");
	fprintf(beamerFile,"\\ifnum4<\\cyclecount");
	fprintf(beamerFile,"\\global\\cyclecount=0");
	fprintf(beamerFile,"\\global\\ind=0");
	fprintf(beamerFile,"\\fi");
	fprintf(beamerFile,"\\pgfmathparse{\\cyclelist[\\the\\ind]}");
	fprintf(beamerFile,"\\edef\\color{\\pgfmathresult}");
	fprintf(beamerFile,"\\draw[fill={\\color!50},draw={\\color}] (0,0) -- (\\angle:\\radius)");
	fprintf(beamerFile,"arc (\\angle:\\angle+\\percent*3.7:\\radius) -- cycle;");
	fprintf(beamerFile,"\\node at (\\angle+0.5*\\percent*3.7:0.7*\\radius) {\\percent\\,\\%};at (\\angle+0.5*\\percent*3.7:\\radius) {};");
	fprintf(beamerFile,"\\pgfmathparse{\\angle+\\percent*3.7}");
	fprintf(beamerFile,"\\xdef\\angle{\\pgfmathresult}");
	fprintf(beamerFile,"\\fi};");
	fprintf(beamerFile,"\\end{tikzpicture}");
  fprintf(beamerFile,"\\end{frame} \n");
}

void getPorcentage(){
	float symbol = (totalSymbol * 100)/ totalTokens;
	float keyword= (totalKeyword * 100)/ totalTokens;
	float operation= (totalOperation * 100)/ totalTokens;
	float constant= (totalConstant * 100)/ totalTokens;
	float identificator= (totalIdentificator * 100)/ totalTokens;

	createPastel(symbol,keyword,operation,constant,identificator);
}

void main(int argc, char **argv)
{
	int tok;
	yyin = fopen ("prueba.c","r+");
  startBeamer();
	tok = yylex();
	int totalLines = 1;

	while(tok!=EOL){

		switch (tok){
			case CONSTANT:
				writeBeamer("blue", yytext);
        totalConstant++;
				totalTokens++;
				break;
			case KEYWORD:
				writeBeamer("purple", yytext);
        totalKeyword++;
				totalTokens++;
				break;
			case OPERATION:
        if (strcmp(yytext,"<") == 0){
					fprintf(beamerFile, "\\textcolor{%s}{%s}", "green","$<$");
        }
        if (strcmp(yytext,">") == 0){
					fprintf(beamerFile, "\\textcolor{%s}{%s}", "green","$>$");
        }
        else{
          writeBeamer("green", yytext);
        }
        totalOperation++;
				totalTokens++;
        break;
			case SALTO:
        fprintf(beamerFile,"\\newline");
				totalLines++;
				break;
			case IDENTIFICATOR:
        writeBeamer("orange", yytext);
        totalIdentificator++;
				totalTokens++;
        break;
			case SYMBOL:
				if (strcmp(yytext,"}") == 0){
          fprintf(beamerFile, "\\textcolor{%s}{\\} }\n", "red");
        }
        if (strcmp(yytext,"{") == 0){
          fprintf(beamerFile, "\\textcolor{%s}{\\{\n", "red");;
        }
        else{
        	writeBeamer("red", yytext);
				}
        totalSymbol++;
				totalTokens++;
        break;
			default:
				break;
		}
		tok = yylex();

	}
  createHistogram();
	getPorcentage();
  endBeamer();
}
