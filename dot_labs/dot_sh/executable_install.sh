set -e

echo "Start configuring bash file..."
if [ -z $IS_CONFIGURED ]; then
        if [ -d ~/.oh-my-zsh ] && [ -e ~/.zshrc ]; then
                echo "Appending config to file ~/.zshrc ..."
                echo ". ~/.bash/.main.sh" >> ~/.zshrc
                source ~/.zshrc
        else
                echo "Appending config to file ~/.bashrc ..."
                echo ". ~/.bash/.main.sh" >> ~/.bashrc
                source ~/.bashrc
        fi
fi


echo "IS_CONFIGURED is set to be " $IS_CONFIGURED
