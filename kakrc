hook global WinSetOption filetype=elm %{
  set window formatcmd 'elm-format --stdin'
 
  hook buffer BufWritePre .* %{format}
}

hook global NormalKey y|d|c %{ nop %sh{
  printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

map global normal ';' ':'

set global tabstop 2
#set global indentwidth 2


