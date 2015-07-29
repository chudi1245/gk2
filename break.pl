#! /usr/bin/perl
##   zq
##   2010.12.30
use strict;
use Genesis;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

##__________
kysy();
if ( get_select_count() ) {
	$f->COM ('sel_break');
}












