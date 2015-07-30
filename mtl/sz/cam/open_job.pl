#!/usr/bin/perl  
## zq 2011.01.14 open a job and del the _desktop file
use strict;
use File::Find;
use Win32;
require Tk::BrowseEntry;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($info,$mw,$fn,@job_list,$GENESIS_DIR,)=('=====');
##____________________________________
kysy();
$f->INFO(entity_type => 'root');
@job_list= @{$f->{doinfo}{gJOBS_LIST}};
###________________________________________
$mw = MainWindow->new(-title=>"OPEN-JOB");
$mw->geometry("+150+100");
$mw->BrowseEntry(-textvariable=>\$fn,-label=>"F/N:",-choices=>\@job_list,)
   ->grid(-column=>1,-row=>0,-columnspan =>4,)->focus;
$mw->Button(-text=>"OPEN",-width=>5,-command=>\&open_fn,)
   ->grid(-column=>5, -row=>0,-columnspan =>2);
$mw->Label(-textvariable=>\$info,)->grid(-column=>0, -row=>1,-columnspan =>5);


MainLoop;
###_____________
sub open_fn {
	find(\&del_desktop,"$GENESIS_DIR/fw/jobs/$fn" );
	my $flag=exists_entity('job',$fn);
	if ($flag eq 'yes') {
    	open_job($fn);	
    	exit;
	}else{
		$info='JOB not exists';
		return;
	}
}

sub del_desktop{
		if ($_ =~ m/^_desktop\.ini$/) {	unlink "$File::Find::dir/$_"; }
}


=head
##
$x='d1cd23//\555';

if ($x =~ m/[msd]\d{3,5}$/i    ) {
	print "ok";
}
print "$x\n";
$x =~ s/[cd\\\/]//gi ;

print "$x";










