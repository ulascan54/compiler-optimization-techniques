%{
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <unordered_map>
#include <cmath>
#include <iostream>
#include <cctype>
#include <set>

int yylex(void);
int yyerror(const char *s);

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
        std::set<char> operators;
        operators.insert('+');
        operators.insert('-');
        operators.insert('*');
        operators.insert('/');
        operators.insert('^');
        std::string input = std::string($3); 
        std::string ident = std::string($1); 
        std::string beforeOperator;
        std::string afterOperator;
        char operatorFound = '\0';

        for (size_t i = 0; i < input.size(); ++i) {
            if (operators.count(input[i]) > 0) {
                operatorFound = input[i];
                beforeOperator = input.substr(0, i);
                afterOperator = input.substr(i + 1);
                break;
            }
        }

        if (operatorFound != '\0') {
            if(operatorFound == '+'){
                if(beforeOperator == "0"){
                    if(ident != afterOperator){
                        std::cout << ident << "=" << afterOperator <<";"<< std::endl;
                    }
                }
                if(afterOperator == "0"){
                    if(ident != beforeOperator){
                        std::cout << ident << "=" << beforeOperator <<";"<< std::endl;
                    }
                }
                if(beforeOperator != "0" && afterOperator != "0"){
                    std::cout << ident << "=" << input <<";"<< std::endl;
                }
            }
            if(operatorFound == '-'){
                if(beforeOperator == "0"){
                    if(ident != afterOperator){
                        std::cout << ident << "=" << afterOperator <<";"<< std::endl;
                    }
                }
                if(afterOperator == "0"){
                    if(ident != beforeOperator){
                        std::cout << ident << "=" << beforeOperator <<";"<< std::endl;
                    }
                }
                if(beforeOperator != "0" && afterOperator != "0"){
                    std::cout << ident << "=" << input <<";"<< std::endl;
                }
            }
            if(operatorFound == '*'){
                if(beforeOperator == "1"){
                    if(ident != afterOperator){
                        std::cout << ident << "=" << afterOperator <<";"<< std::endl;
                    }
                }
                if(afterOperator == "1"){
                    if(ident != beforeOperator){
                        std::cout << ident << "=" << beforeOperator <<";"<< std::endl;
                    }
                }
                if(beforeOperator == "0" || afterOperator == "0"){
                    std::cout << ident << "=" << 0 <<";"<< std::endl;
                }
                if(beforeOperator != "1" && afterOperator != "1" && beforeOperator != "0" && afterOperator != "0"){
                    std::cout << ident << "=" << input <<";"<< std::endl;
                }    
            }
            if(operatorFound == '/'){
                if(beforeOperator == "0"){
                    std::cout << ident << "=" << 0 <<";"<< std::endl;
                }else{
                    std::cout << ident << "=" << input <<";"<< std::endl;
                }
            }
            if(operatorFound == '^'){
                if(afterOperator == "2"){
                    std::cout << ident << "=" << beforeOperator << "*" << beforeOperator << ";"<< std::endl;
                }else{
                    std::cout << ident << "=" << input <<";"<< std::endl;
                }
            }
        } else{
            std::cout << ident << "=" << input <<";"<< std::endl;
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
    std::cerr << "Error: " << s <<";"<< std::endl;
    return 0;
}
