#!/usr/bin/perl
use 5.10.0;
use strict;
use Genesis;
use FBI;

our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

p__("run ok");


