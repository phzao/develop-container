syntax on
set mouse=a
set guioptions-=m
set guioptions=ac
set history=100
set guicursor=
set autochdir

set splitright
set relativenumber
set scrolloff=8
set cmdheight=2
set laststatus=2
set noswapfile
set nu
set nohlsearch
set hidden
set noerrorbells
set nobackup
set nowrap
set undodir=~/.vim/undodir
set undofile
set incsearch

set backspace=2
set expandtab
set smartindent
set backspace=indent,eol,start
set hlsearch

set tabstop=2 softtabstop=2
set shiftwidth=2

set signcolumn=yes

set updatetime=50

set colorcolumn=80

call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'

Plug 'ludovicchabant/vim-gutentags'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'dyng/ctrlsf.vim'

Plug 'preservim/nerdcommenter'

Plug 'mbbill/undotree'

Plug 'jiangmiao/auto-pairs'

Plug 'alvan/vim-closetag'

Plug 'tpope/vim-fugitive'

Plug 'puremourning/vimspector'

Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

Plug 'vim-airline/vim-airline'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/0.x'
  \ }

Plug 'dense-analysis/ale'

call plug#end()

colorscheme gruvbox

highlight Normal guibg=nnoremap

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>

let g:gruvbox_contrast_dark = 'hard'

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2%lu;%lu;%lum"
endif

let g:gruvbox_invert_selection='0'

set background=dark

nmap <leader>do :call vimspector#Launch()<CR>
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>djo <Plug>VimspectorStepOut
nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <leader>dcbp <Plug>VimspectorToggleConditionalBreakpoint
nmap <leader>d_ <Plug>VimspectorRestart
nmap <leader>ds <Plug>VimspectorStop

nnoremap <F5> :UndotreeToggle<CR>

set langmenu=en_US.UTF-8
language messages en_US.UTF-8

if !empty(glob("/bin/zsh"))
  set shell=/bin/zsh
endif
set nocompatible

let g:closetag_filenames = "*.jsx,*.js"
let g:closetag_xhtml_filenames = '*.jsx,*.js'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'
"add numbers to explorer
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
let g:netrw_keepdir=0
let g:netrw_banner = 0
"let g:netrw_browse_split = 1
let g:netrw_winsize = 25

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" Don't resize automatically.
let g:golden_ratio_autocommand = 0

" Mnemonic: - is next to =, but instead of resizing equally, all windows are
" resized to focus on the current.
nmap <C-w>- <Plug>(golden_ratio_resize)
" Fill screen with current window.
nnoremap <C-w>+ <C-w><Bar><C-w>_

let g:gutentags_cache_dir = '~/.vim/gutentags'

let g:gutentags_ctages_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
            \ '*.phar', '*.ini', '*.rst', '*.md',
            \ '*vendor/*/test*', '*vendor/*/Test*',
            \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
            \ '*var/cache*', '*var/log*']

set listchars=
"set listchars+=tab:𐄙\ 
set listchars+=tab:\ \ 
set listchars+=trail:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:coc_global_extensions = [
  \ 'coc-tsserver'
  \ ]

let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
