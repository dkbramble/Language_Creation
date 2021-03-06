%{
	/*****************************************************************
	Bison file for drawing shapes with SDL2, uses Lex tokens to run C code

	@author Dane Bramble
	@version February 2018
	*****************************************************************/
	#include <stdio.h>
	#include "zoomjoystrong.h"
	void yyerror(const char* msg);
	int yylex();
%}
%error-verbose
%start statement_list
/*****************************************************************
 @param i, str, d - value of the token found, to be used to call functions
 *****************************************************************/

%union { int i; char* str; float d;}

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%token FLOAT

%type<i> INT
%type<str> END
%type<str> CIRCLE
%type<str> LINE
%type<str> RECTANGLE
%type<str> SET_COLOR
%type<str> POINT
%type<d> FLOAT

%%
statement_list:	statement
	|	statement statement_list
;

statement: circle_command END_STATEMENT
	|	line_command END_STATEMENT
	|	point_command END_STATEMENT
	|	rectangle_command END_STATEMENT
	|	setcolor_command END_STATEMENT
	|	end_command
;

circle_command: CIRCLE INT INT INT
	{
		if ($2 <= 1024 && $3 <= 768 && $4 <= 768 && $2 >= 0 && $3 >= 0 && $4 >= 0){
			circle($2, $3, $4); //draws circle only if in valid ranges
		}
		else{
			printf("circle inputs are beyond valid screen dimensions\n");
		}
	}
;

line_command: LINE INT INT INT INT
	{
		if ($2 <= 1024 && $3 <= 768 && $4 <= 1024 && $5 <= 768 && $2 >= 0 && $3 >= 0 && $4 >= 0 && $5 >= 0){
			line($2, $3, $4, $5); //draws line only if in valid ranges
		}
		else{
			printf("line inputs are beyond valid screen dimensions\n");
		}
	}
;

point_command: POINT INT INT
	{
		if ($2 <= 1024 && $3 <= 768 && $2 >= 0 && $3 >= 0){
			point($2, $3); //draws point only if in valid ranges
		}
		else{
			printf("point inputs are beyond valid screen dimensions\n");
		}
	}
;

rectangle_command: RECTANGLE INT INT INT INT
	{
		if ($2 <= 1024 && $3 <= 768 && $4 <= 1024 && $5 <= 768 && $2 >= 0 && $3 >= 0 && $4 >= 0 && $5 >= 0){
			rectangle($2, $3, $4, $5); //draws rectangle only if in valid ranges
		} 
		else{
			printf("rectangle inputs are beyond valid screen dimensions\n");
		}
	}
;

setcolor_command: SET_COLOR INT INT INT
	{
		if ($2 <= 255 && $3 <= 255 && $4 <= 255 && $2 >= 0 && $3 >= 0 && $4 >= 0){
			set_color($2, $3, $4); //sets color only if in valid ranges
		}
		else{
			printf("set_color inputs are beyond valid color values\n");
		}
	}
;

end_command: END
	{finish();} //Closes Drawing Panel
;


%%
int main(int argc, char** argv){
	setup();//Opens Drawing Panel
	yyparse(); //parses to find tokens
	return 0;
}
void yyerror(const char* msg){
	fprintf(stderr, "ERROR! %s\n", msg); //prints error message on terminal if syntax is incorrect
}
