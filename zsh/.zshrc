# ===== Oh My Zsh =====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# zsh-syntax-highlighting debe ir SIEMPRE el último
plugins=(
  git
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ===== PATH y entorno =====
export PATH="$HOME/.local/bin:$PATH"
# Globales de pnpm (tsc, etc.)
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"
# Acceso al portapapeles de Hyprland desde SSH
export XDG_RUNTIME_DIR=/run/user/1000
export WAYLAND_DISPLAY=wayland-1

# Sugerencias en gris-lila tenue
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5a4d6b"

# ===== Herramientas modernas =====
if command -v eza >/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lh --icons --group-directories-first --git'
  alias la='eza -lah --icons --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons'
fi
if command -v bat >/dev/null; then
  alias cat='bat --paging=never'
  export BAT_THEME="ansi"
fi
command -v glow >/dev/null && alias md='glow -p'   # visor de markdown (tema Sakura en ~/.config/glow)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v fnm    >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# fzf — colores lila (los atajos Ctrl+R/Ctrl+T/Alt+C los da el plugin fzf)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=fg:#dfdae6,hl:#c9a8d4,fg+:#ffffff,hl+:#b388c4,border:#b388c4,prompt:#c9a8d4,pointer:#c9a8d4,marker:#b388c4"
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ===== Atajos =====
command -v lazygit >/dev/null && alias lg='lazygit'
alias gs='git status'
alias gp='git pull'
alias gco='git checkout'
alias gl='git log --oneline --graph --decorate -20'
alias pn='pnpm'; alias pd='pnpm dev'; alias pb='pnpm build'; alias pi='pnpm install'
alias ff='clear && fastfetch'

# ===== Fastfetch solo en la primera terminal de la sesión =====
# El marcador vive en XDG_RUNTIME_DIR (tmpfs), que se borra al cerrar sesión.
_ff_flag="${XDG_RUNTIME_DIR:-/tmp}/fastfetch-shown"
if [[ -z $HYPRTERM && ! -e "$_ff_flag" ]]; then   # en el móvil (hyprterm) no, mejor limpio
  : > "$_ff_flag"
  fastfetch
fi
unset _ff_flag

# ===== Powerlevel10k =====
# En las terminales de hyprterm (móvil) un prompt minimal; en el escritorio el normal
if [[ -n $HYPRTERM && -f ~/.config/hyprterm/p10k-mobile.zsh ]]; then
  source ~/.config/hyprterm/p10k-mobile.zsh
else
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
