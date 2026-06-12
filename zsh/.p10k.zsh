# Powerlevel10k — configuración lila a juego con Hyprland (c9a8d4 / b388c4)
# Estilo powerline con fondos + marco de dos líneas.

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Sin instant prompt (evita conflictos con fastfetch al abrir)
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

  # Segmentos
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time node_version)

  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate

  # Separadores powerline + extremos redondeados
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$''
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=$''

  # Marco de dos líneas en lila
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{#b388c4}╭─'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%F{#b388c4}├─'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{#b388c4}╰─ '

  # --- Directorio ---
  typeset -g POWERLEVEL9K_DIR_BACKGROUND='#b388c4'
  typeset -g POWERLEVEL9K_DIR_FOREGROUND='#1a1620'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#3a2f46'
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=40
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND='#1a1620'

  # --- Git (vcs) ---
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#5a4d6b'
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#a6e3a1'
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#5a4d6b'
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#e0af68'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#5a4d6b'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#e6dcf0'

  # --- Node (solo en proyectos node) ---
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND='#3a3144'
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#c9a8d4'
  typeset -g POWERLEVEL9K_NODE_ICON=$''   #

  # --- Estado (solo si falla) ---
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#3a3144'
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#ff6b81'

  # --- Duración de comandos largos ---
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#3a3144'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#b388c4'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  # --- Hora ---
  typeset -g POWERLEVEL9K_TIME_BACKGROUND='#5a4d6b'
  typeset -g POWERLEVEL9K_TIME_FOREGROUND='#dfdae6'
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

  # --- Carácter de prompt ---
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#c9a8d4'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#ff6b81'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
