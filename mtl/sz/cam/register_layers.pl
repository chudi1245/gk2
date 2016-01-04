#!/usr/bin/perl
use strict;
use Tk;
use Win32;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###_________________
kysy();

unit_set('inch');
$f->COM ('close_form',job=>$JOB,form=>'eng');
unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 unless ($STEP) { p__('no step');  exit; }
	 open_step($STEP);
};


clear();
$f->COM ('affected_layer',mode=>'all',affected=>'yes');


my $ref_layer='gtl';
if ( exists_layer('gtl') eq 'yes' ){
     $f->COM ('register_layers',
         reference_layer=>'gtl',
		 tolerance=>1.5,
		 mirror_allowed=>'yes',
		 rotation_allowed=>'yes',
		 zero_lines=>'no',
		 reg_mode=>'affected_layers',
		 register_layer=>'');
	 clear('gtl');
}
















=head



