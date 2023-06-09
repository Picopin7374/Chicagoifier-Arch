#!/bin/bash

stty intr ''
set +m

if [ "$1" == "--userland" ]; then
    useris="$(whoami)"
    
    #Cleanup prior installs
    rm -rf /home/$useris/.themes/Chicago95 /home/$useris/.icons/Chicago95 /home/$useris/.Chicago95PlusFiles /home/$useris/.Chicago95Plus /home/$useris/.chicago95plus "/home/$useris/.icons/Chicago95 Animated Hourglass Cursors" "/home/$useris/.icons/Chicago95_Cursor_Black" "/home/$useris/.icons/Chicago95_Cursor_White" "/home/$useris/.icons/Chicago95_Emerald" "/home/$useris/.icons/Chicago95 Standard Cursors" "/home/$useris/.icons/Chicago95 Standard Cursors Black"
    rm -f /home/$useris/.local/share/xfce4/terminal/colorschemes/Chicago95.theme /home/$useris/Downloads/Chicago95.theme /home/$useris/.local/share/applications/chicago95plus.desktop /home/$useris/.chicago95plus /home/$useris/.config/gtk-3.0/gtk.css ~/.config/autostart/chicago95-startup.desktop
    if grep -q "Windows 95" /home/$useris/.bashrc; then
        rm -f /home/$useris/.bashrc
        cp -f /etc/skel/.bashrc /home/$useris/.bashrc
    fi
    
    if [ ! -d "$2" ] || [ -z "$2" ]; then
        echo "No. There is no folder here."
        exit 1
    fi
    
    cd "$2/Chicago95"
    
    clear
    
    rm -f /home/$useris/.local/share/xfce4/terminal/colorschemes/Chicago95.theme
    while [ ! -f /home/$useris/.local/share/xfce4/terminal/colorschemes/Chicago95.theme ]; do
        python3 ./installer.py
        if [ ! -f /home/$useris/.local/share/xfce4/terminal/colorschemes/Chicago95.theme ]; then
            clear
            echo "You cheated not only the script, but yourself.

You didn't grow.
You didn't Chicagofy.
You tried to troll the script and gained nothing.

You wasted your time.
Nothing was done and nothing was gained.

It's sad that you even bothered trying this.
Now just install the theme already."
        fi
    done
    
    if [ -f /usr/bin/firefox ] && [ -f "$2/chicago95_ie4_theme_yes.xpi" ]; then
        clear
        echo "Opening Firefox to install theme..."
        firefox "file://$2/chicago95_ie4_theme_yes.xpi" >/dev/null 2>&1 &
    fi
    if [ -f /usr/bin/palemoon ]; then
        clear
        echo "Opening Pale Moon to install theme..."
        palemoon "https://addons.palemoon.org/addon/moonscape/" >/dev/null 2>&1 &
    fi

    clear
    echo "Updating User Configs"
    xfconf-query -c xsettings -p /Gtk/DialogsUseHeader -s false
    xfconf-query -c xsettings -p /Net/SoundThemeName -s Chicago95
    
    clear
    echo "Linking backgrounds into Pictures"
    ln -sf /usr/share/Chicago95Backgrounds ~/Pictures/Chicago95
    mkdir ~/.Chicago95PlusFiles
    
    clear
    echo "Copying default theme .theme file into Home"
    cp -f ./Extras/Chicago95.theme ~/Downloads/
    
    clear
    echo "Adding Chicago95 sound to startup"
    mkdir ~/.config; mkdir ~/.config/autostart
    cp -f ./sounds/chicago95-startup.desktop ~/.config/autostart/chicago95-startup.desktop
    chmod +x ~/.config/autostart/chicago95-startup.desktop
    
    clear
    echo "Installing Chicago95 Plus!"
    sed -i 's%"/Pictures/"%"/.Chicago95PlusFiles/"%g' ./Plus/pluslib.py
    rm -rf ~/.Chicago95Plus ~/.chicago95plus
    cp -Rf ./Plus ~/.Chicago95Plus
    echo '#!/bin/bash
zenity --info --title="Chicago95 Plus" --text="Remember: When you Apply or OK, leave the computer alone until it is done.
The more you use the computer, the slower the process is." --no-wrap &
sleep 3
python3 '"$HOME"'/.Chicago95Plus/PlusGUI.py' > ~/.chicago95plus
    mkdir ~/.local; mkdir ~/.local/share; mkdir ~/.local/share/applications
    chmod +x ~/.chicago95plus
    echo "[Desktop Entry]
Version=1.0
Name=Chicago95 Plus!
GenericName=Plus! Theme Manager
Comment=Change the look of your Desktop
Exec=$HOME/.chicago95plus
Terminal=true
X-MultipleArgs=false
Type=Application
Icon=preferences-desktop-theme
Categories=Settings;" > ~/.local/share/applications/chicago95plus.desktop
    chmod +x ~/.local/share/applications/chicago95plus.desktop
    
    clear
    echo "Configuring theme some more"
    mkdir ~/.config; mkdir ~/.config/gtk-3.0
    gtkver=$(dpkg -s libgtk-3-0 | grep '^Version:')
    gtkver=$(echo "${gtkver:11:12}")
    gtkver=$(echo "${gtkver:0:2}")
    if [ "$gtkver" -lt 21 ]; then
		false
    elif [ "$gtkver" -ge 22 ] && [ "$gtkver" -lt 24 ]; then
        cp -f ./Extras/override/gtk-3.22/gtk.css ~/.config/gtk-3.0/gtk.css
    elif [ "$gtkver" -ge 24 ]; then
        cp -f ./Extras/override/gtk-3.24/gtk.css ~/.config/gtk-3.0/gtk.css
    fi
    
    cp -f ./Extras/post_install.txt "$HOME/Desktop/Chicago95 Post-Install"
    
    killall mousepad
    
    clear
    read -p "Please install the themes for the browsers that have been opened by this script. Once done, Press ENTER in this Terminal."
    
    clear
    echo "The system will now restart."
    sudo reboot now
    
    exit 0
    
