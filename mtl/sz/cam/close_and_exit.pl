#!/usr/bin/perl 
#**************************************************************
# 程序名称：清空影响层
# 程序版本：v1.0
# 程序功能描述: 清空所有影响层和工作层
# 开发人员：莫志兵
# 创建时间：2012-3-16
#**************************************************************
use strict;
use Genesis;
use FBI;

kysy();

our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};


$f->COM("save_job,job=$JOB,override=no");

#$f->COM("info,out_file=C:/tmp/do_info.1000,write_mode=replace,args= -t matrix -e m46305/matrix");
#$f->COM("disp_on");
#$f->COM("origin_on");

$f->COM("editor_page_close");

$f->COM("check_inout,mode=in,type=job,job=$JOB");
$f->COM("close_job,job=$JOB");
$f->COM("close_form,job=$JOB,form=eng");
$f->COM("close_flow,job=$JOB");


=head



COM save_job,job=$job,override=no
COM check_inout,mode=in,type=job,job=$job
COM close_job,job=$job
COM close_form,job=$job,form=eng
COM close_flow,job=$job

$f->COM ('affected_layer',mode=>'all',affected=>'no');