%{
 int nb_ligne=1, col=1 , niv=0;
 
 int yylex();
%}
%token idf cstint bool aff cstboolean  cstreel cstchar mc_char mc_int mc_float acov acofr vg oprt oprtcomp  gm mc_import  pt  prent prsor  oprtlog dp mc_if saut true_bloc
 
%start S
%%
S : LISTE_BIB saut  CODE 
   { printf("EXIT WITH 0"); YYACCEPT; }
;
LISTE_BIB : mc_import gm idf pt idf gm LISTE_BIB
          |
;

CODE : PDEC CODE 
     | PINST CODE
	 | 
;
PDEC  : DEC_VAR 
      | DEC_TAB
;
DEC_VAR : TYPE  LISTE_IDF
        | idf aff CST
;
DEC_TAB : TYPE idf acov cstint acofr  
;
TYPE : mc_int
     | bool
     | mc_char 
     | mc_float
;
CST : cstint
    | cstreel
    | cstboolean
    | cstchar
;
PINST : INST_AFF saut   {printf("\n AFF RECONNU \n ");}
      |  IFCOND   {printf("\n CONDITION RECCONU \n ");}
	  |
;
LISTE_IDF : idf vg LISTE_IDF
          | idf
;
INST_AFF : idf aff EXPRESSION 
         |idf acov CST acofr aff EXPRESSION 
;
EXPRESSION : idf
| CST
| idf oprt EXPRESSION
| CST oprt EXPRESSION
| prent EXPRESSION prsor 
| EXPRESSION oprtcomp EXPRESSION
;
CONDITION : OPLOG1  EXPRESSION oprtcomp  EXPRESSION OPLOG
                     |cstboolean 
;					 

OPLOG: oprtlog CONDITION  
             |  
;
OPLOG1: oprtlog 
      | 
;
IFCOND: mc_if prent CONDITION prsor dp saut  true_bloc PINST BLOCKS {printf("condition juste");}
;
BLOCKS : true_bloc PINST BLOCKS
       | CODE
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
    printf ("Erreur Syntaxique la ligne %d  \n ",nb_ligne);
 }
