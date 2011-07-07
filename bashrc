#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# source all files in ~/.config/bash/
for CFGFILE in ~/.config/bash/*; do
  if [ -r ${CFGFILE} ]; then
    source ${CFGFILE}
  fi
done


export PATH=$PATH:/home/ian/bin
export EDITOR=vim

shopt -s histappend
export HISTCONTROL=ignoreboth		# no duplicates or empty lines
export HISTIGNORE="&:ls:[bf]g:exit"	# do not store these lines
