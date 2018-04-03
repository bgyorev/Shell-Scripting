#!/bin/sh

originFile="$1"
directory=$(dirname "$originFile")
bigicon=$(basename "$originFile")

appIcons=("appicon20x20" "appicon20x20@2x" "appicon20x20@3x" "appicon29x29" "appicon29x29@2x" "appicon29x29@3x" "appicon40x40" "appicon40x40@2x" "appicon40x40@3x" "appicon60x60@2x" "appicon60x60@3x" "appicon76x76" "appicon76x76@2x" "appicon83.5x83.5@2x")

for appIcon in ${appIcons[@]}
do
	
	numbers=$(echo $appIcon | egrep -o '[0-9]{2}[\.]?[0-9]?x[0-9]{2}[\.]?[0-9]?[\@]?[0-9]?x?')

	resolution=$(echo $numbers | cut -dx -f1)

	scale=$(echo $numbers | egrep -o '[\@][0-9][x]' | cut -d@ -f2 | cut -dx -f1)
	
	if [[ -z $scale ]]; then
		scale=1
	fi

	finalRes=$resolution
	if [[ $resolution = "83.5" ]]; then 
		finalRes=167
	else
		finalRes=$((scale * $resolution))
	fi

	newIcon="${directory}/${appIcon}.png"
	cp "$originFile" "$newIcon"
	
	sips -s dpiHeight 100.0 -s dpiWidth 100.0 -Z "$finalRes" "${newIcon}"
done

exit 0
