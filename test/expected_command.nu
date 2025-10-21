# local command
ls e+o>| get -i name
| length; ls # multiline command
| length
# external command
^git add (
  ls
  | get -i name
)
FOO=BAR BAR=BAZ ^$cmd --arg1=val1 -arg2 arg=value arg=($arg3)
cat unknown.txt o+e> (null-device)

$hash err>| $in + "\n" out>> $NUENV_FILE
