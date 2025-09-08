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
	
	echo "Cloning dotfiles..."
	
	# Check if we're on NixOS and ensure git is available
	if [ -f /etc/os-release ] && grep -q "ID=nixos" /etc/os-release; then
		echo "NixOS detected"
		
		# Use nix shell to get git if not available
		if ! type "git" >/dev/null 2>&1; then
			echo "Git not found, using nix shell..."
			NIX_SHELL_GIT="nix shell nixpkgs#git -c"
		else
			NIX_SHELL_GIT=""
		fi
		
		if [ -d "dotfiles" ]; then
			rm -rf dotfiles
		fi
		
		$NIX_SHELL_GIT git clone https://github.com/roxas1533/dotfiles.git
		cd dotfiles
		
		echo "Copying Nix configuration to /etc/nixos..."
		sudo cp -r .config/nix/* /etc/nixos/
		
		# Check if we need to change default user (WSL specific)
		if grep -q "Microsoft" /proc/version 2>/dev/null; then
			echo "WSL environment detected"
			current_user=$(whoami)
			config_user=$(grep "defaultUser" /etc/nixos/configuration.nix | sed 's/.*defaultUser = "\([^"]*\)".*/\1/')
			
			if [ "$current_user" != "$config_user" ]; then
				echo "User change required: $current_user -> $config_user"
				echo "Building configuration with boot option..."
				sudo nixos-rebuild boot --flake /etc/nixos#nixos
				
				echo "Copying dotfiles to target user's home directory..."
				TARGET_HOME="/home/$config_user"
				sudo mkdir -p "$TARGET_HOME"
				sudo cp -r .config/ "$TARGET_HOME/"
				sudo chown -R "$config_user:users" "$TARGET_HOME/.config"
				
				echo ""
				echo "==================== IMPORTANT ===================="
				echo "WSL user change is required. Please run these commands"
				echo "from Windows PowerShell or Command Prompt:"
				echo ""
				echo "  wsl -t NixOS"
				echo "  wsl -d NixOS --user root exit"  
				echo "  wsl -t NixOS"
				echo ""
				echo "After restarting WSL, you will be logged in as: $config_user"
				echo "===================================================="
				cd ..
				rm -rf dotfiles
				exit 0
			fi
		fi
		
		echo "Building and switching to new configuration..."
		sudo nixos-rebuild switch --flake /etc/nixos#nixos
		
		echo "Copying dotfiles to home directory..."
		cp -r .config/ ~/
		
		echo "NixOS configuration applied successfully!"
	else
		echo "Non-NixOS system detected - using traditional installation..."
		
		if ! type "git" >/dev/null 2>&1; then
			echo "git is not installed"
			exit 1
		fi
		
		if [ -d "dotfiles" ]; then
			rm -rf dotfiles
		fi
		git clone https://github.com/roxas1533/dotfiles.git
		cd dotfiles
		
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
		cp -r .config/ ~/
	fi
	
	cd ..
	rm -rf dotfiles
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
