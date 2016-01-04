#!/usr/bin/perl
## Author: melody
## Email: 190170444@qq.com
## Date:  2011.10.11
## Phone: 13424338595
## Describe: transit genesis cmd line  Cshell to perl
##_________________________________
use strict;
use Tk;
use Win32;

kysy();

my $mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->title("Cshell to perl");
my $t1=$mw->Text(-height=>10)->pack;
my $bt=$mw->Button(-text=>'Cshell Transition To Perl',-command=>\&transition)->pack;
my $t2=$mw->Text(-height=>35)->pack;

MainLoop;

sub transition{
	$t2->delete(0.1,'end');
	my $txt=$t1->get(0.1,'end');
	my @lines=split m/\n/,$txt;
	my $balnks=" "x9;
	foreach  (@lines) {
		my $line=$_;
		$line =~ s{^(COM\s+)(\w+)(.*)}{\$f->$1\(\'$2\'$3\)\;};
		$line =~ s{(\b\w+)(=)([\w\d\.]+\b|)(\,?)}{\n$balnks$1$2\>\'$3\'$4}g;
		$t2->insert('end',$line);
		$t2->insert('end',"\n\n");
	}
}



=head
sub transition{
	$t2->delete(0.1,'end');
	my $txt=$t1->get(0.1,'end');




	$txt =~ s{^(COM\s+)(\w+)(.*)}{\$f->$1\(\'$2\'$3\)\;};
	$txt =~ s{(\b\w+)(=)(.+?\b)(\s*\,)}{\n    \'$1\'$2\>$3$4}g;
	$txt =~ s{(\b\w+)(=)(.+?\b)}{\n    \'$1\'$2\>$3};
	$t2->insert('end',$txt);
}







