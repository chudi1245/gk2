#!/usr/bin/perl  
####
use strict;
use Tk;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###_______________________
kysy();

$f->COM ('close_form',job=>$JOB,form=>'eng');
my $test_pcb=exists_entity('step',"$JOB/pcb");

if ($test_pcb eq 'yes') {
	p__('Warning!!! The step -pcb  will be overwritten,Continue ?');
	copy_step();
}else{
	copy_step();
}

###_________________________________________







