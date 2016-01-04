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
my ($column,$row,$ref,$mw,)=(0,0);
###
kysy();
$f->COM ('close_form',job=>$JOB,form=>'eng');
$ref=info("matrix","$JOB/matrix","row");
my @gROWrow       =@{$ref->{gROWrow}};
my @gROWcontext   =@{$ref->{gROWcontext}};
my @gROWside      =@{$ref->{gROWside}};
my @gROWlayer_type=@{$ref->{gROWlayer_type}};
my @gROWname      =@{$ref->{gROWname}};
my @gROWtype      =@{$ref->{gROWtype}};
my @gROWpolarity  =@{$ref->{gROWpolarity}};

$mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->title("Better and better");

foreach  (0..$#gROWname) {
	if ($gROWcontext[$_] eq 'board' and $gROWside[$_] eq 'inner' and  $gROWpolarity[$_] eq 'positive') {
		$mw->Label(-text=>$gROWname[$_])->grid(-column=>$column,-row=>$row++);

	}
}


MainLoop;
###_______________________________________




=head
$mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->title("Better and better");
foreach  (0..$#gROWname) {
	if ($gROWname[$_]) {
	    $mw->Label(-text=>$gROWname[$_],-width=>12,-relief=>'sun')->grid(-column=>$column,-row=>$row++);
		$mw->Checkbutton(-variable=>\$checkbutton_value[$_] )->grid(-column=>$column+1,-row=>$row-1);
		#$mw->Label(-text=>"${gROWname[$_]}++opt",-width=>18,-relief=>'sun')->grid(-column=>$column+2,-row=>$row-1);
	}
}
$mw->Button(-text=>'Apply',-command=>\&apply,-width=>12)->grid(-column=>$column,-row=>$row);
$mw->Button(-text=>'sw',-command=>\&switch,-width=>2)->grid(-column=>$column+1,-row=>$row);
MainLoop;





