%{
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <unordered_map>
#include <cmath>
#include <iostream>
#include <set>

int yylex(void);
int yyerror(const char *s);

std::unordered_map<std::string, std::string> idents;
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
        std::string input = std::string($3); 
        std::string ident = std::string($1); 
        idents[ident] = input;
        std::cout << ident << "=" << input << ";" << std::endl; 
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
        std::string ident = std::string($1);
        if (idents.find(ident) != idents.end()) {
            ident = idents[ident];
        }
        $$ = strdup(ident.c_str());
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
