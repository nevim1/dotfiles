# nevim's dotfiles

These are my (nevim's) dotfiles, they do a lot of things.


## Installation
Clone this repo and then run `./setup.sh` it should symlink everything to your home dir

## Configuration
If you install this as new, it will yell on you, that you have not yet set up `.dot.conf`.
This is THE configuration file, where all the differences between my machine will be.

setting | default | description
------- | ------- | -----------
`sshPrivateKey` | `''` | path to you ssh private key (for automatic ssh starting)


If you add something here that you do not want to be symlinked to home dir, put it into .lsignore
