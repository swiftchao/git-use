#########################################################################
# File Name: git-set.sh
# Author: chaofei
# mail: chaofeibest@163.com
# Created Time: 2018-11-29 20:30:08
#########################################################################
#!/bin/bash

git config --list
git config --global user.name "chaofei"
git config --global user.email "chaofeibest@163.com"
git config --global color.ui true
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --list
