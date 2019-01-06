#!/bin/sh

TMP="/tmp/flat-remix-gnome"
mkdir -p "$TMP"

for scss in sass/*.scss
do
  scss --sourcemap=none -C -q $scss "$TMP"/$(basename ${scss%%.scss}).css
done


cp -f "$TMP"/gnome-shell.css ../Flat-Remix/gnome-shell/gnome-shell.css
cp -f "$TMP"/gnome-shell-dark.css ../Flat-Remix-Dark/gnome-shell/gnome-shell.css
cp -f "$TMP"/gnome-shell-darkest.css ../Flat-Remix-Darkest/gnome-shell/gnome-shell.css
cp -f "$TMP"/gnome-shell-miami.css ../Flat-Remix-Miami/gnome-shell/gnome-shell.css
cp -f "$TMP"/gnome-shell-miami-dark.css ../Flat-Remix-Miami-Dark/gnome-shell/gnome-shell.css

for i in assets/*
do
  cp -rf "$i"/* "../${i#assets/}/gnome-shell/assets/"
done

sudo cp -rf ../Flat-Remix* /usr/share/themes

gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix"
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'Main.loadTheme();'
