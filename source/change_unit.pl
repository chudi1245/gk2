#!/usr/bin/perl
use strict;
use Genesis;
use C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
kysy();
$f->COM ('get_units');
if (  $f->{COMANS} eq 'mm') {
	unit_set('inch');
}else{
	unit_set('mm');
}

=head










