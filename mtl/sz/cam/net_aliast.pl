#! /usr/bin/perl
use strict;
use Tk;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
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

open (FH,"> c:/genesis/fw/jobs/$JOB/output/net.log") or die $!;
print FH "$result[0] $result[2]";
close FH;



###C:\genesis\fw\jobs\m45308\output
=cut
#my $color;
##if ($result[0]+$result[2] ) {
#	 $color='990000';
#}else{
#     $color='328068';
#}

#$f->COM( 'edit_form',
#job          =>$JOB,     
#form         =>'qae',        
#elem         =>'E25',     
#value        =>"$result[0]-S $result[2]-B", 
#color        =>$color,  
#opt_name     =>'yes', 
#callback     =>'no',  
#);
###_______________________________________
#$f->COM ('save_job',job=>$JOB);
