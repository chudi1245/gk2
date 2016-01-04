#!/usr/bin/perl 
##    zhouqing 
##    2010.06.04
{
use strict;
use Tk;
use POSIX qw/strftime/;
use FileHandle;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;

our $host  = shift;
our $f     = new Genesis($host);
our $JOB   = $ENV{JOB};
our $STEP  = $ENV{STEP};
}

##
kysy();

my @year=gmtime;

unless (-e "C:\genesis\fw\jobs\$JOB\forms\qae") {
  $f->COM ('copy_form',
	       src_job    =>'genesislib',
	       src_form   =>'qae',
	       dst_job    =>$JOB,
	       dst_form   =>'qae');
}
$f->COM ('show_form',
         job         =>$JOB,
         form        =>'qae',
         updonly     =>'No',
         updelem     =>'');
###
$f->COM( 'edit_form',
job          =>$JOB,     
form         =>'qae',        
elem         =>'E21',     
value        =>$STEP, 
color        =>'328068',  
opt_name     =>'yes', 
callback     =>'no',  
);

my $week=strftime "%W", localtime;

$f->COM( 'edit_form',
job          =>$JOB,     
form         =>'qae',        
elem         =>'E23',     
value        =>$week, 
color        =>'328068',  
opt_name     =>'yes', 
callback     =>'no',  
);
#####____________________________________








