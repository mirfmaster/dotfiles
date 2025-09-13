function phpinstall --description 'Install a specific PHP version, common extensions, and Composer'
    # 1st arg = version (e.g. 82  83 …)
    set -l ver $argv[1]
    if test -z "$ver"
        echo "Usage: phpinstall <version>"
        echo "Example: phpinstall 83"
        return 1
    end

    set -l base php$ver php$ver-cli
    set -l ext \
        php$ver-gd php$ver-mbstring php$ver-pgsql php$ver-redis \
        php$ver-curl php$ver-zip php$ver-dom php$ver-xml php$ver-exif php$ver-sqlite \
        php$ver-intl php$ver-openssl php$ver-sodium php$ver-bcmath php$ver-phar \
        php$ver-tokenizer php$ver-fileinfo php$ver-simplexml php$ver-xmlwriter

    echo "Installing PHP $ver + extensions…"
    yay -S --needed --noconfirm $base $ext

    echo "Linking /usr/bin/php → php$ver"
    sudo ln -sfn /usr/bin/php$ver /usr/bin/php

    echo "Installing Composer for php$ver"
    curl -sS https://getcomposer.org/installer | php$ver \
        && sudo mv composer.phar /usr/local/bin/composer \
        && sudo chmod 755 /usr/local/bin/composer

    echo "Done. Check with: php --version  &&  composer --version"
end
