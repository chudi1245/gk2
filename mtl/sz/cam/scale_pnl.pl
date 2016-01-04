#!/usr/bin/perl
#**************************************************************
# 程序名称：PNL层进行缩放
# 程序版本：v1.0
# 程序功能描述: 
# 开发人员：莫志兵
# 创建时间：2012-3-30
#**************************************************************
use strict;
use Tk;
use Genesis;
use FBI;
use Win32;
use Win32::API;
use Encode;
use encoding 'euc_cn';

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

my ($profxmax,$profymax,,$profxmin,$profymin,$x_center,$y_center,$xscal,$yscal,);

#unit_set('inch');
	$f->INFO(units => 'inch',
	entity_type    => 'step',
	entity_path    => "$JOB/$STEP",);
#########################

$profxmax = $f->{doinfo}{gPROF_LIMITSxmax};
$profymax = $f->{doinfo}{gPROF_LIMITSymax};
$profxmin = $f->{doinfo}{gPROF_LIMITSxmin};
$profymin = $f->{doinfo}{gPROF_LIMITSymin};

$x_center = sprintf "%6.2f",($profxmax - $profxmin)/2;
$y_center = sprintf "%6.2f",($profymax - $profymin)/2;


my $mw = MainWindow->new;
$mw->geometry("+400+250");

$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);


$mw->title("缩放内层");
$mw->Label(-text=>"X值:",-font =>[-size => 12],-width=>4)             ->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$xscal,-font =>[-size => 14], -width=>6)   ->grid(-column=>1,-row=>0)->focus;
$mw->Label(-text=>"Y值:",-font =>[-size => 12],-width=>4)             ->grid(-column=>2,-row=>0);
$mw->Entry(-textvariable=>\$yscal,-font =>[-size => 14], -width=>6)   ->grid(-column=>3,-row=>0)->focus;

$mw->Button(-text=>'确定',-command=>\&scal_layer,-font =>[-size => 14],-width=>8)->grid(-column=>4,-row=>0,-sticky=>"ew",);

MainLoop;


sub scal_layer{

	my($x,$y);	
	$xscal ? ($x=1-$xscal/10000) : ($x=1);
	$yscal ? ($y=1-$yscal/10000) : ($y=1);	
	$f->COM('sel_transform',
		mode=>'anchor',
		oper=>'scale',
		duplicate=>'no',
		x_anchor=>$x_center,
		y_anchor=>$y_center,
		angle=>0,
		x_scale=>$x,
		y_scale=>$y,
		x_offset=>0,
		y_offset=>0,			
		
		);
exit;
}

=head
	$f->COM("sel_transform,mode=anchor,oper=scale,duplicate=no,
	x_anchor=8.15,y_anchor=10.25,angle=0,x_scale=0.9,y_scale=0.9,x_offset=0,y_offset=0");


$f->COM("sel_transform,x_offset=0,mode=anchor,angle=0,x_scale=0.99975,
        y_offset=0,y_scale=0.99965,x_anchor=  8.15,oper=scale,duplicate=no,
        y_anchor= 10.25");



$f->COM("sel_transform,mode=anchor,oper=scale,duplicate=no,x_anchor=8.15,
        y_anchor=10.25,angle=0,x_scale=0.99975,y_scale=0.99965,x_offset=0,
        y_offset=0");


