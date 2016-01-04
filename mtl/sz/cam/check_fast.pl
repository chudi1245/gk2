#!/usr/bin/perl
use strict;
use Tk;
use Genesis;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
use FBI;
my $check_name='mtl_qae';
####________________

kysy();

unit_set('inch');
my $run_step=read_form($JOB,'E21'); 
if (! $run_step) {
	p__("this must run in a step, exit");
	exit;
}
my $exists_checklist=exists_entity('check',"$JOB/$run_step/$check_name");
if ($exists_checklist eq 'no') {
	$f->COM ('chklist_from_lib',chklist=>$check_name);
}
$f->COM ('chklist_open',chklist=>$check_name);
$f->COM ('chklist_show',chklist=>$check_name);
$f->COM ('chklist_cupd',
          chklist =>$check_name,
		  nact    =>1,
		  params  =>'((pp_drill_layer=.type=drill & context=board)(pp_rout_distance=401)(pp_tests=Hole Size\;Hole Separation\;Missing Holes\;Extra Holes\;Power/Ground Shorts\;NPTH to Rout)(pp_extra_hole_type=Pth)(pp_use_compensated_rout=Skeleton))',
		  mode    =>'regular');
$f->COM ('chklist_cupd',
          chklist =>$check_name,
		  nact    =>2,
		  params  =>'((pp_layer=.type=signal | mixed & context=board & pol=positive & side=outer | inner)(pp_spacing=4.5)(pp_r2c=18)(pp_d2c=10)(pp_sliver=3)(pp_min_pad_overlap=5)(pp_tests=Spacing\;Drill\;Rout\;Size\;Sliver\;Stubs\;Center\;SMD\;Bottleneck\;Pad Connection Check)(pp_selected=All)(pp_check_missing_pads_for_drills=Yes)(pp_use_compensated_rout=No)(pp_sm_spacing=No))',
		  mode    =>'regular');
$f->COM ('chklist_cupd',
          chklist =>$check_name,
		  nact    =>3,
		  params  =>'((pp_layers=.type=power_ground|mixed&context=board)(pp_d2c=10)(pp_sliver=8)(pp_r2c=20)(pp_nfp_spacing=10)(pp_pln_spacing=10)(pp_tests=Drill\;Sliver\;Rout\;Thermal\;NFP spacing\;Plane spacing)(pp_selected=All)(pp_use_compensated_rout=Yes))',
		  mode    =>'regular');
$f->COM ('chklist_cupd',
          chklist =>$check_name,
		  nact    =>4,
		  params  =>'((pp_layers=.type=solder_mask  & context=board)(pp_ar=3)(pp_coverage=3)(pp_sm2r=3)(pp_sliver=3)(pp_spacing=3)(pp_bridge=3)(pp_min_clear_overlap=5)(pp_tests=Drill\;Pads\;Coverage\;Rout\;Bridge\;Sliver\;Missing\;Spacing\;Clearance Connection)(pp_selected=All)(pp_use_compensated_rout=No))',
		  mode    =>'regular');
$f->COM ('chklist_cupd',
          chklist =>$check_name,
		  nact    =>5,
		  params  =>'((pp_layers=.type=silk_screen & context=board)(pp_spacing=10)(pp_tests=SM clearance\;SMD clearance\;Pad clearance\;Hole clearance\;Line width)(pp_selected=All)(pp_use_compensated_rout=No))',
		  mode    =>'regular');
$f->COM ('chklist_run',
          chklist =>'mtl_qae',
		  nact    =>'a',
		  area    =>'profile');
###_________________________________________
