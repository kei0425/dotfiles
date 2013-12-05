# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# nvm
if [[ -s ~/.nvm/nvm.sh ]] ; then source ~/.nvm/nvm.sh ; fi

# User specific aliases and functions
alias sudo='sudo '
alias cpan-uninstall='\perl -MExtUtils::Install -MExtUtils::Installed -e "unshift@ARGV,new ExtUtils::Installed;sub a{\@ARGV};uninstall((eval{a->[0]->packlist(a->[1])}||do{require CPAN;a->[0]->packlist(CPAN::Shell->expandany(a->[1])->distribution->base_id=~m/(.*)-[^-]+$/)})->packlist_file,1,a->[2])"'

export SVN_EDITOR=emacsclient
export EDITOR=emacsclient

export PGHOME=/usr/local/pgsql
export PGDATA=/var/lib/pgsql/data
export PGLIB=$PGHOME/lib
export PATH=$PATH:$HOME/bin:$PGHOME/bin

export JSTESTDRIVER_HOME=~/bin
