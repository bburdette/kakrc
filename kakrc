eval %sh{kak-lsp --kakoune -s $kak_session}
nop %sh{ (kak-lsp -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }

lsp-enable

# spaces instead of tabs.
hook global InsertChar \t %{ try %{
  execute-keys -draft "h<a-h><a-k>\A\h+\z<ret><a-;>;%opt{indentwidth}@"
}}

hook global InsertDelete ' ' %{ try %{
  execute-keys -draft 'h<a-h><a-k>\A\h+\z<ret>i<space><esc><lt>'
}}

hook global InsertCompletionShow .* %{
    try %{
        # this command temporarily removes cursors preceded by whitespace;
        # if there are no cursors left, it raises an error, does not
        # continue to execute the mapping commands, and the error is eaten
        # by the `try` command so no warning appears.
        execute-keys -draft 'h<a-K>\h<ret>'
        map window insert <tab> <c-n>
        map window insert <s-tab> <c-p>
    }
}
hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
}

# elm format-on-write
hook global WinSetOption filetype=elm %{
  set window formatcmd 'elm-format --stdin'

  hook buffer BufWritePre .* %{format}
}

# yank should go to system clipboard as well as the kakoune register.
hook global NormalKey y|d|c %{ nop %sh{
  printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

# use 'p or 'P to paste from the system clipboard.
map global user P '!xsel --output --clipboard<ret>'
map global user p '<a-!>xsel --output --clipboard<ret>'

add-highlighter global/ show-matching
set-face global MatchingChar green,black+brd

# problem with this is it doesn't work on a blank line.
#map global insert <tab> '<a-;><gt>'

# mapping so that : and ; are the same - command mode.
# then , is for ;                      - clear selection
# and ' is for ,                       - user mode.
map global normal ';' ':'
map global normal ',' ';'
map global normal "'" ','

set global tabstop 2
set global indentwidth 2
