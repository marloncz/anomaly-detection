#! /usr/bin/env bash

# Update pyenv if python version is not yet available
if ! pyenv install -list | grep -q 3.10.10; then
    brew update && brew upgrade pyenv
fi

# Install version '3.10.10' of python using pyenv
pyenv install -s 3.10.10

# HACK: Manually define the venv `deactivate` function and run it.
#       This is needed as poetry does not create a new virtual enviroment
#       if one is currently activated.
deactivate () {
    unset -f pydoc > /dev/null 2>&1 || true
    if ! [ -z "${_OLD_VIRTUAL_PATH:+_}" ]
    then
        PATH="$_OLD_VIRTUAL_PATH"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi
    if ! [ -z "${_OLD_VIRTUAL_PYTHONHOME+_}" ]
    then
        PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME"
        export PYTHONHOME
        unset _OLD_VIRTUAL_PYTHONHOME
    fi
    hash -r 2> /dev/null
    if ! [ -z "${_OLD_VIRTUAL_PS1+_}" ]
    then
        PS1="$_OLD_VIRTUAL_PS1"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi
    unset VIRTUAL_ENV
    if [ ! "${1-}" = "nondestructive" ]
    then
        unset -f deactivate
    fi
}
deactivate

# Create .python-version file to specify local python version
pyenv local 3.10.10

# Create a poetry enviroment with correct python version
if [[ ${TEST_ENVIRONMENT:-0} -eq 1 ]]
then
    # calculate hash project
    hash=$( md5 -q pyproject.toml )

    # find cached directory from hash
    cache_dir=${CACHED_VENV_DIR:-"$HOME/.cache/venvs"}
    mkdir -p "$cache_dir"
    cache_venv="$cache_dir/$hash"

    # create virualenv with python version 3.10.10 if not exists
    if [[ ! -d "$cache_venv" ]]
    then
        $(pyenv prefix 3.10.10)/bin/python -m venv "$cache_venv"
    else
        cp "$cache_venv/poetry.lock" poetry.lock
    fi

    # activate virtualenv
    source "$cache_venv/bin/activate"

    # configure poetry to use virtualenv
    poetry config virtualenvs.create false --local

    # install dependencies
    poetry install --all-extras --no-interaction

    # store poetry.lock in cache
    cp poetry.lock "$cache_venv/poetry.lock"

    # create symlink to virtualenv
    ln -s "$cache_venv" .venv
else
    # Create virtualenv with python version 3.10.10 for poetry
    poetry env use $( pyenv prefix 3.10.10 )/bin/python
    poetry config virtualenvs.create true --local
    poetry config virtualenvs.in-project true --local
    poetry install --all-extras --no-interaction
fi
