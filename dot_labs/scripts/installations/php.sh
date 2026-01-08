sudo add-apt-repository ppa:ondrej/php -y && sudo apt update &&
  sudo apt-get install php8.5 php8.5-bcmath php8.5-mbstring php8.5-xml php8.5-curl php8.5-zip -y

# INSTALL COMPOSER
sudo apt-get update &&
  sudo apt-get install -y curl php-cli php-mbstring unzip &&
  curl -sS https://getcomposer.org/installer -o composer-setup.php &&
  HASH=$(curl -sS https://composer.github.io/installer.sig) &&
  php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&
  sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer &&
  rm composer-setup.php &&
  composer --version
