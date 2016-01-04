#!/usr/bin/perl -w
use Genesis;
use strict;
use Tk;
use warnings;

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

#my $group = $f->{COMANS};
#$f->COM("set_group,group=$group");
kysy();

$f->COM("get_select_count");
my $select_yes_no=$f->{COMANS};

if($select_yes_no eq "0"){
	$f->PAUSE("Please select some drill");
	exit;
  }else{
	$f->COM("cur_atr_set,attribute=.drill,option=plated");
	$f->COM("sel_change_atr,mode=replace");
	}


##option=   non_plated   plated    via