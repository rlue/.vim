`/Users/rlue/.vim`
==================

As with anyone’s config files, most of the stuff in here is pretty personal. Here are a couple of good ideas I had that might be worth trying yourself:

Modularity
----------

My `vimrc` itself is pretty empty. All the customization is broken up into separate files in a `config/` directory, because categorization is one of my favorite things to do in the whole wide world.

```viml
" .vim/vimrc

for file in split(glob(g:vim_home . '/config/**.vim'), '\n')
  exec 'source ' . file
endfor
```

Portability
-----------

There may be times when you want to fire up your vim config on someone else’s computer. Maybe you had to borrow your friend’s laptop because you forgot your charger. Maybe you’re asked to do a live coding challenge in an interview, and the chump on the other side of the table just dropped you into SublimeText. Maybe you’re offering impromptu tech support to your crush, and this is your chance to show her what a fucking wizard you are.

In any case, it can be done — but it usually involves getting all jumbled up in someone else’s dotfiles. The other way (_i.e.,_ the polite way) involves passing some command line flags to vim to specify an alternate `vimrc` and runtime path:

```
$ vim -Nu <vimrc> --cmd "let &rtp = substitute(&rtp, \"$HOME/.vim\", <vim_home>, 'g')" $*
```

That’s a real mouthful. Instead, try the included `bin/vim` and `bin/gvim` launcher scripts:

```
$ git clone https://github.com/rlue/.vim ~/Downloads/vim
Cloning into 'Downloads/vim'...
remote: Counting objects: 39, done.
remote: Compressing objects: 100% (28/28), done.
remote: Total 39 (delta 3), reused 39 (delta 3), pack-reused 0
Unpacking objects: 100% (39/39), done.
$ ~/Downloads/vim/bin/vim
```

With this, you can test drive my vim config, no strings attached, and get things right back to the way they were with

```
$ rm -rf ~/Downloads/vim
```

(All the settings in the `config/` directory have been written to maximize compatibility with various versions of vim you may encounter which, for instance, may not have been compiled with clipboard support.)
