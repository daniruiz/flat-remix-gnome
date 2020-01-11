#Create by Github:pontep
#Test Worked on Ubuntu 19.10

#README
#How to change your lock-screen and login theme.
#Make sure flat-remix-gnome folder is on home directory (~/flat-remix-gnome)
#1.Choose your favorite image.
#2.run fixFlat.sh

#-------------------------------------------------------------------------------------------------------------------------------

#The description of step to change lock-screen, login wallpaper shellscript.
#1.User choose favorite image.

#2.Make current lockscreen image blur.
cd ~/flat-remix-gnome
make

#3.Copy lockscreen blur image from ~/flat-remix-gnome/Flat-Remix/gnome-shell/assets to ~/flat-remix-gnome/src/assets/Flat-Remix/
cp -rf ~/flat-remix-gnome/Flat-Remix/gnome-shell/assets/login-background ~/flat-remix-gnome/src/assets/Flat-Remix/

#4.Run fixFlatRemixLoginScreen.sh
cd ~/flat-remix-gnome/src
./fixFlatRemixLoginScreen.sh
cd ..
sudo make install
sudo ln -sf /usr/share/themes/Flat-Remix/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
