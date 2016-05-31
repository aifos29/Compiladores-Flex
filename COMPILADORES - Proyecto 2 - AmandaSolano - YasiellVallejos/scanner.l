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
	EOL = 9,
	ERROR = 10,
	GREATEREQUAL = 11,
	LESSEQUAL = 12,
	LESSTHAN = 13,
	GREATERTHAN = 14,
	LEFTBRACKET = 15,
	RIGHTBRACKET = 16,
	DOLLAR = 17,
	MODULE = 18,
	AMPERSAND = 19,
	UNDERSCORE = 20,
	AND = 21,
	NUM = 22,
	BACKSLASH = 23,
};
int yylval;
FILE* beamerFile;
int totalKeyword;
int totalOperation;
int totalSymbol;
int totalConstant;
int totalIdentificator;
int totalTokens;
int totalError;
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
"_Packed"	{return KEYWORD;}
"main"	    {return KEYWORD;}
"printf"	{return KEYWORD;}
"fprintf"	{return KEYWORD;}
"scanf"	{return KEYWORD;}
"system"	{return KEYWORD;}

"+" { return OPERATION; }
"++" { return OPERATION; }
"-" { return OPERATION; }
"--" { return OPERATION; }
"*" { return OPERATION; }
"/" { return OPERATION; }
"%" { return MODULE; }
"<" { return LESSTHAN; }
">" { return GREATERTHAN; }
"=" { return OPERATION; }
"==" { return OPERATION; }
"!=" { return OPERATION; }
"<=" { return LESSEQUAL; }
">=" { return GREATEREQUAL; }
"&"	 { return AMPERSAND; }
"&&" { return AND; }
"||" { return OPERATION;}
"|" { return OPERATION; }
"?:"	{ return OPERATION; }

"(" { return SYMBOL; }
")" { return SYMBOL; }
"[" { return SYMBOL; }
"]" { return SYMBOL; }
";" { return SYMBOL; }
"," { return SYMBOL; }
"." { return SYMBOL; }
"{"	{ return LEFTBRACKET; }
"}"	{ return RIGHTBRACKET; }
"!" { return SYMBOL; }
":" { return SYMBOL; }
"'"	{ return SYMBOL; }
"$"	{ return DOLLAR; }
"\\"	{ return BACKSLASH; }
"\""	{ return SYMBOL; }
"_"	{ return UNDERSCORE; }
"#" { return NUM;}


[0-9]+ { yylval = atoi(yytext); return CONSTANT; }

[a-zA-Z][_a-zA-Z0-9]* {return IDENTIFICATOR;}

\n { return SALTO; }

[ \t] { return BLANCO; }

<<EOF>> { return EOL;}

. { return ERROR;}

%%

void startBeamer(){
	beamerFile = fopen( "beamer.tex", "w+" );
	fprintf(beamerFile,"\\documentclass{beamer} \n");
	fprintf(beamerFile, "\\usetheme{Dresden} \n" );
	fprintf(beamerFile, "\\usecolortheme{beaver} \n" );
	fprintf(beamerFile, "\\usepackage{color} \n" );
	fprintf(beamerFile, "\\usepackage[T1]{fontenc} \n" );
	fprintf(beamerFile, "\\usepackage[utf8]{inputenc} \n" );
	fprintf(beamerFile, "\\let\\Tiny=\\tiny \n" );
	fprintf(beamerFile, "\\usepackage{pgfplots}\n" );
	fprintf(beamerFile,"\\pgfplotsset{compat=newest,compat/show suggested version=false} \n");
	fprintf(beamerFile, "\\usepackage{pgf-pie}\n" );
	fprintf(beamerFile, "\\usepackage{tikz}\n" );
	fprintf(beamerFile, "\\usepackage{hyperref}\n" );
	fprintf(beamerFile,"\\title{Primer Semestre - Proyecto 2 Analizador Lexico} \n");
	fprintf(beamerFile,"\\author { \\texttt { Amanda Solano Astorga } \\texttt { Yasiell Vallejos Gómez } } \n");
	fprintf(beamerFile,"\\date{\\today}\n");
	fprintf(beamerFile,"\\begin{document} \n");
	fprintf(beamerFile,"\\maketitle \n");
	fprintf(beamerFile,"\\begin{frame}[allowframebreaks] \n");
	fprintf(beamerFile,"\\frametitle{ Proceso de Scanning y Herramienta Flex} \n \n");
	fprintf(beamerFile,"El análisis léxico es el encargado de separar por tokens la cadena de texto ingresada.");
	fprintf(beamerFile,"Un token es una unidad lexica que tiene coherencia en un lenguaje de programación. \\newline \n");
	fprintf(beamerFile,"En el caso del lenguaje de programación C, el lenguaje contiene 5 tokens: \\newline \n");
	fprintf(beamerFile,"String : Cadenas de texto. \\newline \n");
	fprintf(beamerFile,"Constante: Hace referencia a los números. \\newline \n");
	fprintf(beamerFile,"Identificadores: Son aquellas palabras que no son parte del lenguaje \\newline \n");
	fprintf(beamerFile,"Palabras especiales: Palabras que son usadas por el lenguaje \\newline \n");
	fprintf(beamerFile,"Simboles especiales: Comas, parentesis entre otros \\newline \n");
	fprintf(beamerFile,"Operadores: Signos aritmetricos basicos \\newline \n");
	fprintf(beamerFile,"\\textbf{Flex} es una herramienta que genera un scanner en lenguaje C.");
	fprintf(beamerFile,"Su funcionamiento consiste en declarar los tokens validos en un lenguaje especifico y decirle que hacer cuando reconozca uno de ellos. \n");
	fprintf(beamerFile,"\\end{frame} \n");
	fprintf(beamerFile,"\\begin{frame}[allowframebreaks] \n");
	fprintf(beamerFile,"\\frametitle{Programa Fuente} \n");
}

