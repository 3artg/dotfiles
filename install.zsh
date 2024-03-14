#!/bin/zsh

if ! grep -q 'Ubuntu' /etc/lsb-release; then
  echo 'This script is for Ubuntu.'
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

# fast apt server
$SUDO cp /etc/apt/sources.list /etc/apt/sources.list.bak
$SUDO sed -i 's|/archive.ubuntu|/mirror.kakao|g' /etc/apt/sources.list
$SUDO sed -i 's|/security.ubuntu|/mirror.kakao|g' /etc/apt/sources.list

# default
DEBIAN_FRONTEND=noninteractive
$SUDO apt update
cat docs/ubuntu | awk -v 'RS=\n\n' '1;{exit}' | xargs $SUDO apt install -y

# neovim
$SUDO add-apt-repository -y ppa:neovim-ppa/stable
$SUDO apt update
$SUDO apt install -y neovim

# timezone
$SUDO ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
$SUDO dpkg-reconfigure --frontend noninteractive tzdata

# locale
$SUDO locale-gen en_US.UTF-8
$SUDO update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# debs
wget --directory-prefix=tmp --input-file=etc/debs.txt --quiet --show-progress
$SUDO dpkg -i tmp/*.deb
rm -rf tmp

# antidote
$SUDO chsh -s /bin/zsh
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# symlink
mv ~/.bashrc ~/.bashrc.bak
mv ~/.zshrc ~/.zshrc.bak
stow bash bin git ssh vim zsh tmux python

# ssh public keys
curl https://github.com/ganghe74.keys >> ~/.ssh/authorized_keys

# execute zsh
exec zsh