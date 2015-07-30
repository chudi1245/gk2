#!/usr/bin/perl
##
## zq 2011.01.13 compaire layer
## add mouse wheel adjust the tolence 2011.01.21
use strict;
use Tk;
use Genesis;
use C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($tolence,$ref,@row_name,@row_context,$mw)=(3,);
###_____________________________
kysy();
##_______________________________________________________
$ref=info('matrix',"$JOB/matrix",);
@row_name=@{$f->{doinfo}{gROWname}};
@row_context= @{$f->{doinfo}{gROWcontext}};
###____________________________________________________
$mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->title('Compaire_layer');
$mw->Label(-text=>'Tol=',-width=>8,)->grid(-column=>0, -row=>0,);
$mw->Label(-textvariable=>\$tolence,-width=>6,)->grid(-column=>1, -row=>0,);
$mw->Button(-text=>'^',-width=>6,-command=>\&up)->grid(-column=>2, -row=>0,);
$mw->Button(-text=>'v',-width=>6,-command=>\&down)->grid(-column=>3, -row=>0,);	   
clear();
foreach (0..$#row_name) {
	if ($row_context[$_] eq 'board') {
	      $mw->Button(-text=>$row_name[$_],-command=>[\&comp,$row_name[$_]],-width=>24)
              ->grid(-column=>0, -row=>$_+4,-columnspan=>5,-ipady=>2,-sticky=>"ew",);	   	
	}  
}
$mw->bind('<MouseWheel>' =>\&adjust);
MainLoop;
###____________________________________________sub
sub up   {$tolence++};
sub down {$tolence--};
sub adjust{
	my $widget=shift;
	my $event=$widget->XEvent;
	my $keysym =$event->K;
	if ($keysym eq 'F9') {
		$tolence=$tolence + 0.1;
	}elsif($keysym eq '0'){
		$tolence=$tolence - 0.1;
	}
}
sub comp {
     my $name=shift;  
     my $tst=exists_layer("${name}++orig");
     unit_set("inch");
     clear();
     if ($tst eq "no") { p__('_orig layer not exists,please copy the orig frist');exit }
     layer_compair($name,$tolence);
     exit;    
}











