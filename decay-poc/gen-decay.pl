#!/usr/local/bin/perl

use WWW::Wikipedia;

use v5.14.0;

$SIG{INT} = sub { say "dope, we out"; exit 0 };

use constant SECONDS  => 86400;
use constant MINUTES  => SECONDS / 60;
use constant HOURS    => MINUTES / 60;
use constant CHANCE   => .1; # sup rtm
use constant INTERVAL => 30;

my $word_count = 0;

my $W = WWW::Wikipedia->new( );

# yeah, that's just, like, your *opinion*, man.
my @escalations = qw{
	long short brief difficult large heavy
};

# analogous to "weasel words" like "allegedly"
# avoid placement alongside "more"
my @deescalations = qw{
	somewhat moderately relatively fairly
};

# check for word tense, presence of "of"
my @failures = qw{ success failure };
my @modifiers = qw{ apparent relative };

#while (my $page = $W->random()) {
while (my $page = $W->search('Golf')) {
	if (finder($page)) {
		# do something here
		say "Found something in page.";
		say "--------------------------------- Found something. Sleeping.";
		say $page->title();
		say $page->fulltext();
		sleep INTERVAL;
	}
	else {
		say "Didn't find anything in page";
		say "Printing and sleeping ---------------------------------";
		say $page->title();
		say $page->fulltext();
		sleep INTERVAL;
	}
}

sub finder {
	# words to find
	my @wtf = (@failures, @escalations);
	my @words = map { grep m/$_/i, @wtf } split /\s+/, $_[0]->fulltext;
	scalar @words;
}

=cut
sub degrader {

}
=cut
