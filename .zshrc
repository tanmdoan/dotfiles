# zsh
  HYPHEN_INSENSITIVE=true
  COMPLETION_WAITING_DOTS=true

  function move-last-download {
    local download_dir="${HOME}/Downloads/"
    local last_download="$(ls -t ${download_dir} | head -1)"
    local destination_file="${PWD}/${1:-${last_download}}"

    echo "MV: ${download_dir}${last_download}"
    echo "TO: ${destination_file}"

    mv "${download_dir}${last_download}" "${destination_file}"
  }

  function find-file() {
    find ~ -iname "*$1*" 2>/dev/null
  }

  function killports () {
    for port in "$@"; do
      pid=$(lsof -i tcp:$port -t)

      if [[ $pid ]]; then
        kill -9 $pid
        echo "killed port: $port"
      else
        echo "No proccess matching port: $port"
      fi
    done
  }

# autoujump
  [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# aliases
[[ -f ~/.aliasrc ]] && source ~/.aliasrc

# nope
[[ -f ~/.cigarettes.rc ]] && source ~/.cigarettes.rc

# pnpm
export PNPM_HOME="/Users/tandoan/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Load rbenv automatically
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# 9to5
source ~/.9to5rc

# postgres
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# ruby
eval "$(rbenv init - zsh)"

#node
eval "$(fnm env --use-on-cd --shell zsh)"

# bun completions
[ -s "/Users/tdoan/.bun/_bun" ] && source "/Users/tdoan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"