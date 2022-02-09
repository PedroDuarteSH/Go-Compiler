import os

def main():
    path = "./meta3"
    test_files = os.listdir(path)

    exec_name = "gocompiler"
    os.system(f"lex {exec_name}.l")
    os.system(f"yacc -ydtv {exec_name}.y")
    os.system(f"cc -o {exec_name} y.tab.c lex.yy.c tree.c symbol_table.c ASTnoted.c")



    if not os.path.exists(f"{path}/outputs"):
        os.system(f"mkdir {path}/outputs")


    for i in range(0, len(test_files), 2):
        fname = test_files[i][:-4]
        if(fname != "out"):
            os.system(f'./gocompiler -s < {path}/{fname}.dgo  | diff {path}/{fname}.out ->  {path}/outputs/{fname}.diff ')
            os.system(f'./gocompiler -s < {path}/{fname}.dgo  >  {path}/outputs/{fname}.out')
            print(test_files[i] + " TESTED")

if __name__ == "__main__":
    main()

