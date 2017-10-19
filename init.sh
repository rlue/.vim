#! /bin/bash

# [ "$_" = "$0" ] checks whether the script is being sourced or run
# (this script needs to be SOURCED.)
if [ "$_" = "$0" ]; then
  cat <<EOF
This script aliases the vim and gvim commands to be run using
the configuration files provided within.

These aliases will persist only as long as the current shell
session, and will not create or modify any files on your system.

Run the following command to proceed:

    $ source $0"

EOF
  exit 1
fi

vimhome=$(cd "$(dirname ${BASH_SOURCE[0]})"; pwd)

if [ -x "/Applications/MacVim.app/Contents/MacOS/vim" ]; then
  vimbin="/Applications/MacVim.app/Contents/MacOS/vim"
elif hash vim 2>/dev/null; then
  vimbin="$(which vim)"
fi

if hash gvim 2>/dev/null; then
  gvimbin=$(which gvim)
elif hash mvim 2>/dev/null; then
  gvimbin=$(which mvim)
fi

if [ -n "$vimbin" ]; then
  alias vim="$vimbin -Nu \"$vimhome/vimrc\" --cmd \"let &rtp = substitute(&rtp, \\\"$HOME/.vim\\\", \\\"$vimhome\\\", \\\"g\\\")\" $*"
  modified=1
  echo "vim has been aliased"
else
  echo "vim could not be found."
fi

if [ -n "$gvimbin" ]; then
  alias gvim="$gvimbin -Nu \"$vimhome/vimrc\" -U \"$vimhome/gvimrc\" --cmd \"let &rtp = substitute(&rtp, \\\"$HOME/.vim\\\", \\\"$vimhome\\\", \\\"g\\\")\" $*"
  modified=1
  echo "gvim has been aliased"
else
  echo "gvim could not be found."
fi

if [ -n "$modified" ]; then
  cat <<EOF

To restore the vim and gvim commands to their original state,
simply restart the shell, or run the following command:

    $ unalias vim gvim

EOF
else
  cat <<EOF

Make sure vim is installed and located on your \$PATH,
then try again.
EOF
fi
