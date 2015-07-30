#!/usr/bin/perl
##
## zq 2011.01.13 compaire layer
## add mouse wheel adjust the tolence 2011.01.21
use strict;
use Win32;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($tolence,$ref,@row_name,@row_context,$mw)=(3,);
###_____________________________
kysy();

$f->COM ('close_form',job=>$JOB,form=>'eng');
unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 unless ($STEP) { p__('no step');  exit; }
	 open_step($STEP);
}
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
$mw->Button(-text=>'Compare All layer',-width=>30,-command=>\&COmpareAll)->grid(-column=>0,-columnspan=>5,-row=>1);	

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

sub COmpareAll {

foreach (0..$#row_name) {
	if ($row_context[$_] eq 'board') {
		#p__("$row_name[$_] is compare");
		&comp($row_name[$_]); 	
	}  
}

foreach (0..$#row_name) {
	if ($row_context[$_] eq 'board') {
		display($row_name[$_]);
		p__("please check the result of $row_name[$_]");
	
	}  
}

exit;
}

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
	 open (FH,">> c:/genesis/fw/jobs/$JOB/output/compare.log") or die $!;
	 print FH "$name ";
	 close FH;
     #exit;    
}



sub layer_compair {
    my            ($layer1,$tol,$job2, $step2, $layer2,$layer2_ext,$area,$ignore_attr,$map_layer,$map_layer_res);
    my @default=qw(   x      x   $JOB   pcb       x      ''      global     ''         comp         200);
    my $length=@_-1;
    @default[0..$length]=@_;
    ($layer1,$tol,$job2, $step2, $layer2,$layer2_ext,$area,$ignore_attr,$map_layer,$map_layer_res)=@default;
    $f->COM ('compare_layers',
		  layer1          =>$layer1,
		  job2            =>$JOB,
		  step2           =>'pcb',
		  layer2          =>"${layer1}++orig",
		  layer2_ext      =>'',
		  tol             =>$tol,
		  area            =>'global',
		  ignore_attr     =>'',
		  map_layer       =>"${layer1}_map",
		  map_layer_res   =>200);
    
}

sub display {
	my $layer1 = shift;
	clear();
	$f->COM ('display_layer',name=>$layer1,display=>'yes',number=>1);
    $f->COM ('display_layer',name=>"${layer1}++orig",,display=>'yes',number=>2);
    $f->COM ('display_layer',name=>"${layer1}_map",display=>'yes',number=>3);

}


=head

	$f->COM ('display_layer',name=>$layer1,display=>'yes',number=>1);
    $f->COM ('display_layer',name=>"${layer1}++orig",,display=>'yes',number=>2);
    $f->COM ('display_layer',name=>"${layer1}_map",display=>'yes',number=>3);

sub

