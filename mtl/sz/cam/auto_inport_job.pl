#!/usr/bin/perl
#**************************************************************
# 程序名称：自动导入tgz文件
# 程序版本：v1.0
# 程序功能描述: 
# 开发人员：莫志兵
# 创建时间：2012-3-16
#**************************************************************
use strict;
use warnings;
use Genesis;
use FBI;
use Encode ;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

my $gb_path = "D:/work";
my $tgzname;
my $jobname;

opendir (DH,$gb_path);
my @gb_list=readdir DH;

foreach (@gb_list){
    if ($_ =~ m/\.tgz$/ig){
		$tgzname=$_;
		$jobname = $tgzname;
		$jobname =~ s/\.tgz//ig; 
	}

}
##p__("$tgzname $jobname");

$f->COM("import_job,db=genesis,path=$gb_path/$tgzname,name=$jobname,analyze_surfaces=no");

$f->COM("check_inout,mode=out,type=job,job=$jobname");
$f->COM("clipb_open_job,job=$jobname,update_clipboard=view_job");

$f->COM("open_job,job=$jobname");
$f->COM("open_entity,job=$jobname,type=step,name=pnl,iconic=no");

$f->AUX("set_group,group=0");
$f->COM("units,type=inch");

