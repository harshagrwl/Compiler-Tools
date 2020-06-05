%{
	int isComment = 0;
	int keywordCount = 0;
	int identifierCount = 0;
	int operatorCount = 0;
	int stringCount = 0;
	int numCount = 0;
%}

identifier [a-zA-Z_][a-zA-Z0-9_]*
KEYWORD auto|const|default|enum|extern|register|return|sizeof|static|struct|typedef|union|volatile|break|continue|goto|else|switch|if|case|default|for|do|while|char|double|float|int|long|short|signed|unsigned|void
Hex [o][x|X][0-9A-F]+
Oct [o][0-9]+

%%

#.* {printf("%s is a Preprocessor Directive\n", yytext);}

"for\(" {keywordCount++;} {printf("for is a Keyword\n");}

{KEYWORD} {keywordCount++;} {printf("%s is a Keyword\n", yytext);}

"/*" {isComment = 1;} {printf("%s */ is a Multiline Comment\n", yytext); comment();}
"//".* {printf("// is a Single Line Comment\n");}

";" {printf("\; is Present\n");}

{identifier}\( {if (!isComment) printf("%s is a Function\n", yytext);}

\{ {if (!isComment) printf("Block Begins\n");}
\} {if (!isComment) printf("Block Ends\n");}

{identifier} {identifierCount++;} {if (!isComment) printf("%s is an Identifier\n", yytext);}

[0-9!@`~$#%&*][a-zA-Z0-9_]+ {if (!isComment) printf("%s is an Invalid Identifier\n", yytext);}

\".*\" {stringCount++;} {if (!isComment) printf("%s is a String\n", yytext);}

[0-9]+ {numCount++;} {if (!isComment) printf("%s is a Number\n", yytext);}
{Hex} {numCount++;} {if (!isComment) printf("%s is a Number\n", yytext);}
{Oct} {numCount++;} {if (!isComment) printf("%s is a Number\n", yytext);}

\)(\:)? {if( !isComment) printf("\n"); ECHO;}
\( {printf("\(\n");}

= |
, |
\+ |
\- |
\* |
\/ {operatorCount++;} {if (!isComment) printf("%s is an Operator\n", yytext);}

\<= | \>= | \< | == |
\> {operatorCount++;} {if (!isComment) printf("%s is a Comparison Operator\n", yytext);}

%%

int main()
{
	char fileName[100];
	printf("Enter the name of the file to open: ");
	scanf("%s", fileName);

	FILE* fp = fopen(fileName, "r");
	if (!fp)
	{
		printf("File could not be opened\n");
		exit(0);
	}

	yyin = fp;
	printf("\n");
	yylex();

	printf("\nNumber of keywords: %d\n", keywordCount);
	printf("\nNumber of operators: %d\n", operatorCount);
	printf("\nNumber of identifiers: %d\n", identifierCount);
	printf("\nNumber of strings: %d\n", stringCount);
	printf("\nNumber of numbers: %d\n", numCount);
}

int yywrap()
{
	return 1;
}

void comment()
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
            {
            	isComment = 0;
                return;
            }

            if (c == 0)
                break;
        }
    printf("Unterminated Comment\n");
    exit(-1);
}