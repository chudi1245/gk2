#!/usr/bin/perl
use strict;
use Genesis;
use Win32;
use Tk::Pane;
use FBI;
our ($f,$host,$JOB,$STEP);
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$number_switch,$prof,$mw,@gROWname,@checkbutton_value)=(0,0,0);
###__________________________________________________________
kysy();
unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 $f->COM ('close_form',job=>$JOB,form=>'eng');
	 unless ($STEP) {
		 p__('no step');
		 exit;
	 }
	 	 open_step($STEP);
}
@gROWname=@{info("matrix","$JOB/matrix","row")->{gROWname}};
my $work_layer=get_work_layer();
$prof=info('step',"$JOB/$STEP",'PROF_LENGTH')->{gPROF_LENGTH};
unless ($prof) {
	p__('No profile');
	exit;
}

###_______________________
my $franm=MainWindow->new;
$franm->title("Better and better");
$franm->geometry("+200+100");
$mw=$franm->Scrolled("Frame", -scrollbars => 'w',-height=>600 )->pack();
foreach  (0..$#gROWname) {
	if ($gROWname[$_] and $gROWname[$_] ne 'box' and $gROWname[$_] ne 'dd') {
	    $mw->Label(-text=>$gROWname[$_],-width=>12,-relief=>'sun')->grid(-column=>$column,-row=>$row++);
		if ($work_layer eq $gROWname[$_]) {$checkbutton_value[$_] = 1 };
		$mw->Checkbutton(-variable=>\$checkbutton_value[$_] )->grid(-column=>$column+1,-row=>$row-1);
	}
}
$franm->Button(-text=>'Apply',-command=>\&apply,-width=>15)->pack(-side => 'left');
$franm->Button(-text=>'sw',-command=>\&switch,-width=>2)->pack(-side => 'left');
MainLoop;

sub apply {
	foreach  (0..$#gROWname) {
		if ($gROWname[$_] and $gROWname[$_] ne 'box' and $gROWname[$_] ne 'dd') {
			if (  $checkbutton_value[$_]  ) {
				clear($gROWname[$_]);
                $f->COM ('filter_reset',filter_name=>'popup');
                $f->COM ('filter_set',filter_name=>'popup',update_popup=>'no',profile=>'out');
                $f->COM ('filter_area_strt');
                $f->COM ('filter_area_end',
		                 layer         =>'',
            		     filter_name   =>'popup',
            		     operation     =>'select',
            		     area_type     =>'none',
            		     inside_area   =>'no',
            	     	 intersect_area=>'no',
            		     lines_only    =>'no',
            		     ovals_only    =>'no',
            		     min_len       =>0,
            		     max_len       =>0,
            		     min_angle     =>0,
            		     max_angle     =>0);
            	$f->COM ('sel_delete') if &get_select_count;
			}
		}
	}
	exit;
}

sub switch {
	my $value;
	(++$number_switch % 2)?($value=1):($value=0);
	foreach  (@checkbutton_value) {  $_=$value;	};
}









=head


	clear();
	$f->COM ('affected_layer',mode=>'all',affected=>'yes');
    $f->COM ('filter_reset',filter_name=>'popup');
    $f->COM ('filter_set',filter_name=>'popup',update_popup=>'no',profile=>'out');
    $f->COM ('filter_area_strt');
    $f->COM ('filter_area_end',
		     layer         =>'',
		     filter_name   =>'popup',
		     operation     =>'select',
		     area_type     =>'none',
		     inside_area   =>'no',
	     	 intersect_area=>'no',
		     lines_only    =>'no',
		     ovals_only    =>'no',
		     min_len       =>0,
		     max_len       =>0,
		     min_angle     =>0,
		     max_angle     =>0);
	$f->COM ('sel_delete') if &get_select_count;
	clear();

