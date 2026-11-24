ZSH_THEME_GIT_PROMPT_PREFIX="%B%F{magenta} "
ZSH_THEME_GIT_PROMPT_SUFFIX=" %f%b"
ZSH_THEME_GIT_PROMPT_DIRTY="%B%F{red}*%f%b"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function virtualenv_prompt_info() {
  if [[ -n $VIRTUAL_ENV ]]; then
    echo "%B%F{green}($(basename $VIRTUAL_ENV ))%f%b "
  fi
}

function container_prompt_info() {

  if [[ -n $CONTAINER_ID ]]; then
    echo "%B%F{magenta}($CONTAINER_ID)%f%b "
  fi
}

PROMPT="%B$(container_prompt_info)$(virtualenv_prompt_info)%F{yellow}%n%f@%F{green}%m%f:%F{cyan}%~%f$(git_prompt_info)
%F{green}$%f%b "
