#!/usr/bin/env bash
if ! [ -s "$HOME"/.pyenv/bin/pyenv ]; then
    curl https://pyenv.run | bash
fi
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# pyenv install 3.11

# pyenv versions | grep -q '3.11' && echo install 3.11


if pyenv versions  | grep -q "3.11"; then
  echo "Python 3.11 installed"
else
  echo "Python 3.11 is not installed"
  pyenv install 3.11
  echo "Python 3.11 maked installed"
fi

if pyenv versions  | grep -q "* 3.11"; then
  echo "Python 3.11 is global"
else
  echo "Python 3.11 is not global"
  pyenv global 3.11
  echo "Python 3.11 maked global"
fi



# local PROFILE_INSTALL_DIR
# PROFILE_INSTALL_DIR="$(nvm_install_dir | command sed "s:^$HOME:\$HOME:")"

SOURCE_STR="\\nexport NVM_DIR=\"${PROFILE_INSTALL_DIR}\"\\n[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\"  # This loads nvm\\n"


# if ! command grep -qc '/nvm.sh' "$NVM_PROFILE"; then
#   nvm_echo "=> Appending nvm source string to $NVM_PROFILE"
#   command printf "${SOURCE_STR}" >> "$NVM_PROFILE"
# else

# Load pyenv automatically by appending
# the following to
# ~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
# and ~/.bashrc (for interactive shells) :

SOURCE_STR_PYENV="\\nexport PYENV_ROOT=\"\$HOME/.pyenv\"\\n[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"\\neval \"\$(pyenv init -)\"  # This loads pyenv\\n"

NVM_PROFILE=".bashrc"

if ! command grep -qc '/.pyenv' "$NVM_PROFILE"; then
  echo "=> Appending pyenv  source string to $NVM_PROFILE"
  command printf "${SOURCE_STR_PYENV}" >> "$NVM_PROFILE"
fi

NVM_PROFILE=".profile"

if ! command grep -qc '/.pyenv' "$NVM_PROFILE"; then
  echo "=> Appending pyenv  source string to $NVM_PROFILE"
  command printf "${SOURCE_STR_PYENV}" >> "$NVM_PROFILE"
fi

