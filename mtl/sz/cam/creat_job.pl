#!/usr/bin/perl  
####
####  zq 20110113 creat a file number and open the input package a
use strict;
use Genesis;
use Win32;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###______________________________________________________
kysy();

my($work_path,$mw,$entry_fn,$job_exists,)=('D:/work');  
my ($i,) = (0,);
if (-e "c:/tmp/fn_get"){
    open(FHIN,"c:/tmp/fn_get") or die $!;
    $entry_fn=<FHIN>;
    close FHIN;
    chomp $entry_fn;
}
$entry_fn=lc $entry_fn;
###______________________________________________________
$mw = MainWindow->new;
$mw->geometry("+200+100");
$mw->title("Creat_F/N");
$mw->Label(-text=>'Creat_F/N:',)->grid(-column=>0, -row=>0,-columnspan =>3,-sticky=>"w");
$mw->Entry(-textvariable=>\$entry_fn, -width=>13)->grid(-column=>2, -row=>0,-columnspan =>4)->focus;
$mw->Button(-text=>"Del",-width=>8,-command=>sub{$entry_fn='',;})->grid(-column=>6, -row=>0,-columnspan =>3);
foreach  (qw/m s d 7 8 9 _ p/) {
	$mw->Button(-text=>"$_",-command=>[\&press_word,$_],-width=>3)->grid(-column=>$i++, -row=>1);
};$i=0;
foreach  (qw/ 0 1 2 3 4 5 6 -/) {
	$mw->Button(-text=>"$_",-command=>[\&press_word,$_],-width=>3)->grid(-column=>$i++, -row=>2);
}
$mw->Button(-text=>"OK",-width=>13,-command=>\&creat_fn)->grid(-column=>5, -row=>3,-columnspan =>5);
$mw->Label(-text=>'====mtl====',-width=>32,-height=>2,-relief => 'groove')->grid(-column=>0, -row=>6,-columnspan =>7);
MainLoop;
###____________________________________________________
sub press_word {
        my $word = shift; 
        $entry_fn .= $word;
}
sub creat_fn{
    my $job_exists=exists_job($entry_fn);
    if  ($job_exists eq "yes") {
        p__("the $entry_fn already exists!");
	    exit;
	}else{		
		creat_job($entry_fn);
        open_job($entry_fn);
		$f->COM('create_entity',job=>$entry_fn,is_fw=>'no',type=>'step',name=>'orig',db=>'genesis',fw_type=>'form');
		###$f->COM('create_entity',job=>$entry_fn,is_fw=>'no',type=>'step',name=>'pcb',db=>'genesis',fw_type=>'form');
		###$f->COM('create_entity',job=>$entry_fn,is_fw=>'no',type=>'step',name=>'pnl',db=>'genesis',fw_type=>'form');
		###$f->COM('copy_form',src_job=>'genesislib',src_form=>'eng',dst_job=>$entry_fn,dst_form=>'eng');		
		###$f->COM('save_job',job=>$entry_fn);
        if (-e "$work_path/input") {
			 $f->COM('input_show_page'); 
             $f->COM ('input_set_params',path=>"$work_path/input",job=>$entry_fn,step=>'orig',exclude=>'*tar;*zip;*tgz;*exe;*gz;*.pdf'); 
			 ###record the filen umber for the after script 
			 open (FH,">D:/work/FN.log") or die "$!";
			 print FH "FN $entry_fn creat ok";
			 close FH;
             
		}
	}
	exit;
}


###end














