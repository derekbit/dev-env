#!/usr/bin/env sh

WORKINGDIR=$HOME/.derekorbit

msg ()
{
    printf '%b\n' "$1" >&2
}

success ()
{
    msg "${Green}[✔]${Color_off} ${1}${2}"
}

info ()
{
    msg "${Blue}[➭]${Color_off} ${1}${2}"
}

error ()
{
    msg "${Red}[✘]${Color_off} ${1}${2}"
    exit 1
}

warn ()
{
    msg "${Yellow}[⚠]${Color_off} ${1}${2}"
}

install_prerequisites ()
{
    local dist=`awk -F= '/^NAME/{print $2}' /etc/os-release`

    for tool in $@; do
        which $tool > /dev/null
        if [ "$?" != "0" ]; then
            info "Install '$tool' at '$dist'..."

            case "$dist" in
                "\"Ubuntu\"")
                    sudo apt-get install -y $tool
                    ;;
                "\"CentOS Linux\"")
                    sudo yum install -y $tool
                    ;;
                *)
                    info "Unsupported distribution: $dist"
                    exit 1
                    ;;
            esac
        fi
    done
}

configure_golang ()
{
    info "Configure golang"

    wget "https://dl.google.com/go/$(curl 'https://golang.org/VERSION?m=text').linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $(curl 'https://golang.org/VERSION?m=text').linux-amd64.tar.gz

    mkdir -p $HOME/go
}

configure_ohmyzsh ()
{
    info "Configure oh-my-zsh"

    [ ! -e "$HOME/.oh-my-zsh" ] || rm -rf "$HOME/.oh-my-zsh"

    pushd $HOME
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    sed -i s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"bira\"/g ~/.zshrc
    popd

    # Update ~/.zshrc
    echo "GOPATH=$HOME/go" >> $HOME/.zshrc
    echo "GOBIN=$GOPATH/bin" >> $HOME/.zshrc
    source $HOME/.zshrc
    export PATH="$PATH:/usr/local/go/bin:$(go env GOPATH)/bin" >> $HOME/.zshrc

    # Install gopls
    go install github.com/golang/tools/cmd/gopls@latest

    chsh -s $(which zsh)
}

configure_ohmytmux ()
{
    info "Configure oh-my-tmux"
 
    [ ! -e "$HOME/.tmux" ] || rm -rf "$HOME/.tmux"
    [ ! -e "$HOME/.tmux.conf" ] || rm -rf "$HOME/.tmux.conf"
    [ ! -e "$HOME/.tmux.conf.local" ] || rm -rf "$HOME/.tmux.conf.local"

    pushd $HOME
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
    popd
}

configure_vim ()
{
   info "Configure vim"

   [ ! -e "$HOME/.vim/pack/plugins/start/vim-go" ] || rm -rf "$HOME/.vim/pack/plugins/start/vim-go"

    git clone https://github.com/derekorbit/development-environment.git "$WORKINGDIR"

    # Backup
    mkdir -p $WORKINGDIR/backup
    [ ! -e "$HOME/.vimrc" ] || cp -a "$HOME/.vimrc" "$WORKINGDIR/backup/"
    [ ! -e "$HOME/.vim" ] || cp -a "$HOME/.vim" "$WORKINGDIR/backup/"
    [ ! -e "$HOME/.vimrc" ] || rm -rf "$HOME/.vimrc"
    [ ! -e "$HOME/.vim" ] || rm -rf "$HOME/.vim"

    ln -sfn "$WORKINGDIR/.vimrc" "$HOME/.vimrc"
    ln -sfn "$WORKINGDIR/vim" "$HOME/.vim"
}

configure_vimplug ()
{
    info "Configure vim-plug"

    [ ! -e "$HOME/.vim/autoload/plug.vim" ] || rm -rf "$HOME/.vim/autoload/plug.vim"

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Install plugins
    vim +PlugInstall +qall
}

configure_vimgo ()
{
    info "Configure vim-go"
    git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
}

cleanup ()
{
    [ ! -e "$WORKINGDIR" ] || rm -rf "$WORKINGDIR"
}

#### Main function ####
cleanup
install_prerequisites vim git bash-completion cscope ctags tmux zsh

configure_golang
configure_vim
configure_vimplug
configure_ohmytmux
configure_ohmyzsh

echo "Finish and enjoy it!!!"
