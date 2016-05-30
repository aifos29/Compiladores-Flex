#include "mc2.h"

token checkreserved(){
	if ((strcmp(tokenbuffer,"READ")==0) || (strcmp(tokenbuffer,"read")==0)){
		return READ;}
	if ((strcmp(tokenbuffer,"WRITE")==0) || (strcmp(tokenbuffer,"write")==0)){
		return WRITE;}
	if ((strcmp(tokenbuffer,"BEGIN")==0) || (strcmp(tokenbuffer,"begin")==0)){
		return BEGIN;}
	if ((strcmp(tokenbuffer,"END")==0) || (strcmp(tokenbuffer,"end")==0)){
		return END;
	}
	else{
	 return ID;
  }
}

token scanner(void)
{
	int inchar,c;

	clearbuffer();
	if (feof(archivo))
		return SCANEOF;

	while (feof(archivo)==0){
		inchar=fgetc(archivo);
		if (isspace(inchar))
			continue; 
		else if (isalpha(inchar)){
			bufferchar(inchar);
			for (c= fgetc(archivo);isalnum(c)||c=='-';c=fgetc(archivo))
				bufferchar(c);
				return checkreserved();

		}else if (isdigit(inchar)){
			bufferchar(inchar);
			for (c=fgetc(archivo);isdigit(c);c=fgetc(archivo))
				bufferchar(c);
			return INTLITERAL;
		}else if (inchar== '(')
			return LPAREN;
		else if (inchar==')')
			return RPAREN;
		else if (inchar==';')
			return SEMICOLON ;
		else if (inchar==',')
			return COMMA ;
		else if (inchar=='+')
			return  PLUSOP;
		else if (inchar==':'){
			c=fgetc(archivo);
			if (c=='=')
				return ASSIGNOP ;
			else{
				lexicalerror(inchar);
			}		
		}
	
		else if (inchar=='-'){
			c=fgetc(archivo);
			if (c=='-'){
				do 
					inchar=fgetc(archivo);
				while (inchar!='\n');

			} else{
				return MINUSOP;
			}
			}else 
				lexicalerror(inchar);
		}
}

void syntaxerror(token t){
	printf("%s","Error de sintaxis");
}

void match(token t){
	if (flagnexttoken==0){
		token auxiliar=scanner();
	    if (auxiliar==t){
	    	currenttoken=t;
	    	flagnexttoken=0;
	    	flag=1; 
	    }
	    else{
	    	flag=0;
	    	printf("Error de semantica");
	    	fflush(stdout);
	    	exit(1);
	    }
	}
	else{
		if (next==t){
			currenttoken=t;
			flagnexttoken=0;
			flag=1;
		}
		else{
			flag=0;
			printf("Error de semantica");
		    fflush(stdout);
		    exit(1);
		}
	}
}

token nexttoken(){
	
	if (flag==1){
		flagnexttoken=1;
		flag=0; 
		next=scanner();
	}
	
	return next;
}

void idlist(void)
{
	exprrec rec;
	match(ID);
	expression(&rec);
	readid(rec);

	while (nexttoken() == COMMA) {
		match(COMMA);
		match(ID);
		expression(&rec);
		readid(rec);
	}
}

oprec processop(void)
{
	oprec o;

	if (currenttoken == PLUSOP)
		o.operator = PLUS;
	else
		o.operator = MINUS;
	return o;
}

void addop(oprec * rec)
{
	token tok = nexttoken();

	if (tok == PLUSOP || tok == MINUSOP){
		match(tok);
		*rec = processop();
	}
	else{
		syntaxerror(tok);
	}
}