void endBeamer(){
  fprintf(beamerFile,"\\end{document} \n");
  fclose(beamerFile);
  system("pdflatex beamer.tex");
  remove("tmp.c");
  remove("listo.c");
  system("evince beamer.pdf");
}

void writeBeamer(char *_color, char *_word){
  fprintf(beamerFile, "\\textcolor{%s}{ %s } \n", _color, _word);
}

void createHistogram(){
  fprintf(beamerFile,"\\end{frame} \n");
  fprintf(beamerFile,"\\begin{frame} \n");
  fprintf(beamerFile,"\\frametitle{Histograma} \n");
  fprintf(beamerFile,"\\begin{tikzpicture} \n");
  fprintf(beamerFile,"\\begin{axis}[");
  fprintf(beamerFile,"ybar,enlargelimits=0.15,");
  fprintf(beamerFile,"legend style={at={(0.5,-0.2)}, anchor=north,legend columns=-1}, ylabel={Lexemas},");
  fprintf(beamerFile,"symbolic x coords={Keyword,Operation,Symbol,Constant,Identificator,Error},");
  fprintf(beamerFile,"xtick=data,nodes near coords,nodes near coords align={vertical},");
  fprintf(beamerFile,"x tick label style={rotate=45,anchor=east},] \n");
  fprintf(beamerFile,"\\addplot[ybar,fill=blue] coordinates {(Keyword,%i) (Operation,%i)",totalKeyword,totalOperation);
  fprintf(beamerFile,"(Symbol,%i) (Constant,%i) (Identificator,%i) (Error,%i)}; \n",totalSymbol,totalConstant,totalIdentificator,totalError);
  fprintf(beamerFile,"\\end{axis} \n");
  fprintf(beamerFile,"\\end{tikzpicture} \n");
  fprintf(beamerFile,"\\end{frame} \n");
}


void createPastel(int _symbol,int _keyword,int _operation,int _constant,int _identificator,int _error){
fprintf(beamerFile,"\\begin{frame}{Diagrama Pastel} \n");
fprintf(beamerFile,"\\def\\angle{0}");
fprintf(beamerFile,"\\def\\radius{2}");
fprintf(beamerFile,"\\def\\labelradius{3}");
fprintf(beamerFile,"\\def\\cyclelist{{\"purple\",\"green\",\"olive\",\"blue\",\"orange\",\"red\"}}");
fprintf(beamerFile,"\\centering");
fprintf(beamerFile,"\\newcount\\cyclecount \\cyclecount=-1");
fprintf(beamerFile,"\\newcount\\ind \\ind=-1");
fprintf(beamerFile,"\\begin{tikzpicture}");
fprintf(beamerFile,"\\foreach \\percent/\\name in {");
fprintf(beamerFile,"%i/Keyw.,",_keyword);
fprintf(beamerFile,"%i/Operat.,",_operation);
fprintf(beamerFile,"%i/Symb.,",_symbol);
fprintf(beamerFile,"%i/Const.,",_constant);
fprintf(beamerFile,"%i/Ident.,",_identificator);
fprintf(beamerFile,"%i/Error",_error);
fprintf(beamerFile,"} {\\ifx\\percent\\empty\\else");
fprintf(beamerFile,"\\global\\advance\\cyclecount by 1");
fprintf(beamerFile,"\\global\\advance\\ind by 1");
fprintf(beamerFile,"\\ifnum6<\\cyclecount");
fprintf(beamerFile,"\\global\\cyclecount=0");
fprintf(beamerFile,"\\global\\ind=0");
fprintf(beamerFile,"\\fi");
fprintf(beamerFile,"\\pgfmathparse{\\cyclelist[\\the\\ind]}");
fprintf(beamerFile,"\\edef\\color{\\pgfmathresult}");
fprintf(beamerFile,"\\draw[fill={\\color!50},draw={\\color}] (0,0) -- (\\angle:\\radius) arc (\\angle:\\angle+\\percent*3.7:\\radius) -- cycle;");
fprintf(beamerFile,"\\draw[draw=gray, shorten >=2pt] (\\angle+0.5*\\percent*3.7:\\labelradius) node {\\name~[\\percent\\%%]} edge (\\angle+0.5*\\percent*3.7:\\radius);");
fprintf(beamerFile,"\\pgfmathparse{\\angle+\\percent*3.7}");
fprintf(beamerFile,"\\xdef\\angle{\\pgfmathresult}");
fprintf(beamerFile,"\\fi};");
fprintf(beamerFile,"\\end{tikzpicture}");
fprintf(beamerFile,"\\end{frame} \n");
}

