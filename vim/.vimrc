" arsenmuk's vimrc
" $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" $ vim +PlugInstall +qall

syntax on
filetype plugin indent on

" ============================================================================
" General settings
" ============================================================================
" TODO: figure out -- set clipboard
set confirm
set cursorline
set hidden
set mouse=a
set number
set scrolloff=5
set signcolumn="yes"
set splitbelow
set splitright
set timeout
set timeoutlen=2000
set updatetime=5000
set wildmenu
set wildmode=longest:full,full

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Highlight while searching with '/'; ':nohls' to cancel
set hlsearch
set ignorecase
set incsearch
set smartcase

" Indentication
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4

" Persistent undo
if has('persistent_undo')
    set undodir=~/.vim/undodir
    set undofile
endif

" Enable 24-bit colors
if has('termguicolors')
    set termguicolors
endif

" Special symbols
set list
set listchars=tab:>-,trail:*,nbsp:%,precedes:<,extends:>

" Leader key - not using it, but let's set it though
let mapleader = " "

" Status line
set laststatus=2
set statusline=
set statusline+=\ %f
set statusline+=\ %m%r%h%w
set statusline+=%=
set statusline+=\ [%{&fileformat}]
set statusline+=\ %p%%
set statusline+=\ %l:%c

" ============================================================================
" Plugin installation
" ============================================================================
call plug#begin('~/.vim/plugged')
" LSP plugins
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Fuzzy finder - an alternative to Telescope in neovim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git-related plugins
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Colorschemes
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sainnhe/everforest'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
call plug#end()

" ============================================================================
" Color scheme setup
" ============================================================================
set background=dark
colorscheme catppuccin_mocha

" ============================================================================
" LSP Configuration
" ============================================================================
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->[
        \   'clangd',
        \   '--j=16',
        \   '--background-index',
        \   '--clang-tidy',
        \   '--pch-storage=memory',
        \ ]},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlights_enabled = 1
"let g:lsp_preview_keep_focus = 0
let g:lsp_signs_enabled = 1

" ============================================================================
" FZF Configuration
" ============================================================================
let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['right,65%', 'ctrl-\']

" <C-a>+<C-q> move search results to quicklist split
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
endfunction

let g:fzf_action ={
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-q': function('s:build_quickfix_list')}


" Use ripgrep for faster searching
"if executable('rg')
"    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
"    "set grepprg=rg\ --vimgrep\ --hidden\ -glob '!.git'
"endif
"
" Use fd for file finding (faster than find)
"if executable('fdfind')
"    let $FZF_DEFAULT_COMMAND = 'fdfind --type f --hidden --follow --exclude .git'
"endif

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all --border=sharp --margin=1,2 --padding=1 --info=inline --prompt="❯ " --pointer="▶" --marker="✓"'
"let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'


" FZF layout - popup window
let g:fzf_layout = { 'down': '90%' }
"let g:fzf_layout = {
"  \ 'window': {
"    \ 'width': 0.9,
"    \ 'height': 0.7,
"    \ 'border': 'rounded',
"    \ 'highlight': 'Normal'
"  \ }
"\ }

" Customize fzf colors to match Vim colorscheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Function'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'String'],
  \ 'border':  ['fg', 'Comment'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" ============================================================================
" Custom FZF commands for enhanced functionality
" ============================================================================

"-"" Ripgrep with preview
"-"command! -bang -nargs=* Rg
"-"  \ call fzf#vim#grep(
"-"  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
"-"  \   fzf#vim#with_preview(), <bang>0)
"-"
"-"" Files with preview
"-""command! -bang -nargs=? -complete=dir Files
"-""  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
"-"
"-"" Search in open buffers
"-"command! -bang -nargs=* BLines
"-"  \ call fzf#vim#buffer_lines(<q-args>, <bang>0)
"-"
"-"" LSP symbols search (if available)
"-"function! s:lsp_document_symbols() abort
"-"    if !lsp#server_is_connected()
"-"        echo 'LSP server not running'
"-"        return
"-"    endif
"-"    let l:servers = lsp#get_allowed_servers()
"-"    if len(l:servers) == 0
"-"        echo 'No LSP server available'
"-"        return
"-"    endif
"-"    call lsp#callbag#pipe(
"-"        \ lsp#request(l:servers[0], {'method': 'textDocument/documentSymbol'}),
"-"        \ lsp#callbag#subscribe({
"-"        \   'next': { x -> s:handle_symbols(x) },
"-"        \ })
"-"        \ )
"-"endfunction
"-"
"-"" Search text across all files in current directory (your main use case #2)
"-"command! -bang -nargs=* RgSearch
"-"  \ call fzf#vim#grep(
"-"  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
"-"  \   1,
"-"  \   fzf#vim#with_preview({'options': ['--delimiter=:', '--nth=4..']}),
"-"  \   <bang>0)
"-"
"-"" Interactive Rg - type as you search (most powerful)
"-"function! RipgrepFzf(query, fullscreen)
"-"  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
"-"  let initial_command = printf(command_fmt, shellescape(a:query))
"-"  let reload_command = printf(command_fmt, '{q}')
"-"  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--delimiter', ':', '--preview-window', 'up:60%:border-bottom']}
"-"  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
"-"endfunction
"-"
"-"command! LspSymbols call s:lsp_document_symbols()
"-"nnoremap <leader>fs :LspSymbols<CR>


