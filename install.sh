#!/bin/bash

set -exuo pipefail

VIM_DIR="${HOME}/.vim"

init()
{
    vim_dir="${HOME}/restore/.vim"
    if [ -d "${vim_dir}" ]; then
        rm -rf "${vim_dir}"
    fi

    vim_dir="${HOME}/.vim"
    if [ -d "${vim_dir}" ]; then
        rm -rf "${vim_dir}"
    fi

    vimrc="${HOME}/.vimrc"
    if [ -f "${vimrc}" ]; then
        rm -rf "${vimrc}"
    fi
}

init_vim()
{
    mkdir "${VIM_DIR}"
    mkdir "${VIM_DIR}/colors"
    mkdir "${VIM_DIR}/plugged"
    mkdir "${VIM_DIR}/autoload"
    cp  ./linux/vimrc "${VIM_DIR}"
}

install_tools()
{
    sudo apt-get install -y curl cscope cmake clang exuberant-ctags
    curl -fLo "${VIM_DIR}/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_colors()
{
    cd "${VIM_DIR}"
    git clone git@github.com:altercation/solarized.git --depth=1
    cp "${VIM_DIR}/solarized/vim-colors-solarized/colors/solarized.vim" "${VIM_DIR}/colors/"
    rm -rf "${VIM_DIR}/solarized"
}

install_ycm()
{
    cd "${VIM_DIR}/plugged"
    if [ ! -d "${VIM_DIR}/plugged/YouCompleteMe" ]; then
        git clone https://github.com/ycm-core/YouCompleteMe.git
    fi

    cd "${VIM_DIR}/plugged/YouCompleteMe"
    git submodule update --init --recursive
    ./install.py --clang-completer
}

main()
{
    init
    init_vim
    install_tools
    install_colors
    install_ycm
}

main
