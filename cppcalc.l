%option noyywrap
%{
# include <cstdlib>

# include "cppcalc-ctx.hh"
# include "cppcalc.tab.hh"

#define YY_DECL int yylex(yy::cppcalc::semantic_type *yylval, \
    yy::cppcalc::location_type *yylloc, cppcalc_ctx &ctx)

# define YY_USER_ACTION  yylloc->columns (yyleng);

typedef yy::cppcalc::token token;
extern int myatoi(int radix, char *s);

%}

%%

%{
     // start where previous token ended
     yylloc->step ();
%}

"+"	{ return token::ADD; }
"-"	{ return token::SUB; }
"*"	{ return token::MUL; }
"/"	{ return token::DIV; }
"|"     { return token::ABS; }
"("     { return token::OP; }
")"     { return token::CP; }
[0-9]+	{ yylval->ival = myatoi(ctx.getradix(), yytext); return token::NUMBER; }

\n      { yylloc->lines(1); return token::EOL; }

  /* skip over comments and white space */
"//".*  |
[ \t]   {  yylloc->step (); }

.	{ printf("Mystery character %c\n", *yytext); }
%%