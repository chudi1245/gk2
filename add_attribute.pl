#!/usr/bin/perl
##
## zq 20110113 add drill attribute
use strict;
use Tk;
use Genesis;
use C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###________________________________
my @attribute=('non_plated', 'plated', 'via');
kysy();
my $mw = MainWindow->new;
$mw->title("Better and better QQ_190170444");
$mw->geometry("+200+100");
$mw->title("trand_drill_attribute");
my $i=0;
foreach  (@attribute) {
    $mw->Button(-text=>$_,-width=>10,-command=>[\&add_attribute,$_])->grid(-column=>0, -row=>$i++);
}
$mw->Label(-text=>"----------------",)->grid(-column=>0, -row=>$i++);
$mw->Button(-text=>'EXIT',-width=>10,-command=>sub{exit;})->grid(-column=>0, -row=>$i++);
MainLoop;

sub add_attribute  {
	my $attribute=shift;
	my $count=&get_select_count;
	if ($count != 0) {
	    $f->COM ('cur_atr_reset');
        $f->COM ('cur_atr_set',attribute=>'.drill',option=>$attribute);
        $f->COM ('sel_change_atr',mode=>'add');
		exit;
	}else{
		p__('select count is 0,exit');
		exit;
	}
}


###end



