source ~/.bashrc

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

alias ltmate="tmate_ssh=tmate display -p '#{tmate_ssh}'"

terminate(){
    lsof -P | grep ':3000' | awk '{print $2}' | xargs kill -9 
  }

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
