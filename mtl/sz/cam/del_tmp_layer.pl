#! /usr/bin/perl
#**************************************************************
# 程序名称：删除临时层
# 程序版本：v1.0
# 程序功能描述: 清空所有影响层和工作层
# 开发人员：莫志兵
# 创建时间：2012-3-16
#**************************************************************
use strict;
use Tk;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________________
kysy();

my @gROWname=@{info("matrix","$JOB/matrix","row")->{gROWname}};
foreach  (0..$#gROWname) {  delete_layer($gROWname[$_])  if  
	(($gROWname[$_] =~ /orig/) or ($gROWname[$_] =~ /\+/) or ($gROWname[$_] =~ /\.gbr/)
	
or ($gROWname[$_] =~ /\.drl/)or ($gROWname[$_] =~ /org/) or ($gROWname[$_] =~ /comp/) 
	
or ($gROWname[$_] eq'c') or ($gROWname[$_] eq 's') or ($gROWname[$_] eq 'pmt')  );

}





=h

@re_row = reverse @{info("matrix","$JOB/matrix","row")->{gROWrow}};
@name=@{info("matrix","$JOB/matrix","row")->{gROWname}};
###________________________________________
clear();
foreach (@re_row) {
    delete_row($_) if (  ($name[$_-1] =~ /orig/) or ($name[$_-1] =~ /\+/) or ($name[$_-1] =~ /org/)  )
}  





