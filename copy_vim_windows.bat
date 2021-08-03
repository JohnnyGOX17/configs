:: Updates/syncs (g)Vim config files from repo and local dirs
:: currently for 32-bit build of Vim (if 64, replace dest dir)
::
:: Also install monokai colorscheme to vimfiles dir
:: Install vim plug for windows https://github.com/junegunn/vim-plug
:: Install python for YouCompleteMe support https://www.python.org/downloads/windows/
:: After install, re-run install.py
:: Install PowerLine fonts https://medium.com/@slmeng/how-to-install-powerline-fonts-in-windows-b2eedecace58
:: Make sure swap directories (i.e. C:\temp\vim) exist
::

xcopy configs\_gvimrc "C:\Program Files (x86)\Vim\_gvimrc" /D /H /R /Y /K
xcopy configs\_vimrc "C:\Program Files (x86)\Vim\_vimrc" /D /H /R /Y /K
xcopy "C:\Program Files (x86)\Vim\_gvimrc" configs\_gvimrc /D /H /R /Y /K
xcopy "C:\Program Files (x86)\Vim\_vimrc" configs\_vimrc /D /H /R /Y /K
