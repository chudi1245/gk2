#!/usr/bin/perl

use strict;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
kysy();
$f->COM ('close_form',job=>$JOB,form=>'eng');
$f->COM ('matrix_auto_rows',job=>$JOB,matrix=>'matrix');


