#!/bin/bash

# This script will check to see if the user has a .bash_aliases file in their home directory. If they do not, it will create one and add the alias for the script to it.

# If the user does have a .bash_aliases file, append the following aliases to it.
if [ -f ~/.bash_aliases ]; then
    printf "\n### gilliardlab group directory aliases\n" >> ~/.bash_aliases
    echo "alias already='echo appending'" >> ~/.bash_aliases
else # If the user does not have a .bash_aliases file, create one and add the aliases to it.
    touch ~/.bash_aliases
    echo "alias greet='echo new'" >> ~/.bash_aliases
fi

# Source the .bash_aliases file to make the aliases available in the current shell.
source ~/.bashrc

# Inform the user that the aliases have been added to the .bash_aliases file.
echo "Aliases have been added to the .bash_aliases file."
