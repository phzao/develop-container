#!/bin/sh

USERSPACE="/home/dev"

mkdir -p $USERSPACE/.oh-my-zsh/custom/themes
mkdir -p $USERSPACE/.local/share/fonts
mkdir -p $USERSPACE/.config/fontconfig/conf.d
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#install tools
mkdir -p $USERSPACE/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions $USERSPACE/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $USERSPACE/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

git clone git://github.com/wting/autojump.git
cd autojump
./install.py

cd $USERSPACE

if ! git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
then
  echo "Theme install fail"
else
  if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]
  then
    echo "Theme installed"
  else
    echo "Theme not installed"
  fi
fi

wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
mv PowerlineSymbols.otf $USERSPACE/.local/share/fonts/PowerlineSymbols.otf

wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
fc-cache -vf $USERSPACE/.local/share/fonts
mv 10-powerline-symbols.conf $USERSPACE/.config/fontconfig/conf.d/10-powerline-symbols.conf

chown -R dev:dev .config .zshrc .tmux.conf .local

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

pip install --user neovim

#tmux custom
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
