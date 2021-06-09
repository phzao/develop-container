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
Plug 'simrat39/symbols-outline.nvim'

Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'dyng/ctrlsf.vim'

Plug 'preservim/nerdcommenter'

Plug 'mbbill/undotree'

Plug 'tpope/vim-fugitive'

Plug 'puremourning/vimspector'

Plug 'vim-airline/vim-airline'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/0.x'
  \ }

Plug 'jremmen/vim-ripgrep'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'

Plug 'alvan/vim-closetag'

Plug 'hrsh7th/nvim-compe'
Plug 'glepnir/lspsaga.nvim'
Plug 'ctrlpvim/ctrlp.vim'

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

"lua require'lspconfig'.tsserver.setup{}
"lua require'lspconfig'.tsserver.setup{on_attach=require'completion'.on_attach}

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

nnoremap <leader>hh :vsplit<CR>
nnoremap <leader>kk :split<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>undo :UndotreeToggle<CR>

"caso nao mostrar problemas rodar
" lua vim.lsp.stop_client(vim.lsp.get_active_clients())
set runtimepath^=~/.vim/bundle/ctrlp.vim

let g:ctrlp_cmd = 'CtrlP'
nnoremap <Leader>cp :CtrlP<CR>
set wildignore+=*/tmp/*,*/node_modules/*,*.so,*.swp,*.zip
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_working_path_mode = 'ra'
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

let g:closetag_filenames = "*.jsx,*.js"
let g:closetag_xhtml_filenames = '*.jsx,*.js'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

let g:prettier#config#trailing_comma = 'es5'
let g:prettier#config#tab_width = '2'
let g:prettier#config#semi = 'false'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#arrow_parens = 'avoid'
let g:prettier#config#bracket_spacing = 'true'

"autocmd BufEnter * lua require'completion'.on_attach()
"" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
"let g:completion_trigger_keyword_length = 3


nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set list
set lcs=tab:->,eol:↵,nbsp:&
"¶
nnoremap <Leader>b :ls<CR>:b<Space>

let g:symbols_outline = {
    \ "highlight_hovered_item": v:true,
    \ "show_guides": v:true,
    \ "position": 'right',
    \ "auto_preview": v:true,
    \ "keymaps": {
        \ "close": "<Esc>",
        \ "goto_location": "<Cr>",
        \ "focus_location": "o",
        \ "hover_symbol": "<C-space>",
        \ "rename_symbol": "r",
        \ "code_actions": "a",
    \ },
    \ "lsp_blacklist": [],
\ }

nnoremap <Leader>sb :SymbolsOutline<CR>

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', '<Leader>ld',"lua require'lspsaga.diagnostic'.show_line_diagnostic()<CR>", opts)
  buf_set_keymap('n', '<Leader>c]',"<cmd> lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap('n', 'K',"<cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>", opts)
  buf_set_keymap('n', 'gd',"<cmd>lua vim.lsp.buf.declaration()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

highlight link LspSagaFinderSelection Search

nnoremap <Leader>= :vertical resize +20<CR>
nnoremap <Leader>- :vertical resize -20<CR>

