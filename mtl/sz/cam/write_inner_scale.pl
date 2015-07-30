#!/usr/bin/perl
use strict;
use Genesis;
use Win32;
use Win32::API;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###______________________________
kysy();
my ($row,$inner_num,@val_sca_x,@val_sca_y)=(0,);

##info
my $ref=info('matrix',"$JOB/matrix",'ROW');
my @gROWname      =@{$ref->{gROWname}};
my @gROWlayer_type=@{$ref->{gROWlayer_type}};
my @gROWcontext   =@{$ref->{gROWcontext}};
my @gROWside      =@{$ref->{gROWside}};
my @gROWfoil_side =@{$ref->{gROWfoil_side}};

my $mw = MainWindow->new;
$mw->geometry("+400+250");
$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
#**********************保证程序显示在最前边
$mw->title("Better and better!");
$mw->Label(-text=>"layer",-font =>[-size => 12],-width=>10)->grid(-column=>0,-row=>0);
$mw->Label(-text=>"%%-x",-font =>[-size => 12],-width=>10)->grid(-column=>1,-row=>0);
$mw->Label(-text=>"%%-y",-font =>[-size => 12],-width=>10)->grid(-column=>2,-row=>0);
$mw->Button(-text=>"save",-font=>[-size=>12],-width=>8,-command=>\&save,)->grid(-column=>3,-row=>0);
foreach  (0..@gROWname) {
	if ($gROWside[$_] eq 'inner'){
	$mw->Label(-text=>$gROWname[$_],-width=>20,-anchor=>'c')->grid(-column=>0, -row=>++$row,);
	$mw->Entry(-textvariable=>\$val_sca_x[$_],-width=>7,)->grid(-column=>1, -row=>$row,);
	$mw->Entry(-textvariable=>\$val_sca_y[$_],-width=>7,)->grid(-column=>2, -row=>$row,);
   }
	if ($gROWname[$_] =~m/l2[tb]/ig) {
	$inner_num=$_;
	$mw->Button(-text=>'same',-font=>[-size=>12],-width=>6,-command=>\&same_scale)->grid(-column=>3, -row=>$row);
   }	
}


MainLoop;
#******************************
sub same_scale {
foreach  (0..@gROWname) {
	if ($gROWside[$_] eq 'inner') {
	$val_sca_x[$_]=$val_sca_x[$inner_num];
	$val_sca_y[$_]=$val_sca_y[$inner_num];
	}
	}
}
sub save{
	my $file="c:/genesis/fw/jobs/$JOB/output/scal.log";
	if (-e $file ){ unlink($file);}
	foreach  (0..@gROWname) {
	if ($gROWside[$_] eq 'inner') {
	open (FH,">> c:/genesis/fw/jobs/$JOB/output/scal.log") or die $!;
	print FH "$gROWname[$_] $val_sca_x[$_] $val_sca_y[$_]\n";
	close FH;
	}
	}	
}


=head

my $mw = MainWindow->new;
$mw->geometry("+400+250");

$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);


$mw->title("自动缩铜");
$mw->Label(-text=>"减少值:",-font =>[-size => 12],-width=>10)             ->grid(-column=>0,-row=>0);

$mw->Entry(-textvariable=>\$value,-font =>[-size => 14], -width=>6)   ->grid(-column=>1,-row=>0)->focus;
$mw->Button(-text=>'确定',-command=>\&shrink_cu,-font =>[-size => 14],-width=>10)->grid(-column=>2,-row=>0,-sticky=>"ew",);

MainLoop;



为什么要unlink呢？rm不行吗？ 
这样写： 
system( "rm   $source "); 
保证干净利索