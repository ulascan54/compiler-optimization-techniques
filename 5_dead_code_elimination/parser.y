%{
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cctype>
#include <string>
#include <vector>
#include <iostream>
#include <algorithm>
#include <unordered_set>

int yylex(void);
int yyerror(const char *s);

std::vector<std::pair<std::string, std::string> > all_assgmt;
static std::unordered_set<std::string> extract_idents(const std::string &expr);

void eliminate_dead_code() {
    std::vector<bool> keep(all_assgmt.size(), false);
    std::unordered_set<std::string> used;
    if (!all_assgmt.empty()) {
        keep[all_assgmt.size() - 1] = true;
        used.insert(all_assgmt.back().first);
        std::unordered_set<std::string> lastExprVars = extract_idents(all_assgmt.back().second);
        for (std::unordered_set<std::string>::iterator it = lastExprVars.begin();it != lastExprVars.end(); ++it) {
            used.insert(*it);
        }
    }

    for (int i = (int)all_assgmt.size() - 2; i >= 0; i--) {
        const std::string &var  = all_assgmt[i].first;
        const std::string &expr = all_assgmt[i].second;
        if (used.find(var) != used.end()) {
            keep[i] = true;
            std::unordered_set<std::string> rhsIds = extract_idents(expr);
            for (std::unordered_set<std::string>::iterator it = rhsIds.begin();it != rhsIds.end(); ++it){
                used.insert(*it);
            }
        }
    }
    for (size_t i = 0; i < all_assgmt.size(); i++) {
        if (keep[i]) {
            std::cout << all_assgmt[i].first << "=" << all_assgmt[i].second << ";" << std::endl;
        }
    }
}
static std::unordered_set<std::string> extract_idents(const std::string &expr) {
    std::unordered_set<std::string> ids;
    std::string token;
    for (size_t i = 0; i < expr.size(); i++) {
        char c = expr[i];
        if (std::isalnum(static_cast<unsigned char>(c)) || c == '_') {
            token.push_back(c);
        } else {
            if (!token.empty()) {
                if (std::isalpha(static_cast<unsigned char>(token[0])) || token[0] == '_') {
                    ids.insert(token);
                }
                token.clear();
            }
        }
    }
    if (!token.empty()) {
        if (std::isalpha(static_cast<unsigned char>(token[0])) || token[0] == '_') {
            ids.insert(token);
        }
        token.clear();
    }
    return ids;
}

%}

%union {
    int   num;
    char* str;
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
    TOKEN_VAR TOKEN_ASSIGN exps TOKEN_SEMICOLON
    {
        std::string var($1);
        std::string expr($3);
        all_assgmt.push_back(std::make_pair(var, expr));
    }
    ;

exps:
      exp TOKEN_PLUS exp
        { $$ = strdup((std::string($1) + "+" + std::string($3)).c_str()); }
    | exp TOKEN_MINUS exp
        { $$ = strdup((std::string($1) + "-" + std::string($3)).c_str()); }
    | exp TOKEN_MULTIPLY exp
        { $$ = strdup((std::string($1) + "*" + std::string($3)).c_str()); }
    | exp TOKEN_DIVIDE exp
        { $$ = strdup((std::string($1) + "/" + std::string($3)).c_str()); }
    | exp TOKEN_POWER exp
        { $$ = strdup((std::string($1) + "^" + std::string($3)).c_str()); }
    | exp
        { $$ = strdup($1); }
    ;

exp:
    TOKEN_VAR
        { $$ = strdup($1); }
    | TOKEN_NUM
        { $$ = strdup(std::to_string($1).c_str()); }
    ;

%%

int main() {
    if (yyparse() == 0) { 
        eliminate_dead_code();
    }
    return 0;
}

int yyerror(const char *s) {
    std::cerr << "Error: " << s << std::endl;
    return 0;
}
