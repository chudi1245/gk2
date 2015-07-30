#!/usr/bin/perl
use strict;
use Genesis;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###________________________
kysy();
unit_set('inch');
$f->COM ('zoom_home');
$f->COM ('close_form',job=>$JOB,form=>'eng');
clear('box');
$f->COM ('sel_resize',size=>2,corner_ctl=>'no');
clear();
affected_layer('yes','all','box');
affected_layer('no','single','box');
$f->COM ('sel_ref_feat',
    layers       =>'box',
	use          =>'filter',
	mode         =>'cover',
	pads_as      =>'shape',
	f_types      =>'line\;pad\;surface\;arc\;text',
	polarity     =>'positive\;negative',
	include_syms =>'',
	exclude_syms =>'');



























