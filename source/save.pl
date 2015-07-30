#!/usr/bin/perl  
use strict;
use Genesis;
use C;
kysy();
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
$f->COM ('save_job',job=>$JOB);
$f->COM ('close_form',job=>$JOB,form=>'eng');
clear();













