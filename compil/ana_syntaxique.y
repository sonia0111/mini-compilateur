%{
 int nb_ligne=1, col=1;
 int yylex();
%}
%token idf cstint bool aff cstboolean  cstreel cstchar mc_char mc_int mc_float acov acofr vg oprt oprtcomp

%start S
%%
S : DEC S
   | CONDITION
   |
   { printf(" Le programme est correcte syntaxiquement"); YYACCEPT; }
;
DEC : DEC_VAR
    | DEC_TAB 	
;
DEC_VAR : TYPE  LISTE_IDF
         | idf aff cst
;
TYPE : int
     | bool
     | char 
     |float
;
CST : cstint
  | cstreel
  |cstboolean
  | cstchar
 ;
LISTE_IDF : idf vg LISTE_IDF
          | idf
		 
;
DEC_TAB : TYPE idf acov cstint acofr 
;
CONDITION: PART oprtcomp PART CONDITION
        |
;
PART : idf 
    |CST
;
%%
main ()
{
   yyparse();  
 }
 yywrap ()
 {}
 int yyerror ( char*  msg )  
 {
    printf ("Erreur Syntaxique a ligne %d a colonne %d \n", nb_ligne,col);
  }