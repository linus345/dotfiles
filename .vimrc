" NOTE:
" * File specific configuration is in ~/.vim/ftplugin/
" * Plugins from ~/.vim/pack/plugins/start is loaded automatically
" * Plugins from ~/.vim/pack/plugins/opt will be loaded manually here or in ~/.vim/ftplugin

" ---
"  Variables
" ---
let mapleader = ','
" ALE
let g:ale_set_highlights = 1
" Gutentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['Cargo.toml', 'package.json', '.git']
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_ctags_extra_args = ['--tag-relative=yes', '--fields=+ailmnS']
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg', '*/tests/*', 'build', 'dist',
      \ '*sites/*/files/*', 'bin', 'node_modules', 'bower_components',
      \ 'cache', 'compiled', 'docs', 'example', 'bundle', 'vendor', 'target',
      \ '*.md', '*-lock.json', '*.lock', '*bundle*.js', '*build*.js', '.*rc*',
      \ '*.json', '*.toml', '*.min.*', '*.map', '*.bak', '*.zip', '*.pyc',
      \ '*.class', '*.sln', '*.Master', '*.csproj', '*.tmp', '*.csproj.user',
      \ '*.cache', '*.pdb', 'tags*', 'cscope.*', '*.css', '*.less', '*.scss',
      \ '*.exe', '*.dll', '*.mp3', '*.ogg', '*.flac', '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]
" Gruvbox8
let g:gruvbox_italicize_strings = 0

" ---
"  Options
" ---
syntax enable

filetype plugin indent on

set background=dark
set showcmd
set relativenumber
set numberwidth=1
set autoread
set path+=src/**,static/**,config/**,components/**,shared/**,pages/**,utils/**
set foldcolumn=1
set cursorline
set cursorlineopt=number,line
set wildmenu
set wildignore+=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/node_modules/*
set hidden
set backspace=eol,start,indent
set whichwrap+=h,l
set ignorecase
set smartcase
set tagcase=followscs
set hlsearch
set incsearch
set showmatch
set matchtime=1
set colorcolumn=80
set formatoptions+=j
set textwidth=0
set linebreak
set breakindent
set showbreak=>
set updatetime=1000
set autoindent
set smartindent
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set switchbuf=useopen,split
set ttimeout ttimeoutlen=50
set laststatus=2
set statusline=\ %t\ %(\|\ %R\ %)%(\|\ %M\ %)%(\|\ %{GitStatus()}\ %)%(\|\ %{gutentags#statusline()}\ %)
set statusline+=%=%{&filetype}\ \|%8.(\ %l:%c%)\ (%LL)

" ---
"  Maps
" ---
" Easier way to move between windows
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l
" Map <Space> to / (search) 
noremap <Space> /
" swap functionality of 0 and ^ because 0 is faster to reach while ^ is often the functionality I want
noremap 0 ^
noremap ^ 0

" ---
"  Normal Mode Maps
" ---
nnoremap <leader>w :w<cr>
" Make Y behave consistently with other operators
nnoremap Y y$
" Disable highlight when <leader><cr> is pressed
nnoremap <silent> <leader><cr> :noh<cr>
" jump to tag
nnoremap <leader>t :tag <c-r><c-w><cr>
" jump to tag with horizonal split window
nnoremap <leader>st :stag <c-r><c-w><cr>
" jump to tag with vertical split window
nnoremap <leader>vt :vert stag <c-r><c-w><cr>
" show tag in preview window
nnoremap <leader>pt :ptag <c-r><c-w><cr>
" Toggle paste mode on and off
nnoremap <leader>pp :setlocal paste!<cr>
" Pressing ,ss will toggle and untoggle spell checking
nnoremap <leader>ss :setlocal spell!<cr>
" go to next spelling error
nnoremap <leader>sn ]s
" go to previous spelling error
nnoremap <leader>sp [s
" show details of error/warning
nnoremap <leader>ad :ALEDetail<cr>
" go to next error/warning
nnoremap <leader>an :ALENextWrap<cr>
" go to previous error/warning
nnoremap <leader>ap :ALEPreviousWrap<cr>

" ---
"  Augroups / Autocmds and Highlights
" ---
augroup bufevent
    autocmd!
    " Return to last edit position when opening files
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " Remove trailing whitespace
    autocmd BufWritePre *.txt,*.js,*.jsx,*.ts,*.tsx,*.go,*.py,*.sh,*.rs %s/\s\+$//e
augroup END
augroup MyGutentagsStatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating redrawstatus
    autocmd User GutentagsUpdated redrawstatus
augroup END
augroup gruvbox
    autocmd!
    autocmd ColorScheme gruvbox8 call ChangeHighlights()
augroup END

" ---
"  Functions
" ---
function ChangeHighlights()
    highlight FoldColumn ctermbg=NONE
    " Change Quick Scope colors and add underline
    highlight QuickScopePrimary ctermfg=155 cterm=underline
    highlight QuickScopeSecondary ctermfg=81 cterm=underline
endfunction

" function to get count of added, modified and removed lines for git, used for statusline
function GitStatus()
    let [a,m,r] = GitGutterGetHunkSummary()
    if (a || m || r) 
        return printf('+%d ~%d -%d', a, m, r)
    else
        return ''
    endif
endfunction

" show 'ctags' in statusbar when generating tags
function GTags()
    let generating = gutentags#statusline()
    return generating
endfunction

colorscheme gruvbox8
