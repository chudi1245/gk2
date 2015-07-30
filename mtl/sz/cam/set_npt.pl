#!/usr/bin/perl -w
use Genesis;
use strict;
use warnings;

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

#my $group = $f->{COMANS};
#$f->COM("set_group,group=$group");

$f->COM("get_select_count");
my $select_yes_no=$f->{COMANS};

if($select_yes_no eq "0"){
	$f->PAUSE("Please select some drill");
	exit;
  }else{
	$f->COM("cur_atr_set,attribute=.drill,option=non_plated");
	$f->COM("sel_change_atr,mode=replace");
	}


##option=   non_plated   plated    via