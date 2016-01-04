#!/usr/bin/perl

## how to sure the lear drill size?
use strict;
use Tk;
use Win32;
use Genesis;
use  C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my (@text);
###____
kysy();
$f->COM ('close_form',job=>$JOB,form=>'eng');
unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 open_step($STEP);
	 unless ($STEP) {p__('no step');  exit; }
}
unit_set('inch');
clear('drl');
selcet_line();
if ( get_select_count() ) {
    $f->INFO(entity_type => 'layer',
		entity_path => "$JOB/$STEP/drl",
		data_type => 'FEATURES',
		options => "select");
	@text=@{$f->{doinfo}->{'text'}};

}else{
	p__('not find slot');
	exit;
}
###how to 



###
creat_clear_layer('tmp');
foreach  (@text) {
	my ($symbol_size,@word,$xs,$ys,$xe,$ye,$size,$length,$midx,$midy)=();
	next unless m{^\#L};
	@word=split ' ',$_;
	($xs,$ys,$xe,$ye,$size)=(@word[1..5] );
	$size =~ s/[Rr]//;
	$symbol_size=round(  ($size/2)/1000*25.397, 2 );
    $symbol_size= ($symbol_size*100-$symbol_size*100%5)/2.5397 ; ##adjust the tool to 0.05mm
	$length = sqrt( ($xe-$xs)**2 + ($ye-$ys)**2  ) + $size/1000;
	next unless ( $length < $size/1000*2 );
	($midx,$midy)=( $xs/2+$xe/2, $ys/2+$ye/2 );
	if ( $xe != $xs ) {
		my $sin=($ye-$ys)/($length-$size/1000);
		my $cos=($xe-$xs)/($length-$size/1000);
		my ($ad_x1,$ad_y1,)=(  ($length/2-$symbol_size/2000)*$cos+$midx,  ($length/2-$symbol_size/2000)*$sin+$midy   );
        my ($ad_x2,$ad_y2,)=( -($length/2-$symbol_size/2000)*$cos+$midx, -($length/2-$symbol_size/2000)*$sin+$midy   );
		add_pad($ad_x1,$ad_y1,"r$symbol_size");
		add_pad($ad_x2,$ad_y2,"r$symbol_size");

	}else{ 
		my ($ad_y1,$ad_y2);
		if ( $ye > $ys ) {
			$ad_y1= $ye+$size/2000-$symbol_size/2000;
			$ad_y2= $ys-$size/2000+$symbol_size/2000;
			add_pad($xe,$ad_y1,"r$symbol_size");
			add_pad($xs,$ad_y2,"r$symbol_size");

		}else{
			$ad_y1= $ys+$size/2000-$symbol_size/2000;
			$ad_y2= $ye-$size/2000+$symbol_size/2000;
			add_pad($xe,$ad_y1,"r$symbol_size");
			add_pad($xs,$ad_y2,"r$symbol_size");
		}	
	}
}
clear('tmp','drl');

###_______________________________________________sub
sub selcet_line {
$f->COM ('filter_reset',filter_name=>'popup');
$f->COM ('filter_set',filter_name=>'popup',update_popup=>'no',feat_types=>'line');
$f->COM ('filter_set',filter_name=>'popup',update_popup=>'no',polarity=>'positive');
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



