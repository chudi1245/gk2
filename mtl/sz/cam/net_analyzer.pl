#!/usr/bin/perl
use strict;
use Tk;
use Genesis;
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
          step1   =>'orig_net',
          type1   =>'ref',
          job2    =>$JOB,
          step2   =>'pcb_net',
          type2   =>'cur');
$f->COM ('netlist_recalc',
          job     =>$JOB,
          step    =>'orig_net',
          type    =>'cur',
          display =>'top');
$f->COM ('netlist_ref_update',
          job     =>$JOB,
          step    =>'orig_net',
          source  =>'cur',
          reduce  =>'no');
$f->COM ('netlist_recalc',
          job     =>$JOB,
          step    =>'pcb_net',
          type    =>'cur',
          display =>'bottom');
$f->COM ('netlist_recalc',
          job     =>$JOB,
          step    =>'orig_net',
          type    =>'ref',
          display =>'top');
$f->COM ('netlist_recalc',
          job     =>$JOB,
          step    =>'pcb_net',
          type    =>'cur',
          display =>'bottom');
$f->COM ('netlist_compare',
          job1    =>$JOB,
          step1   =>'orig_net',
          type1   =>'ref',
          job2    =>$JOB,
          step2   =>'pcb_net',
          type2   =>'cur',
          display =>'yes');
###___________________________________

my $result=$f->{COMANS};
my @result=split ' ',$result;


my $date = &getTime();#获取当前系统时间的Hash
my $year=$date->{year}-2000;#获取年
my $month=$date->{month};#获取月
my $day=$date->{day};#获取日
my $hour= $date->{hour};
my $minute= $date->{minute};
my $second= $date->{second};
my $alldate= "$year$month$day$hour$minute$second";


open (FH,"> c:/genesis/fw/jobs/$JOB/output/net.log") or die $!;
print FH "$result[0] $result[2] $alldate";
close FH;

$f->PAUSE("$alldate");


=head
open (FH,"> c:/genesis/fw/jobs/$JOB/output/net.log") or die $!;

my $result=$f->{COMANS};
my @result=split ' ',$result;
my $color;
($result[0]+$result[2]) ? ( $color='990000') : ( $color='328068');
$f->COM( 'edit_form',
job          =>$JOB,     
form         =>'eng',        
elem         =>'E103',     
value        =>"$result[0]-S $result[2]-B", 
color        =>$color,  
opt_name     =>'yes', 
callback     =>'no',  
);
###_______________________________________
open (FH,">> d:/work/FN.log") or die $!;
print FH "net $result[0] short $result[2] broken \n";
close FH;















