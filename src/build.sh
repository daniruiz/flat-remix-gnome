#!/bin/sh

TMP="/tmp/flat-remix-gnome"

rm -rf "$TMP"
mkdir -p "$TMP"

# Build CSS files
for scss in sass/*.scss
do
  scss --sourcemap=none -C -q "$scss" "$TMP"/"$(basename ${scss%%.scss})".css
done

for css in "$TMP"/Flat-Remix*.css
do
 cp -f "$css" ../"$(basename "${css%.css}")"/gnome-shell/gnome-shell.css
done

# Copy assets
for assets in assets/*
do
  target=../"${assets#assets/}"/gnome-shell/assets
  rm -f "$target"/*
  cp -rf "$assets"/* "$target"
done

# Generate gresource files
cp -r assets/* "$TMP"
sed "s/assets/resource:\/\/\/org\/gnome\/shell\/theme/g" -i "$TMP"/*.css
for theme in "$TMP"/Flat-Remix*/
do
  cp gnome-shell-theme.gresource.xml "$theme"
  cp "$TMP"/"$(basename ${theme%/})".css "$theme"gnome-shell.css
  cp "$TMP"/gnome-shell-high-contrast.css "$theme"
  cp pad-osd.css "$theme"
  (cd "$theme" && glib-compile-resources gnome-shell-theme.gresource.xml)
  cp "$theme"/gnome-shell-theme.gresource ../$(basename "$theme")
done
