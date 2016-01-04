#!/usr/bin/perl 
#!/usr/bin/perl 
##    zhouqing 
##    2010.06.04
use strict;
use Tk;
use POSIX qw/strftime/;
use FileHandle;
use Genesis;
use lib "D:/xxx/camp/lib";
our $host  = shift;
our $f     = new Genesis($host);
our $JOB   = $ENV{JOB};
our $STEP  = $ENV{STEP};
my $name_forms='eng';
use FBI;
##
kysy();
my @year=gmtime;
unless (-e "C:\genesis\fw\jobs\$JOB\forms\$name_forms") {
  $f->COM ('copy_form',
	       src_job    =>'genesislib',
	       src_form   =>$name_forms,
	       dst_job    =>$JOB,
	       dst_form   =>$name_forms);
}
$f->COM ('show_form',
         job         =>$JOB,
         form        =>$name_forms,
         updonly     =>'No',
         updelem     =>'');
###
$f->COM( 'edit_form',
job          =>$JOB,     
form         =>$name_forms,        
elem         =>'E102',     
value        =>$STEP, 
color        =>'328068',  
opt_name     =>'yes', 
callback     =>'no',  
);

my $week=strftime "%W", localtime;
$f->COM( 'edit_form',
job          =>$JOB,     
form         =>$name_forms,        
elem         =>'E101',     
value        =>$week, 
color        =>'328068',  
opt_name     =>'yes', 
callback     =>'no',  
);
#####____________________________________








