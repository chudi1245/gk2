#!/usr/bin/perl
use strict;
use Tk;
use File::Copy::Recursive;
use POSIX qw/strftime/;

my $year  =strftime "%Y", localtime;
my $moth  =strftime "%m", localtime;
my $day   =strftime "%d", localtime;
my $hour  =strftime "%H", localtime;
my $minute=strftime "%M", localtime;
my $sec   =strftime "%S", localtime;
my $fix=$year.$moth.$day.$hour.$minute.$sec;

if (-d "d:/work"){ 
	File::Copy::Recursive::dirmove("d:/work", "c:/tmp/work.$fix") or dis_erro($!) ;
}
unless (-d "d:/work") {
	mkdir "d:/work" 
	and mkdir "d:/work/input"
	and mkdir "d:/work/output"
	and mkdir "d:/work/output/K_file"
	and mkdir "d:/work/output/D_file"
	and mkdir "d:/work/output/M_file"
	and mkdir "d:/work/output/T"
	and mkdir "d:/work/output/B";
}
sub dis_erro{
	my $message=shift;
	my $mw=MainWindow->new(-width=>100,);
	$mw->title("Better and better");
	$mw->Label(-text=>$message,-width=>30)->pack;
    $mw->geometry("+200+100");
	MainLoop;
	exit;
}




=head

use Cwd;
chdir "d:/work";
if ( getcwd() eq 'd:/work') {
	`rm -rf *`; ##del all file and filedir
	mkdir 'input' or die $!;
	mkdir 'output' or die $!;


	 
}










