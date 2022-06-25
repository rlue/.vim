`~/.vim`
========

As with anyone’s config files, most of the stuff in here is pretty personal.
Here are a couple of good ideas I had that might be worth trying yourself:

XDG Spec Compliance
-------------------

Think `~/.config/vim` > `~/.vim`? Try:

```bash
# ~/.profile

export MYVIMRC="${XDG_CONFIG_HOME:-$HOME/.config}/vim/vimrc"
```

(Stolen from [this blog post][] by Jakub Łukasiewicz.)

Organizing `vimrc` with Folds
-----------------------------

Folds are amazing. Here they are in action on my `vimrc`:

```
" ~/.vim/vimrc

" PATHS ========================================================================
" XDG compliance (adapted from https://blog.joren.ga/tools/vim-xdg) ----- [30] -

" MAPPINGS =====================================================================
" Base ------------------------------------------------------------------- [4] -
" Text Manipulation ----------------------------------------------------- [35] -
" Buffer Management ------------------------------------------------------ [7] -
" UI & Window Management ------------------------------------------------ [12] -
" File Management -------------------------------------------------------- [7] -
" Navigation ------------------------------------------------------------ [13] -
" Miscellaneous --------------------------------------------------------- [21] -
                                                                                
" PER-MACHINE ==================================================================

" SEEDBOX ---------------------------------------------------------------- [3] -
" Default Working Directory --------------------------------------------- [14] -

" PLUGINS ======================================================================

" vim-plug -------------------------------------------------------------- [41] -
" browserlink ----------------------------------------------------------- [23] -
...
```

The number in brackets on the right indicates
how many lines of code (_i.e.,_ non-blank, non-comment) there are in the fold.

I used to have all these sections
[broken out as separate files, stored in a `config/` directory
and sourced in a `for` loop in `vimrc`][modularity].
That was pretty good, and [romainl even pointed out
that I could just put them in a `plugin/` directory
and ditch the `for` loop altogether][romainl],
but I like this even better. 

`ftplugin/vim.vim` is where the magic happens.
Headings are any commented lines exactly 80 characters long,
ending in a space followed by string of `=` or `-` characters.
Functions get folded, too.

Portability
-----------

### with Neovim

> **Note:** Neovim looks for its configuration directory under `~/.config/nvim`.

Neovim adopts some breaking changes with vim’s dotfile scheme
(including compliance with the XDG specification! 🎉🎉🎉).
That’s fine if you know for sure which team you’re on,
but I’m still trying Neovim out,
and want to reserve the option to switch back one day.

For cross-compatibility, this repo includes **two** config files:

* `init.vim`, which is read by Neovim only
* `vimrc`, which is read by both (thanks to this little trick):

  ```viml
  " init.vim

  source <sfile>:p:h/vimrc

  " ...followed by any backwards-incompatible configuration
  ```

We also define some path variables at launch,
which are used to set dotfile paths as appropriate
(_e.g.,_ `set undodir=$VIM_CACHE_HOME/undo`):

|                    | Vim      | Vim (with [XDG compliance hack](#xdg-spec-compliance)) | Neovim                  |
| ------------------ | -------- | ------------------------------------------------------ | ----------------------- |
| `$VIM_CONFIG_HOME` | `~/.vim` | `$XDG_CONFIG_HOME/vim`                                 | `$XDG_CONFIG_HOME/nvim` |
| `$VIM_CACHE_HOME`  | `~/.vim` | `~/.cache`                                             | `~/.cache`              |
| `$VIM_DATA_HOME`   | `~/.vim` | `$XDG_DATA_HOME/vim`                                   | `$XDG_DATA_HOME/nvim`   |

### on someone else’s machine / user account

There may be times when you want to fire up your vim config on someone else’s computer.
Maybe you have to borrow your friend’s laptop because you forgot your charger.
Maybe you’re asked to do a live coding challenge in an interview,
and the chump on the other side of the table just dropped you into SublimeText.
Maybe you’re offering impromptu tech support to your crush,
and this is your big chance to show her what a fucking wizard you are.

In any case, it can be done —
but it usually involves getting all jumbled up in someone else’s dotfiles.
The other way (_i.e.,_ the polite way) involves passing some command line flags to vim
to specify an alternate `vimrc` and runtime path:

```
$ vim -Nu <vimrc>
```

That’s a real mouthful. Instead, try loading the included binstubs onto your `$PATH`:

```
$ git clone https://github.com/rlue/.vim ~/Downloads/vim
$ source ~/Downloads/vim/vimstubs/load
```

Now, the `vim` and `gvim` commands will automatically load this configuration,
so you can test drive it with no strings attached.
To get things back to the way they were, simply restart your shell, or

```
$ rm -rf ~/Downloads/vim
```

(All the settings in `vimrc` have been written
to maximize compatibility with various versions of vim you may encounter
which, for instance, may not have been compiled with clipboard support.)

[modularity]: https://github.com/rlue/.vim/blob/4363cea2d762d895ee9e6b69acc2184fc0b9a597/README.md#modularity
[romainl]: https://www.reddit.com/r/vim/comments/6hz4il/two_good_ideas_for_your_vim_config_building_in/dj2ule0/
[this blog post]: https://blog.joren.ga/tools/vim-xdg
