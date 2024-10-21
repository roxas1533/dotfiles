#!bin/bash
set -ue

_header() {
	echo -e "${GREEN}"
	cat <<"EOF"
 ____       _               
/ ___|  ___| |_ _   _ _ __  
\___ \ / _ \ __| | | | '_ \ 
 ___) |  __/ |_| |_| | |_) |
|____/ \___|\__|\__,_| .__/ 
                     |_|    

EOF
}
_check_distribution() {
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		if [ $ID = "arch" ]; then
			echo "Arch Linux"
		else
			echo "Not Arch Linux"
			exit 1
		fi
	else
		echo "Not Arch Linux"
		exit 1
	fi
}

install_config() {
	echo "Installing config..."
	echo "Installing yay..."
	if type "yay" >/dev/null 2>&1; then
		echo "yay is already installed"
	else
		echo "Installing yay..."
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si
		cd ..
		rm -rf yay
	fi

	echo "Installing neovim..."
	yay -S neovim

	echo "Copying config files..."
	if type "git" >/dev/null 2>&1; then
		git clone https://github.com/roxas1533/dotfiles.git
		cp -r dotfiles/.config/ ~/
	else
		echo "git is not installed"
		exit 1
	fi
}

validation_args() {
	if [ $# -ne 1 ]; then
		echo "Usage: $0 {config|endeavouros}"
		exit 1
	fi
	_check_distribution
	case $1 in
	config)
		install_config
		;;
	endeavouros)
		echo "Installing Endeavouros..."
		;;
	*)
		echo "Invalid argument"
		exit 1
		;;
	esac
}

validation_args $@
