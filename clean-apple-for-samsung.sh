#!/bin/bash
# stupid apple crap
rm -rf .Spotlight-V100 .Trashes .fseventsd .cm0012 .cmdb
# more stupid apple crap
find . -type f -name '._*' -exec rm {} -rf \;
# bittorrent crap
find . -type f -name '*.part' -exec rm -rf {} \;
# tracked by demonoid.com and so on
find . -type f -name '*.txt' -exec rm -f {} \;
