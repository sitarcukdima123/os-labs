run() { echo; echo "\$ $1"; eval "$1"; }
cd ~/xv6-riscv
echo "===== PART 1: sleep ====="
run 'grep -n "pause\|sleep" user/user.h'
run 'cat user/sleep.c'
run 'grep -n "_sleep" Makefile'
echo; echo "===== PART 2: bash side ====="
rm -rf ~/os-lab4 && mkdir -p ~/os-lab4/cmp && cd ~/os-lab4/cmp
cp ~/xv6-riscv/README .
run 'echo hello > f ; cat < f'
run 'ls | grep READ'
run '(echo a; echo b) | wc'
run 'echo one ; echo two'
run 'echo bg & wait'
run 'ls *'
run 'echo $HOME'
run 'echo "a b"'
run 'mkdir d ; cd d ; ls ..'
cd ~/os-lab4
echo; echo "===== PART 3: args (Linux) ====="
mkdir -p linux && cd linux
cat > args_linux.c << 'EOS'
#include <stdio.h>

int
main(int argc, char *argv[])
{
  printf("argc = %d\n", argc);
  for(int i = 0; i < argc; i++)
    printf("argv[%d] = [%s]\n", i, argv[i]);
  return 0;
}
EOS
touch test1.c test2.c
run 'gcc -o args args_linux.c && ls'
run './args *.c "x y"'
run './args $HOME'
run "./args 'single quoted'"
run './args one   two      three'
echo; echo "===== PART 3: args (xv6 source) ====="
cd ~/xv6-riscv
cat > user/args.c << 'EOS'
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  printf("argc = %d\n", argc);
  for(int i = 0; i < argc; i++)
    printf("argv[%d] = [%s]\n", i, argv[i]);
  exit(0);
}
EOS
grep -q '_args' Makefile || sed -i 's/^\t\$U\/_sleep\\$/&\n\t$U\/_args\\/' Makefile
run 'cat user/args.c'
run 'grep -n "_sleep\|_args" Makefile'
echo; echo "===== PART 4: reading sh.c ====="
run 'wc -l user/sh.c'
run 'grep -n "#define" user/sh.c'
run 'grep -n "case " user/sh.c'
run 'grep -n "cd" user/sh.c'
run 'sed -n "160,175p" user/sh.c'
run 'grep -c "\*" user/sh.c'
run 'grep -n "glob\|getenv\|PATH" user/sh.c; echo "matches: $(grep -c "glob\|getenv\|PATH" user/sh.c)"'
run "grep -n '\\\$' user/sh.c"
