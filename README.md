# configs

Personal configuration files (dotfiles) for a variety of tools & platforms

## Installation

1. Run `./install_packages_apt` or `./install_packages_yum` (depending on your Linux distribution) as `sudo` or root user first. This will install most pertinent packages and software.
2. Then run `./install_user_packages` as a regular user account. This installs mainly Ruby packages via `gem` which is _usually_ best done as your intended user.
3. Finally run `./update_configs` as a regular user to install configuration files in necessary places.

## Script Descriptions

- `diff_configs` diff's the tracked dotfiles for easy view of changes
- `install_packages_apt` installs packages for Ubuntu systems
- `install_packages_yum` installs packages for CentOS systems
- `install_user_packages` installs non-admin level packages
- `update_configs` updates local/remote changes to most-up-to-date

## Misc. scripts and helper applications

# Todo

- [ ] Make a more robust scripting interface to update on each distro (note sometimes apt shows up on macos... so check for brew first) that can be rerun to pull in any updates
- [X] brew stuff shouldn't be run as root
- [ ] make a hidden file in user dir to compare git hash to know if anything needs to be updated from repo
- [ ] add tmux line to let know if git repos need updating and/or if updates need to be made due to this repo
