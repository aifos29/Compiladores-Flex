#include "mc1.h"

FILE *fp;
 	
 	
exprrec processliteral(void)
{
	exprrec t;
	checkreserved(tokenbuffer);

	t.kind = LITERALEXPR;
	(void) sscanf(tokenbuffer,"%d", & t.val);
	return t;
}

exprrec processid(void)
{
	exprrec t;
	checkid(tokenbuffer);
	t.kind = IDEXPR;
	strcpy(t.name, tokenbuffer);
	return t;
}

void primary(exprrec * x)
{
	token tok = nexttoken();

	switch (tok){
		case LPAREN:
			match(LPAREN); 
            
			expression(x);
			match(RPAREN);
			break;

		case ID:
			match(ID);
			exprrec p;
			p=processid();
			*x=p;
			break;

		case INTLITERAL:
			match(INTLITERAL);
			exprrec y;
			y=processliteral();
			*x=y;
			break;

		default:
		syntaxerror(tok);
		break;
	}
}
void exprlist(void)
{
	exprrec rec;
	expression(& rec);
	writeexpr(rec);

	while(nexttoken() == COMMA)
	{
		match(COMMA);
		expression(& rec);
		writeexpr(rec);
	}
}

char * extract2(exprrec x){
	if (x.kind==LITERALEXPR){
		char * valor[MAXIDLEN];
		sprintf(*valor,"%d",x.val);
        return * valor;
	}
	else{
		char  * val[MAXIDLEN];

		strcpy(*val,x.name);
		return * val;
	}

}

char * extract(oprec x){
	if (x.operator == PLUS){
		char *ret[MAXIDLEN];
		*ret ="Add";
		return * ret;
	}
	else{
		char * ret[MAXIDLEN];
		*ret="Sub";
		return * ret;
	}
}


void assign(exprrec target, exprrec source)
{
	if (source.kind==LITERALEXPR){
		generate("Store",extract2(source), target.name,"");
	}
	else{
		generate("Store",source.name, target.name,"");
	}
}

void statement(void)
{
	token tok = nexttoken();
	exprrec source,target;

	switch (tok){
		case ID:
			match(ID);
			target = processid();
			match(ASSIGNOP);
			expression(& source); 
			match(SEMICOLON);
			assign(target,source);
			break;

		case READ:
			match(READ); match(LPAREN);
			idlist(); match(RPAREN);
			match(SEMICOLON);
			break;

		case WRITE:
			match(WRITE); match(LPAREN);
			exprlist(); match(RPAREN);
			match(SEMICOLON);
			break;

		default:
			syntaxerror(tok);
			break;
	}
}

void statementlist(void){
	statement();
	while (1){
		switch (nexttoken()){
			case ID:
			case READ:
			case WRITE:
				statement();
				break;
			default:
				return;
		}
    }
}


void finish(void)
{
	generate("Halt","","","");


	
	fclose(fp);

}

void program(void){
	match(BEGIN);
	statementlist();
	match(END);
	finish();

}

void systemgoal(void){
	program();

}


int main(int argc, char const *argv[])
{
	printf("%s\n",argv[1]);
	fflush(stdout);
	archivo=fopen(argv[1],"r+");

	fp=fopen("salida.txt","w+");


	systemgoal();
	fclose(fp);
	return 0;
}
extern int lookup(string s);

extern void enter(string s);
	

void generate(string dec,string s,string tipo,string espacio){
	fprintf(fp,"%s\n ","");
	fprintf(fp,"%s ",dec);
	fprintf(fp,"%s ",s);
	fprintf(fp,"%s ",tipo);
	fprintf(fp,"%s ",espacio);



char *gettemp(void)
{
	static int maxtemp = 0;
	static char tempname[MAXIDLEN];

	maxtemp++;
	sprintf(tempname,"Temp%d",maxtemp);
	checkid(tempname);
	return tempname;
}

exprrec geninfix(exprrec e1, oprec op, exprrec e2)
{
	exprrec erec;
	erec.kind = TEMPEXPR;
	strcpy(erec.name,gettemp());
	char uno[33];
	strcpy(uno,extract2(e2));

    generate(extract(op), extract2(e1),uno, erec.name);
	return erec;
}

void checkid(string s)
{
	if(lookup(s)==0){
		enter(s);
		generate("Declare",s,"Integer","");
	}
}

void start(void)
{
}

void readid(exprrec invar)
{
	generate("Read",invar.name,"Integer","");
}

void writeexpr(exprrec outexpr)
{
	char  valor[MAXIDLEN];
	if (outexpr.kind==LITERALEXPR){
			sprintf(valor,"%d",outexpr.val);
			generate("Write", valor,"Integer","");

		}
		else{
			generate("Write", outexpr.name,"Integer","");

		}

}

void expression(exprrec *result)
{
	exprrec leftoperand, rightoperand, constantfolding;
	oprec op;

	primary(& leftoperand);
	while(nexttoken() == PLUSOP || nexttoken() == MINUSOP)
	{
		int valor;
		addop(& op);
		primary(& rightoperand);
		leftoperand = geninfix(leftoperand, op, rightoperand);
	
	*result= leftoperand;
}
}

