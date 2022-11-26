#!/bin/zsh

if [[ $(pwd) != *dotfiles ]]; then
  echo 'SHOULD BE AT DOTFILES'
  exit
fi

SUDO=''
if (( $EUID != 0 )); then
  SUDO='sudo'
fi

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

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

rm ~/.bashrc ~/.zshrc
stow bash bin git ssh vim zsh

source ~/.zshrc