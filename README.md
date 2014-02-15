# Lee's Dotfile Customizations

These are my extensions to the [Thoughtbot dotfiles project](https://github.com/thoughtbot/dotfiles). They coexist with the Thoughtbot configuration files wherever possible. Where coexistence isn't possible, like with the `.gitignore` configuration, this project is designed to clobber Thoughtbot's configuration file.

This is intended to replace my [environment project](https://github.com/lee-dohm/environment).

## Prerequisites

1. Install [Homebrew](http://brew.sh/) if it isn't already
1. Install [rcm](https://github.com/thoughtbot/rcm)

## Installation

Since I'm using the Thoughtbot dotfiles as a basis and keeping my customizations separate, this is a little more complicated than perhaps it should be.

1. Clone the Thoughtbot dotfiles: `git clone git://github.com/lee-dohm/thoughtbot-dotfiles.git`
1. Clone this project: `git clone git@github.com:lee-dohm/dotfiles.git personal-dotfiles`
1. Install the dotfiles (this has to be done in two steps currently due to a bug in rcm)
    1. `rcup -d personal-dotfiles -x LICENSE.md -x README.md`
    1. Press ENTER when prompted
    1. `rcup`

## Copyright

Copyright &copy; 2014 [Lee Dohm](http://www.lee-dohm.com), [Lifted Studios](http://www.liftedstudios.com). See [LICENSE](LICENSE.md) for details.
