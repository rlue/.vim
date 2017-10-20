`/Users/rlue/.vim`
==================

As with anyone’s config files, most of the stuff in here is pretty personal. Here are a couple of good ideas I had that might be worth trying yourself:

Organizing `vimrc` with Folds
-----------------------------

Folds are amazing. Here they are in action on my `vimrc`:

```
" ~/.vim/vimrc

" Initializing variables for portability
let g:vim_home = expand('<sfile>:p:h')
let $MYVIMRC   = g:vim_home . '/vimrc'
let $MYGVIMRC  = g:vim_home . '/gvimrc'

" MAPPINGS =====================================================================

" BASE ------------------------------------------------------------------- [4] -
" TEXT MANIPULATION ----------------------------------------------------- [35] -
" BUFFER MANAGEMENT ------------------------------------------------------ [7] -
" UI & WINDOW MANAGEMENT ------------------------------------------------ [12] -
" FILE MANAGEMENT -------------------------------------------------------- [7] -
" NAVIGATION ------------------------------------------------------------ [13] -
" MISCELLANEOUS --------------------------------------------------------- [21] -
                                                                                
" PER-MACHINE ==================================================================

" SEEDBOX ---------------------------------------------------------------- [3] -
" DEFAULT WORKING DIRECTORY --------------------------------------------- [14] -

" PLUGINS ======================================================================

" VIM-PLUG -------------------------------------------------------------- [41] -
" BROWSERLINK ----------------------------------------------------------- [23] -
...
```

The number in brackets on the right indicates how many lines of code (_i.e.,_ non-blank, non-comment) there are in the fold.

I used to have all these sections [broken out as separate files, stored in a `config/` directory and sourced in a `for` loop in `vimrc`][modularity]. That was pretty good, and [romainl even pointed out that I could just put them in a `plugin/` directory and ditch the `for` loop altogether][romainl], but I like this even better. 

`ftplugin/vim.vim` is where the magic happens. Headings are any commented lines exactly 80 characters long, ending in a space followed by string of `=` or `-` characters. Functions get folded, too.

Portability
-----------

There may be times when you want to fire up your vim config on someone else’s computer. Maybe you have to borrow your friend’s laptop because you forgot your charger. Maybe you’re asked to do a live coding challenge in an interview, and the chump on the other side of the table just dropped you into SublimeText. Maybe you’re offering impromptu tech support to your crush, and this is your big chance to show her what a fucking wizard you are.

In any case, it can be done — but it usually involves getting all jumbled up in someone else’s dotfiles. The other way (_i.e.,_ the polite way) involves passing some command line flags to vim to specify an alternate `vimrc` and runtime path:

```
$ vim -Nu <vimrc> --cmd "let &rtp = substitute(&rtp, \"$HOME/.vim\", <vim_home>, 'g')"
```

That’s a real mouthful. Instead, try loading the included shims onto your `$PATH`:

```
$ git clone https://github.com/rlue/.vim ~/Downloads/vim
$ source ~/Downloads/vim/vimshims/load
```

Now, the `vim` and `gvim` commands will automatically load this configuration, so you can test drive it with no strings attached. To get things back to the way they were, simply restart your shell, or

```
$ rm -rf ~/Downloads/vim
```

(All the settings in `vimrc` have been written to maximize compatibility with various versions of vim you may encounter which, for instance, may not have been compiled with clipboard support.)

[modularity]: https://github.com/rlue/.vim/blob/4363cea2d762d895ee9e6b69acc2184fc0b9a597/README.md#modularity
[romainl]: https://www.reddit.com/r/vim/comments/6hz4il/two_good_ideas_for_your_vim_config_building_in/dj2ule0/
