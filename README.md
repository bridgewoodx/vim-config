# Vim Configuration Setup

Centralised Vim configuration synced across multiple servers. Use `.vimrc.local` for machine-specific settings.

## Quick Setup

### First Time Setup

```bash
# Clone repo
git clone https://github.com/bridgewoodx/vim-config.git ~/.vim-config
ln -s ~/.vim-config/.vimrc ~/.vimrc

# Install Vundle and plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Create local overrides (optional)
touch ~/.vimrc.local
```

### Setup on New Server

```bash
# Same steps as above
git clone https://github.com/bridgewoodx/vim-config.git ~/.vim-config
ln -s ~/.vim-config/.vimrc ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
```

## Key Features

**Leader key:** `,` (comma)

Press `<leader>` and wait to see all available commands (vim-which-key).

### Essential Commands

| Command | Action |
|---------|--------|
| `,d` | Toggle NERDTree |
| `,p` | Open CtrlP fuzzy finder |
| `,a` | Search with Ag |
| `,1-9` | Go to tab 1-9 |
| `,n` | Next tab |
| `,gd` | Git diff current file |
| `,ev` | Edit vimrc |
| `,sv` | Reload vimrc |
| `Ctrl-h/j/k/l` | Navigate windows |

## Machine-Specific Settings

Edit `~/.vimrc.local` for settings that differ between machines:

```vim
" Dark terminal
set background=dark
colorscheme desert

" Disable features on work servers
let g:gitgutter_enabled = 0
```

## Updates

### Manual Updates

```bash
# Update config
cd ~/vim-config && git pull

# Update plugins
vim +PluginUpdate +qall
```

### Automatic Updates on Login

Add to your `~/.bashrc` or `~/.zshrc` to automatically update your configuration when you log in:

```bash
# Auto-update vim config on login (runs in background)
(cd ~/vim-config && git pull --quiet) &
```

## Managing Plugins

### Adding Plugins

1. **Edit** `~/vim-config/.vimrc.bundles` for shared plugins:
   ```vim
   Plugin 'tpope/vim-fugitive'
   Plugin 'preservim/nerdtree'
   ```

2. **Or edit** `~/.vimrc.bundles.local` (in home directory) for personal plugins (optional)

3. **Install**:
   ```bash
   vim +PluginInstall +qall
   ```

4. **Commit and push** (for shared plugins):
   ```bash
   cd ~/vim-config
   git add .vimrc.bundles
   git commit -m "Add vim-fugitive plugin"
   git push
   ```

### Removing Plugins

1. Remove or comment out the plugin line in `.vimrc.bundles`
2. Run cleanup:
   ```bash
   vim +PluginClean +qall
   ```

## Troubleshooting

**Plugins not working?**
```bash
rm -rf ~/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
```

**Bundles file not found?**
```bash
# Make sure bundles file exists
touch ~/vim-config/.vimrc.bundles
# Or copy from your existing setup
cp ~/.vimrc.bundles ~/vim-config/.vimrc.bundles
```

**Colours look wrong?** Add to `~/.vimrc.local`:
```vim
set t_Co=256
```

**Required:** Vim 7.4+, Git

**Optional:** 
- The Silver Searcher: `brew install the_silver_searcher` (macOS) or `apt-get install silversearcher-ag` (Ubuntu)
- ctags: `brew install ctags` (macOS) or `apt-get install exuberant-ctags` (Ubuntu)
