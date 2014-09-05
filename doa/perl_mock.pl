#!/usr/bin/perl

# a mockup for the node package

use warnings;
use strict;

my $cost = {
	metal => 0,
	wood  => 0,
	stone => 0,
	food  => 0,
};

my $avail = $cost;

$avail->{metal} = 718000;
$avail->{stone} = 103000;
$avail->{wood}  = 509000;

# bd  = 5:1 metal/wood
# gt  = 1:4 metal/wood
# ssd = 5:6 metal/wood

my %units = map { $_ => $cost } qw{ giant ssd bd };

$units{giant}->{divisor} = .25;
$units{bd}->{divisor} = 5;
$units{ssd}->{divisor} = .83;

foreach my $unitname (keys %units) {
	if ($avail->{wood} > $avail->{metal}) {
		print 


=cut

sandy says it is the lesser of:



=cut

sub gcd($$) {
  my ($u, $v) = @_;
  if ($v) {
    return gcd($v, $u % $v);
  } else {
    return abs($u);
  }
}
