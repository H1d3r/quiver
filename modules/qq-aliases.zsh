#!/usr/bin/env zsh

############################################################# 
# qq-aliases
#############################################################

qq-aliases-help() {
  cat << END

qq-aliases
----------
Helpful aliases and functions.

Package Management
------------------
agu: apt-get update
aguu: apt-get update and upgrade
agi: apt-get install
agr: apt autoremove
agfix: fixes broken packages
mega-update: apt-get full-upgrade, go get all, npm update
repull: pull all git repos in $HOME/tools

Navigation
----------
cd..: up one directory (handles typo)
cls: clear
path: echos path as a string
cp: cp -iv (interactive, verbose)
mv: mv -iv (interactive, verbose)
lf: list files only
ldir: list dirs only

System
------
mounted: show all mounted file systems
mem10: list top 10 procs by mem usage
disk10: list top 10 largest directories in current path (recursive)
df: display disk usage report

Network
-------
hp: shortcut for httprobe -t 3000 -c 50 
pcap: reads a pcap file $1
myip: curls current public IP
netwatch: list listening and established connections
netss: list network connections
netls: lists network sockets
grip: grep for IP addresses

ZSH
---
zprc: print zshrc
zerc: edit zshrc
zsrc: source zshrc

Git
---
gacp: add all, commit (message is $@) and push current repo dir

Media
-----
arec: asciinema start recording
aplay: asciinema start playing

File System
-----------
linestocsv: convert lines to a csv string
csvtolines: convert a csv string to lines
f3: files changed in last 3 days
pa: add directory, $1, to the path (appended to .zshrc)
mcd: mkdir $1 then cd to it
mdd: mkdir using current date
tgf: tail/follow file, $1, grep pattern, $2
rnf: replace $1 with $2 in file, $3
sfu: sort file uniq in place $1
sfip: sort file uniq in place (IP addresses) $1
sfuc: sort file uniq and report count $1
dos2unix: convert file from dos line endings to unix, $1 to $2
unix2dos: convert file from unix line endings to dos, $1 to $2
fsync: rsync folders, $1 to $2
umnt: unmount folder, $1
dt: detach zsh script, $1

Strings
-------
trim1: trims the last 1 chars
trim2: trims the last 2 chars
trim3: trims the last 3 chars
trim4: trims the last 4 chars

END
}

# packages
alias agu="sudo apt-get update"
alias aguu="sudo apt-get update && sudo apt-get upgrade"
alias agi="sudo apt-get install"
alias agr="sudo apt autoremove"
alias agfix="sudo apt-get install --fix-broken && sudo apt-get autoremove && sudo apt-get update"
alias mega-update="sudo apt-get update && sudo apt-get full-upgrade && go get -u all && sudo npm install npm@latest -g && sudo n stable"
alias repull="cd \$HOME/tools; for d in \$(ls -d */);do cd \$d && git pull && cd - ; done; cd"

#nav
alias cd..="cd ../"
alias cls="clear"
alias path="echo -e \${PATH//:/\\n}"
alias cp="cp -iv"
alias mv="mv -iv"
alias lf="ls -l | egrep -v '^d'"
alias ldir='ls -d */'

#sys
alias mounted="sudo mount | column -t"
alias mem10="qq-aliases-sys-mem10"
alias disk10="qq-aliases-sys-disk10"
alias df='df -mTh'

#network
alias hp="httprobe -t 3000 -c 50 "
alias pcap="sudo tcpdump -r"
alias myip="qq-aliases-net-public-ip-curl"
alias netwatch="qq-aliases-net-watch-netstat"
alias netss="qq-aliases-net-ss"
alias netls="qq-aliases-net-lsof"
alias grip="grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'"

#zsh
alias zprc="cat ~/.zshrc"
alias zerc="nano ~/.zshrc"
alias zsrc="source ~/.zshrc"

#git
alias gacp="qq-aliases-git-add-commit-push"

#media
alias arec="asciinema rec"
alias aplay="asciinema play"

# files and directory
alias linestocsv="paste -s -d, -"
alias csvtolines="tr ',' '\n'"
alias f3="sudo find /etc /var -mtime -3"  #files changed in last 3 days
alias pa="qq-aliases-path-add"
alias mcd="qq-aliases-make-dir-cd"
alias mdd="mkdir $(date -I)-$(date +%R)"
alias tgf="qq-aliases-tail-grep-follow"
alias rnf="qq-aliases-replace-in-file"
alias sfu="qq-aliases-sort-file-uniq"
alias sfip="qq-aliases-sort-file-uniq-ip"
alias sfuc="qq-aliases-sort-file-uniq-counts"
alias dos2unix="qq-aliases-dos-to-unix"
alias unix2dos="qq-aliases-unix-to-dos"
alias fsync="qq-aliases-rsync-folders"
alias umnt="qq-aliases-unmount"
alias dt="qq-aliases-dtach"
alias fs1="find . -type f -size +1M"

# out

alias trim1="sed 's/.$//'"
alias trim2="sed 's/..$//'"
alias trim3="sed 's/...$//'"
alias trim4="sed 's/....$//'"

# functions

qq-aliases-path-add() { echo "export PATH=\$PATH:$1" | tee -a ~/.zshrc }  
qq-aliases-make-dir-cd() { mkdir -p "$1" && cd "$1"; }      
qq-aliases-tail-grep-follow() { tail -f $1 | grep --line-buffered $2 }       
qq-aliases-replace-in-file() {print -z "sed 's/$1/$2/g' $3"} #replace $1 with $2 in file $3
qq-aliases-sort-file-uniq() { cat $1 | sort -u -o $1 }  
qq-aliases-sort-file-uniq-ip() { cat $1 | sort -u | sort -V -o $1 } 
qq-aliases-sort-file-uniq-counts() {cat $1 | sort | uniq -c | sort -n}
qq-aliases-dos-to-unix() { tr -d '\015' < $1 > $2 }
qq-aliases-unix-to-dos() { sed -e 's/$/\r/' $1 > $2 } 
qq-aliases-rsync-folders() { rsync -avu $1/ $2 }
qq-aliases-unmount() { fusermount -u $1 }

#network
qq-aliases-net-public-ip-curl() { curl icanhazip.com }     
qq-aliases-net-watch-netstat() { print -z "_ watch -n 0.3 'netstat -pantlu | grep \"ESTABLISHED\|LISTEN\"' "}
qq-aliases-net-ss() { print -z "_ ss -plunt" }
qq-aliases-net-lsof() { print -z "_ lsof -P -i -n "}

#scans
qq-aliases-scan-gnmap-to-hosts() { grep -i "open" $1 | cut -d' ' -f2 > $2 }

#git
qq-aliases-git-add-commit-push() {
  git add .
  git commit -m "$@"
  git push
}

#usage
qq-aliases-sys-mem10() { print -z "_ ps aux | sort -rk 4,4 | head -n 10 | awk '{print \$4,\$11}' "}
qq-aliases-sys-disk10() { print -z "_ du -sk ./* | sort -r -n | head -10"}

#jobs
qq-aliases-dtach() { dtach -A $1 /bin/zsh }

