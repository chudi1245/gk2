#!/usr/bin/perl
#**************************************************************
# 程序名称：显示VUT信息
# 程序版本：v1.0
# 程序功能描述: 
# 开发人员：莫志兵
# 创建时间：2012-3-30
#**************************************************************
use strict;
use Genesis;
use FBI;
use Encode;
use encoding 'euc_cn';
use Win32;
use Win32::API;

our $host = shift;
our $f = new Genesis;
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();
#******************************************
my %vut=(	
		"1020"=>23.63,  ###1.0MM
		"1030"=>26.78,
		"1045"=>31.50,
		"1060"=>35.43,  

		"1120"=>24.41, ###1.1MM
		"1130"=>27.56,
		"1145"=>33.08,
		"1160"=>39.37,

		"1220"=>25.20, ###1.2MM
		"1230"=>28.35,
		"1245"=>34.65,
		"1260"=>40.95,

		"1320"=>25.98,  ###1.3MM
		"1330"=>29.93,
		"1345"=>36.23,
		"1360"=>43.31,

		"1420"=>26.78,  ###1.4MM
		"1430"=>30.71,
		"1445"=>37.80,
		"1460"=>45.67,

		"1520"=>27.56,  ###1.5MM
		"1530"=>31.50,
		"1545"=>39.37,
		"1560"=>48.82,

		"1620"=>28.35,  ###1.6MM
		"1630"=>32.29,
		"1645"=>40.16,
		"1660"=>50.40,

		"1720"=>29.14,  ###1.7MM
		"1730"=>33.08,
		"1745"=>41.74,
		"1760"=>51.97,

		"1820"=>29.93,  ###1.8MM
		"1830"=>34.65,
		"1845"=>43.31,
		"1860"=>53.55,

		"1920"=>30.71,  ###1.9MM
		"1930"=>35.44,
		"1945"=>44.89,
		"1960"=>55.91,

		"2020"=>31.50,  ###2.0MM
		"2030"=>37.10,
		"2045"=>47.25,
		"2060"=>58.27,

		"2120"=>32.30,  ###2.1MM
		"2130"=>37.80,
		"2145"=>48.82,
		"2160"=>60.63,

		"2220"=>33.08,  ###2.2MM
		"2230"=>39.37,
		"2245"=>50.40,
		"2260"=>63.78,

		"2320"=>33.86,  ###2.3MM
		"2330"=>40.95,
		"2345"=>52.76,
		"2360"=>66.15,

		"2420"=>34.65,  ###2.4MM
		"2430"=>42.52,
		"2445"=>54.34,
		"2460"=>68.50,
);

unit_set('inch');
my ($value,$vutvalue)=(1630,);
$vutvalue=$vut{$value};
my $mw = MainWindow->new;

$mw->geometry("+400+250");
$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);


$mw->title("检查VUT叠铜");

$mw->Label(-text=>"板厚角度:",-font =>[-size => 12],-width=>10)             ->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$value,-font =>[-size => 14], -width=>6)   ->grid(-column=>1,-row=>0)->focus;

$mw->Label(-text=>"叠铜宽度:",-font =>[-size => 12],-width=>10)             ->grid(-column=>0,-row=>1);
$mw->Entry(-textvariable=>\$vutvalue,-font =>[-size => 14], -width=>6)   ->grid(-column=>1,-row=>1)->focus;

$mw->Button(-text=>'确定',-command=>\&vut_line,-font =>[-size => 14],-width=>10)->grid(-column=>2,-row=>0,-sticky=>"ew",);
$mw->Button(-text=>'退出',-command=>sub{exit;},-font =>[-size => 14],-width=>10)->grid(-column=>2,-row=>1,-sticky=>"ew",);
MainLoop;



sub vut_line{

	$vutvalue=$vut{$value};
	if (get_select_count()){
	$f->COM("sel_change_sym,symbol=r$vut{$value},reset_angle=no");
	}
}





