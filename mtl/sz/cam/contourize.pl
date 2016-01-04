#! /usr/bin/perl
##   zq
##   2010.12.30
use strict;
use Tk;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

##__________
kysy();

if ( get_select_count() ) {
	$f->COM ('sel_contourize',
		accuracy            =>0.25,
		break_to_islands    =>'yes',
		clean_hole_size     =>3,
		clean_hole_mode     =>'x_and_y');
}






