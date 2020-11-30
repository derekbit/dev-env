#!/usr/bin/env sh

WORKINGDIR=$HOME/.naturlich

create_symlinks ()
{
    ln -sfn $WORKINGDIR/vimrc $HOME/.vimrc
    ln -sfn $WORKINGDIR/vim $HOME/.vim
    ln -sfn $WORKINGDIR/gitconfig $HOME/.gitconfig
}

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

cleanup ()
{
    if [ -d "$WORKINGDIR" ]; then
        rm -rf "$WORKINGDIR"
    fi

    if [ -d "$HOME/.vim" ]; then
        rm -rf "$HOME/.vim"
    fi

    if [ -d "$HOME/.vimrc" ]; then
        rm -rf "$HOME/.vimrc"
    fi
}

#### Main function ####
cleanup

preq_install vim git cscope ctags

git clone https://github.com/naturlich/development-environment.git $WORKINGDIR

create_symlinks

# Install necessary plugins
install_fugitive

echo "Finish and enjoy it!!!"
