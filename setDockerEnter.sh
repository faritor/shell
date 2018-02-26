#!/bin/base

wget -P ~ https://raw.githubusercontent.com/FaritorKang/shell/master/.bashrc_docker;

echo "[ -f ~/.bashrc_docker ] && . ~/.bashrc_docker" >> ~/.bashrc; source ~/.bashrc
