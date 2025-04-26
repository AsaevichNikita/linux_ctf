#!/bin/bash

# -= 1. INIT =-
if [ "$(id -u)" -eq 0 ]; then
    echo "Never run as root! Aborting." >&2
    exit 1
fi

# -= 2. SETUP =-
CTF_DIR="$HOME/darkadmin_ctf"
mkdir -p "$CTF_DIR"
cd "$CTF_DIR" || exit

# -= 3. TASKS =- 

## == TASK 1: Encrypted Flag (AES-256) ==
echo "Flag 1: part1_$(openssl rand -hex 3)" > flag1.txt
openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -salt -in flag1.txt -out task1.enc -pass pass:"D4rkP4ss!" 2>/dev/null
rm flag1.txt

## == TASK 2: Binary Reverse (Crackme) ==
cat <<'EOF' > task2.c
#include <stdio.h>
#include <string.h>
int main() {
    char input[20];
    printf("Password: ");
    scanf("%19s", input);
    if (strcmp(input, "B1n4ryR3v!") == 0) {
        printf("Flag 2: part2_$(openssl rand -hex 3)\n");
    } else {
        printf("Access Denied!\n");
    }
    return 0;
}
EOF
gcc task2.c -o task2.bin
rm task2.c

## == TASK 3: Hidden Process ==
( sleep 1337 & ) 2>/dev/null
echo "Flag 3: part3_$(openssl rand -hex 3)" > .hidden_flag3

## == TASK 4: Network Mystery ==
echo "Flag 4: part4_$(openssl rand -hex 3)" | nc -l -p 31337 -q 1 2>/dev/null &

## == TASK 5: Obfuscated Script ==
echo -n "Flag 5: part5_$(openssl rand -hex 3)" | base64 > task5.enc

## == TASK 6: Permission Puzzle ==
mkdir -p task6_dir
echo "Flag 6: part6_$(openssl rand -hex 3)" > task6_dir/flag.txt
chmod 000 task6_dir/flag.txt

## == TASK 7: Git Secret ==
mkdir -p task7
cd task7 || exit
git init >/dev/null 2>&1
echo "Flag 7: part7_$(openssl rand -hex 3)" > secret.txt
git add secret.txt >/dev/null 2>&1
git commit -m "Initial commit" >/dev/null 2>&1
rm secret.txt
cd ..

## == TASK 8: SQL Injection Test ==
sqlite3 task8.db "CREATE TABLE secrets (id INT, flag TEXT);"
sqlite3 task8.db "INSERT INTO secrets VALUES (1, 'Flag 8: part8_$(openssl rand -hex 3)');"

## == TASK 9: Memory Dump ==
echo "Flag 9: part9_$(openssl rand -hex 3)" > task9.txt
strings task9.txt > task9.dump
rm task9.txt

## == TASK 10: Final Puzzle ==
echo "Flag 10: part10_$(openssl rand -hex 3)" > final_flag.txt
zip --password "F1n4lP4ss!" task10.zip final_flag.txt >/dev/null 2>&1
rm final_flag.txt

# -= 4. FINAL MESSAGE =-
cat <<EOF

▓█████▄  ▄▄▄       ██▀███   ██ ▄█▀ ██▓ ███▄    █ 
▒██▀ ██▌▒████▄    ▓██ ▒ ██▒ ██▄█▒ ▓██▒ ██ ▀█   █ 
░██   █▌▒██  ▀█▄  ▓██ ░▄█ ▒▓███▄░ ▒██▒▓██  ▀█ ██▒
░▓█▄   ▌░██▄▄▄▄██ ▒██▀▀█▄  ▓██ █▄ ░██░▓██▒  ▐▌██▒
░▒████▓  ▓█   ▓██▒░██▓ ▒██▒▒██▒ █▄░██░▒██░   ▓██░
 ▒▒▓  ▒  ▒▒   ▓▒█░░ ▒▓ ░▒▓░▒ ▒▒ ▓▒░▓  ░ ▒░   ▒ ▒ 
 ░ ▒  ▒   ▒   ▒▒ ░  ░▒ ░ ▒░░ ░▒ ▒░ ▒ ░░ ░░   ░ ▒░
 ░ ░  ░   ░   ▒     ░░   ░ ░ ░░ ░  ▒ ░   ░   ░ ░ 
   ░          ░  ░   ░     ░  ░    ░           ░ 
 ░                                                

10 Trials of the Dark Admin:
----------------------------
1. Decrypt task1.enc (AES-256, password hint: 'D4rk' + 'P4ss!')
2. Reverse task2.bin (Password required)
3. Find the hidden process and get flag
4. Connect to localhost:31337
5. Decode task5.enc (Base64)
6. Read task6_dir/flag.txt (Permission denied?)
7. Recover deleted file in task7/.git
8. Extract flag from task8.db (SQL)
9. Analyze task9.dump (strings)
10. Unzip task10.zip (Password: F1n4lP4ss!)

Flags format: partX_[a-z0-9]+
Combine all parts to get the final flag!
EOF
