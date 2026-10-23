run() { echo; echo "\$ $1"; eval "$1"; }
mkdir -p ~/os-lab3 && cd ~/os-lab3
echo "===== DATA ====="
for i in $(seq 1 500); do
  echo "2026-10-05 10:$(printf %02d $((i % 60))) user$((i % 7)) $([ $((i % 5)) -eq 0 ] && echo FAIL || echo OK) /page$((i % 4))"
done > access.log
run 'head -3 access.log'
run 'wc -l access.log'
echo; echo "===== PART 1 ====="
run 'type cd'
run 'type ls'
run 'type echo'
run 'which ls'
run 'echo $PATH | tr ":" "\n"'
run 'nosuchprog; echo "exit code: $?"'
run 'ls --help | grep -- " -t "'
echo; echo "===== PART 2 ====="
rm -rf play && mkdir play && cd play
touch a.c b.c file1.txt file2.txt notes.txt "alfa beta.txt"
run 'ls'
run 'echo *.c'
run 'echo file?.txt'
run 'echo [a-b]*'
run 'echo *.xyz'
run 'ls alfa beta.txt'
run 'ls "alfa beta.txt"'
run "echo '\$HOME' \"\$HOME\" \\\$HOME"
run 'echo {1..5}'
run 'echo $((7*6))'
run 'echo "today is $(date +%A), I am $(whoami)"'
run 'touch log{1..3}.txt && ls log*'
cd ..
echo; echo "===== PART 3 ====="
run 'ls /etc /nope > out.txt 2> err.txt'
run 'tail -2 out.txt'
run 'cat err.txt'
run 'ls /etc /nope > all.txt 2>&1'
run 'grep nope all.txt; tail -2 all.txt'
run 'ls /etc /nope 2>&1 > all2.txt'
run 'wc -l < access.log'
run 'wc -l access.log'
run 'ls /nope 2> /dev/null || echo "failed with code $?"'
run 'true && echo "after success"'
run 'false ; echo "always runs"'
run 'sleep 100 &'
run 'jobs'
run 'kill %1'
run 'sleep 0.2; jobs'
echo; echo "===== PART 4: ONE-LINERS ====="
cat > oneliners.sh << 'EOS'
# Q1. How many requests failed?
grep -c FAIL access.log
# Q2. How many different pages were requested, and which?
cut -d' ' -f5 access.log | sort -u | awk '{print} END{print NR, "different pages"}'
# Q3. How many requests did each page get?
cut -d' ' -f5 access.log | sort | uniq -c
# Q4. Which user(s) have the most failed requests, and how many?
grep FAIL access.log | cut -d' ' -f3 | sort | uniq -c | sort -rn | awk 'NR==1{m=$1} $1==m'
# Q5. How many requests did user3 make, and how many failed?
grep -w user3 access.log | awk '{t++; if($4=="FAIL") f++} END{print t" requests, "f" failed"}'
# Q6. Last 3 failed requests: time and user only
grep FAIL access.log | tail -3 | cut -d' ' -f2,3
# Q7. Login shells in /etc/passwd and how many accounts use each
cut -d: -f7 /etc/passwd | sort | uniq -c | sort -rn
# Q8. Why do these differ by exactly one?
ls /etc | wc -l ; ls -l /etc | wc -l ; ls -l /etc | head -1
# Bonus. Failed requests where the minute ends in 0
grep -E ' 10:[0-5]0 user[0-9] FAIL ' access.log | wc -l
EOS
bash -v oneliners.sh 2>&1
echo; echo "===== PART 5: report.sh ====="
cat > report.sh << 'EOS'
#!/bin/bash
# usage: ./report.sh access.log
log=$1
if [ ! -f "$log" ]; then
  echo "no such file: $log" >&2
  exit 1
fi
total=$(wc -l < "$log")
fails=$(grep -c FAIL "$log")
echo "$total requests, $fails failed"
for i in $(seq 0 6); do
  n=$(grep -c "user$i FAIL" "$log")
  echo "user$i: $n failures"
done
EOS
chmod -x report.sh
run 'cat report.sh'
run './report.sh access.log'
run 'chmod +x report.sh && ls -l report.sh'
run './report.sh access.log'
run './report.sh nope.log; echo "exit code: $?"'
cp oneliners.sh report.sh /workspaces/os-labs/ 2>/dev/null
