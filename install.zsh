#!/bin/zsh

#
# Caution
# This code is not tested.
#

if ! grep -q 'Ubuntu 18.04' /etc/lsb-release; then
  echo 'This script is for Ubuntu 18.04. (aistages)'
  echo 'Current OS:' $(lsb_release -d | cut -f2)
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

# locale
$SUDO locale-gen en_US.UTF-8

# default
$SUDO apt update
cat docs/ubuntu | awk -v 'RS=\n\n' '1;{exit}' | xargs $SUDO apt install -y

# neovim
$SUDO add-apt-repository ppa:neovim-ppa/stable
$SUDO apt update
$SUDO apt install -y neovim

# nodejs
curl -fsSL https://deb.nodesource.com/setup_16.x | $SUDE bash - &&\
$SUDO apt install -y nodejs
$SUDO npm i -g serve diff-so-fancy

# debs
for url in `cat etc/debs.txt`; do
  curl -LJO $url
done
$SUDO dpkg -i *.deb
rm *.deb

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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