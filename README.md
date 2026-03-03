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
cd ~/.vim-config && git pull

# Update plugins
vim +PluginUpdate +qall
```

### Automatic Updates on Login

Add to your `~/.bashrc` or `~/.zshrc` to automatically update your configuration when you log in:

```bash
# Auto-update vim config on login (runs in background)
(cd ~/.vim-config && git pull --quiet) &
```

## Troubleshooting

**Plugins not working?**
```bash
rm -rf ~/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
```

**Colours look wrong?** Add to `~/.vimrc.local`:
```vim
set t_Co=256
```

## Dependencies

**Required:** Vim 7.4+, Git

**Optional:** 
- The Silver Searcher: `brew install the_silver_searcher` (macOS) or `apt-get install silversearcher-ag` (Ubuntu)
- ctags: `brew install ctags` (macOS) or `apt-get install exuberant-ctags` (Ubuntu)
