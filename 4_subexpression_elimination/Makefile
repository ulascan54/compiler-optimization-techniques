Red    = \033[0;31m
Green  = \033[0;32m
NoColor= \033[0m

all: lex yacc
	g++ lex.yy.c y.tab.c -ll -o subexpression_elimination -Wno-deprecated

yacc: parser.y
	yacc -d -v parser.y

lex: lexer.l
	lex lexer.l

run: all
	./subexpression_elimination < input.txt > output.txt
	if diff -q output.txt expected_output.txt; then \
		echo "$(Green)🚀🚀 Subexpression Elimination Algorithm is working correctly 🚀🚀$(NoColor)"; \
	else \
		echo "$(Red)💥💥 Subexpression Elimination Algorithm is not working correctly 💥💥$(NoColor)"; \
	fi

clean:
	rm -f lex.yy.c y.tab.c y.tab.h subexpression_elimination y.output output.txt