void getPorcentage(){
	int symbol = (totalSymbol * 100)/ totalTokens;
	int keyword= (totalKeyword * 100)/ totalTokens;
	int operation= (totalOperation * 100)/ totalTokens;
	int constant= (totalConstant * 100)/ totalTokens;
	int identificator= (totalIdentificator * 100)/ totalTokens;
	int error = (totalError * 100)/ totalTokens;

	createPastel(symbol,keyword,operation,constant,identificator,error);
}

void main(int argc, char **argv)
{
	int tok;
	yyin = fopen ("listo.c","r+");
  	startBeamer();
	tok = yylex();

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
        		writeBeamer("green", yytext);
        		totalOperation++;
				totalTokens++;
        		break;
			case GREATEREQUAL:
				fprintf(beamerFile, "\\textcolor{%s}{%s} \n", "green","$>=$");
				totalOperation++;
				totalTokens++;
				break;
			case GREATERTHAN:
				fprintf(beamerFile, "\\textcolor{%s}{\\textgreater} \n", "green");
				totalOperation++;
				totalTokens++;
				break;
			case LESSEQUAL:
				fprintf(beamerFile, "\\textcolor{%s}{%s} \n", "green","$<=$");
				totalOperation++;
				totalTokens++;
				break;
			case LESSTHAN:
				fprintf(beamerFile, "\\textcolor{%s}{\\textless} \n", "green");
				totalOperation++;
				totalTokens++;
				break;
			case MODULE:
				fprintf(beamerFile, "\\textcolor{%s}{\\%%} \n", "green");
				totalOperation++;
				totalTokens++;
				break;
			case AMPERSAND:
				fprintf(beamerFile, "\\textcolor{%s}{\\&} \n", "green");
				totalOperation++;
				totalTokens++;
				break;
			case AND:
				fprintf(beamerFile, "\\textcolor{%s}{\\&\\&} \n", "green");
				totalOperation++;
				totalTokens++;
				break;
			case SALTO:
        		fprintf(beamerFile,"\\newline \n");
				break;
			case IDENTIFICATOR:
        		writeBeamer("orange", yytext);
        		totalIdentificator++;
				totalTokens++;
        		break;
			case SYMBOL:
		        writeBeamer("olive", yytext);
		        totalSymbol++;
				totalTokens++;
        		break;
        	case BACKSLASH:
				fprintf(beamerFile, "\\textcolor{%s}{\\textbackslash} \n", "olive");
				totalSymbol++;
				totalTokens++;
				break;
			case UNDERSCORE:
				fprintf(beamerFile, "\\textcolor{%s}{\\_ } \n", "olive");
				totalSymbol++;
				totalTokens++;
				break;
			case NUM:
				fprintf(beamerFile, "\\textcolor{%s}{\\# } \n", "olive");
				totalSymbol++;
				totalTokens++;
				break;
			case DOLLAR:
			    fprintf(beamerFile, "\\textcolor{%s}{\\$ } \n", "olive");
			    totalSymbol++;
				totalTokens++;
	      		break;
			case RIGHTBRACKET:
	      		fprintf(beamerFile, "\\textcolor{%s}{\\} } \n", "olive");
	      		totalSymbol++;
				totalTokens++;
	      		break;
			case LEFTBRACKET:
				fprintf(beamerFile, "\\textcolor{%s}{ \\{ } \n", "olive");
		    	totalSymbol++;
				totalTokens++;
		    	break;
			case ERROR:
				writeBeamer("red", "Symbol not identified");
				totalError++;
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
