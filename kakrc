eval %sh{kak-lsp --kakoune -s $kak_session}
nop %sh{ (kak-lsp -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }

lsp-enable


hook global WinSetOption filetype=elm %{
  set window formatcmd 'elm-format --stdin'

  hook buffer BufWritePre .* %{format}

# lsp-enable-window
}

# yank should go to system clipboard too.
hook global NormalKey y|d|c %{ nop %sh{
  printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

# use 'p or 'P
map global user P '!xsel --output --clipboard<ret>'
map global user p '<a-!>xsel --output --clipboard<ret>'

add-highlighter global/ show-matching
set-face global MatchingChar green,black+brd

map global insert <tab> '<a-;><gt>'

map global normal ';' ':'
map global normal ',' ';'
map global normal "'" ','

set global tabstop 2
set global indentwidth 2

#hook global WinSetOption filetype=(rust|python|go|javascript|typescript|c|cpp) %{
#    lsp-enable-window
#}

