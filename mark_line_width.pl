#!/usr/bin/perl
##
use strict;
use Genesis;
use C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($dis_layer,@mark_line_width,$mirror_1,$rotate_2,$ref);
my (@PROF_LIMITS,@gSR_LIMITS,$mouse,@mouse_coordinate);
###___________________
kysy();
unit_set('inch');
my $affect_layer=$f->COM ('get_affect_layer');
if ($affect_layer) { 
	p__("affect_layer $affect_layer,");
	exit;
};

$ref=info('step',"$JOB/$STEP",);
@PROF_LIMITS=($ref->{gPROF_LIMITSxmin}, $ref->{gPROF_LIMITSymin}, $ref->{gPROF_LIMITSxmax}, $ref->{gPROF_LIMITSymax},);
@gSR_LIMITS=($ref->{gSR_LIMITSxmin}, $ref->{gSR_LIMITSymin}, $ref->{gSR_LIMITSxmax}, $ref->{gSR_LIMITSymax},);
$mouse=$f->MOUSE('p');
@mouse_coordinate=split m/\s/,$mouse;
###1
if ( $mouse_coordinate[0] < ($PROF_LIMITS[2] + $PROF_LIMITS[0])/2 ) {
	$mark_line_width[1]{x}=$gSR_LIMITS[0] - 0.03;
	$mirror_1='no';
}else{
	$mark_line_width[1]{x}=$gSR_LIMITS[2] + 0.03;
	$mirror_1='yes';
}
###2
if (    $mouse_coordinate[1] > ($PROF_LIMITS[3] + $PROF_LIMITS[1])/2   ) {
	$mark_line_width[2]{y}=$gSR_LIMITS[3] + 0.03;
	$rotate_2=0;
}else{
	$mark_line_width[2]{y}=$gSR_LIMITS[1] - 0.03;
	$rotate_2=180;
}
###__________________
add_pad($mark_line_width[1]{x}, $mouse_coordinate[1],   'mark_line_width', $mirror_1, 270      );
add_pad($mouse_coordinate[0],   $mark_line_width[2]{y}, 'mark_line_width', 'no',      $rotate_2);
=head





































































