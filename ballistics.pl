#!/usr/bin/perl

use warnings;
use strict;

# hurrdurr
use Math::Trig qw{ :pi };

my $cal = shift;
die "usage: $0 [caliber in mm]" unless $cal;

my $pi     = 4 * atan2 1, 1;

my $rimdia = 2   * $cal;                # outer dia
my $rimrad = $rimdia/2;                 # outer radius
my $ltos   = 5   * $cal;                # length to shoulder
my $bull   = 8   * $cal;                # bullet length
my $los    = 2   * $cal;                # length of shoulder
my $nel    = 1.2 * $cal;                # length of neck
my $casel  = $nel + $ltos + $los;       # length from rim to end of neck
my $seatl  = $nel / 2;                  # seating depth
my $oal    = ($bull + $casel) - $seatl; # overall length

# no proportions yet
my $blen   = 1500;            # length of barel
my $bwall  = $cal;            # width of barrel wall
my $bod    = $bwall*2 + $cal; # outside diameter
my $btwist = 115;             # mm each twist occupies
my $gcnt   = 6;               # number of grooves

printf '%25s %2.2f mm %s', 'caliber', $cal, $/;
printf '%25s %2.2f mm %s', 'overall length', $oal, $/;
printf '%25s %2.2f mm %s', 'rim diameter', $rimdia, $/;
#printf '%25s %2.2f mm %s', 'pre-neck cartridge volume', $volt, $/;
printf '%25s %2.2f mm %s', 'length to shoulder', $ltos, $/;
printf '%25s %2.2f mm %s', 'length of shoulder', $los, $/;
printf '%25s %2.2f mm %s', 'length of neck', $nel, $/;
printf '%25s %2.2f mm %s', 'overall case length', $casel, $/;
printf '%25s %2.2f mm %s', 'seating depth', $seatl, $/;

print $/;

printf '%25s %2.2f mm %s', 'barrel length', $blen, $/;
printf '%25s %2.2f mm %s', 'barrel wall thickness', $bwall, $/;
printf '%25s %2.2f mm %s', 'barrel outer diameter', $bod, $/;

print $/;
