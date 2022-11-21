#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H
#include <string.h>

typedef enum {integer, character, doub} basic_type;


typedef struct _t1{
	char name[32];
	char type[32];
	struct _t1 *next;
} table_element;

typedef struct table{
	char nome[65535];
	char tipo[32];
	struct table* next_table;
	table_element* table_element;
} table;

table_element *insert_el(table_element* class_element, char *str, char *tipo);
void show_table();
table_element *search_el(char *str);

#endif
