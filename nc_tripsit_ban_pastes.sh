#!/bin/sh

# nc_tripsit_ban_pastes.sh
#  jane avriette, jane@cpan.org
#  http://goo.gl/UMPoHO
#
# pull down all the ban_* factoids, check them for pastie/
# pastebin/whatever urls, then gank those files as raw/text
# for perusal

AGENT="$0:[$$] banpasteaggregator - http://goo.gl/UMPoHO"

curl -s -A "${AGENT}" --compressed -L --no-keepalive \
	--referer "http://nourishedcloud.com:1337/quoteremovals" \
	--retry 6 --retry-delay 8 -S \
	--url "http://nourishedcloud.com:1337/quotes/" | \
		perl -ne 'print $1.qq/\n/ while m{(ban_[^/ ])[/ ]}' 
