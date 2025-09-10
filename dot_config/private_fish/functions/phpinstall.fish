function phpinstall --description 'Install a specific PHP version and common extensions'
    # 1st arg = version (e.g. 82  83 …)
    set -l ver $argv[1]
    if test -z "$ver"
        echo "Usage: phpinstall <version>"
        echo "Example: phpinstall 83"
        return 1
    end

    # build package list exactly like your history
    set -l base php$ver php$ver-cli
    set -l ext   php$ver-gd php$ver-mbstring php$ver-pgsql php$ver-redis \
                 php$ver-curl php$ver-zip php$ver-dom php$ver-xml \
                 php$ver-intl php$ver-openssl php$ver-sodium

    echo "Installing PHP $ver + extensions…"
    yay -S --needed $base $ext

    # optional: symlink /usr/bin/php if the user wants
    echo "Done. Run 'sudo ln -sfn /usr/bin/php$ver /usr/bin/php' if you want it as default."
end
