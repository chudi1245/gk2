#!/usr/bin/perl 
###zq 2009.08.08
use strict;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
#################################
kysy();

$f->COM ('sel_drawn', type=>"mixed", therm_analyze=>"no");
if ( get_select_count() ){
    $f->COM ('sel_contourize',
              accuracy         =>0.25, 
              break_to_islands =>'yes', 
              clean_hole_size  =>3, 
              clean_hole_mode  =>'x_and_y'); 
};



















