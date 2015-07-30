#!/usr/bin/perl 
use Genesis;
$f = new Genesis;
$JOB  = $ENV{JOB};
$STEP = $ENV{STEP};
#################################
$f->COM(units, type =>"inch");

$f->COM("sel_drawn,type=mixed,therm_analyze=no");

$f->COM(get_select_count);

$select_count=$f->{COMANS};

if ( $select_count ){
$f->COM("sel_contourize,accuracy=0.25,break_to_islands=yes,clean_hole_size=3,clean_hole_mode=x_and_y");
	}






















