#!/usr/bin/perl 
###zq 2009.08.12
##_________________________________________
use strict;
use Tk;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my (@re_row,@name);
###________________________________________
kysy();

@re_row = reverse @{info("matrix","$JOB/matrix","row")->{gROWrow}};
@name=@{info("matrix","$JOB/matrix","row")->{gROWname}};
###________________________________________
clear();
foreach (@re_row) {
    delete_row($_) if (  ($name[$_-1] =~ /orig/) or ($name[$_-1] =~ /\+/) or ($name[$_-1] =~ /org/)  )
}  
$f->COM ('matrix_refresh',job=>$JOB,matrix=>"matrix");
undef @name;
undef @re_row;
@name=@{info("matrix","$JOB/matrix","row")->{gROWname}};

foreach (@name){
     copy_layer($_) if $_;
}
$f->COM ('matrix_refresh',job=>$JOB,matrix=>"matrix");
clear('drl','drl++orig');









































            

                     
                                  
               








  



