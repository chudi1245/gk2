#!/usr/bin/perl
##  zq 2010.06.21

use strict;
use Genesis;
use C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($count,@layer_outer);
###_____________________
kysy();

if ($STEP ne "pcb") {p__("This script only run on the pcb step");exit}
my @gROWrow       =@{info("matrix","$JOB/matrix","row")->{gROWrow}};
my @gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
my @gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};
my @gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
my @gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
my @gROWtype      =@{info("matrix","$JOB/matrix","row")->{gROWtype}};
###_________________________
foreach  (0..$#gROWrow){
	if ($gROWcontext[$_] eq 'board' and $gROWside[$_] ne 'inner'
	    and $gROWlayer_type[$_] eq 'signal' || $gROWlayer_type[$_] eq 'power_ground' || $gROWlayer_type[$_] eq 'mixed'
		) {
			push @layer_outer,$gROWname[$_];
	}
}
clear('drl');
$f->COM ('sel_ref_feat',
         layers                  =>"$layer_outer[0]\;$layer_outer[1]",
		 use                     =>'filter',
		 mode                    =>'disjoint',
		 f_types                 =>'line\;pad\;surface\;arc\;text',
		 polarity                =>'positive\;negative',
		 include_syms            =>'',
		 exclude_syms            =>'');
$count = get_select_count();
if ($count) {
        sel_options("clear_none");
        $f->COM ('cur_atr_reset');
        $f->COM ('cur_atr_set',attribute=>'.drill',option=>'non_plated');
        $f->COM ('sel_change_atr',mode=>'add');
        sel_options("clear_after");
}else{
	    p__("not find the hole disjoint the top and botton");
}









