# setup-react

A simple function for setting up JavaScript + React projects, including Webpack, in a your teminal.

## Setting up this function

You **must** install jq and moreutils to use this function. 
For Mac Users: brew install jq; brew install moreutils

For Linux: apt install jq; apt install moreutils


For bash users: You can copy and paste this in your .bash_profile folder (you can open this up to edit in VSCode using the command code ~/.bash_profile)

For zsh users: You should copy and paste this either in your .zshrc or .zshenv file (I picked my .zshenv file).

## Basic instructions for using setup-react

This function takes in two arguments: a source folder name and an entry file name. If no arguments are passed, the default names will be frontend and entry_file.jsx. 

If you only want to change the name of the entry_file, you **must** still pass in an argument for the source folder (this is due to terminal functions being weird and only allowing arguments to be referenced by the number arg that they were).

### How to call this function in terminal: 

setup-react <folder_name> <filename>
ex. setup-react src index.jsx

### Note
I have uploaded the file as a .zsh so that the coloring in code editors would look nice. **Please** copy and paste the code within setup-react.zsh into a file that is suitable for your shell.
