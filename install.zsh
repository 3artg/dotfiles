#!/bin/zsh

if ! grep -q 'Ubuntu' /etc/lsb-release; then
  echo 'This script is for Ubuntu.'
  echo 'Current OS:' $(lsb_release -d | cut -f2)
  exit
fi

VER=`lsb_release -r | cut -f2 | cut -d. -f1`
if [[ $VER -eq 18 ]]; then
  NODE_VER=16
elif [[ $VER -eq 22 ]]; then
  NODE_VER=19
else
  echo Cannot specify node version for this Ubuntu version. $VER
  exit
fi

if [[ $(pwd) != *dotfiles ]]; then
  echo 'YOU MUST BE AT DOTFILES TO EXECUTE THIS'
  exit
fi

SUDO=''
if (( $EUID != 0 )); then
  SUDO='sudo'
  SUDOE='sudo -E'
fi

# fast repo server
# $SUDO cp /etc/apt/sources.list /etc/apt/sources.list.bak
# $SUDO sed -i 's|/archive.ubuntu|/mirror.kakao|g' /etc/apt/sources.list
# $SUDO sed -i 's|/security.ubuntu|/mirror.kakao|g' /etc/apt/sources.list

# default
DEBIAN_FRONTEND=noninteractive
$SUDO apt update
cat docs/ubuntu | awk -v 'RS=\n\n' '1;{exit}' | xargs $SUDO apt install -y

# neovim
$SUDO add-apt-repository -y ppa:neovim-ppa/stable
$SUDO apt update
$SUDO apt install -y neovim

# nodejs
curl -fsSL https://deb.nodesource.com/setup_$NODE_VER.x | $SUDOE bash -
$SUDO apt install -y nodejs
$SUDO npm i -g serve

# timezone
$SUDO ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
$SUDO dpkg-reconfigure --frontend noninteractive tzdata

# locale
$SUDO locale-gen en_US.UTF-8

# debs
wget --directory-prefix=tmp --input-file=etc/debs.txt --quiet --show-progress
$SUDO dpkg -i tmp/*.deb
rm -rf tmp

# oh-my-zsh
$SUDO chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/jeffreytse/zsh-vi-mode ~/.oh-my-zsh/custom/plugins/zsh-vi-mode

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# symlink
mv ~/.bashrc ~/.bashrc.bak
mv ~/.zshrc ~/.zshrc.bak
stow bash bin git ssh vim zsh tmux

exec zsh