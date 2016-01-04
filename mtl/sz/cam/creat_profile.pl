#!/usr/bin/perl
##
## zq 2011.01.21 
##  cant select three  method to creat profile 2011.01.26
###save the step_name to forms ?
use strict;
use Win32;
use Genesis;
use FBI;
use Tk;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$mw,$method)=(0,0,undef,'Box_peak');
###_____________________________

unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 $f->COM ('close_form',job=>$JOB,form=>'eng');
	 open_step($STEP);
	 unless ($STEP) {
		 p__('no step');
		 exit;
	 }
}

$mw=MainWindow->new();
$mw->title("Better and better");
$mw->geometry("+200+100");
foreach (qw/Box_peak Box Step_limit/) {
    $mw->Radiobutton(-text=>$_, -variable=>\$method, -value=>$_)->grid(-sticky=>'w',-column=>$column,-row=>$row++,);
}
$mw->Button(-text=>"Apply",-command=>\&apply)->grid(-column=>0,-row=>$row++,);
MainLoop;
###_________________________________________________________
sub apply {
	if ($method eq 'Box') {
		my $test=exists_entity('layer',"$JOB/$STEP/box");
	    if ($test eq 'yes') {
		    clear('box');
		    $f->COM ('sel_reverse');
		    $f->COM ('sel_create_profile');
		    exit;
		}else{
		    p__('layer box not exists');
		    exit;
		}
	}elsif ($method eq 'Box_peak'){
		pro_box_peak();
		exit;
	}elsif ($method eq 'Step_limit'){
	    $f->COM ('profile_limits');
	    exit;
	}
}

sub pro_box_peak{
    $f->VOF;
    delete_layer('tmp');
    $f->VON;
	my $test=exists_entity('layer',"$JOB/$STEP/box");
    if ($test eq 'yes' ) {
        $f->COM ('copy_layer',
        source_job   =>$JOB,
        source_step  =>$STEP,
        source_layer =>'box',
        dest         =>'layer_name',
        dest_layer   =>'tmp',
        mode         =>'replace',
        invert       =>'no');
    }else{
		p__('layer box not exists');
		exit;

    }
    clear('tmp');
    $f->COM ('sel_change_sym',symbol=>'r0',reset_angle=>'no');
    my $ref=info('layer',"$JOB/$STEP/tmp",'limits');
    my @profile_datum=($ref->{gLIMITSxmin}, $ref->{gLIMITSymin}, $ref->{gLIMITSxmax}, $ref->{gLIMITSymax},);
    $f->COM ('profile_rect',
        x1=>$profile_datum[0],
	    y1=>$profile_datum[1],
	    x2=>$profile_datum[2],
	    y2=>$profile_datum[3]);
	clear('box');
	exit;
}




=head

$f->VOF;
delete_layer('tmp');
$f->VON;
if ( exists_entity('layer',"$JOB/$STEP/box") eq 'yes' ) {
    $f->COM ('copy_layer',
    source_job   =>$JOB,
    source_step  =>$STEP,
    source_layer =>'box',
    dest         =>'layer_name',
    dest_layer   =>'tmp',
    mode         =>'replace',
    invert       =>'no');
}else{

}
clear('tmp');
$f->COM ('sel_change_sym',symbol=>'r0',reset_angle=>'no');
my $ref=info('layer',"$JOB/$STEP/tmp",'limits');
my @profile_datum=($ref->{gLIMITSxmin}, $ref->{gLIMITSymin}, $ref->{gLIMITSxmax}, $ref->{gLIMITSymax},);
$f->COM ('profile_rect',
    x1=>$profile_datum[0],
	y1=>$profile_datum[1],
	x2=>$profile_datum[2],
	y2=>$profile_datum[3]);

###end










