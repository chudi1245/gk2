#! /usr/bin/perl
use strict;
use Genesis;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
our $COMANS;
###_______________________________
kysy();
$f->COM ('netlist_page_open',
          set     =>'yes',
          job1    =>$JOB,
          step1   =>'orig',
          type1   =>'ref',
          job2    =>$JOB,
          step2   =>'pcb',
          type2   =>'cur');
$f->COM ('netlist_recalc',
          job     =>$JOB,
          step    =>'orig',
          type    =>'cur',
          display =>'top');
$f->COM ('netlist_ref_update',
          job     =>$JOB,
          step    =>'orig',
          source  =>'cur',
          reduce  =>'no');
$f->COM ('netlist_recalc',
          job     =>$JOB,
          step    =>'pcb',
          type    =>'cur',
          display =>'bottom');
$f->COM ('netlist_recalc',
          job     =>$JOB,
          step    =>'orig',
          type    =>'ref',
          display =>'top');
$f->COM ('netlist_recalc',
          job     =>$JOB,
          step    =>'pcb',
          type    =>'cur',
          display =>'bottom');
$f->COM ('netlist_compare',
          job1    =>$JOB,
          step1   =>'orig',
          type1   =>'ref',
          job2    =>$JOB,
          step2   =>'pcb',
          type2   =>'cur',
          display =>'yes');
###___________________________________
my $result=$f->{COMANS};
my @result=split ' ',$result;

open (FH,">> d:/work/FN.log") or die $!;
print FH "net $result[0] short $result[2] broken \n";
close FH;











