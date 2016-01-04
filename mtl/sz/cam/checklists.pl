#!/usr/bin/perl
use strict;
use Tk;
use Win32;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________________________
kysy();

$f->VOF;
$f->COM ('chklist_from_lib',chklist=>'fls_basic_analysis');
$f->VON;

$f->COM ('chklist_open',chklist=>'fls_basic_analysis');
$f->COM ('chklist_show',chklist=>'fls_basic_analysis');

$f->COM ('chklist_erf',chklist=>'fls_basic_analysis',nact=>2,erf=>'UNiC-outer-new');
$f->COM ('chklist_erf',chklist=>'fls_basic_analysis',nact=>3,erf=>'UNiC-STD');
$f->COM ('chklist_erf',chklist=>'fls_basic_analysis',nact=>4,erf=>'UNiC-STD');
$f->COM ('chklist_erf',chklist=>'fls_basic_analysis',nact=>5,erf=>'FastChk');
$f->COM ('chklist_select_act',chklist=>'fls_basic_analysis',nact=>6,select=>'no');
$f->COM ('chklist_select_act',chklist=>'fls_basic_analysis',nact=>7,select=>'no');


$f->COM ('chklist_cupd',chklist=>'fls_basic_analysis',nact=>1,
    params=>'((pp_drill_layer=.type=drill&context=board)(pp_rout_distance=200)(pp_tests=Hole Size\;Hole Separation\;Missing Holes\;Extra Holes\;Power/Ground Shorts\;NPTH to Rout)(pp_extra_hole_type=Pth\;Via)(pp_use_compensated_rout=Skeleton))',
	mode=>'regular');

####sig check
$f->COM ('chklist_cupd',chklist=>'fls_basic_analysis',nact=>2,
    params=>'((pp_layer=.type=signal|mixed&context=board&pol=positive)(pp_spacing=4.5)(pp_r2c=18)(pp_d2c=10)(pp_sliver=3)(pp_min_pad_overlap=5)(pp_tests=Spacing\;Drill\;Rout\;Size\;Sliver\;Stubs\;Center\;SMD\;Bottleneck\;Pad Connection Check)(pp_selected=All)(pp_check_missing_pads_for_drills=Yes)(pp_use_compensated_rout=No)(pp_sm_spacing=No))',
	mode=>'regular');
#####power check
$f->COM ('chklist_cupd',chklist=>'fls_basic_analysis',nact=>3,
    params=>'((pp_layers=.type=power_ground|mixed&context=board)(pp_d2c=10)(pp_sliver=10)(pp_r2c=15)(pp_nfp_spacing=10)(pp_pln_spacing=10)(pp_tests=Drill\;Sliver\;Rout\;Thermal\;NFP spacing\;Plane spacing)(pp_selected=All)(pp_use_compensated_rout=No))',
	mode=>'regular');
####solder mask
$f->COM ('chklist_cupd',chklist=>'fls_basic_analysis',nact=>4,
    params=>'((pp_layers=.type=solder_mask & context=board)(pp_ar=3)(pp_coverage=3)(pp_sm2r=10)(pp_sliver=3)(pp_spacing=3)(pp_bridge=2)(pp_min_clear_overlap=5)(pp_tests=Drill\;Pads\;Coverage\;Rout\;Bridge\;Sliver\;Missing\;Spacing\;Clearance Connection)(pp_selected=All)(pp_use_compensated_rout=No))',
	mode=>'regular');
####silk_screen
$f->COM ('chklist_cupd',chklist=>'fls_basic_analysis',nact=>5,
    params=>'((pp_layers=.type=silk_screen & context=board)(pp_spacing=10)(pp_tests=SM clearance\;SMD clearance\;Pad clearance\;Hole clearance\;Rout clearance\;Line width)(pp_selected=All)(pp_use_compensated_rout=No))',
	mode=>'regular');
$f->COM ('chklist_run',chklist=>'fls_basic_analysis',nact=>'s',area=>'profile');


=head


