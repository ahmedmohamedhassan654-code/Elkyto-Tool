#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# SILENT AUTO INSTALLER
# ==========================================
clear
echo -e "\033[1;33m[*] Starting up...\033[0m"

# تثبيت الأدوات الأساسية في الخلفية
(
    pkg update -y > /dev/null 2>&1
    pkg install -y curl nmap whois python git > /dev/null 2>&1
) &
INSTALL_PID=$!

sleep 2
echo -e "\r\033[1;32m[+] Ready! \033[0m"
sleep 1

# ==========================================
# COLORS
# ==========================================
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# ==========================================
# MENU
# ==========================================
show_menu() {
    clear
    echo -e "${RED}"
    echo "███████╗██╗     ██╗  ██╗██╗   ██╗████████╗ ██████╗ "
    echo "██╔════╝██║     ██║ ██╔╝╚██╗ ██╔╝╚══██╔══╝██╔═══██╗"
    echo "█████╗  ██║     █████╔╝  ╚████╔╝    ██║   ██║   ██║"
    echo "██╔══╝  ██║     ██╔═██╗   ╚██╔╝     ██║   ██║   ██║"
    echo "███████╗███████╗██║  ██╗   ██║      ██║   ╚██████╔╝"
    echo "╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝    ╚═════╝ "
    echo -e "${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}               💀 ELKYTO RX7 - IP INTELLIGENCE 💀               ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${RED}  [1] ${YELLOW}IP Info & Maps Link      ${PURPLE}[🌍]${NC}"
    echo -e "${RED}  [2] ${YELLOW}Basic Port Scan          ${PURPLE}[🔍]${NC}"
    echo -e "${RED}  [3] ${YELLOW}WHOIS Lookup             ${PURPLE}[📄]${NC}"
    echo -e "${RED}  [4] ${YELLOW}Fast Aggressive Scan     ${PURPLE}[💀]${NC}"
    echo -e "${RED}  [5] ${YELLOW}Deep OSINT (GhostTrack)  ${PURPLE}[👻]${NC}"
    echo -e "${RED}  [6] ${WHITE}Exit ❌${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════════════${NC}"
}

# ==========================================
# MAIN LOGIC
# ==========================================
while true; do
    show_menu
    read -p "Select option [1-6]: " CHOICE
    if [[ "$CHOICE" == "6" ]]; then
        exit 0
    elif [[ "$CHOICE" =~ ^[1-5]$ ]]; then
        break
    fi
done

echo ""

case $CHOICE in
    1)
        read -p "Enter Target IP or Domain: " TARGET
        echo -e "\n${CYAN}[*] Fetching IP Info...${NC}"
        RESPONSE=$(curl -s "http://ip-api.com/json/$TARGET?fields=status,message,country,regionName,city,zip,lat,lon,timezone,isp,org,as,query")
        echo "$RESPONSE" | python3 -m json.tool
        LAT=$(echo "$RESPONSE" | grep -oP '"lat":\s*\K[0-9.-]+')
        LON=$(echo "$RESPONSE" | grep -oP '"lon":\s*\K[0-9.-]+')
        if [ -n "$LAT" ] && [ -n "$LON" ]; then
            echo -e "\n${GREEN}[+] Google Maps Link:${NC}"
            echo -e "${CYAN}https://www.google.com/maps?q=$LAT,$LON${NC}"
        fi
        ;;
    2)
        read -p "Enter Target IP or Domain: " TARGET
        echo -e "\n${CYAN}[*] Scanning Ports (Fast)...${NC}"
        nmap -Pn -F -sV $TARGET
        ;;
    3)
        read -p "Enter Target IP or Domain: " TARGET
        echo -e "\n${CYAN}[*] Fetching WHOIS Info...${NC}"
        whois $TARGET
        ;;
    4)
        read -p "Enter Target IP or Domain: " TARGET
        echo -e "\n${CYAN}[*] Launching Fast Aggressive Scan...${NC}"
        nmap -Pn -T5 -A --top-ports 1000 $TARGET
        ;;
    5)
        echo -e "\n${CYAN}[*] Checking GhostTrack...${NC}"
        
        # لو الأداة مش موجودة، ننزلها في الخلفية
        if [ ! -d "$HOME/GhostTrack" ]; then
            echo -e "${YELLOW}[*] Not found. Installing in background...${NC}"
            (
                git clone https://github.com/HunxByts/GhostTrack.git > /dev/null 2>&1
                cd $HOME/GhostTrack
                pip install -r requirements.txt > /dev/null 2>&1
            ) &
            INSTALL_PID=$!
            
            # شاشة تحميل
            while kill -0 $INSTALL_PID 2>/dev/null; do
                echo -ne "\r${CYAN}[*] Installing GhostTrack... ${NC}"
                sleep 1
            done
            echo -e "\r${GREEN}[+] Installed successfully! ${NC}"
        fi

        echo -e "\n${GREEN}[+] Starting GhostTrack...${NC}"
        cd $HOME/GhostTrack
        python3 GhostTR.py
        cd $HOME
        ;;
esac

echo -e "\n${GREEN}[+] Done.${NC}"
