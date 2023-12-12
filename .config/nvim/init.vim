
"   ████████ ██                               ██    
"  ██░░░░░░ ░██                              ░██    
" ░██       ░██      ██████  ██████  ███████ ░██  ██
" ░█████████░██████ ░░██░░█ ██░░░░██░░██░░░██░██ ██ 
" ░░░░░░░░██░██░░░██ ░██ ░ ░██   ░██ ░██  ░██░████  
"        ░██░██  ░██ ░██   ░██   ░██ ░██  ░██░██░██ 
"  ████████ ░██  ░██░███   ░░██████  ███  ░██░██░░██
" ░░░░░░░░  ░░   ░░ ░░░     ░░░░░░  ░░░   ░░ ░░  ░░

set nocompatible              " be iMproved, required
set backspace=indent,eol,start
set ruler
set nu rnu
set showcmd
set incsearch
set hlsearch
set tabstop=4
set ts=4 sw=4
set lazyredraw

" Line number coloring
hi LineNrAbove ctermfg=red
hi LineNrBelow ctermfg=green
hi LineNr ctermfg=grey
hi Pmenu ctermbg=gray guibg=gray

" Search result highlight
hi MatchParen cterm=none ctermbg=magenta ctermfg=white

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle")

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'frazrepo/vim-rainbow'
Plugin 'rust-lang/rust.vim'
Plugin 'rust-lang/rls'

" Completion framework
Plugin 'hrsh7th/nvim-cmp'

" LSP completion source for nvim-cmp
Plugin 'hrsh7th/cmp-nvim-lsp'

" Snippet completion source for nvim-cmp
Plugin 'hrsh7th/cmp-vsnip'

" Other usefull completion sources
Plugin 'hrsh7th/cmp-path'
Plugin 'hrsh7th/cmp-buffer'

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plugin 'simrat39/rust-tools.nvim'

" Snippet engine
Plugin 'hrsh7th/vim-vsnip'

" Fuzzy finder
" Optional
Plugin 'nvim-lua/popup.nvim'
Plugin 'nvim-lua/plenary.nvim'
Plugin 'nvim-telescope/telescope.nvim'
Plugin 'neovim/nvim-lspconfig'
Plugin 'nvim-lua/lsp_extensions.nvim'
Plugin 'nvim-lua/completion-nvim'
Plugin 'tomlion/vim-solidity'

" All of your Plugins must be added before the following line
call vundle#end()            " required

syntax enable

map <C-n> :NERDTreeToggle<CR>

set laststatus=2
set t_Co=256

:let g:colorizer_auto_color = 1
:let g:colorizer_syntax     = 1
:let g:colorizer_colornames = 0
:let g:rainbow_active       = 1

let g:lightline = { 
       \ 'colorscheme': 'selenized_dark',
       \ }

let g:lightline = { 
       \ 'colorscheme': 'jellybeans',
       \ 'active': {
       \   'left': [ ['mode', 'paste'],
       \             ['fugitive', 'readonly', 'filename', 'modified'] ],
       \   'right': [ [ 'lineinfo' ], ['fileencoding','filetype','percent'] ]
       \ },
       \ 'component': {
       \   'readonly': '%{&filetype=="help"?"":&readonly?"\ue0a2":""}',
       \   'modified': '%{&filetype=="help"?"":&modified?"\ue0a0":&modifiable?"":"-"}',
       \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
       \ },
       \ 'component_visible_condition': {
       \   'readonly': '(&filetype!="help"&& &readonly)',
       \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
       \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
       \ },
       \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
       \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
       \ }   ""

" Rust
autocmd BufWritePost *.rs :silent !cargo fmt <afil
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

" LaTeX
autocmd BufEnter *.tex :setlocal filetype=tex
autocmd BufWritePost *.tex :silent !xelatex <afile>

lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

filetype plugin indent on

