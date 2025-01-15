Red    = \033[0;31m
Green  = \033[0;32m
NoColor= \033[0m

all: lex yacc
	g++ lex.yy.c y.tab.c -ll -o algebraic_simplification -Wno-deprecated

yacc: parser.y
	yacc -d -v parser.y

lex: lexer.l
	lex lexer.l

run: all
	./algebraic_simplification < input.txt > output.txt
	if diff -q output.txt expected_output.txt; then \
		echo "$(Green)🚀🚀 Algebraic Simplification Algorithm is working correctly 🚀🚀$(NoColor)"; \
	else \
		echo "$(Red)💥💥 Algebraic Simplification Algorithm is not working correctly 💥💥$(NoColor)"; \
	fi

clean:
	rm -f lex.yy.c y.tab.c y.tab.h algebraic_simplification y.output output.txt
