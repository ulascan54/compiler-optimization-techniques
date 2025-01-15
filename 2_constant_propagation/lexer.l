%{
#include "y.tab.h"
%}

%option noyywrap

%%
[a-zA-Z][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return TOKEN_VAR; }
[0-9]+                { yylval.num = atoi(yytext); return TOKEN_NUM; }
"="                   { return TOKEN_ASSIGN; }
"+"                   { return TOKEN_PLUS; }
"-"                   { return TOKEN_MINUS; }
"*"                   { return TOKEN_MULTIPLY; }
"/"                   { return TOKEN_DIVIDE; }
"^"                   { return TOKEN_POWER; }
";"                   { return TOKEN_SEMICOLON; }
[ \t\n]+              { /* ignore whitespace */ }
.                     { printf("ERROR: Unknown character: %c\n", *yytext); }
%%
