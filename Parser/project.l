%option yylineno

%{
	#include <stdio.h>
	#include "y.tab.h"
	#include <math.h>
%}

%%
"#include"([ ]+)?((<(\\.|[^>])+>)|(\"(\\.|[^"])+\"))					                                    {return HEADER;}
"void"|"char"|"short"|"int"|"long"|"float"|"double"|"signed"|"unsigned"										{return type_const;}	
"const"																										{return qual_const;}
"if"																										{return IF;}
"else"																										{return ELSE;}
"for"																										{return FOR;}
"do"																										{return DO;}
"while"																										{return WHILE;}
"continue"																									{return CONTINUE;}
"break"																										{return BREAK;}
"return"																									{return RETURN;}
"||" 																										{return or_const;}
"&&"																										{return and_const;}
"=="|"!="																									{return eq_const;}
"<="|">="																									{return rel_const;}
">>"|"<<"																									{return shift_const;}
"++"|"--"																									{return inc_const;}
";"|"="|","|"{"|"}"|"("|")"|"["|"]"|"*"|"+"|"-"|"/"|"?"|":"|"&"|"|"|"^"|"!"|"~"|"%"|"<"|">"					{return yytext[0];}
"*="|"/="|"+="|"%="|">>="|"-="|"<<="|"&="|"^="|"|="															{return PUNC;}
[0-9]+																										{return int_const;}
[0-9]+"."[0-9]+																								{return float_const;}	
"'"."'"																										{return char_const;}
[a-zA-z_][a-zA-z_0-9]*			 																			{return id;}
\"(\\.|[^\"])*\"																							{return string;}
"//"(\\.|[^\n])*[\n]																						;
[/][*]([^*]|[*]*[^*/])*[*]+[/]                                                                              ;
[ \t\n]																										;
%%

int yywrap(void)
{
    return 1;
}