# Powerlevel10k — tema Niebla, minimalista.
# Una sola línea, todo a la izquierda, sin fondos ni separadores:
#
#   󰉋 ~/dev/personal/Beacon-Split 󰘬 main ⇡1 +2 !1 ?3  ❯
#
# Copia del estilo anterior (dos líneas, pastillas): ~/.p10k.zsh.bak-2026-10-26

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

  # Solo a la izquierda: carpeta, git y el carácter de prompt
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs prompt_char)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  # Estilo "lean": sin fondos ni separadores powerline
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'

  # Una línea, con un respiro entre comandos
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=

  # --- Carpeta: icono + ruta acortada, la carpeta actual resaltada ---
  typeset -g POWERLEVEL9K_DIR_FOREGROUND='#8a8f93'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#5b5e60'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#f4f5f6'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=40
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_VISUAL_IDENTIFIER_EXPANSION='%F{#b8656a}󰌾'
  # Icono según dónde estés: casa en ~, carpeta en el resto
  typeset -g POWERLEVEL9K_DIR_CLASSES=(
    '~(|/*)'  HOME     ''
    '*'       DEFAULT  '')
  typeset -g POWERLEVEL9K_DIR_HOME_VISUAL_IDENTIFIER_EXPANSION='%F{#c8ccd0}󰋜'
  typeset -g POWERLEVEL9K_DIR_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='%F{#c8ccd0}󰉋'
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND='#8a8f93'
  typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='#8a8f93'
  typeset -g POWERLEVEL9K_DIR_HOME_ANCHOR_FOREGROUND='#f4f5f6'
  typeset -g POWERLEVEL9K_DIR_DEFAULT_ANCHOR_FOREGROUND='#f4f5f6'
  typeset -g POWERLEVEL9K_DIR_HOME_SHORTENED_FOREGROUND='#5b5e60'
  typeset -g POWERLEVEL9K_DIR_DEFAULT_SHORTENED_FOREGROUND='#5b5e60'

  # --- Git: rama + estado con iconos ---
  #  rama · ⇡ commits por subir · ⇣ por bajar · +n preparados · !n modificados
  #  ?n sin seguimiento · ✘n conflictos · ≡n stash · ●  cambios en curso (rebase/merge)
  function my_git_formatter() {
    emulate -L zsh
    if [[ -n $P9K_CONTENT ]]; then           # gitstatus aún calculando
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    local      base='%F{#8b98a6}'   # acero: icono y rama
    local     clean='%F{#a9b9a5}'   # musgo: todo limpio
    local  modified='%F{#c4b49a}'   # hueso: hay cambios
    local untracked='%F{#8a8f93}'   # niebla: sin seguimiento
    local  conflict='%F{#c98287}'   # rojo apagado: conflictos
    local      sync='%F{#a7b4c1}'   # ahead/behind

    local res where
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      where=${(V)VCS_STATUS_LOCAL_BRANCH}
    elif [[ -n $VCS_STATUS_TAG ]]; then
      where="#${(V)VCS_STATUS_TAG}"
    else
      where="@${VCS_STATUS_COMMIT[1,8]}"
    fi
    (( $#where > 32 )) && where[13,-13]="…"

    local dirty=0
    (( VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_CONFLICTED )) && dirty=1

    res+="${base}󰘬 "
    (( dirty )) && res+="${modified}${where//\%/%%}" || res+="${clean}${where//\%/%%}"

    (( VCS_STATUS_COMMITS_AHEAD  )) && res+=" ${sync}⇡${VCS_STATUS_COMMITS_AHEAD}"
    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${sync}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_STASHES        )) && res+=" ${untracked}≡${VCS_STATUS_STASHES}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflict}✘${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${clean}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflict}● ${VCS_STATUS_ACTION}"

    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
  typeset -g POWERLEVEL9K_VCS_LOADING_TEXT='%F{#5b5e60} …'
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  # --- Carácter de prompt: plata si fue bien, rojo apagado si falló ---
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#c8ccd0'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#c98287'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
