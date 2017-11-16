#!/bin/sh

for scss in *.scss
do
  sassc -a $scss ${scss%%.scss}.css
done

gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'Main.loadTheme();'
