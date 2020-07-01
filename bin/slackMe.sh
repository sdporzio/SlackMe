#!/bin/bash
### CALCULATE TIME
SME_THISSESSIONRUNTIME="$((SME_THISSESSIONENDTIME-SME_THISSESSIONSTARTTIME))"
SME_THISSESSIONMIN=$(( ${SME_THISSESSIONRUNTIME}/60 ))
SME_THISSESSIONSEC=$(( ${SME_THISSESSIONRUNTIME}%60 ))
if [ "${SME_THISSESSIONRUNTIME}" -gt "60" ];
then
    SME_THISSESSIONTIMEMESSAGE="${SME_THISSESSIONMIN} minutes and ${SME_THISSESSIONSEC} seconds"
else
    SME_THISSESSIONTIMEMESSAGE="${SME_THISSESSIONSEC} seconds"
fi


### ADD EXTRA INFORMATION LIKE SCREEN SESSION, OR TMUX SESSION AND LOCATION OF LOG FILE
SME_ADDINFO=""
if [[ ! -z "$STY" ]]; then
	SME_ADDINFO="${SME_ADDINFO}\n|_ Screen session: _${STY}_"
fi

if [[ ! -z "$TMUX" ]]; then
  echo "we in tmux"
  SME_TMUXSESSION=$(tmux display-message -p "#S")
  SME_ADDINFO="${SME_ADDINFO}\n|_ Tmux session: _${SME_TMUXSESSION}_"
fi

if [[ ! -z "${SME_THISSESSIONLOG}" ]] && [ -f ${SME_THISSESSIONLOG} ]; then
	# Transfer content of log to variable
	SME_LOGPREVIEW=$(tail -n 5 ${SME_THISSESSIONLOG})
	# Add escape characters that can break payload
	SME_LOGPREVIEW=$(echo "$SME_LOGPREVIEW" | sed "s~\(['\"\/]\)~\\\\\1~g")
	SME_ADDINFO="${SME_ADDINFO}\n|_ Log file: _${SME_THISSESSIONLOG}_"
	SME_ADDINFO="${SME_ADDINFO}\n\`\`\`${SME_LOGPREVIEW}\`\`\`"
else
	SME_ADDINFO="${SME_ADDINFO}\n|_ Log file: _No log file available_"
fi

### STANDARD NOTIFICATION ###
# If no user input message, then generate default one
if [[ -z "$SME_COMMAND" ]]; then
	SME_COMMAND="$(history 2 | head -n 1)"
  # Remove " from message (they break payload)
  SME_COMMAND=$(echo "$SME_COMMAND" | sed "s~\(['\"\/]\)~\\\\\1~g")
	SME_MESS="# *| ${SME_COMMAND} |* on ${HOSTNAME}:${PWD} is now completed.${SME_ADDINFO}"
else
	SME_MESS="# *| ${SME_COMMAND} |* on ${HOSTNAME}:${PWD} has completed in ${SME_THISSESSIONTIMEMESSAGE} with status ${SME_STATUS}."
	SME_MESS="$SME_MESS$SME_ADDINFO"
fi

# Generate payload and send to Slack
SME_PAYLOAD="payload={\"channel\": \"$SME_CHANNEL\", \"as_user\": false, \"username\": \"$SME_USERNAME\", \"text\": \"$SME_MESS\"}"
curl -X POST --data-urlencode "$SME_PAYLOAD" "$SME_HOOKS" &> ${SME_NULL}

