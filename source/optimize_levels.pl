#!/usr/bin/perl
use strict;
use Tk;
use Tk::Pane;
use Genesis;
use C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$number_switch,@gROWname,$mw,$number_switch,@checkbutton_value)=(0,0,0);
###_____________
kysy();
@gROWname=@{info("matrix","$JOB/matrix","row")->{gROWname}};
###_______________________________________
my $franm=MainWindow->new;
$franm->title("Better and better");
$franm->geometry("+200+100");
$mw=$franm->Scrolled("Frame", -scrollbars => 'w',-height=>500 )->pack();
foreach  (0..$#gROWname) {
	if ($gROWname[$_]) {
	    $mw->Label(-text=>$gROWname[$_],-width=>12,-relief=>'sun')->grid(-column=>$column,-row=>$row++);
		$mw->Checkbutton(-variable=>\$checkbutton_value[$_] )->grid(-column=>$column+1,-row=>$row-1);
		#$mw->Label(-text=>"${gROWname[$_]}++opt",-width=>18,-relief=>'sun')->grid(-column=>$column+2,-row=>$row-1);
	}
}
#$mw->Button(-text=>'Apply',-command=>\&apply,-width=>12)->grid(-column=>$column,-row=>$row);
#$mw->Button(-text=>'sw',-command=>\&switch,-width=>2)->grid(-column=>$column+1,-row=>$row);

$franm->Button(-text=>'Apply',-command=>\&apply,-width=>15)->pack(-side => 'left');
$franm->Button(-text=>'sw',-command=>\&switch,-width=>2)->pack(-side => 'left');
MainLoop;
###___________________________________________
sub apply {
	foreach  (0..$#gROWname) {
		if ($checkbutton_value[$_] == 1) {
			$f->COM ('optimize_levels',
				layer     =>$gROWname[$_],
				opt_layer =>"${gROWname[$_]}++opt",
				levels    =>1);
		}
	}
	exit;
}

sub switch {
	my $value;
	(++$number_switch % 2)?($value=1):($value=0);
	foreach  (@checkbutton_value) {  $_=$value;	};
}

=h
COM optimize_levels,layer=l2t,opt_layer=l2ttt,levels=1










