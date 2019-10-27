#!/bin/sh

USAGE="
$(basename "$0") [--login-background FILE]
    Generate Flat-Remix gnome-shell theme variants

    Options:
      --login-background FILE    use a custom login background image
      --sync-login-background    use gnome settings lock background as login background image
      --blur N                   apply gaussian blur to login background image (default 2.5)
      -r, --rebuild-theme        regenerate theme CSS files
      -h, --help                 show this help text
"


TMP="/tmp/flat-remix-gnome"
LOGIN_BACKGROUND=''
BLUR=6

while [ $# -gt 0 ]
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
			echo "$USAGE"
			exit 0
			;;
	esac
done


rm -rf "$TMP"
mkdir -p "$TMP"

# Build CSS files
if [ -n "$REBUILD_CSS" ]
then
	for scss in sass/*.scss
	do
		scss --sourcemap=none -C -q "$scss" css/"$(basename "${scss%%.scss}")".css
	done
fi

for css in css/Flat-Remix*.css
do
	cp -f "$css" ../"$(basename "${css%.css}")"/gnome-shell/gnome-shell.css
done

# Copy assets
if [ -n "$SYNC_LOGIN_BACKGROUND" ]
then
	LOGIN_BACKGROUND="$(printf \
			$(dconf read /org/gnome/desktop/screensaver/picture-uri | \
					sed -e 's/file:\/\///' -e 's/%/\\x/g' -e "s/'//g"))"
fi
[ "${LOGIN_BACKGROUND##*.}" = xml ] && LOGIN_BACKGROUND=''
echo
echo LOGIN_BACKGROUND:
echo $LOGIN_BACKGROUND
if [ -n "$LOGIN_BACKGROUND" ]
then
	if [ "$BLUR" -lt 1 ] || [ "$BLUR" -eq 1 ]
		then convert -gaussian-blur 0x"${BLUR}" "$LOGIN_BACKGROUND" "$TMP"/login-background;
		else convert -scale 10% -gaussian-blur 0x"${BLUR}" -resize 1000% "$LOGIN_BACKGROUND" "$TMP"/login-background;
	fi
fi
for assets in assets/*
do
	target=../"${assets#assets/}"/gnome-shell/assets
	rm -f "$target"/*
	cp -rf "$assets"/* "$target"
	[ -n "$LOGIN_BACKGROUND" ] && cp -f "$TMP"/login-background "$target"/login-background
done

# Generate gresource files
cp -r assets/* "$TMP"
cp css/* "$TMP"
sed "s/assets/resource:\/\/\/org\/gnome\/shell\/theme/g" -i "$TMP"/*.css
find "$TMP" -name "Flat-Remix*" -type d | while IFS= read -r theme
do
	[ -n "$LOGIN_BACKGROUND" ] && cp -f "$TMP"/login-background "$theme"/login-background
	cp gnome-shell-theme.gresource.xml "$theme"
	cp "$TMP"/"$(basename "$theme")".css "$theme"/gnome-shell.css
	cp "$TMP"/gnome-shell-high-contrast.css "$theme"
	cp pad-osd.css "$theme"
	(cd "$theme" && glib-compile-resources gnome-shell-theme.gresource.xml)
	cp "$theme"/gnome-shell-theme.gresource ../"$(basename "$theme")"
done
