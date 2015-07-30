#!/usr/bin/perl -w
use strict;
use Win32;
use encoding 'euc_cn';
use Encode;
use Encode::CN;
require Tk::LabFrame;
use Tk::BrowseEntry;
use Genesis;

my $host = shift;
my $f = new Genesis($host);
    
my $JOB = $ENV{JOB};
my $STEP = $ENV{STEP};
my $job_name = $JOB;
my $step_name = $STEP;
my $bg =  "cornsilk";

kysy();

my $def_path1 = "";
my $def_path2 = "";

my $CK = MainWindow->new;
$CK->title("导入job");
        $CK->Label(-text=>"选择文件",-font=>'Times 18 normal',-fg=>'blue')->pack;	
	my $f1 = $CK->Frame;
	my $lab1 = $f1->Label(-text => "文件路径",-fg=>'red',-font=>'Times 14 normal',-anchor => 'e');
	my $ent1 = $f1->Entry(-width => 40,-textvariable=>\$def_path1,-bg=>$bg);
	my $but = $f1->Button(-text => "Browse ...",-command => sub { fileDialog1($CK, $ent1,'open')});

	#my $select_file =$CK->getOpenFile(-initialdir=>"D:/jobs",-filetypes=> [['GIF Files', '.tgz',],['All Files', '*',]] );
   # $select_file=encode('gbk',$select_file);

	$lab1->pack(-side => 'left');
	$ent1->pack(-side => 'left',-expand => 'yes', -fill => 'x');
	$but->pack(-side => 'left');
	$f1->pack(-fill => 'x', -padx => 2, -pady => 2);

    my $f2 = $CK->Frame;
    $lab1 = $f2->Label(-text => "厂内编号",-fg=>'red',-font=>'Times 14 normal',-anchor => 'e');
	my $ent2 = $f2->Entry(-width => 40,-textvariable=>\$def_path2,-bg=>$bg);

	$lab1->pack(-side => 'left');
	$ent2->pack(-side => 'left',-expand => 'yes', -fill => 'x');
	$f2->pack(-fill => 'x', -padx => 2, -pady => 2);
	

MainLoop;


