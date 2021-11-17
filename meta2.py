import os
path = "./meta2"
test_files = os.listdir(path)

exec_name = "gocompiler"
os.system(f"lex {exec_name}.l")
os.system(f"yacc -dtv {exec_name}.y")
os.system(f"cc -o {exec_name} y.tab.c lex.yy.c tree.c")



if not os.path.exists(f"{path}/outputs"):
    os.system(f"mkdir {path}/outputs")


for i in range(0, len(test_files), 2):
    fname = test_files[i][:-4]
    if(fname != "out"):
        os.system(f'./gocompiler -t < {path}/{fname}.dgo | diff {path}/{fname}.out ->  {path}/outputs/{fname}.diff')
        print(test_files[i] + " TESTED")
