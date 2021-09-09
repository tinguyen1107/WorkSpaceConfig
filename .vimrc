" ------ Config NEO VIM ------ "
syntax enable
syntax on


" ------ Setup ------ "
set number
"set mouse=a
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set smarttab

set cmdheight=3
set showmatch
set smartcase
set noswapfile
set incsearch
set encoding=utf-8
set hidden
set shortmess+=c
set cursorline
set nobackup
set nowritebackup

set background=dark
set termguicolors


" ------ PLUGIN ------ "
call plug#begin ('~/.vim/plugged')
    " color scheme
    Plug 'morhetz/gruvbox'

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'jiangmiao/auto-pairs'

    Plug 'yuezk/vim-js'
    Plug 'maxmellon/vim-jsx-pretty'
    Plug 'HerringtonDarkholme/yats.vim'
    " or Plug 'leafgarland/typescript-vim'
    Plug 'maxmellon/vim-jsx-pretty'
    
    Plug 'pangloss/vim-javascript'
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
    Plug 'jparise/vim-graphql'    

    Plug 'christoomey/vim-tmux-navigator'

call plug#end()

colorscheme gruvbox

" ------ Map ------ "
" Insert Mode
inoremap jj <ESC>
inoremap <C-z> <C-o>:u <CR>

" Normal Mode
nnoremap <C-z> :u <CR>
nnoremap <silent> <C-k> <c-w>k<CR>
nnoremap <silent> <C-j> <c-w>j<CR>
nnoremap <silent> <C-h> <c-w>h<CR>
nnoremap <silent> <C-l> <c-w>l<CR>

" ------ Compile C++ ------ "
nnoremap <f8> <esc>:!g++ -std=c++14 -o %:r %:t<enter>


" ------ Setup for Nerd Tree ------ "
" NERDTreeToggle
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
" autocmd VimEnter * NERDTree | wincmd p

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-o> :NERDTreeToggle<CR>
nnoremap <C-s> :NERDTreeFind<CR>


" ------ Setup NERDTree Commenter ------ "
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_java = 1
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1


" ------ Setup for FZF ------ "
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags -R'
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

if has("nvim")
    autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
endif

let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

nnoremap <silent> <Leader>c  :Commits<CR>
nnoremap <silent> <Leader>bc :BCommits<CR>

nnoremap <silent> <Leader>bb :VBuffers<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <leader>f :Rg<CR>
"command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

" ------ coc.vim ------ "
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" ------ Setup for AutoPairs ------"
if get(g:, 'AutoPairsFlyMode', 0) == 0
   function! s:replace_autopairs_map(char)
      let afterStr = strpart(getline('.'), col('.')-1)
      if afterStr =~ '^\s*'.a:char
        return a:char
     elseif afterStr =~ '^\s*$'
        let nextLineNum = getpos('.')[1] + 1
        let nextLine = getline(nextLineNum)
        while nextLineNum <= line('$') && nextLine =~ '^\s*$'
          let nextLineNum += 1
          let nextLine = getline(nextLineNum)
        endwhile
        if nextLine =~ '^\s*'.a:char
          return a:char
        else
          return AutoPairsInsert(a:char)
        endif
      else
        return AutoPairsInsert(a:char)
      endif
    endfunction

    function! s:disable_autopair_flymod()
      if b:autopairs_loaded < 2
       iunmap <buffer> }
        iunmap <buffer> ]
        iunmap <buffer> )
        iunmap <buffer> `
        iunmap <buffer> '
        iunmap <buffer> "
        inoremap <buffer> <silent> } <c-r>=<SID>replace_autopairs_map('}')<cr>
        inoremap <buffer> <silent> ] <c-r>=<SID>replace_autopairs_map(']')<cr>
        inoremap <buffer> <silent> ) <c-r>=<SID>replace_autopairs_map(')')<cr>
        inoremap <buffer> <silent> ` <c-r>=<SID>replace_autopairs_map('`')<cr>
        inoremap <buffer> <silent> ' <c-r>=<SID>replace_autopairs_map("'")<cr>
        inoremap <buffer> <silent> " <c-r>=<SID>replace_autopairs_map('"')<cr>
      endif
      let b:autopairs_loaded = 2
    endfunction

    augroup AutoPairs
      autocmd InsertEnter * call s:disable_autopair_flymod()
    augroup END
endif 

" Colorful style (vim-javascript only)
let g:vim_jsx_pretty_colorful_config = 1 " default 0
let g:coc_global_extensions = [
  \ 'coc-tsserver'
  \ ]

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

nnoremap <silent> K :call CocAction('doHover')<CR>

function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>

nmap <leader>do <Plug>(coc-codeaction)

nmap <leader>rn <Plug>(coc-rename)
