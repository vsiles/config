"nnoremap <leader>a :echo("\<leader\> works! It is set to <leader>")<CR>
"set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'godlygeek/tabular'
Plugin 'let-def/ocp-indent-vim'
Plugin 'let-def/vimbufsync'
Plugin 'ludovicchabant/vim-lawrencium'
Plugin 'majutsushi/tagbar'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'racer-rust/vim-racer'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'rust-lang/rust.vim'
Plugin 'Shougo/deoplete.nvim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/a.vim'
Plugin 'w0rp/ale'
Plugin 'whonore/Coqtail'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line 

" Function to source only if file exists
function! SourceIfExists(file)
    if filereadable(expand(a:file))
        exe 'source' a:file
    endif
endfunction

syntax enable
set hlsearch
set shiftwidth=4
set softtabstop=4
set expandtab
set incsearch
set cino+=(0
set textwidth=78

" save & build
autocmd FileType c,tex command! -nargs=? W write | make

colorscheme wombat256mod

set cursorline
set cursorcolumn

" split
set splitbelow
set splitright

" air-line
set laststatus=2
let g:airline_theme='badwolf'

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
set ttimeoutlen=10

call SourceIfExists("~/.vimrc.macos")
call SourceIfExists("~/.vimrc.fb")

" Include - (ASCII 45) and : (ASCII 58) as part of word for tag searches
autocmd FileType php setlocal iskeyword=@,45,48-57,58,_,192-255,#
set hlsearch

" set colorcolumn=81,101 " absolute columns to highlight "
set colorcolumn=+1,+21 " relative (to textwidth) columns to highlight "

syn match tab display "\t"
hi link tab Error

"setlocal spell spelllang=en_us
set spelllang=en_us
set nospell
nnoremap <F10> :set spell!<CR>

" Spell Check
let b:myLang=0
let g:myLangList=["nospell","fr","en_us"]
function! ToggleSpell()
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
endfunction

nmap <silent> <Leader>s :call ToggleSpell()<CR>

" Tab completion behavior
set wildmode=longest,list,full
set wildmenu

set switchbuf+=usetab,newtab

nnoremap <C-W>o <C-W>o:diffoff<CR>

" Latex Mapping
imap \vdash ⊢
imap \forall ∀
imap \bto ▹
imap \Gamma Γ
imap \lambda λ
imap \Pi Π
imap \equiv ≡
imap \to →
imap \dot •
imap \sigma σ

autocmd FileType tex imapclear

fun! StripTrailingWhitespaces()
  if !&binary && &filetype != 'diff'
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
  endif
endfun
autocmd FileType c,cpp,java,php,ruby,python,ocaml,lisp autocmd BufWritePre <buffer> :call StripTrailingWhitespaces()

" Color stuff
" set t_Co=256
" set t_ut=

" autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
" autocmd Syntax * syn match OverLength /\%80v.\+/

" vim-commentary
autocmd FileType ocaml setlocal commentstring=(*\ %s\ *)
autocmd FileType coq setlocal commentstring=(*\ %s\ *)

" Coq files
autocmd FileType coq setlocal formatoptions-=o

" netRW
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

" terminal-specific magic
let s:iterm   = exists('$ITERM_PROFILE') || exists('$ITERM_SESSION_ID') || filereadable(expand("~/.vim/.assume-iterm"))
let s:screen  = &term =~ 'screen'
let s:tmux    = exists('$TMUX')
let s:xterm   = &term =~ 'xterm'

if has('mouse')
    set mouse=a
    if s:screen || s:xterm
      set ttymouse=xterm2
    endif
endif

set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"" Vim 8: sending text to terminal
augroup my_terminal
    autocmd!
        autocmd BufWinEnter,TerminalOpen * if &buftype ==# 'terminal' |
                    \     call s:my_term(+expand('<abuf>')) |
                    \ endif
augroup END

let s:terms = {}
function! s:my_term(bufnr)
    let tabpagenr = tabpagenr()
    let s:terms[tabpagenr] = a:bufnr
endfunction

function! s:op(type, ...)
      let [sel, rv, rt] = [&selection, @@, getregtype('"')]
      let &selection = "inclusive"

      if a:0 
        silent exe "normal! `<" . a:type . "`>y"
      elseif a:type == 'line'
        silent exe "normal! '[V']y"
      elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]y"
      else
        silent exe "normal! `[v`]y"
      endif

    call s:send_to_term(@@)

      let &selection = sel
        call setreg('"', rv, rt)
endfunction

function! s:send_to_term(keys)
    let bufnr = get(s:terms, tabpagenr(), 0)
    if bufnr > 0 && bufexists(bufnr)
        let keys = substitute(a:keys, '\n$', '', '')
        call term_sendkeys(bufnr, keys . "\<cr>")
        echo "Sent " . len(keys) . " chars -> " . bufname(bufnr)
    else
        echom "Error: No terminal"
    endif
endfunction

command! -range -bar SendToTerm call s:send_to_term(join(getline(<line1>, <line2>), "\n"))
nmap <script> <Plug>(send-to-term-line) :<c-u>SendToTerm<cr>
nmap <script> <Plug>(send-to-term) :<c-u>set opfunc=<SID>op<cr>g@
xmap <script> <Plug>(send-to-term) :<c-u>call <SID>op(visualmode(), 1)<cr>

nmap yrr <Plug>(send-to-term-line)
nmap yr <Plug>(send-to-term)
xmap R <Plug>(send-to-term)
"" sending text to terminal

"" RLS
if executable('rls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'rls',
                \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
                \ 'whitelist': ['rust'],
                \ })
endif
"" see https://github.com/prabirshrestha/vim-lsp for the command

"" Rust
let g:racer_experimental_complete = 1
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" Old syntastic stuff
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_ocaml_checkers = ['merlin']
" let g:syntastic_coq_checkers = []
" let g:syntastic_python_checkers = ['flake8']
" let g:syntastic_python_flake8_exec = 'python3'

function! Tapi_newTab(bufnum, arglist)
    if len(a:arglist) == 0
        echomsg "newTab: Missing filename"
    else
        tabnew a:arglist[0]
    endif
endfunction

" Target is displayed in a new tab
" let g:merlin_split_method = "tab"

command! OcamlFormat :w | %!ocamlformat %

set number

" Deoplete
let g:deoplete#enable_at_startup = 1

let no_ocaml_maps = 1

" ## added by OPAM user-setup for vim / base ##
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ##
if count(s:opam_available_tools,"ocp-indent") == 0
" Using Fred's ocp-indent
"  source "/home/vsiles/.opam/default/share/ocp-indent/vim/indent/ocaml.vim"
  source "/home/vsiles/.vim/bundle/ocp-indent-vim/indent/ocaml.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line

if executable('ocaml-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'ocaml-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'opam config exec -- ocaml-language-server --stdio']},
        \ 'whitelist': ['reason', 'ocaml'],
        \ })
endif

" ale
let g:ale_linters = { 'python': [] }
