# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
#export DISPLAY=10.60.0.183:0.0

source ~/perl5/perlbrew/etc/bashrc

[[ -s /home/okada/.nvm/nvm.sh ]] && . /home/okada/.nvm/nvm.sh # This loads NVM
