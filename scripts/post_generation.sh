#! /usr/bin/env bash

# HACK: Manually define the venv `deactivate` function and run it.
#       This is needed as poetry does not create a new virtual enviroment
#       if one is currently activated.

# install dependencies
make install
