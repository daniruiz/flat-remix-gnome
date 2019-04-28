#!/bin/bash

USAGE="$(basename "$0") [--login-background FILE]
    Generate Flat-Remix gnome-shell theme variants

    Options:
      --login-background FILE \t use a custom login background image
      --sync-login-background \t use gnome settings lock background as login background image
      --blur N                \t apply gaussian blur to login background image (default 2.5)
      -r, --rebuild-theme     \t regenerate theme CSS files
      -h, --help              \t show this help text"


TMP="/tmp/flat-remix-gnome"
LOGIN_BACKGROUND=''
BLUR=6

while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
		--login-background)
			LOGIN_BACKGROUND="$2"
			shift # past argument
			shift # past value
			;;
		--sync-login-background)
			SYNC_LOGIN_BACKGROUND=1
			shift # past argument
			;;
		-r|--rebuild-theme)
			REBUILD_CSS=1
			shift # past argument
			;;
		--blur)
			BLUR="$2"
			shift # past argument
			shift # past value
			;;
		-h|--help)
			echo -e "$USAGE"
			exit 0
			;;
	esac
done


rm -rf "$TMP"
mkdir -p "$TMP"

# Build CSS files
if (( $REBUILD_CSS ))
then
	for scss in sass/*.scss
	do
		scss --sourcemap=none -C -q "$scss" css/"$(basename ${scss%%.scss})".css
	done
fi

for css in css/Flat-Remix*.css
do
	cp -f "$css" ../"$(basename "${css%.css}")"/gnome-shell/gnome-shell.css
done

# Copy assets
(( $SYNC_LOGIN_BACKGROUND )) && LOGIN_BACKGROUND=$(dconf read /org/gnome/desktop/screensaver/picture-uri | sed -e "s/file:\/\///" -e "s/'//g")
if [[ $LOGIN_BACKGROUND != '' ]]
then
	if [[ $BLUR < 1 || $BLUR == 1 ]]
		then convert -gaussian-blur 0x${BLUR} $LOGIN_BACKGROUND "$TMP"/login-background;
		else convert -scale 10% -gaussian-blur 0x${BLUR} -resize 1000% $LOGIN_BACKGROUND "$TMP"/login-background;
	fi
fi
for assets in assets/*
do
	target=../"${assets#assets/}"/gnome-shell/assets
	rm -f "$target"/*
	cp -rf "$assets"/* "$target"
	[[ $LOGIN_BACKGROUND != '' ]] && cp -f "$TMP"/login-background "$target"/login-background
done

# Generate gresource files
cp -r assets/* "$TMP"
cp css/* "$TMP"
sed "s/assets/resource:\/\/\/org\/gnome\/shell\/theme/g" -i "$TMP"/*.css
for theme in "$TMP"/Flat-Remix*/
do
	[[ $LOGIN_BACKGROUND != '' ]] && cp -f "$TMP"/login-background "$theme"/login-background
	cp gnome-shell-theme.gresource.xml "$theme"
	cp "$TMP"/"$(basename ${theme%/})".css "$theme"gnome-shell.css
	cp "$TMP"/gnome-shell-high-contrast.css "$theme"
	cp pad-osd.css "$theme"
	(cd "$theme" && glib-compile-resources gnome-shell-theme.gresource.xml)
	cp "$theme"/gnome-shell-theme.gresource ../$(basename "$theme")
done
