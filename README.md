# mirfmaster's Dotfiles

This repository is my method for synchronizing my environment across multiple machines. It is managed using [chezmoi](https://www.chezmoi.io/).

## Check-In-Dance

To get started with these dotfiles, run the following command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mirfmaster
```

### Retrieving Encrypted Files

Currently, there are no significant vulnerabilities associated with GPG as per the latest CVE records ([references](https://www.cvedetails.com/vulnerability-list/vendor_id-4711/Gnupg.html)).

This assures the security of the encryption method used for the files in this repository.
The encrypted files primarily contain private configurations rather than highly sensitive information.
Therefore, it is safe to provide instructions for decrypting them here.

[References](https://www.chezmoi.io/user-guide/encryption/gpg/)

1. Import the private GPG key

   `gpg --import private.key`

2. Obtain the public GPG key ID

   Retrieve the ID of your public key generated during the import process:
   `gpg --list-keys`

3. Insert the ID to be GPG Identifier

make a folder in `~/.config/chezmoi/chezmoi.toml`

```
encryption = "gpg"
[gpg]
    recipient = "ID_FROM_GPG_PUBLIC_KEY"
```

## Application list

### Main

| Type                | Name          | Custom Configuration |
| ------------------- | ------------- | -------------------- |
| System Operation    | Pop_OS!       | ✅                   |
| Terminal            | Kitty         | ✅                   |
| Public DNS resolver | Warp-Cli      | ❌                   |
| Text Editor         | neovim        | ❌                   |
|                     | AstroNVIM     | ✅                   |
|                     | LunarVIM      | ✅                   |
| Second Brain        | Obsidian      | ✅                   |
|                     | Obsidian-nvim | ✅                   |
| Browser             | Chrome        | ✅                   |
|                     | Firefox       | ❌                   |
| Auth manager        | Bitwarden     | ✅                   |
|                     | Authy         | ❌                   |

### Supports

- [AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher)

## Custom keybindings

- [Pop_OS! Keybindings](./dot_labs/docs/keybinding_popos.md)


# AWESOME WM MODE
```bash
sudo apt install scrot awesome-extra unclutter brightnessctl i3lock-fancy rofi bluez bluez-tools blueman
```

Touchpad enable tapping
https://www.reddit.com/r/awesomewm/comments/ik15im/comment/g3hjis1/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
