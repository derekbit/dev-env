#!/usr/bin/env sh

WORKINGDIR=$HOME/.derekorbit

# Check and install pre-requitesite tools
preq_install ()
{
    local dist=`awk -F= '/^NAME/{print $2}' /etc/os-release`

    for tool in $@; do
        which $tool > /dev/null
        if [ "$?" != "0" ]; then
            echo "Install '$tool' at '$dist'..."

            case "$dist" in
                "\"Ubuntu\"")
                    apt-get install -y $tool
                    ;;
                "\"CentOS Linux\"")
                    yum install -y $tool
                    ;;
                *)
                    exit 1
                    ;;
            esac
        fi
    done
}

install_fugitive ()
{
    mkdir -p $HOME/.vim/pack/tpope/start
    git clone https://tpope.io/vim/fugitive.git $HOME/.vim/pack/tpope/start/fugitive
    pushd $HOME/.vim/pack/tpope/start
    vim -u NONE -c "helptags fugitive/doc" -c q
    popd
}

install_ohmyzsh ()
{
    pushd $HOME
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    sed -i s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"bira\"/g ~/.zshrc
    chsh -s $(which zsh)
    popd
}

install_ohmytmux ()
{
    pushd $HOME
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
    popd
}

install_vim ()
{
    git clone https://github.com/derekorbit/development-environment.git $WORKINGDIR

    ln -sfn $WORKINGDIR/vimrc $HOME/.vimrc
    ln -sfn $WORKINGDIR/vim $HOME/.vim
}

cleanup ()
{
    [ ! -d "$WORKINGDIR" ] || rm -rf "$WORKINGDIR"
    [ ! -d "$HOME/.vim" ] || rm -rf "$HOME/.vim"
    [ ! -d "$HOME/.vimrc" ] || rm -rf "$HOME/.vimrc"
    [ ! -d "$HOME/.oh-my-zsh" ] || rm -rf "$HOME/.oh-my-zsh"
    [ ! -d "$HOME/.tmux" ] || rm -rf "$HOME/.tmux"
    [ ! -d "$HOME/.tmux.conf" ] || rm -rf "$HOME/.tmux.conf"
    [ ! -d "$HOME/.tmux.conf.local" ] || rm -rf "$HOME/.tmux.conf.local"
}

#### Main function ####
cleanup

preq_install vim git cscope ctags tmux zsh

install_vim
install_fugitive
install_ohmytmux
install_ohmyzsh

echo "Finish and enjoy it!!!"
