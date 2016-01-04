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

my $test_orig=exists_entity('step',"$JOB/orig");
my $test_orig_net=exists_entity('step',"$JOB/orig_net");

if ($test_orig eq 'no') {
	p__('orig step not eixsts');
	exit;
}else{
    if ($test_orig_net eq 'yes') {
    	p__('Warning!!! The step orig_net  will be overwritten,Continue ?');
    }
	copy_step('orig','orig_net',);
}
###_________________________________________




