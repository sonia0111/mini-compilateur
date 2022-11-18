%{
#include <string.h>
#include "parti_syntaxique.tab.h"
extern int nb_ligne;
extern int col;
extern int niv;
int first=0;
int blocks(int longeur){
    if(longeur >= niv+4){
	return 0;
	} 
	return 1;
}

int strToInt (const char str[])
{
    int i, int_value, fin_result,Result = 0;
    if (str[0] == '(')
    {
	  if(str[1] == '-'){
        for (i = 2; str[i] >= '0' && str[i] <= '9'; ++i)
        {   
            int_value = str[i] - '0';
            Result = Result * 10 + int_value;
            fin_result = Result * (-1);
        }
      }
      else if(str[1] == '+'){
        for (i = 2; str[i] >= '0' && str[i] <= '9'; ++i)
        {   
            int_value = str[i] - '0';
            Result = Result * 10 + int_value;
            fin_result = Result;
        }
	  }
	  
	  return fin_result;
    }
	else return 0;
}
%}
bloc "    "*
commantaire "#"(.|[ ])*
chiffre [0-9]
carectere [a-zA-Z]
entier {chiffre}+|"("("+"|"-"){chiffre}+")"
boulean "True"|"False"
reel {chiffre}+"."{chiffre}+
char "'"[^']"'"
idf [a-zA-Z]({carectere}|{chiffre})*
operateur_arth "+"|"-"|"*"|"/"
operateur_log "or"|"not"|"And"
operateur_comp ">"|"<"|">="|"<="|"=="|"!="
%option noyywrap
%%
{commantaire} ;
int {
     col=col+yyleng;
     printf("mot cle integer reconnu \n");
	 return mc_int;
	}
bool {
      col=col+yyleng;
      printf("mot cle boolean reconnu \n");
	  return bool;
	 }
float {
       col=col+yyleng;
       printf("mot cle float reconnu \n");
	   return mc_float;
	  }
char {
      col=col+yyleng;
      printf("mot cle char reconnu \n");
	  return mc_char;
	 }
while {
       col=col+yyleng; 
       printf("mot cle while reconnu \n");
	  }
for {
     col=col+yyleng;
     printf("mot cle for reconnu \n");
	}
"in range" {
            col=col+yyleng;
            printf("mot cle in range reconnu \n");
		   }
if {
    col=col+yyleng;
    printf("mot cle if reconnu \n");
	niv=col-yyleng;
	first=1;
	printf("%d\n",niv);
	return mc_if;
   }
else {
      col=col+yyleng;
      printf("mot cle else reconnu \n");
	 }
{operateur_arth} {
                  col=col+strlen(yytext);
                  printf("operateur arethmetique reconnu \n");
				  return oprt;
				 }
{operateur_log} {
                 col=col+strlen(yytext);
                 printf("operateur logique reconnu \n");
				 return oprtlog;
				}
{operateur_comp} {
                  col=col+strlen(yytext);
                  printf("operateur comparaison reconnu \n");
				  return oprtcomp;
				 }
{entier} {
          if(atoi(yytext)<=32767 && strToInt(yytext)>(-32769) && strToInt(yytext)<32768)
		    {printf("entier reconnu %s \n",yytext);
			return cstint;}
		  else
		    printf("erreur lexical a la ligne %d  la col %d entite %s un entier doit etre entre -32769 et 32768 \n",nb_ligne,col, yytext);
		    col=col+strlen(yytext);
		}
{boulean} {
           col=col+strlen(yytext);
           printf("boolean reconnu \n");
		   return cstboolean;
		  }
{reel} {
        col=col+strlen(yytext);
        printf("reel reconnu \n");
		return cstreel;
	   }
{char} {
        col=col+strlen(yytext);
        printf("char reconnu \n");
		return cstchar;
       }
"import" { col=col+strlen(yytext);
           printf("mot cle import  reconnu \n");
	       return mc_import;
        }	 
"=" {
     col=col+strlen(yytext);
     printf("affectation reconnu \n");
	 return aff;
    }
"\"" { col=col+strlen(yytext);
     printf("gm reconnu \n");
	 return gm;
}
"," {
     col=col+strlen(yytext);
     printf("vergule reconnu \n");
	 return vg;
    }
"(" {
     col=col+strlen(yytext);
     printf("parenthese entrant reconnu \n");
	 return prent;
    }
")" {
     col=col+strlen(yytext);
     printf("paranthese sortant reconnu \n");
	 return prsor;
    }
":" {
     col=col+strlen(yytext);
     printf("deux points reconnu \n");
	 return dp;
	}
"[" {
     col=col+strlen(yytext);
     printf("acolade entrant reconnu \n");
	 return acov;
	}
"]" {
     col=col+strlen(yytext);
     printf("acolade sortant reconnu \n");
	 return acofr;
	}
"." {col=col+strlen(yytext);
     printf("point  reconnu \n");
	 return pt;
}
" " col=col+yyleng;
[\n] { 
    nb_ligne++;
	col=0;
	return saut;
   }
{idf} {
       if(yytext[0]<'A' || yytext[0]>'Z')
	    {
	      printf("erreur lexical a la ligne %d  la col %d entite %s un identificateur doit commancer par une majescule \n",nb_ligne,col, yytext);
		}
       else if(strlen(yytext)<=8){
       printf("idf reconnu \n");
	   return idf;
	   }
	   else
	   printf("erreur lexical a la ligne %d  la col %d entite %s un idf ne  doit pas contenir plus de 8 carecteres \n",nb_ligne,col);
	  }
{bloc} { col=col+yyleng;
        printf("bloc reconnue \n");
		if(blocks(yyleng)==0){
		    return true_bloc;
		}}
. {printf("erreur lexical a la ligne %d  la col %d entite %s \n",nb_ligne,col, yytext);
   col++;
  }
%%