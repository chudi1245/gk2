#!/usr/bin/perl
use strict;
use warnings;
use Genesis;

use FBI;
#use Win32;
#use Win32::API;

use Encode;
use encoding 'euc_cn';


our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

$f->INFO(	units => 'mm',
			entity_type => 'layer',
			entity_path => "$JOB/pcb/$cen");

@orig_size  = @{$f->{doinfo}{gTOOLdrill_size}};
@orig_count = @{$f->{doinfo}{gTOOLcount}};
my (%orig_info);
foreach  (0..$#orig_size) {
		
		$orig_info{$orig_size[$_]} = $orig_count[$_];
}
@orig_size = sort{$a<=>$b} @orig_size;









=head

$text = "T01C003175\\18";
$text =~ s/[\\\/c]/ /ig;   
my @word=split m{ },$text;
$word[1]/=1000;
print "$text\n";
print "$word[1]\n";

$str = "r808";
$a = substr $str, 1, 4;                # 由第一個字元開始截取 5 個字元長度
print $a;                               # 得：ABCDE