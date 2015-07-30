#! /usr/bin/perl
use strict;
use Win32;
##use Tk::Pane;
use Genesis;
use FBI;
##use Encode;
use Encode::CN;


our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________________
kysy();

unit_set('inch');

my (@gROWname,@gROWlayer_type,@gROWcontext,@gROWside,);

@gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
@gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
@gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
@gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};

my (@inner,@checkbutton_value);

foreach  (0..$#gROWname) {
	if ($gROWcontext[$_] eq 'board' and $gROWside[$_] eq 'inner' ){
		push @inner,$gROWname[$_];
	}
}

my $mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->title("Define negative");

my $row=0;

foreach  (0..$#inner) {
$mw->Label(-text=>$inner[$_],-relief=>'sunken',-font => [-family=>'ºÚÌå',-size=>14],-width=>14)
	->grid(-column=>0,-row=>++$row);
$mw->Checkbutton(-variable=>\$checkbutton_value[$_],-width=>8)
   ->grid(-column=>1,-row=>$row);
}

$mw->Button(-text=>'Apply',-width=>8,-command=>\&apply,-font => [-family=>'ºÚÌå',-size=>14],-width=>8)
     ->grid(-column=>1,-row=>$row+1,);
  
MainLoop;

sub apply{

foreach my $id (0..$#inner){
if ($checkbutton_value[$id]==1) {
	#clear($inner[$id]);
   $f->COM('matrix_layer_type', job    => $JOB,
                                matrix => 'matrix',
								layer  => $inner[$id],
								type   => 'power_ground');

   $f->COM('matrix_layer_polar', job      =>  $JOB,
								 matrix   => 'matrix',
								 layer    => $inner[$id],
								 polarity => 'negative');
	}
    }
exit;
}




























