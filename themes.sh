#!/bin/bash

theme_path=~/.config/alacritty/themes

for i in $(ls ${theme_path})
do
	cat ${theme_path}/$i | egrep -q "^#\sColors\s\(.+\)"
	if [[ $? -eq 1 ]];then
		name="$(echo $i | awk -F "." '{print $NR}')"
		sed -i "1i\# Colors (${name})" ${theme_path}/$i
	else
				
		continue
	fi
done
