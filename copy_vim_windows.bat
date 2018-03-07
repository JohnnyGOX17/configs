:: Updates/syncs (g)Vim config files from repo and local dirs
:: currently for 32-bit build of Vim (if 64, replace dest dir)

xcopy configs\_gvimrc "C:\Program Files (x86)\Vim\_gvimrc" /D /H /R /Y /K
xcopy configs\_vimrc "C:\Program Files (x86)\Vim\_vimrc" /D /H /R /Y /K
xcopy "C:\Program Files (x86)\Vim\_gvimrc" configs\_gvimrc /D /H /R /Y /K
xcopy "C:\Program Files (x86)\Vim\_vimrc" configs\_vimrc /D /H /R /Y /K