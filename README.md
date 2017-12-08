# configs

Personal configuration files for a variety of tools & platforms

## Installation

1. Run `./install_packages_apt` or `./install_packages_yum` (depending on your Linux distribution) as `sudo` or root user first. This will install most pertinent packages and software.
2. Then run `./install_user_packages` as a regular user account. This installs mainly Ruby packages via `gem` which is _usually_ best done as your intended user.
3. Finally run `./update_configs` as a regular user to install configuration files in necessary places.
