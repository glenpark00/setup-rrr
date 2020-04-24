# setup-rrr

Because boilerplate code really sucks.

## About

The goal of this project is to create a set of console commands that will take a lot of the boilerplate code out of setting up and developing a web app using React and Redux, with a Rails backend. At the moment, this project consists of two functions: the first one (setup-react) will setup a simple React project for you, with the basic packages and webpack all configured; the second one (setup-rrr) will setup a complete React-Redux-Rails project for you. This includes adding some useful/necessary gems (however, BCrypt is still commented out in the Gemfile!), installing all required packages, setting up the state shape and reducers, and giving you a basic entry file. 

This project is still developing, and the end goal for it is to be fully fleshed out into a package that can aid in creating and developing any React-Redux-Rails project.

## Setting up this function

You **must** install jq and moreutils to use this function.
For Mac Users: brew install jq; brew install moreutils

For Linux: apt install jq; apt install moreutils

You also must have Ruby on Rails installed (gem install rails -v 5.2.3) as well as Node Package Manager (brew install npm).

For bash users: You can copy and paste the functions into your .bash_profile folder (you can open this up to edit in VSCode using the command code ~/.bash_profile)

For zsh users: You should copy and paste the functions either in your .zshrc or .zshenv file (I picked my .zshenv file).

## Basic instructions for using these functions

These functions take in three arguments: the name of the project, an entry file name (**without** any extension), and a source folder name. The default names for the entry file and source folder are entry_file.jsx and frontend; you must provide the function with the project name argument.

If you only want to change the name of the source folder, you **must** still pass in an argument for the entry file (this is due to terminal functions being weird and only allowing arguments to be referenced by the number arg that they were).

### How to call these functions in terminal: 

- `setup-react <project_name> <file_name> <folder_name>`

ex.  `setup-react react_proj index src`

- `setup-rrr <project_name> <file_name> <folder_name>`

ex.  `setup-rrr rails_proj entry_file frontend `

### Note
I have uploaded the file as a .zsh so that the coloring in code editors would look nice. **Please** copy and paste the code within setup-react.zsh into a file that is suitable for your shell.
