#!/usr/bin/perl

use warnings;
use strict;

=cut 

 # Lensmaker's equation
 # 1/f = (n-1) [1/r1 - 1/r2 + ((n - 1)d)/n*r1*r2]

 f  = focal length
 n  = refractive index of the material
 r1 = radius of the near curvature (to light source)
 r2 = radius of the far curvature
 d  = thickness of the lens (the distance between top and bottom)

=cut

=cut

# If we ever wanted to build a laser rifle, we'd need these

# they're in yards as we are developing them from american rifle/handgun
# patternins. 
my @desired_focal_lengths = (
	7,			# close range pistol
	15,			# intermediate pistol
	25,			# intermediate pistol
	100,		# typical rifle point-blank range
	300,		# considered the beginning of "long-range" rifle shooting
	600,		# long-range rifle
	1000,		# long-range magnum rifle, .338 LM, .50 BMG
	2000,		# anti-materiel, .50 BMG
	2400,		# maximum effective range, .50 BMG
);

=cut


my %refractive_indices = (
	pyrex => 1.47,
	flint_glass => 1.52,
);


# In millimeters per rifle scope conventions
my @desired_lens_diameters = (
	56,			# Nightforce NXS, Mag-Lite
	80,			# ATN 12-36x80
	120,		# Spotter's scope
);

# In millimeters again, this time because nobody really has a standard for
# this. In truth, it's determined more by the diameter of the lens than the
# thickness.
my @desired_max_lensdepth = (
	50,			# depth of the Mag-Lite reflector
);

foreach my $material (keys %refractive_indices) {
	# $refractive_indices{$material} is "n"
	my $n = $refractive_indices{$material};
	# foreach my $possible_lens_depth (0.19) {
	foreach my $possible_lens_depth (sort (1/3, 3/5, 1/4, 7/8, 1/10, .15, .18, 1/25)) {
		# Our lens is symmetric and convex. this means that the fraction given is
		# the fraction of the total height (d) of the lens.
		my $r1 = $possible_lens_depth;
		my $r2 = $possible_lens_depth;
		foreach my $lens_height (@desired_lens_diameters) {
		#foreach my $lens_height (56) {
			# $lens_height is "d"
			my $d = $lens_height;
			my $brackets = ( (1/$r1 - 1/$r2) + (($n - 1) * $d) / ($n * $r1 * $r2) );

			# At this point 1/f = ($n - 1)*$brackets
			# sooo... (($n - 1) * $brackets) ** 2 = f

			my $f = (($n - 1 ) * $brackets) ** 2;

			printf 'Using %s with %d mm housing at frac %2.2f, focal point is %s',
				$material,
				$lens_height,
				$possible_lens_depth,
				$f > 1000 ? (sprintf "%2.2f yd", $f / 914) :
				(sprintf "%2d mm", $f);
			print $/;
		} # diameters
	} # lens depth (really width, but whatever)
} # materials


	
