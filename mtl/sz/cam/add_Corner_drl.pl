#!/usr/bin/perl
use strict;
use Tk;
use Win32;
use Tk::Pane;
use Genesis;
use FBI;
use Encode;
use Encode::CN;

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

#______________
my ($profxmax,$profymax,$profxmin,$profymin);
my (@gROWname,@ drill,@checkbutton_value  );


if ($STEP ne "pnl"){
	$f->PAUSE("Please running at PNL"); 
	return;
	}
$f->COM("units,type=inch");
#####################
$f->INFO(units => 'inch',
	entity_type => 'step',
	entity_path => "$JOB/pnl",);
######################################
$profxmax = $f->{doinfo}{gPROF_LIMITSxmax};
$profymax = $f->{doinfo}{gPROF_LIMITSymax};
$profxmin = $f->{doinfo}{gPROF_LIMITSxmin};
$profymin = $f->{doinfo}{gPROF_LIMITSymin};
#_________________________________
$f->INFO( entity_type => 'matrix',
          entity_path => "$JOB/matrix");
@gROWname      =@{$f->{doinfo}{gROWname}};
foreach  (@gROWname) {
	if ($_ =~ m/drl/ig ){
		push @drill,$_;
	}
}

my $mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->title("Better and better");

my $row=0;

foreach  (0..$#drill) {
$mw->Label(-text=>$drill[$_],-relief=>'sunken',-font => [-family=>'ºÚÌå',-size=>14],-width=>14)->grid(-column=>0,-row=>++$row);
$mw->Checkbutton(-variable=>\$checkbutton_value[$_],-width=>8)->grid(-column=>1,-row=>$row);
}

$mw->Button(-text=>'Apply',-width=>8,-command=>\&apply,-font => [-family=>'ºÚÌå',-size=>14],-width=>8)->grid(-column=>1,-row=>$row+1,);
  
#MainLoop;

sub apply{

foreach my $id (0..$#drill){

    if ($checkbutton_value[$id]==1) {
	clear($drill[$id]);
	add_pad($profxmin+0.07874,$profymin+0.07874,'r39.606');
	add_pad($profxmin+0.07874,$profymax-0.07874,'r39.606');
	add_pad($profxmax-0.07874,$profymax-0.07874,'r39.606');
	add_pad($profxmax-0.07874,$profymin+0.07874,'r39.606');
	}
}
    clear();
	exit;
}


=head
my ($profxmax,$profymax,$profxmin,$profymin);
#@gROWrow = @{$f->{doinfo}{gROWrow}};
#@gROWcontext   =@{$f->{doinfo}{gROWcontext}};
#@gROWlayer_type=@{$f->{doinfo}{gROWlayer_type}};

#@gROWtype      =@{$f->{doinfo}{gROWtype}};
#@gROWside      =@{$f->{doinfo}{gROWside}};
