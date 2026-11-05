#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\033[1;33m[*] Installing Elkyto Tool... Please wait.\033[0m"

curl -sL https://raw.githubusercontent.com/ahmedmohamedhassan654-code/Elkyto-Tool/main/elkyto.sh -o $PREFIX/bin/elkyto

chmod +x $PREFIX/bin/elkyto

echo -e "\033[1;32m[+] Installation Complete!\033[0m"
echo -e "\033[1;36m[*] Type 'elkyto' in Termux to run the tool.\033[0m"
