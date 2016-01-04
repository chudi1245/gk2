#!/usr/bin/perl 
##    zhouqing 
##    2010.05.13
use strict;
use Tk;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my (@row,@side,@name,$ref, );
###_______________________
kysy();
###$run_step = read_form($JOB,'E21');
if ($STEP ne "orig") {p__("this script only run on the orig");exit;}
$ref=info('matrix',"$JOB/matrix",'ROW');
@row=@{$ref->{gROWrow}};
@name=@{$ref->{gROWname}};
@side=@{$ref->{gROWside}};
###_________________________
foreach (0..$#row){ 
    if ($side[$_] eq "inner"){
               clear($name[$_]);
               slect_thermal();
               $f->COM ('get_select_count');
               $f->COM ('sel_delete') if ($f->{COMANS} != 0);              
    }               
}
$f->COM ('close_form',job=>"$JOB",form=>"qae");
###_________________________







