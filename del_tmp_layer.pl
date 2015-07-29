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
###__________________________
kysy();
my @gROWname=@{info("matrix","$JOB/matrix","row")->{gROWname}};
foreach  (0..$#gROWname) {  delete_layer($gROWname[$_])  if   $gROWname[$_]=~m{\+}  };











