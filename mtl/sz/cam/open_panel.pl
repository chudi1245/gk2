#!/usr/bin/perl
use strict;
use Genesis;
use lib "D:/xxx/camp/lib";
usec C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###______________________
kysy();
$f->COM ('close_form',job=>$JOB,form=>'eng');
my $test_panel=exists_entity('step',"$JOB/pnl");
if ($test_panel eq 'yes') {
    $f->COM ('open_entity',job=>$JOB,type=>'step',name=>'pnl',iconic=>'no');
    $f->AUX ('set_group',group=>$f->{COMANS});
	unit_set('inch');
}else{
	exit;
}


