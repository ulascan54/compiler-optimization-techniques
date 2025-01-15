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
bool is_number(const std::string& s) {
    if (s.empty()) return false;
    for (size_t i = 0; i < s.size(); ++i) {
        if (!std::isdigit(s[i]) && s[i] != '.') return false;
    }
    return true;
}

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
        std::cout << $1 << "=" << $3 << ";" << std::endl;
    }
    ;

exps:
    exp TOKEN_PLUS exp {
        if (is_number($1) && is_number($3)) {
            $$ = strdup(std::to_string(std::stoi($1) + std::stoi($3)).c_str());
        } else {
            $$ = strdup((std::string($1) + "+" + std::string($3)).c_str());
        }
    }
    | exp TOKEN_MINUS exp {
        if (is_number($1) && is_number($3)) {
            $$ = strdup(std::to_string(std::stoi($1) - std::stoi($3)).c_str());
        } else {
        $$ = strdup((std::string($1) + "-" + std::string($3)).c_str());
        }
    }
    | exp TOKEN_MULTIPLY exp {
        if (is_number($1) && is_number($3)) {
            $$ = strdup(std::to_string(std::stoi($1) * std::stoi($3)).c_str());
        } else {
            $$ = strdup((std::string($1) + "*" + std::string($3)).c_str());
        }
    }
    | exp TOKEN_DIVIDE exp {
        if (is_number($1) && is_number($3)) {
            $$ = strdup(std::to_string(std::stoi($1) / std::stoi($3)).c_str());
        } else {
            $$ = strdup((std::string($1) + "/" + std::string($3)).c_str());
        }
    }
    | exp TOKEN_POWER exp {
        if (is_number($1) && is_number($3)) {
            int temp = std::stoi($1);
            for (int i = 1; i < std::stoi($3); i++) {
                temp *= std::stoi($1);
            }
            $$ = strdup(std::to_string(temp).c_str());
        } else {
            $$ = strdup((std::string($1) + "^" + std::string($3)).c_str());
        }
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