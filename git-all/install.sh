#!/bin/bash

: '
    AN INIT FILE FOR GIT-ALL
    dsd
'



# GET DEPENDENCIES (linux and macos)

# Determine OS name
os="$(uname)" # default for macos
# Desktop manager
pkg_manager=""

#finds linux distro
if [ -f /etc/os-release ]
then
    source "/etc/os-release"
    os=$ID

# checks if it's android
elif [ ! -z "$(echo $TERMUX_VERSION)" ]
then
    os="android"
fi


# IF LINUX - FIND THE DISTRO
#TODO: dont forget to add sudo
case "$os" in
    # ARCH
    arch)
    pkg_manager="yay -S"        
    ;;

    # MANJARO
    manjaro)
    pkg_manager="sudo pacman -Sy"
    ;;

    # UBUNTU AND DLINUX MINT
    ubuntu | linuxmint)
    pkg_manager="sudo apt install"
    ;;

    # FEDORA
    fedora)
    pkg_manager="sudo dnf install"
    ;;

    # RASBERRY PI
    raspbian)
    pkg_manager="sudo apt-get install"
    ;;

    # CENT OS
    centos)
    pkg_manager="yum -y install"
    ;;

    # MACOS
    Darwin)
    # if brew isn't installed, install it
    if [ -z "$(command -v brew)" ] 
    then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    pkg_manager="brew install"
    ;;

    # android
    android)
    pkg_manager="pkg install"
    ;;
    
esac


#dir path of the executable
#dir="$(realpath $(dirname $0))"
dir="$(pwd)"

# have to do sudo user for linux whereas macos keeps it at home variable

# if os is supported, install the dependencies
if [ ! -z "$pkg_manager" ] 
then
    eval "$pkg_manager shc"
fi

# checking if dependencies are installed 
if [ -z "$(command -v shc)" ]
then
    echo -e "FATAL ERROR:"
    echo -e "   SHC not found.\n   Please install shc and run 'sudo ./$(basename "$0")' again."
    exit 1
fi

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

chmod +x "$dir/git-all.sh"
chmod +x "$dir/git-all.desktop"
chmod +x "$dir/uninstall.sh"

echo -e "COMPILING THE EXECUTABLE..."
shc -f $dir/git-all.sh -o git-all
mv git-all /usr/bin/


echo -e "MAKING CONFIG FOLDER..."
mkdir -p "$HOME/.config/ez-scripts"
mkdir -p "$HOME/.config/ez-scripts/git-all"

touch "$HOME/.config/ez-scripts/git-all/git-all-sm.sh"
chmod +x "$HOME/.config/ez-scripts/git-all/git-all-sm.sh"

touch "$HOME/.config/ez-scripts/git-all/git-all-sp.sh"
chmod +x "$HOME/.config/ez-scripts/git-all/git-all-sp.sh"

# different installation for macos
#linux only
if [ ! "$os" == "Darwin" ]
then
    # for linux
    echo -e "COPYING THE .DESKTOP FILE..."
    sudo cp -r $dir/git-all.desktop /usr/share/applications
fi




