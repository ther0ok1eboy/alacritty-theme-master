#!/bin/bash

####################################################

ALACRITTY_PATH=~/.config/alacritty/alacritty.yml
THEME_PATH=~/.config/alacritty/themes

####################################################


help_option(){
	echo -e "
	Usage: alacritty_themes [OPTION]...\n	
	OPTION: 
	\t[EMPTY]: randomly switch into the themes\n
	\tall/-a/--all: show all themes name\n
	\thelp/-h/--help: show help information\n
	\tshow/--show: show main information of config file\n
	\tsize/-s/--size [FONT_SIZE]: change the alacritty font size\n
	\ttheme/-t/--theme [THEME_NAME]: switch into the special themes\n
	
	TODO: font/-f/--font [FONT_NAME]: change the alacritty font\n
	\t[EMPTY]: randomly change the alacritty font\n"
	
}

all_option(){

	ls ~/.config/alacritty/themes/ | awk '{print $1}' | awk -F "." '{print $1}' | more
}


name_option(){
	if [[ $1 == "" ]]
	then
		echo -e "Usage: alacritty_themes name/-t/-name [THEME_NAME]\n"
		exit 1
	fi
	
	THEME_NAME_PATH="$THEME_PATH/$1.yaml"

	copy_to_file $THEME_NAME_PATH
}


copy_to_file(){

	COLOR_START_LINE=$(cat $ALACRITTY_PATH | grep -E -n "^#\sColors\s\(.+\)" | awk -F ":" '{print $1}')
	COLOR_END_LINE=$(cat $ALACRITTY_PATH | grep -E -n "^\s+white:" | tail -n 1 | awk '{print $1}' | awk -F ":" '{print $1}')
	
	if [[ $COLOR_START_LINE == "" || $COLOR_START_LINE -lt 1 ]]; then
		cat $1 >> $ALACRITTY_PATH
	else
		TRAILING=$(echo $COLOR_START_LINE | awk '{print $NF}')
		sed -i "${TRAILING},${COLOR_END_LINE}d" $ALACRITTY_PATH
		cat $1 >> $ALACRITTY_PATH
	fi

	COLOR_THEME="$(echo $1 | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')"
	echo -e "\nSwitch to ${COLOR_THEME} alacritty theme"

}

do_random(){
	RD=$(($RANDOM%$1))
	echo $RD
}


empty_option(){

	THEME_ARRAY=($(ls ~/.config/alacritty/themes/ | awk '{print $1}'))
	THEME_ARRAY_LEN=${#THEME_ARRAY[*]}
	
	RANDOM_NUMBER=$(do_random $THEME_ARRAY_LEN)
	
	THEME_NAME=${THEME_ARRAY[$RANDOM_NUMBER]}

	THEME_NAME_PATH="$THEME_PATH/$THEME_NAME"
	
	copy_to_file $THEME_NAME_PATH
	
}

size_option(){

	if [[ $1 == "" ]]
	then
		echo -e "Usage: alacritty_themes size/-s/--size [FONT_SIZE]: change the alacritty font size\n"
		exit 1
	fi
	
	SIZE_NOW=$(cat $ALACRITTY_PATH | grep -E "^\s+size:\s[1-9][0-9]")
	
	sed -i "s/${SIZE_NOW}/  size: $1/g" $ALACRITTY_PATH

}

show_option(){
	FONT_NAME="$(grep -E "^\s+family: " ${ALACRITTY_PATH} | awk '{print $2,$3,$4,$5}')"
	FONT_SIZE=$(grep -E "^\s+size:\s[1-9][0-9]" ${ALACRITTY_PATH} | awk '{print $2}')
	START_SHELL="$(grep -E "^\s+program:" ${ALACRITTY_PATH} | awk '{print $2}')"
	START_DIR="$(grep -E "^working_directory:" ${ALACRITTY_PATH} | awk '{print $2}')"
	COLOR_THEME="$(grep -E "^#\s+Colors\s\(.+\)" ${ALACRITTY_PATH} | awk -F "(" '{print $2}')"

	echo ${COLOR_THEME//)/ }
}


OPTION=$1

case $OPTION in
	"")
		empty_option
	;;
	"theme"|"-t"|"--theme")
		name_option $2
	;;
	"help"|"-h"|"--help")
		help_option
	;;
	"size"|"-s"|"--size")
		size_option $2
	;;
	"all"|"-a"|"--all")
		all_option
	;;
	"show"|"--show")
		show_option
	;;
	*)
		help_option
		exit 1
	;;
esac


