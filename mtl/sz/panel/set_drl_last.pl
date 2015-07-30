#! /usr/bin/perl

use strict;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};



$f->COM ('cur_atr_set',attribute=>'.drill_first_last',option=>'last');

$f->COM ('cur_atr_reset');

