#!/bin/sh

# nc_tripsit_ban_pastes.sh
#  jane avriette, jane@cpan.org
#
# pull down all the ban_* factoids, check them for pastie/
# pastebin/whatever urls, then gank those files as raw/text
# for perusal

AGENT=""

curl "http://nourishedcloud.com:1337/quotes/"
