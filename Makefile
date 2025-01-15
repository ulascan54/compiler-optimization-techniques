PROJECTS := 1_constant_folding \
            2_constant_propagation \
            3_algebraic_simplification \
            4_subexpression_elimination \
			5_dead_code_elimination 
check:
	@for dir in $(PROJECTS); do \
	    echo ">>> Checking < $$dir >"; \
	    (cd $$dir && make run) | tail -n 1; \
	done

clear:
	@for dir in $(PROJECTS); do \
	    echo ">>> Cleaning < $$dir >"; \
	    (cd $$dir && make clean) \
	done