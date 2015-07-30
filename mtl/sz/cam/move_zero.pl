#!/usr/bin/perl
use strict;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###______________________
kysy();
unit_set('inch');
unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 $f->COM ('close_form',job=>$JOB,form=>'eng');
	 open_step($STEP);
	 unless ($STEP) {
		 p__('no step');
		 exit;
	 }
}

if ( info('step',"$JOB/$STEP",'PROF_LENGTH')->{gPROF_LENGTH}  ) {
	my $limit_x=info('step',"$JOB/$STEP",'PROF_LIMITS')->{gPROF_LIMITSxmin};
	my $limit_y=info('step',"$JOB/$STEP",'PROF_LIMITS')->{gPROF_LIMITSymin};
	$f->VOF;
    delete_layer('tmp');
	$f->VON;
	$f->COM ('profile_to_rout',layer=>'tmp',width=>1);
	clear();
    $f->COM ('affected_layer',mode=>'all',affected=>'yes');
    $f->COM ('sel_move',dx=>-$limit_x,dy=>-$limit_y);
	clear('tmp');
	$f->COM ('sel_reverse');
    $f->COM ('sel_create_profile');
    delete_layer('tmp');
}else{
    my $limit_x=info('layer',"$JOB/$STEP/box",'limits')->{gLIMITSxmin};
    my $limit_y=info('layer',"$JOB/$STEP/box",'limits')->{gLIMITSymin};
    clear();
    $f->COM ('affected_layer',mode=>'all',affected=>'yes');
    $f->COM ('sel_move',dx=>-$limit_x,dy=>-$limit_y);
    clear('box');
}








