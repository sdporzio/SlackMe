# The directory where this file is located, regardless of where it is called from
export SME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export SME_NULL="${SME_DIR}/null/null"
export SME_LOG="${SME_DIR}/logs"
export SME_BIN="${SME_DIR}/bin"
export PATH=${SME_DIR}/bin:${PATH}
source ${SME_DIR}/conf/slackMe.conf