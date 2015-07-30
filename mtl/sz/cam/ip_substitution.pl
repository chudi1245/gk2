#!/usr/bin/perl

## Author: melody
## Email: 190170444@qq.com
## Date:  2011.11.15
## Phone: 13424338595
## Describe: 
##_________________________________
use strict;
my $line=qx{netsh -c interface ip dump};
my $origin='255';
my $subst='254';
$line =~ s!(\d{1,3})(\.)(\d{1,3})(\.)($origin)(\.)(\d{1,3})!$1$2$3$4$subst$6$7!g;
open (WW, "| netsh ");
print WW "$line";
=head

#my $tmp_file="c:/$$.txt";
#open (FH,'>',$tmp_file) or die $!;
#print FH $line;
=head
close FH;
my $result=qx(netsh -f $tmp_file);
print $result;
unlink $tmp_file or die $@;
#open(PIP, ">  |   netsh -f");
#print PIP $line;





##open £¨PIP , ">" , "xxx.txt");
#print PIP $line;|netsh -f



##print $line;


###open£¨PIP£¬ ">" , "| netsh -f");


=head
foreach  (@lines) {
	$_ =~ s!(\d{1,3})(\.)(\d{1,3})(\.)($origin)(\.)(\d{1,3})!$1$2$3$4$subst$6$7!;
}













=head
my $file="c:/ip.txt";

print qx{netsh -c interface ip dump >  $file};


open (FH,  'c:/ip.txt') or die$!;
my @lines=<FH>;
close FH;

my $origin='255';
my $subst='254';

open (FH_w, '>', 'c:/ip.txt') or die$!;
foreach  (@lines) {
	$_ =~ s!(\d{1,3})(\.)(\d{1,3})(\.)($origin)(\.)(\d{1,3})!$1$2$3$4$subst$6$7!;
	print FH_w $_;
}
close FH;







=head

netsh -c interface ip dump >c:\ip.txt



netsh -f c:\ip.txt
delete c:\ip.txt /y