fi

chicagodir=/
while [ -d "$chicagodir" ]; do
    chicagodir="/tmp/ChicagoStuff$RANDOM"
done
mkdir "$chicagodir"

if [ "$1" == "--rootland" ]; then
echo "This script will now install Chicago95! Please be patient while this script runs, the system will restart once this is finished"


#Get the user who ran this command 'cos it's possible with this simple trick - don't ask me why
useris=$(who | head -n1 | awk '{print $1;}')
if [ "$useris" == "root" ]; then
    echo "You are ment to run the script without sudo."
    exit 1
fi
if [ ! -d "$2" ] || [ -z "$2" ]; then
    echo "There is no folder here."
    exit 1
fi

#Cleanup prior installs
rm -rf /usr/share/themes/Chicago95 /usr/share/icons/Chicago95 /usr/share/plymouth/themes/Chicago95 /usr/share/Chicago95Backgrounds "/usr/share/icons/Chicago95 Animated Hourglass Cursors" "/usr/share/icons/Chicago95_Cursor_Black" "/usr/share/icons/Chicago95_Cursor_White" "/usr/share/icons/Chicago95_Emerald" "/usr/share/icons/Chicago95 Standard Cursors" "/usr/share/icons/Chicago95 Standard Cursors Black" /usr/share/sounds/Chicago95

pacman -Syu
clear
echo "Installing dependencies"
pacman -S git python-svgwrite python-fonttools inkscape python-numpy gnome-session sox libcanberra python curl unzip coreutils
pacman -S libxfce4ui || pacman -S gtk3

clear
echo "Grabbing the theme"
cd /tmp

cd "$2"
git clone https://github.com/grassmunk/Chicago95
chown -hR $useris:$useris "$2"
cd Chicago95

clear
echo "Patching the theme"
sed -i 's%@import url("gtk-titlebars.css");%/*@import url("gtk-titlebars.css");*/%g' Theme/Chicago95/gtk-3.0/gtk.css
sed -i 's%.*@import url("gtk-titlebars_no-csd.css");.*%@import url("gtk-titlebars_no-csd.css");%g' Theme/Chicago95/gtk-3.0/gtk.css
sed -i 's%@import url("gtk-headerbars.css");%/*@import url("gtk-headerbars.css");*/%g' Theme/Chicago95/gtk-3.0/gtk.css
sed -i 's%.*@import url("gtk-headerbars_no-csd.css");.*%@import url("gtk-headerbars_no-csd.css");%g' Theme/Chicago95/gtk-3.0/gtk.css
clear

echo "Grabbing and installing W95FA a modern recreation of Microsoft Sans Serif" 
wget -O /tmp/w95fa-cdnfonts.zip https://www.cdnfonts.com/download/w95fa-cdnfonts.zip
cd /tmp
unzip w95fa-cdnfonts.zip
mkdir /usr/share/fonts/W95FA
mv /tmp/W95FA.otf /usr/share/fonts/W95FA


clear
echo "Installing the theme system-wide"
cp -Rfv ./Theme/Chicago95 /usr/share/themes/
cp -Rfv ./Icons/Chicago95 /usr/share/icons/

clear
echo "Configuring LightDM GTK+ Greeter (the login screen that XFCE uses)"
sudo pacman -S lightdm-gtk-greeter lightdm 
sudo pacman -R sddm
sudo systemctl enable lightdm
echo "[greeter]
background = #008080
theme-name = Chicago95
icon-theme-name = Chicago95
indicators = ~spacer;~session;~language;~a11y;~power
hide-user-image = true
position = 50%,center -60%,center
user-background = false" > /etc/lightdm/lightdm-gtk-greeter.conf

clear
echo "Installing the Chicago95 Plymouth Theme"

cp -Rf ./Plymouth/Chicago95 /usr/share/plymouth/themes/
update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/Chicago95/Chicago95.plymouth 100
update-alternatives --set default.plymouth /usr/share/plymouth/themes/Chicago95/Chicago95.plymouth

clear
echo "Installing sounds"
cp -Rf ./sounds/Chicago95 /usr/share/sounds/
cp -f "./Extras/Microsoft Windows 95 Startup Sound.ogg" /usr/share/sounds/Chicago95/startup.ogg

clear
echo "Installing Wallpapers"
cp -Rf ./Extras/Backgrounds /usr/share/Chicago95Backgrounds
cp -f ./KDE/Splash/chicago95.splashscreen/contents/splash/images/background.jpg /usr/share/Chicago95Backgrounds/background.jpg

clear
echo "Installing extra cursors system-wide..."
cp -Rf ./Cursors/* /usr/share/icons/

true



exit 0
fi

if [ "$(whoami)" == "root" ]; then
    echo "You're not meant to run it as root here."
    exit 1
fi

clear
read -p "Welcome to Chicagofier Arch, an unofficial script that is based of off dominichayes Chicagofier a transformation script that changes the look of XFCE4.

Before we begin, huge shout-outs to grassmunk and everyone else who has contributed to Chicago95. Without all of you this wouldn't be possible to do.

You can find the original repository at https://github.com/grassmunk/Chicago95. The only thing I've made out of all of this is this mere script.

PRESS ENTER to continue. (a 'sudo password' prompt will follow, enter your normal password in it to run the script)

"

sudo bash "$0" --rootland "$chicagodir" && bash "$0" --userland "$chicagodir"
