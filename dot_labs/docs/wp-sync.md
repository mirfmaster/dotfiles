# Personal Wallpaper Sync

## Overview

Syncs personal wallpapers from `~/Pictures/Wallpapers/Personal/` to your Omarchy theme's backgrounds folder using symlinks.

## Usage

```bash
# Add new wallpapers to your Personal folder
cp /path/to/wallpaper.jpg ~/Pictures/Wallpapers/Personal/

# Sync to theme
wp-sync
```

## Features

- **One-way sync**: Personal → Theme backgrounds
- **Symlinks**: No file duplication, automatic updates
- **Smart sync**: Only updates when needed
- **Cleanup**: Removes broken symlinks automatically
- **Format support**: jpg, jpeg, png, webp, gif

## How it works

1. Place wallpapers in `~/Pictures/Wallpapers/Personal/`
2. Run `wp-sync` to create/update symlinks in theme backgrounds
3. Original theme backgrounds are preserved
4. Symlinks are removed if source files are deleted

## Directory Structure

```
~/Pictures/Wallpapers/
├── Personal/              # Your personal wallpapers
│   └── Mori Jin.jpg      # ← Add wallpapers here
└── (other wallpapers)     # Not synced

~/.config/omarchy/current/theme/backgrounds/
├── black.jpg              # Original theme background
└── Mori Jin.jpg -> ../..   # Symlink to Personal folder
```

## Commands

- `wp-sync` - Run wallpaper sync
- `omarchy-theme-bg-next` - Cycle through wallpapers (built-in)

## Script Location

`~/.labs/scripts/wp-sync.sh`

## Examples

```bash
# Add a new wallpaper
mv ~/Downloads/cool-wallpaper.jpg ~/Pictures/Wallpapers/Personal/

# Sync it
wp-sync

# Cycle to next wallpaper
omarchy-theme-bg-next

# Remove a wallpaper (run sync to clean up)
rm ~/Pictures/Wallpapers/Personal/cool-wallpaper.jpg
wp-sync
```
