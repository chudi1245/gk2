#! /usr/bin/perl
##   zq
##   2010.02.12
use strict;
use Win32;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$unit_use,$mw,)=(0,0,'Inch');
my(@gTOOLnum,@gTOOLtype,@gTOOLfinish_size,@gTOOLdrill_size,@finish_mm,@tooldrill_display);
###________________________
kysy();
my $ref=info('layer',"$JOB/$STEP/drl");
@gTOOLnum=@{$ref->{gTOOLnum}};
@gTOOLtype=@{$ref->{gTOOLtype}};
@gTOOLfinish_size=@{$ref->{gTOOLfinish_size}};
@gTOOLdrill_size=@{$ref->{gTOOLdrill_size}};
###______________________
$mw=MainWindow->new();
$mw->title("Better and better");
$mw->geometry("+200+100");

my @head_word=qw(Tool Type Finish_INCH Finish_MM ToolDrill);
foreach  (@head_word) {
	$mw->Label(-text=>$_,)->grid(-column=>$column++,-row=>$row);
}


foreach  (0..$#gTOOLnum) {
	$mw->Label(-text=>"T$gTOOLnum[$_]",-width=>8,-relief=>'sun')->grid(-column=>0,-row=>$_+1);
	$mw->Label(-text=>$gTOOLtype[$_],-width=>10,-relief=>'sun')->grid(-column=>1,-row=>$_+1);
	$mw->Label(-text=>$gTOOLfinish_size[$_],-width=>10,-relief=>'sun')->grid(-column=>2,-row=>$_+1);
	$finish_mm[$_]=$gTOOLfinish_size[$_]*25.397/1000;
	$finish_mm[$_]=round($finish_mm[$_],4);
    $mw->Label(-text=>$finish_mm[$_],-width=>6,-relief=>'sun')->grid(-column=>3,-row=>$_+1);


	$mw->Entry(-textvariable=>\$tooldrill_display[$_],)->grid(-column=>4,-row=>$_+1);
	($_ > $row-2) && ($row=$_+2);
}
$mw->Label(-text=>'Paramters',-width=>8,)->grid(-column=>0,-row=>$row++);
$mw->Button(-text=>'Hasl',-width=>8,)->grid(-column=>0,-row=>$row++);
$mw->Button(-text=>'Imm_au',-width=>8,)->grid(-column=>0,-row=>$row++);
$mw->Button(-text=>'Apply',-width=>12,)->grid(-column=>3,-row=>$row);
MainLoop;




sub hasl {

}

sub imm_au {

}

