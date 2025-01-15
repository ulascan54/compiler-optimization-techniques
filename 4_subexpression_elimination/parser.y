%{
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <unordered_map>
#include <cmath>
#include <iostream>

int yylex(void);
int yyerror(const char *s);

std::unordered_map<std::string, std::string> exps_map;

%}

%union {
    int num;
    char *str;
}

%token TOKEN_ASSIGN TOKEN_PLUS TOKEN_MINUS TOKEN_MULTIPLY TOKEN_DIVIDE TOKEN_POWER TOKEN_SEMICOLON 
%token <str> TOKEN_VAR
%token <num> TOKEN_NUM
%type <str> exps
%type <str> exp


%%

prog:
    prog assgmt
    | assgmt
    ;

assgmt:
    TOKEN_VAR TOKEN_ASSIGN exps TOKEN_SEMICOLON {
        std::string expression_return($3);
        if (exps_map.find(expression_return) != exps_map.end()) {
            std::cout << $1 << "=" << exps_map[expression_return].c_str() << ";" << std::endl;
        } else {
            std::cout << $1 << "=" << $3 << ";" << std::endl;
            exps_map[expression_return] = $1;
        }
    }
    ;

exps:
    exp TOKEN_PLUS exp {
        $$ = strdup((std::string($1) + "+" + std::string($3)).c_str());
    }
    | exp TOKEN_MINUS exp {
        $$ = strdup((std::string($1) + "-" + std::string($3)).c_str());
    }
    | exp TOKEN_MULTIPLY exp {
        $$ = strdup((std::string($1) + "*" + std::string($3)).c_str());
    }
    | exp TOKEN_DIVIDE exp {
        $$ = strdup((std::string($1) + "/" + std::string($3)).c_str());
    }
    | exp TOKEN_POWER exp {
        $$ = strdup((std::string($1) + "^" + std::string($3)).c_str());
    }
    | exp
    ;

exp:
    TOKEN_VAR {
        $$ = strdup($1);
    }
    | TOKEN_NUM {
        $$ = strdup(std::to_string($1).c_str());
    }
    ;
%%

int main() {
    return yyparse();
}

int yyerror(const char *s) {
    std::cerr << "Error: " << s << std::endl;
    return 0;
}
