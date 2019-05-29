#!/bin/sh

insLoc=/usr/local/bin/

cp ./dev_utils/generate-sitemap          $insLoc
cp ./dev_utils/git/git-print-TODOs       $insLoc
cp ./dev_utils/git/git-rewrite-author    $insLoc
cp ./dev_utils/git/git-status-src-dirs   $insLoc
cp ./dev_utils/git/git-update-src-dirs   $insLoc
cp ./dev_utils/git/git-rm-dos-whitespace $insLoc

cp ./sys_utils/scrot-screenshot          $insLoc
cp ./sys_utils/tmux_mem_cpu              $insLoc

echo "Scripts installed to $insLoc"
