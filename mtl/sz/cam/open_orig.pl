#!/usr/bin/perl
use strict;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###______________________
kysy();
$f->COM ('close_form',job=>$JOB,form=>'eng');
my $test_orig=exists_entity('step',"$JOB/orig");
if ($test_orig eq 'yes') {
    $f->COM ('open_entity',job=>$JOB,type=>'step',name=>'orig',iconic=>'no');
    $f->AUX ('set_group',group=>$f->{COMANS});
	unit_set('inch');
}else{
	exit;
}


=head###___________________




=head
#!/bin/csh
########
COM close_form,job=$JOB,form=qae
########
COM open_entity,job=$job,type=step,name=orig,iconic=no
AUX set_group,group=1
COM units,type=inch