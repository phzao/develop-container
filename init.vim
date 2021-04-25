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
function! BuildYCM(info)
  " - name: YouCompleteMe
  " - status: 'installed'
  if a:info.status == 'installed' || a:info.force
    !python3 ./install.py --clangd-completer --go-completer --ts-completer
    !python3 .ycm_extra_conf.py ~/.vim/plugged/YouCompleteMe/third_party/ycmd
  endif
endfunction

call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'

Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'dyng/ctrlsf.vim'

Plug 'preservim/nerdcommenter'

Plug 'mbbill/undotree'

Plug 'tpope/vim-fugitive'

Plug 'puremourning/vimspector'

Plug 'vim-airline/vim-airline'

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

Plug 'jremmen/vim-ripgrep'

Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildYCM'), 'for': ['go', 'javascript', 'PHP']}

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

call plug#end()

let mapleader = " "
set t_Co=256
colorscheme gruvbox

"highlight ColorColumn ctermbg=0 guibg=lightgrey

let g:gruvbox_contrast_dark = 'hard'

if executable('rg')
  let g:rg_derive_root='true'
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2%lu;%lu;%lum"
endif

let g:gruvbox_invert_selection='0'

set background=dark
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>

nmap <leader>do :call vimspector#Launch()<CR>
nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dco <Plug>VimspectorContinue
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

"add numbers to explorer
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
let g:netrw_keepdir=0
let g:netrw_banner = 0
let g:netrw_winsize = 25

" Don't resize automatically.
let g:golden_ratio_autocommand = 0

" Mnemonic: - is next to =, but instead of resizing equally, all windows are
" resized to focus on the current.
nmap <C-w>- <Plug>(golden_ratio_resize)
" Fill screen with current window.
nnoremap <C-w>+ <C-w><Bar><C-w>_

lua require'lspconfig'.tsserver.setup{}

nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>gw :lua require('telescope').extensions.git_worktree.git_worktrees()<CR>
" next greatest remap ever : asbjornHaland
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap <leader>h :vsplit<CR>
nnoremap <leader>k :split<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>undo :UndotreeToggle<CR>
nnoremap <silent> <leader>goto :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>gdef :YcmCompleter GoToDefinition<CR>
nnoremap <silent> <leader>gref :YcmCompleter GoToReferences<CR>
let g:ycm_always_populate_location_list = 1
"caso nao mostrar problemas rodar
" lua vim.lsp.stop_client(vim.lsp.get_active_clients())
set runtimepath^=~/.vim/bundle/ctrlp.vim

let g:ctrlp_cmd = 'CtrlP'
nnoremap <Leader>lk :CtrlP<CR>
set wildignore+=*/tmp/*,*/node_modules/*,*.so,*.swp,*.zip
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_working_path_mode = 'ra'
nnoremap <Leader>sv :w<CR>
nnoremap <Leader>nv :q!<CR>
nnoremap <Leader>ls :wqa!<CR>
nnoremap <Leader>ln :qa!<CR>
nnoremap <Leader>nh :noh<CR>

lua require'nvim-treesitter.configs'.setup{
  \ highlight = {
  \   enable = true,
  \   custom_captures = {
  \     ["foo.bar"] = "Identifier",
  \   },
  \ },
  \ ensure_installed = {"python", "lua", "yaml", "json", "javascript", "bash"},
  \textobjects = { enable = true },
  \incremental_selection = { enable = true },
  \indent = {
  \  enable = true
  \ }
\}

highlight TSVariable ctermfg=yellow

lua <<EOF
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.typescript.used_by = "javascriptflow"
EOF

set cursorline

