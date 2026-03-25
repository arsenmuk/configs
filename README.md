arsenmuk's configs

## Usage

Each top-level directory reflects its target tree structure and can be handled with [GNU Stow](https://www.gnu.org/software/stow/).

Example:
```bash
stow -t ~ nvim
stow -t ~ --adopt nvim
stow -t ~ -D nvim
```

## NVim

It was started from kickstart, then enhanced manually & using AI-assistance

### Keymaps

#### Search

```
<l>sf     Search in Git files
<l>sF     Search across All files
<l>sw     Grep word under cursor
<l>sg     Live grep
<l>sr     Resume last search
<l>/      Fuzzy search in current buffer
```

#### Browse

```
<l>bb     Fuzzy file browser
<l>bs     Open split file browser
<l>bv     Open vertical split with file browser
<l>bt     Open new tab with file browser
```

#### Go / LSP

```
<l>gd     Go to Definition
<l>gD     Go to Declaration
<l>gr     Show References of current symbol
<l>gi     Implementations of current method
<l>gt     Go to Type definition
<l>gj     Jumplist
<l>gA     Open split with All symbols 
<l>gF     Open split with Functions
<l>gV     Open split with Variables and Declarations
<l>gM     Show diagnostic Messages for current buffer
<l>gG     Open new tab with Global diagnostics
<l>gA     Code action for current line
K         Hover info
<S-F12>   Switch .h/.cpp
```

#### Tools

```
<l>tn     Rename symbol
<l>th     Toggle inlay hints
<l>tm     Toggle inline diagnostics

<C-o>     Jump to last position in the previous buffer
<C-i>     Jump to the next buffer
<C-p>     Jump back to the previous position in Jumps

gc        Comment block
gcc       Comment line
```

#### Git

```
<l>ob     Blame
<l>od     Diffview
<l>op     Find PR for current line
<l>oP     Find PR for SHA
<l>oH     File history
<l>ooi    GitHub Issues
<l>oop    GitHub PRs
<l>oos    Search GitHub
```

#### Clipboard

```
y/p       Copy/Paste to/from NVim buffers only
<l>y      Copy to system clipboard
<l>Y      Copy line to system clipboard
<l>p      Paste from system clipboard
<l>P      Paste before from system clipboard
```

#### Windows

```
<F4>      Toggle line wrap
<F9>      Height -2
<F10>     Height +2
<F11>     Maximize height
<S-F9>    Width -2
<S-F10>   Width +2
<S-F11>   Maximize width
<F12>     Next split
```

#### Completion (insert mode, blink.cmp)

```
<C-h>     Show / toggle docs
<CR>      Accept
<Tab>     Accept
<Up>      Previous item
<Down>    Next item
<C-p>     Previous item
<C-n>     Next item
<C-Up>    Scroll docs up
<C-Down>  Scroll docs down
```

#### Oil (file browser buffer)

```
g?        Help
<CR>      Select
<C-x>     Open in h-split
<C-v>     Open in v-split
<C-t>     Open in tab
<C-p>     Preview
-         Parent directory
gs        Change sort
gx        Open external
gh        Toggle hidden
gd        Toggle detail view
```

#### Misc

```
<l>ht     Help tags
<l>hk     Keymaps
<l>hs     Telescope builtins
```

## Vim
Mostly using NVim nowadays. Still loving vim, current config is quite raw - an attempt to merge what I've been using for years with new tricks learned from onboarding onto NVim and LSP stuff
