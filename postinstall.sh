#!/usr/bin/env bash
# ----------------------------- VARIABLES ----------------------------- #

URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

DIRETORY_DOWNLOADS="$HOME/Downloads/programas"

SOFTWARES=(
  snapd
  virtualbox
  conky 
  conky-all 
  conky-manager 
  conky-manager-extra
  dconf-editor
  obs-studio
  remmina
  terminator
  timeshift
  vlc
  ttf-mscorefonts-installer
  thunderbird
  gnome-tweaks
  bleachbit
  git
  npm
  zsh
  powerline 
  fonts-powerline
  rclone
  flatpak
  gnome-software-plugin-flatpak
  cryptomator
  preload
)
# ---------------------------------------------------------------------- #

# ----------------------------- Pre functions ----------------------------- #
## Removing eventuals locks in the apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adding third part repositos and Snap support (Driver Logitech, Lutris e Drivers Nvidia)##
wget -nc "$URL_WINE_KEY"
sudo apt-key add winehq.key
sudo add-apt-repository ppa:linuxmint-tr/araclar
sudo add-apt-repository multiverse
sudo add-apt-repository ppa:sebastian-stenzel/cryptomator
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# ---------------------------------------------------------------------- #

# ----------------------------- EXEC ----------------------------- #
## Update the repos after adding the new repos ##
sudo apt update -y

## Download and install external softwares ##
mkdir "$DIRETORY_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORY_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORY_DOWNLOADS/*.deb

# Instalar programas no apt
for software in ${SOFTWARES[@]}; do
  if ! dpkg -l | grep -q $software; then # Only install if its not installed yet
    apt install "$software" -y
  else
    echo "[INSTALADO] - $software"
  fi
done

sudo apt install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y

## Install pacotes Flatpak ##
flatpak install flathub com.obsproject.Studio -y

## Installl pacotes Snap ##
sudo snap install spotify
sudo snap install slack --classic
sudo snap install skype --classic
sudo snap install heroku --classic
sudo snap install --classic code
sudo snap install photogimp
sudo snap install rambox
sudo snap install bitwarden
sudo snap install insomnia
sudo snap install node --classic --channel=8

# ----------------------------- PÓS-INSTALL ----------------------------- #
## Finalizingo, update and cleaning##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #
# -------------- Configuring and customizing the software -------------- #

sudo ufw enable #enable firewall

# sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# ---------------------------------------------------------------------- #
