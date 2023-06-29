#!/bin/bash

HOSTNAME=$(echo $(hostname) | tr '[:lower:]' '[:upper:]')

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'

CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
YELLOW='\033[0;33m'

NC='\033[0m' # No Color

COLOR=$NC

CONTAINER=$(cat /proc/self/mountinfo\
    | grep "/docker/containers/"\
    | head -1 | awk '{print $4}'\
    | sed 's/\/var\/lib\/docker\/containers\///g'\
    | sed 's/\/resolv.conf//g' | cut -c1-12)
INSTALL=$(stat -c %w / | cut -c1-10)
NAME=$(sudo dmidecode -s system-product-name)
OS=$((lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1)
SERIAL=$(sudo dmidecode -s system-serial-number | cut -c1-19)
UUID=$(sudo dmidecode -s system-uuid | cut -c1-23)
VERSION=$(sudo dmidecode -s system-version | cut -c1-12)

echo -e "\nDefine server role: "
read ROLE

echo -e "\nAdmin user email: "
read MAIL

echo -e "\nSelect platform: "

echo -e "\n\
    1) Docker container\n\
    2) Virtual machine\n\
    3) Bare metal server\n"

read PLATFORM

figlet $HOSTNAME -f smmono12 > banner.tmp
echo -e " OS: $OS" >> banner.tmp
echo -e "   · Server Role: ${MAGENTA}$ROLE${NC}" >> banner.tmp
echo -e "   · Admin: ${MAGENTA}$MAIL${NC}" >> banner.tmp

case $PLATFORM in
    1)
        COLOR=$BLUE
        echo -e "   · Host: ${COLOR}Docker Engine${NC}" >> banner.tmp
        echo -e "   · Container ID: ${COLOR}$CONTAINER${NC}" >> banner.tmp
        ;;
    2)
        COLOR=$GREEN
        echo -e "   · Host: ${COLOR}$VERSION${NC}" >> banner.tmp
        echo -e "   · UUID: ${COLOR}$UUID${NC}" >> banner.tmp
        ;;
    3)
        COLOR=$RED
        echo -e "   · Host: ${COLOR}$NAME${NC}" >> banner.tmp
        echo -e "   · Serial: ${COLOR}$SERIAL${NC}" >> banner.tmp
        ;;
esac

echo -e " Installation date: ${YELLOW}1$INSTALL HE${NC}" >> banner.tmp

reset

cat banner.tmp | boxes -d parchment > motd

rm banner.tmp
cat motd