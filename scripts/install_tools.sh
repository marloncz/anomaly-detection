#! /usr/bin/env bash

# Generate .zshrc file if not exits
touch ${ZDOTDIR-~}/.zshrc

# Install Homebrew <https://brew.sh/index_de>
if ! command -v brew &>/dev/null; then
    echo "Install Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    # Update Homebrew
    brew update
fi


# Install Direnv
if ! command -v direnv &>/dev/null; then
    echo "Install Direnv..."
    brew install direnv

    # Add hook to .zshrc
    printf "\n# Run direnv hook\n" >>${ZDOTDIR-~}/.zshrc
    echo "eval \"\$(direnv hook zsh )\"" >>${ZDOTDIR-~}/.zshrc
    source ${ZDOTDIR-~}/.zshrc
fi


# Install Pyenv
if ! command -v pyenv &>/dev/null; then
    echo "Install Pyenv..."
    brew install pyenv

    # Add hook to .zshrc
    printf "\n# Run pyenv hook\n" >>${ZDOTDIR-~}/.zshrc
    echo 'eval "$(pyenv init --path)"' >>${ZDOTDIR-~}/.zshrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >>${ZDOTDIR-~}/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>${ZDOTDIR-~}/.zshrc
    echo 'export PATH="$PYENV_ROOT/shims:$PATH"' >>${ZDOTDIR-~}/.zshrc

    source ${ZDOTDIR-~}/.zshrc
fi

# Install Pipx
if ! command -v pipx &>/dev/null; then
    echo "Install Poetry..."
    brew install pipx
    pipx ensurepath
fi

# Install Poetry
# HACK: Fix version to 1.3.2 because of https://github.com/python-poetry/poetry/issues/7686
if ! command -v poetry &>/dev/null; then
    echo "Install Poetry..."
    pipx install poetry==1.3.2
fi
