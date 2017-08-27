# This is the custom theme template for gitprompt.sh

override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Custom"

  GIT_PROMPT_LEADING_SPACE=0

  GIT_PROMPT_PREFIX="-["               # start of the git info string
  GIT_PROMPT_SEPARATOR=""              # separates each item

  GIT_PROMPT_BRANCH="${Magenta}"       # the git branch that is active in the current directory
  GIT_PROMPT_STAGED=" ${Red}●"         # the number of staged files/directories
  GIT_PROMPT_CONFLICTS=" ${Red}✖"      # the number of files in conflict
  GIT_PROMPT_CHANGED=" ${Blue}✚"       # the number of changed files

  GIT_PROMPT_UNTRACKED=" ${Cyan}…"     # the number of untracked files/dirs
  GIT_PROMPT_STASHED=" ${BoldBlue}⚑"   # the number of stashed files/dir
  GIT_PROMPT_CLEAN=" ${BoldGreen}✔"    # a colored flag indicating a "clean" repo

  GIT_PROMPT_SHOW_UNTRACKED_FILES=no

  GIT_PROMPT_COMMAND_OK=""
  GIT_PROMPT_COMMAND_FAIL="${Red}→_LAST_COMMAND_STATE_ "

  local time="${White}[${BoldBlue}\@${White}]${ResetColor}"
  local hist="${White}[${BoldWhite}\!${White}]${ResetColor}"
  local dir="${White}[${BoldYellow}\w${White}]${ResetColor}"
  GIT_PROMPT_START_USER="\n${time}-${hist}-${dir}"
  GIT_PROMPT_START_ROOT="${GIT_PROMPT_START_USER}"

  # add vagrant status if we're in a vagrant dir
  local vagrant_status_cmd="$(vagrant_local_status)"
  local vagrant_status=""
  if [ "${vagrant_status}" != "" ]; then
    vagrant_status="${White}[${Cyan}${vagrant_status_cmd}${White}]${ResetColor}"
  fi

  GIT_PROMPT_END_USER="${vagrant_status}\n_LAST_COMMAND_INDICATOR_${ResetColor}$ "
  GIT_PROMPT_END_ROOT="${vagrant_status}\n_LAST_COMMAND_INDICATOR_${ResetColor}# "
}

reload_git_prompt_colors "Custom"
