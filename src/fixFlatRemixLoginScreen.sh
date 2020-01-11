#!/bin/sh

TMP="/tmp/flat-remix-gnome"

rm -rf "$TMP"
mkdir -p "$TMP"

# Copy CSS files
for theme in ../Flat-Remix*
do
  cp "$theme"/gnome-shell/gnome-shell.css "$TMP/$(basename $theme).css"
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
cp ../Flat-Remix-Darkest/gnome-shell/gnome-shell.css "$TMP"/gnome-shell-high-contrast.css
cat << EOF >> "$TMP"/gnome-shell-high-contrast.css
stage {
  -st-icon-style: symbolic;
}

.toggle-switch-us, .toggle-switch-intl {
  background-image: url("resource:///org/gnome/shell/theme/toggle-off-hc.svg");
}

.toggle-switch-us:checked, .toggle-switch-intl:checked {
  background-image: url("resource:///org/gnome/shell/theme/toggle-on-hc.svg");
}
EOF
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
