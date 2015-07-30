#!/usr/bin/perl  
####
use strict;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###_______________________
kysy();

my $test_pcb=exists_entity('step',"$JOB/pcb");
my $test_pcb_net=exists_entity('step',"$JOB/pcb_net");

if ($test_pcb eq 'no') {
	p__('pcb step not eixsts');
	exit;
}else{
    if ($test_pcb_net eq 'yes') {
    	p__('Warning!!! The step pcb_net  will be overwritten,Continue ?');
    }
	copy_step('pcb','pcb_net',);
}
###_________________________________________
