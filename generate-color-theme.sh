#!/bin/sh

RED='\033[1;31m'
BLUE='\033[1;36m'
GREEN='\033[1;32m'
ORANGE='\033[1;33m'
UNDERLINE='\033[3;4m'
RESET='\033[0m'

printf $BLUE
printf '___________.__          __    __________               .__         \n'; sleep 0.1
printf '\_   _____/|  | _____ _/  |_  \______   \ ____   _____ |__|__  ___ \n'; sleep 0.1
printf ' |    __)  |  | \__  \\   __\  |       _// __ \ /     \|  \  \/  / \n'; sleep 0.1
printf ' |     \   |  |__/ __ \|  |    |    |   \  ___/|  Y Y  \  |>    <  \n'; sleep 0.1
printf ' \___  /   |____(____  /__|    |____|_  /\___  >__|_|  /__/__/\_ \ \n'; sleep 0.1
printf '     \/              \/               \/     \/      \/         \/ \n'; sleep 0.1
printf $RESET

if [ $# -lt 2 ]
then
  printf "    ${GREEN}Usage:${RESET} ${UNDERLINE}$0${RESET} ${ORANGE} <HIGHLIGHT_HEX_COLOR> <HIGHLIGHT_TEXT_HEX_COLOR>${RESET}\n"
  printf "                                                                                                                    \n"
  printf "        ${GREEN}Example:${RESET} ${UNDERLINE}$0${RESET} ${ORANGE}'#123456' '#987654'${RESET}                        \n"
  EXIT=1
fi

command -v make > /dev/null \
  || { printf "   ${RED} !! YOU NEED TO INSTALL ${RESET}make\n"; EXIT=1; }
command -v sassc > /dev/null \
  || { printf "   ${RED} !! YOU NEED TO INSTALL ${RESET}sassc\n"; EXIT=1; }
command -v glib-compile-resources > /dev/null \
  || { printf "   ${RED} !! YOU NEED TO INSTALL ${RESET}glib-compile-resources\n"; EXIT=1; }

[ -z $EXIT ] || exit 1


sleep 1

eval export COLOR=$1
eval export TEXT_COLOR=$2

rm -rf themes/*
make -j build
