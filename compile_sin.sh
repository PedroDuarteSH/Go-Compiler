#!/bin/sh

# run lex and compile the resulting C analyser
lex $1
yacc -d $2
# cc -o $3 y.tab.c lex.yy.c

# 'lex' and 'gcc' are commonly available too