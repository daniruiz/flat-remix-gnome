#!/bin/sh

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

VERSION=41.1

echo
printf " $YELLOW[ i ]$RESET Upstream version $VERSION\n"
echo

while read file;
do
	echo
	printf " $GREEN[ * ]$RESET Downloading file $file\n"
	wget https://gitlab.gnome.org/GNOME/gnome-shell/raw/$VERSION/data/theme/$file -O $file --quiet
	sed 's/resource:\/\/\/org\/gnome\/shell\/theme/assets/g' -i $file

	if [ -f $file.patch ]
	then
		printf " $YELLOW[ ~ ]$RESET Apply patch\n"
		patch $file $file.patch --quiet
	fi
done <<- EOF
	pad-osd.css
	gnome-shell-high-contrast.scss
	gnome-shell-sass/_colors.scss
	gnome-shell-sass/_common.scss
	gnome-shell-sass/_drawing.scss
	gnome-shell-sass/_widgets.scss
	gnome-shell-sass/widgets/_a11y.scss
	gnome-shell-sass/widgets/_app-grid.scss
	gnome-shell-sass/widgets/_base.scss
	gnome-shell-sass/widgets/_buttons.scss
	gnome-shell-sass/widgets/_calendar.scss
	gnome-shell-sass/widgets/_check-box.scss
	gnome-shell-sass/widgets/_corner-ripple.scss
	gnome-shell-sass/widgets/_dash.scss
	gnome-shell-sass/widgets/_dialogs.scss
	gnome-shell-sass/widgets/_entries.scss
	gnome-shell-sass/widgets/_hotplug.scss
	gnome-shell-sass/widgets/_ibus-popup.scss
	gnome-shell-sass/widgets/_keyboard.scss
	gnome-shell-sass/widgets/_login-dialog.scss
	gnome-shell-sass/widgets/_looking-glass.scss
	gnome-shell-sass/widgets/_message-list.scss
	gnome-shell-sass/widgets/_misc.scss
	gnome-shell-sass/widgets/_network-dialog.scss
	gnome-shell-sass/widgets/_notifications.scss
	gnome-shell-sass/widgets/_osd.scss
	gnome-shell-sass/widgets/_overview.scss
	gnome-shell-sass/widgets/_panel.scss
	gnome-shell-sass/widgets/_popovers.scss
	gnome-shell-sass/widgets/_screen-shield.scss
	gnome-shell-sass/widgets/_scrollbars.scss
	gnome-shell-sass/widgets/_search-entry.scss
	gnome-shell-sass/widgets/_search-results.scss
	gnome-shell-sass/widgets/_slider.scss
	gnome-shell-sass/widgets/_switcher-popup.scss
	gnome-shell-sass/widgets/_switches.scss
	gnome-shell-sass/widgets/_tiled-previews.scss
	gnome-shell-sass/widgets/_window-picker.scss
	gnome-shell-sass/widgets/_workspace-switcher.scss
	gnome-shell-sass/widgets/_workspace-thumbnails.scss
EOF
