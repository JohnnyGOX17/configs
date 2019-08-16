# configs

Helpful scripts & personal configuration files (dotfiles) for a variety of tools & platforms

## Installation

1. Run `./install_packages`.

## Other Script Descriptions

- `diff_configs` diff's the tracked dotfiles for easy view of changes
- `install_scripts` installs tracked scripts to executable directory in path
- `term_test` tries to print lines with different attributes to test the terminal's ability to display (e.g. italics, bold, etc.)
- `update_configs` updates local/remote changes to most-up-to-date

```
dev_utils/  
├── `generate-sitemap` for website projects, can generate a `sitemap.xml` file for SEO  
└── git/  
    ├── `git-acp` does git add -> commit -> push operations for simple changes in a branch  
    ├── `git-list-large` lists large files in a git repo  
    ├── `git-print-TODOs` parses design files for "TODO" comments and generates a Markdown file  
    ├── `git-rewrite-author` rewrites git repo history to replace a certain author with another  
    ├── `git-rm-dos-whitespace` removes all POSIX whitespace from design files in a repo  
    ├── `git-status-src-dirs` parses the git status information of all repos under ~/src  
    └── `git-update-src-dirs` updates all repos under ~/src and pulls down any missing remotes
```

```
sys_utils/  
├── `backup_data` backs up data from a common directory structure to a remote using rsync  
├── `scrot-screenshot` captures screenshot using scrot utility  
├── `sys-backup` specific rsync backup operation from Macbook to Linux server  
└── `tmux_mem_cpu` script to parse system statistics to be printed in tmux status line  
```

## Todo

- [ ] make a hidden file in user dir to compare git hash to know if anything needs to be updated from repo
- [ ] add tmux line to let know if git repos need updating and/or if updates need to be made due to this repo
