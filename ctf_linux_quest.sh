#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
    echo "Не запускай от root! Это опасно."
    exit 1
fi

echo "[+] CTF Linux Quest: Тайна взломанного сервера"
echo "[+] Задачи спрятаны в $HOME/ctf_quest. Удачи!"

# Создаем директорию для квеста
CTF_DIR="$HOME/ctf_quest"
mkdir -p "$CTF_DIR"
cd "$CTF_DIR" || exit

# 1. Стеганография (сообщение в .jpg)
echo "Это просто картинка... Или нет?" > innocent.jpg
echo "FLAG: st3g4n0_1s_c00l" >> innocent.jpg

# 2. Бинарный реверс (простой C-код, скомпилированный)
cat <<'EOF' > mystery_code.c
#include <stdio.h>
#include <string.h>

int main() {
    char pass[20];
    printf("Пароль: ");
    scanf("%s", pass);
    if (strcmp(pass, "s3cr3t_p4ss") == 0) {
        printf("Флаг: b1n4ry_r3v_ftw\n");
    } else {
        printf("Неверно!\n");
    }
    return 0;
}
EOF
gcc mystery_code.c -o mystery_binary
rm mystery_code.c

# 3. Криптография (AES-256 с PBKDF2)
echo "Флаг: cr7pt0_1s_fun" > secret.txt
openssl enc -aes-256-cbc -pbkdf2 -iter 100000 -salt -in secret.txt -out secret.enc -k "p@ssw0rd123"
rm secret.txt

# 4. Скрытый процесс (netcat в фоне)
nc -lvnp 31337 -e /bin/bash &>/dev/null &
echo "Демон слушает порт 31337..." > .ghost_info

# 5. Обфусцированный скрипт (base64 + eval)
cat <<'EOF' > obfuscated.sh
#!/bin/bash
echo "Запускаю странный код..."
eval "$(echo "ZWNobyAnRmxhZzogb2JmdXNjYXRpb25fcm9ja3Mn" | base64 -d)"
EOF
chmod +x obfuscated.sh

# 6. Файл-ловушка (удаляется при чтении)
cat <<'EOF' > README.txt
echo "Этот файл самоуничтожится..."
rm -f README.txt
EOF

# Финальный флаг (если все решено)
cat <<'EOF' > .final_flag.txt
Финальный флаг: CTF{linux_j0urn3y_3nds_h3r3}
EOF

echo "[+] Квест установлен! Ищи тайны в $CTF_DIR."
