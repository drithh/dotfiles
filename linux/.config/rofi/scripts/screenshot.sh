#!/usr/bin/env bash

## Copyright (C) 2020-2021 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
export LC_ALL=POSIX LANG=POSIX; . "${HOME}/.owl4ce_var"


rofi_command="rofi -theme themes/sidebar/three-${CHK_ROFI_MOD}.rasi"

time=`date +%Y-%m-%d-%I-%M-%S`
geometry=`xrandr | head -n1 | cut -d',' -f2 | tr -d '[:blank:],cursrent'`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"

# Buttons
screen='' area='' timer=''

MENU="$(printf "${screen}\n${area}\n${timer}\n" | ${rofi_command} -dmenu -selected-row 1)"

# notify
notify_user () {
	if [[ -e "$dir/$file" ]]; then
		dunstify -u low --replace=699 -i /usr/share/archcraft/icons/dunst/picture.png "Saved in $dir"
	else
		dunstify -u low --replace=699 -i /usr/share/archcraft/icons/dunst/picture.png "Screenshot Deleted."
	fi
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		dunstify -t 1000 --replace=699 -i /usr/share/archcraft/icons/dunst/timer.png "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
shotnow () {
	cd ${dir} && sleep 0.5 && maim -u -f png "$file" && xclip -selection clipboard -t image/png ${dir}/"$file"
	notify_user
}

shot5 () {
	countdown '5'
	sleep 1 && cd ${dir} && maim -u -f png "$file" && xclip -selection clipboard -t image/png ${dir}/"$file"
	notify_user
}

shot10 () {
	countdown '10'
	sleep 1 && cd ${dir} && maim -u -f png "$file" && xclip -selection clipboard -t image/png ${dir}/"$file"
	notify_user
}

shotwin () {
	cd ${dir} && maim -u -f png -i `xdotool getactivewindow` "$file" && xclip -selection clipboard -t image/png ${dir}/"$file"
	notify_user
}

shotarea () {
	cd ${dir} && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l "$file" && xclip -selection clipboard -t image/png ${dir}/"$file"
	notify_user
}

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# Variable passed to rofi
# options="$screen\n$area\n$window\n$infive\n$inten"

# chosen="$(echo -e "$options" | $rofi_command -p 'Take A Shot' -dmenu -selected-row 0)"
case $MENU in
    $screen)
		shotnow
        ;;
    $area)
		shotarea
        ;;
    $window)
		shotwin
		;;
    $timer)
		shot5
		;;
esac
