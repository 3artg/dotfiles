#!/bin/zsh

if [[ ! $(lsb_release -d) =~ '.*Ubuntu 18.04.05 LTS' ]]; then
  echo 'This script is for Ubuntu 18.04.05 LTS. (aistages)'
  echo 'Current OS:' $(lsb_release -d | cut -f2)
  exit
fi

if [[ $(pwd) != *dotfiles ]]; then
  echo 'SHOULD BE AT DOTFILES'
  exit
fi

SUDO=''
if (( $EUID != 0 )); then
  SUDO='sudo'
fi

# fast repo server
# cp /etc/apt/sources.list /etc/apt/sources.list.bak

# default
$SUDO apt update
cat docs/ubuntu | awk -v 'RS=\n\n' '1;{exit}' | xargs $SUDO apt install -y

# neovim
$SUDO add-apt-repository ppa:neovim-ppa/stable
$SUDO apt update
$SUDO apt install -y neovim

# nodejs
curl -fsSL https://deb.nodesource.com/setup_19.x | $SUDO -E bash - &&\
$SUDO apt-get install -y nodejs
$SUDO npm i -g serve

# lsd
curl -LJo lsd.deb https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd_0.23.1_amd64.deb
$SUDO dpkg -i lsd.deb
rm lsd.deb

# fd
curl -LJo fd.deb https://github.com/sharkdp/fd/releases/download/v8.5.3/fd_8.5.3_amd64.deb
$SUDO dpkg -i fd.deb
rm fd.deb

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

mv ~/.bashrc ~/.bashrc.bak
mv ~/.zshrc ~/.zshrc.bak
stow bash bin git ssh vim zsh

source ~/.zshrc