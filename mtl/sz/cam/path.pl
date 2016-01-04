#!/usr/bin/perl
use strict;
use Tk;
use warnings;

use Encode;
#use encoding 'euc_cn';

use Genesis;
use Win32;
use Tk::BrowseEntry;
use Tk::Pane;
use File::Basename;


our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
#########################
kysy();

my $selectPath;
my($fname, $dir, $ext);

my $frame=MainWindow->new; 
$frame->title("import JOB"); 
$frame->geometry("+200+100"); 
#$frame->withdraw;

$frame->Label(-text=>"select File",-width=>10,)->grid(-column=>0, -row=>0);
$frame->Entry(-width => 30,-textvariable=>\$selectPath,)->grid(-column=>1, -row=>0);
$frame->Button(-text=>"Browse",-width=>15,-command=>\&getfile)->grid(-column=>2, -row=>0);

$frame->Label(-text => "job file",-width=>10)->grid(-column=>0, -row=>1);
$frame->Entry(-width => 30,-textvariable=>\$fname,)->grid(-column=>1, -row=>1);

MainLoop;

sub getfile{
 $selectPath = $frame->getOpenFile(-initialdir=>"D:/jobs",-filetypes=> [['GIF Files', '.tgz',],['All Files', '*',]] );
 ($fname, $dir, $ext)=fileparse($selectPath, '.tgz');
 $frame->Entry(-width => 40,-textvariable=>\$fname,-bg=>"cornsilk")->grid(-column=>1, -row=>1);

}