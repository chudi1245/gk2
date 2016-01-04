#!/usr/bin/perl
use strict;
use Tk;
use Win32;
use File::Copy::Recursive;
use File::Path; 

my $path="d:/work";
my $fix=gmtime();
$fix =~ s/[ :]//g;

kysy();

if (-d $path){ 
	File::Copy::Recursive::dirmove($path, "c:/tmp/work.$fix") or dis_erro($!);
}

mkpath("$path/input") or dis_erro($!);
mkpath("$path/output/K_file" ) or dis_erro($!);
mkpath("$path/output/D_file" ) or dis_erro($!);
mkpath("$path/output/M_file" ) or dis_erro($!);
mkpath("$path/output/T" ) or dis_erro($!);
mkpath("$path/output/B" ) or dis_erro($!);
mkpath("$path/output/ps" ) or dis_erro($!);
mkpath("$path/pcb" ) or dis_erro($!);

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










