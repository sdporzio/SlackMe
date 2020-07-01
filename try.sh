# if [[ ! -z "$TMUX" ]]; then
#   SME_ADDINFO="${SME_ADDINFO}\n|_ Screen session: _${STY}_"
# fi

if [[ ! -z "$TMUX" ]]; then
  echo "we in tmux"
  SME_TMUXSESSION=$(tmux display-message -p "#S")
  echo "session ${SME_TMUXSESSION}"
else

  echo "not in tmux"
fi