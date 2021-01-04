#!/bin/bash

#sh deploy.sh
PROJECT_DIR="$HOME/devicespecifications_parser"

PUBLIC_KEY="$HOME/.ssh/id_rsa.pub"

SERVER_PB_KEY="~/.ssh/authorized_keys"

SERVER_PB_KEY2=~/.ssh/authorized_keys

CONFIG_PATH=~/securconfig


if [ -f "$PUBLIC_KEY" ]; then
    echo "PUBLIC_KEY ALREADY ISSET"
else PROJECT_DIR
	mkdir ~/.ssh
	ssh-keygen -t rsa -q -N '' -f ~/.ssh/id_rsa
	scp $PUBLIC_KEY  gvozde0m_develop@gvozde0m.beget.tech:~/devicespecifications_parser
	
	ssh gvozde0m_develop@gvozde0m.beget.tech "[ -d ~/.ssh ] || (mkdir ~/.ssh; chmod 711 ~/.ssh)"
	ssh gvozde0m_develop@gvozde0m.beget.tech "cat ~/id_rsa.pub >> ~/.ssh/authorized_keys"
	ssh gvozde0m_develop@gvozde0m.beget.tech "chmod 600 ~/.ssh/authorized_keys"
	ssh gvozde0m_develop@gvozde0m.beget.tech "rm ~/id_rsa.pub"

fi

	scp gvozde0m_develop@gvozde0m.beget.tech:$SERVER_PB_KEY $SERVER_PB_KEY2

    if cmp -s $PUBLIC_KEY $SERVER_PB_KEY2 ; then
		
		echo "SERVER_PB_KEY == LOCAL_PB_KEY"

    	if [ -d $PROJECT_DIR ]; then
		sudo rm -R $PROJECT_DIR
		fi

		cd $HOME

		git clone --branch=dev git@bitbucket.org:litesoftteam/devicespecifications_parser.git
        
        git clone git@bitbucket.org:redmal/securconfig.git

			cp $CONFIG_PATH/db_params.php $PROJECT_DIR/app/core/config/
			
			sudo rm -R $CONFIG_PATH
		#fi
        echo "END COPY db_params"

		rsync -av -e ssh --exclude '.gitignore' --exclude '.git' --exclude 'composer.lock' $PROJECT_DIR gvozde0m_develop@gvozde0m.beget.tech:~
        #[ ! -d ~/androidinfo/vendor/doctrine ] && 
		ssh gvozde0m_develop@gvozde0m.beget.tech "cd ~/devicespecifications_parser && composer-php7.3 update"
        echo "END COMPOSER UPDATE"

		ssh gvozde0m_develop@gvozde0m.beget.tech "cd ~/devicespecifications_parser && /usr/local/bin/php7.3 vendor/bin/doctrine orm:schema-tool:update --force"

		sudo rm -R $PROJECT_DIR
	else
		echo "SERVER_PB_KEY != LOCAL_PB_KEY"
    fi

    sudo rm $SERVER_PB_KEY2

echo "Конец"