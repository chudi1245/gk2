#!/usr/bin/perl
use strict;
use Tk;
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
my $ref=info('layer',"$JOB/$STEP/drl",);
my @gTOOLnum=@{$ref->{gTOOLnum}};
my @gTOOLtype=@{$ref->{gTOOLtype}};
my @gTOOLdrill_size=@{$ref->{gTOOLdrill_size}};

$f->VOF;
clear('hm');
$f->COM ('sel_delete');
$f->VON;

$f->COM ('filter_reset',filter_name=>'popup');
clear('drl');
foreach  (0..$#gTOOLnum) {
	if ($gTOOLdrill_size[$_] < 23.7  ) {
		$f->COM ('filter_set',filter_name=>'popup',update_popup=>'no',dcode=>$gTOOLnum[$_]);
		$f->COM ('filter_area_strt');
	    $f->COM ('filter_area_end',
			layer=>'',
			filter_name=>'popup',
			operation=>'select',
			area_type=>'none',
			inside_area=>'no',
			intersect_area=>'no',
			lines_only=>'no',
			ovals_only=>'no',
			min_len=>0,
			max_len=>0,
			min_angle=>0,
			max_angle=>0);
	}
}
if ( get_select_count() ){
  sel_copy_other('hm');
  clear('hm');
  $f->COM ('sel_ref_feat',
	  layers=>'gts\;gbs',
	  use=>'filter',
	  mode=>'touch',
	  pads_as=>'shape',
	  f_types=>'line\;pad\;surface\;arc\;text',
      polarity=>'positive',
	  include_syms=>'',
	  exclude_syms=>'');
  if ( get_select_count() ){ $f->COM ('sel_delete'); };
}








=h
COM sel_ref_feat,layers=gts\;gbs,use=filter,mode=touch,pads_as=shape,f_types=line\;pad\;surface\;arc\;text,polarity=positive\;negative,include_syms=,exclude_syms=

COM filter_set,filter_name=popup,update_popup=no,dcode=2
COM filter_area_strt
COM filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0


    $f->VOF;
    delete_layer('tmp');
    $f->VON;

	clear('tmp');
