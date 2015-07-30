#!/usr/bin/perl
use strict;
use Win32;
use File::Copy::Recursive;
use File::Path; 

kysy();

my $path="d:/work";
my $fix=gmtime();
$fix =~ s/[ :]//g;

if (-d $path){ 
	File::Copy::Recursive::dirmove($path, "c:/tmp/work.$fix") or dis_erro($!);
}

mkpath("$path/input") or dis_erro($!);
mkpath("$path/gerber" ) or dis_erro($!);
sub dis_erro{
	my $message=shift;
	my $mw=MainWindow->new(-width=>100,);
	$mw->title("Better and better");
	$mw->Label(-text=>$message,-width=>30)->pack;
    $mw->geometry("+200+100");
	MainLoop;
	exit;
}