" ============================================================================
" All Key Mappings
" ============================================================================

" === Simple maps ===
"   Resising
nnoremap <F9> <cmd>resize -2<CR>
nnoremap <S-F9> <cmd>vertical resize -2<CR>
nnoremap <F10> <cmd>resize +2<CR>
nnoremap <S-F10> <cmd>vertical resize +2<CR>
nnoremap <F11> <cmd>resize<CR>
nnoremap <S-F11> <cmd>vertical resize<CR>
nnoremap <F12> <C-w>w
nnoremap <S-F12> <C-w>W
"   Wrapping/Unwrapping
set nowrap
nnoremap <F4> <cmd>set wrap!<CR>
set breakindent

" === Git ===
"   Git blame in left split, 'o' - open commit in a split, 'O' - in a tab
nnoremap <leader>ob :Git blame<CR>
"   Git history of a file - same 'o'/'O' logic
nnoremap <leader>oh :GV!<CR>
"   Git & GitHub stuff
nnoremap <leader>od :GFiles?<CR>

" === LSP ===
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> <leader>gd <plug>(lsp-definition)
    nmap <buffer> <leader>gD <plug>(lsp-implementation)
"    nmap <buffer> <leader>gr :call <SID>LspReferencesWithFzf()<CR>
    nmap <buffer> <leader>gr <plug>(lsp-references)
    nmap <buffer> <leader>gT <plug>(lsp-type-definition)
    nmap <buffer> <leader>gs <plug>(lsp-document-symbol-search)
    nmap <buffer> <leader>gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> <leader>gN <plug>(lsp-rename)
    nmap <buffer> <leader>g[ <plug>(lsp-previous-diagnostic)
    nmap <buffer> <leader>g] <plug>(lsp-next-diagnostic)
    nmap <buffer> <leader>gK <plug>(lsp-hover)
endfunction

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" === FZF ===
" Navigation (keeping under 'g' together with LSP stuff)
nnoremap <leader>gJ :Jumps<CR>
nnoremap <leader>gW :Windows<CR>
nnoremap <leader>gH :History<CR>

" Searching
"   Search git files only (lightning fast)
nnoremap <leader>sf :GFiles<CR>
"   Search all files (so-so fast)
nnoremap <leader>sF :Files<CR>
"   RipGrep within git files only (fast)
nnoremap <leader>sw :RG <C-R><C-W><CR>
"   RipGrep within git files only (fast)
nnoremap <leader>sg :RG<CR>
"   RipGrep within all files
nnoremap <leader>sG :Rg<CR>

"   Help
nnoremap <leader>sh :Helptags<CR>
nnoremap <leader>sH :Commands<CR>
nnoremap <leader>sk :Maps<CR>
