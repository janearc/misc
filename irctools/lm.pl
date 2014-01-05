#!/usr/bin/perl

=cut

    So I once had this relationship with an ISTJ. It was, well, to quote his 
    mother, like pulling teeth. I literally had to run through my irc logs to
    see that I *wasn't* going insane. Yeah, we *were* talking less. So that
    when I finally went to tell him this, and he inevitably would say, "gosh,
    Jane, I have no idea what you're talking about!", I could actually
    *point* to the metrics, in handy chart, showing that he *was* talking to
    me less.

    Note: This worked with my irssi(1) logs. It may not work with yours, and
    it's not real smart. Also, this is not an especially great indicator of
    whether someone is an asshole, or even really talking to you. But it's a
    reasonable diagnostic to *check*.

    jane avriette, jane@cpan.org

=cut

use warnings;
use strict;
use Date::Calc qw{ Day_of_Year Decode_Date_US };
use File::Slurp qw{ read_file };

# if (($year,$month,$day) = Decode_Date_US($string[,$lang])
# $doy = Day_of_Year($year,$month,$day);

=cut

--- Log opened Mon Aug 05 23:32:20 2013
23:32 -!- Irssi: Starting query in tripsit with reality
23:32 <reality> it worked
23:33 <dramallama> yes
23:33 <dramallama> it seems to have
23:33 <reality> that said iirc snoonet have an expired ssl cert
23:33 <reality> :p
23:33 <reality> but it still helps
23:34 <dramallama> heh
23:34 <dramallama> well at this point it's silly to add more protection

=cut

my $doy;
my %days;

my %mlookup = qw{
	Jan 1 Feb 2 Mar 3 Apr 4 May 5
	Jun 6 Jul 7 Aug 8 Sep 9 Oct 10
	Nov 11 Dec 12
};

my %dlookup = qw{
	Sun 7 Mon 1 Tue 2 Wed 3
	Thu 4 Fri 5 Sat 6 
};

for my $logfile (@ARGV) {
	my @loglines = read_file( $logfile );
	warn "reading logfile $logfile\n";
	LINE: foreach my $line (@loglines) {
		next LINE if $line =~ /Irssi: Start/;
		my ($date) = $line =~ /--- Log opened (.*)$/;
		if ($date) {
			$date =~ s/ \d\d:\d\d:\d\d//;
			# Wed Sep 11 2013
			my ($dow, $m, $dom, $y) = split ' ', $date;
			$doy = Day_of_Year( $y, $mlookup{ $m }, $dom );
			next LINE;
		}
		next LINE unless $doy;
		$days{ $doy }++;
	}
}

foreach my $key (sort { $a <=> $b } keys %days) {
	print "$key,".$days{$key}."\n";
}

# jane@cpan.org // vim:tw=80:ts=2:noet
