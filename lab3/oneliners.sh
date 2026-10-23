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
