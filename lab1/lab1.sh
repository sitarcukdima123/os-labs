whoami; uname -a; uptime
pwd; ls -la / | head -15; ls -la ~
cd /etc && ls | head; cd ~/os-lab1
rm -rf demo; mkdir demo && cd demo
echo "hello operating systems" > note.txt
cp note.txt copy.txt; mv copy.txt renamed.txt; ls -l
chmod 600 note.txt; ls -l; rm renamed.txt; cd ..
ps aux | head; ps aux | wc -l; ps -p 1 -o pid,comm
sleep 300 & PID=$!
ps -ef | grep sleep | grep -v grep
head -20 /proc/$PID/status
grep VmRSS /proc/$PID/status
kill $PID
free -h; head -6 /proc/meminfo
df -h; lsblk; du -sh ~/os-lab1
ls -l /dev | head; mount | head
