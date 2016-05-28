all: Preprocesador Scan

Preprocesador: preprocesador.c
	gcc preprocesador.c -o pre
	./pre prueba.txt

Scan: scanner.l
	flex scanner.l
	gcc -o scan lex.yy.c -lfl
	./scan
