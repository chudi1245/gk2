#! /usr/bin/perl

print "$ENV{USERNAME}\n";

if ($ENV{USERNAME} =~ m/eng|tor/i) {
	print "ok\n";
}


#print $ENV{USERDNSDOMAIN};

=head
use strict;
use encoding "utf8";
use Win32;
use Tk::Pane;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my $x;
foreach  (0..198) {
	$x.='a';
}


add_text($x,'no',0,0,0);



COM open_entity,job=tn,type=step,name=tn,iconic=no 
COM open_entity,job=tn,type=step,name=lcl,iconic=no
COM display_layer,name=test,display=yes 
COM work_layer,name=test 
COM add_pad,symbol=r50,x=5,y=5 

my $use_name='mzb';

my $login_name=$use_name.'_mtl';


print $login_name;





























