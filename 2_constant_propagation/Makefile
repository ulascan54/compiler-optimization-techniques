Red    = \033[0;31m
Green  = \033[0;32m
NoColor= \033[0m

all: lex yacc
	g++ lex.yy.c y.tab.c -ll -o constant_propagation -Wno-deprecated

yacc: parser.y
	yacc -d -v parser.y

lex: lexer.l
	lex lexer.l

run: all
	./constant_propagation < 1_input.txt > 1_output.txt
	./constant_propagation < 2_input.txt > 2_output.txt
	if diff -q 1_output.txt 1_expected_output.txt && diff -q 2_output.txt 2_expected_output.txt; then \
		echo "$(Green)🚀🚀 Constant Propagation Algorithm is working correctly 🚀🚀$(NoColor)"; \
	else \
		echo "$(Red)💥💥 Constant Propagation Algorithm is not working correctly 💥💥$(NoColor)"; \
	fi

clean:
	rm -f lex.yy.c y.tab.c y.tab.h constant_propagation y.output 1_output.txt 2_output.txt
