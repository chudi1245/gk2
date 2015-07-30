#!/usr/bin/perl
use strict;
use Win32;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($mw,$column,$row,@layer_name,@layer_side,@layer_row,$number_only)=(undef,0,0);
my(@button_side,@finish_cu,@checkbutton_value,@expiation_value,@layer_polarity,@button_polarity);
###_______

kysy();


unit_set('inch');
$f->COM ('close_form',job=>$JOB,form=>'eng');
unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 unless ($STEP) { p__('no step');  exit; }
	 open_step($STEP);
}
my $ref_info=info("matrix","$JOB/matrix","row");
my @gROWrow       =@{$ref_info->{gROWrow}};
my @gROWcontext   =@{$ref_info->{gROWcontext}};
my @gROWside      =@{$ref_info->{gROWside}};
my @gROWlayer_type=@{$ref_info->{gROWlayer_type}};
my @gROWname      =@{$ref_info->{gROWname}};
my @gROWtype      =@{$ref_info->{gROWtype}};
foreach  (0..$#gROWrow) {
	if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
		push @layer_name,$gROWname[$_];
		my $side=$gROWside[$_];   $side =~ s/top/out/i;   $side =~ s/bottom/out/i;
		push @layer_side, $side;
		push @layer_row, $gROWrow[$_]; 			
	}
}
###_______________________________tk
$mw=MainWindow->new;
$mw->title("Better and better");
$mw->geometry("+200+100");
foreach  ( 'Name','Side','Finish_Cu','Only_L&P','Repair',) {
	if ($_ eq 'Repair' or $_ eq 'Only_L&P') {
		$mw->Button(-text=>$_,-width=>9,-command=>[\&set_all,$_])->grid(-column=>$column++, -row=>$row,);
	}else{
		$mw->Label(-text=>$_,-width=>9,)->grid(-column=>$column++, -row=>$row,);
	}
};$row++;
foreach  (0..$#layer_name) {
	$mw->Label(-text=>$layer_name[$_],-width=>12,-relief=>'sunken')->grid(-column=>0, -row=>$row++,);
	$button_side[$_]=$mw->Button(-text=>$layer_side[$_],-width=>8,-command=>[\&chang_side,$_])->grid(-column=>1, -row=>$row-1,);
    $finish_cu[$_]=1;
	$mw->Entry(-textvariable=>\$finish_cu[$_],-width=>8)->grid(-column=>2, -row=>$row-1,);
	$mw->Checkbutton(-variable=>\$checkbutton_value[$_])->grid(-column=>3, -row=>$row-1,);
	$mw->Entry(-textvariable=>\$expiation_value[$_],-width=>8)->grid(-column=>4, -row=>$row-1,);
}
$mw->Button(-text=>'Apply',-width=>12,-command=>\&apply)->grid(-column=>4, -row=>$row,);
set_all('Repair');
MainLoop;
###________________________________sub

sub chang_side {
	my $id=shift;
	($button_side[$id]->cget(-text) eq 'out') ? ( $button_side[$id]->configure(-text=>'inner')) : ($button_side[$id]->configure(-text=>'out'));
}
sub chang_polarity {
	my $id=shift;
	($button_polarity[$id]->cget(-text) eq '+') ? ( $button_polarity[$id]->configure(-text=>'-')) : ($button_polarity[$id]->configure(-text=>'+'));
}

sub set_all {
my $id=shift;
if ($id eq 'Repair') {
	foreach  (0..$#layer_name) {
		$expiation_value[$_]=$finish_cu[$_]+0.5;
		if ( $button_side[$_]->cget(-text) eq 'inner') { $expiation_value[$_]-=0.5 };
		###the repair
	}
}elsif($id eq 'Only_L&P'){
	$number_only++;
	($number_only % 2) ? (map {$_=1} @checkbutton_value) : (map {$_=0} @checkbutton_value);
}
}

sub apply {
    foreach  (0..$#layer_name) {
	    clear($layer_name[$_]);
	    if ($checkbutton_value[$_]) { 
		    my $ref={feat_types=>'line\;pad\;arc\;text',  polarity=>'positive' };
		    filter($ref);
	    }
	    $f->COM ('sel_resize',size=>$expiation_value[$_],corner_ctl=>'no');
    };
	exit;
}




=head














