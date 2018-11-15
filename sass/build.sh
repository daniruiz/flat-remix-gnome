#!/bin/sh

for scss in *.scss
do
  scss --sourcemap=none -q $scss ${scss%%.scss}.css
done


cp -f gnome-shell.css ../Flat-Remix/gnome-shell/gnome-shell.css
cp -f gnome-shell-dark.css ../Flat-Remix-Dark/gnome-shell/gnome-shell.css
cp -f gnome-shell-darkest.css ../Flat-Remix-Darkest/gnome-shell/gnome-shell.css
cp -f gnome-shell-miami.css ../Flat-Remix-Miami/gnome-shell/gnome-shell.css
cp -f gnome-shell-miami-dark.css ../Flat-Remix-Miami-Dark/gnome-shell/gnome-shell.css

sudo cp -Rf ../Flat-Remix* /usr/share/themes

gsettings set org.gnome.shell.extensions.user-theme name "Flat-Remix"
gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'Main.loadTheme();'
