#!/usr/bin/perl 
##    zhouqing 1
##    2010.05.27
use strict;
no strict "refs";
use Genesis;
use Tk;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($rotate,$distance,$ratio_x,$ratio_y,$mw,$distance_mm)=(90,);
my $tmp_layer=$$;
###________________________________
kysy();
unit_set('inch');
if (-e "c:/tmp/scale") {
	open (FH, "c:/tmp/scale") or die $!;
    ($ratio_x,$ratio_y,$distance)=<FH>;
	chomp $ratio_x;  chomp $ratio_y;  chomp $distance;
}
$ratio_x=1.5 unless $ratio_x;
$ratio_y=1.5 unless $ratio_y;
$distance=10 unless $distance;


$mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->title("Better and better QQ_190170444");
$mw->Button(-text=>"N",-width=>4,-command=>[\&move,'n',])->grid(-column=>1, -row=>0,);
##$mw->Label(-textvariable=>\$distance_mm,-width=>4,)->grid(-column=>0, -row=>2,);
##$distance_mm=$distance/25.397*1000;
$mw->Button(-text=>"W",-width=>4,-command=>[\&move,'w',])->grid(-column=>0, -row=>1,);
$mw->Button(-text=>"S",-width=>4,-command=>[\&move,'s',])->grid(-column=>1, -row=>2,);
$mw->Button(-text=>"E",-width=>4,-command=>[\&move,'e',])->grid(-column=>2, -row=>1,);
my $engtry_distance=$mw->Entry(-width=>4,-textvariable=>\$distance)->grid(-column=>1, -row=>1);
my $entry_ratio_x  =$mw->Entry(-width=>4,-textvariable=>\$ratio_x)->grid(-column=>3, -row=>0);
my $entry_ratio_y  =$mw->Entry(-width=>4,-textvariable=>\$ratio_y)->grid(-column=>4, -row=>0);
$mw->Button(-text=>"Scale",-width=>4,-command=>[\&scale,])->grid(-column=>4, -row=>1);
$mw->Label(-text=>"-"x60,)->grid(-column=>0, -row=>3,-columnspan=>5);
$mw->Button(-text=>"M_X",-width=>4,-command=>[\&mirror,'x'])->grid(-column=>0, -row=>4);
$mw->Button(-text=>"M_Y",-width=>4,-command=>[\&mirror,'y'])->grid(-column=>1, -row=>4);
my $entry_rotate=$mw->Entry(-text=>\$rotate,-width=>4)->grid(-column=>3, -row=>4);
$mw->Button(-text=>"rotate",-width=>4,-command=>\&rotate)->grid(-column=>4, -row=>4);
$mw->Label(-text=>'-'x60,)->grid(-column=>0, -row=>5,-columnspan=>5);
$mw->Button(-text=>"OK and go on",-width=>10,-command=>sub{p__('Please select next silk')},)->grid(-column=>1, -row=>6,-columnspan=>2);
$mw->Button(-text=>"Exit",-width=>4,-command=>\&exit_this,)->grid(-column=>4, -row=>6);
###$mw->focus;
$mw->bind('<Up>'=>[\&move,'n',]);
$mw->bind('<Down>'=>[\&move,'s',]);
$mw->bind('<Left>'=>[\&move,'w',]);
$mw->bind('<Right>'=>[\&move,'e',]);
$mw->bind('<Control_R>'=>[\&rotate]);
$mw->bind('<Prior>'=>[\&scale,'big']);
$mw->bind('<Next>'=>[\&scale,'small']);
$mw->bind('<Home>'=>[\&mirror,'x']);
$mw->bind('<End>'=>[\&mirror,'y']);
$mw->bind('<Escape>'=>[\&exit_this]);
$mw->bind('<Return>'=>sub{$f->COM ('sel_clear_feat');p__('Please select next silk')});
$engtry_distance->bind('<MouseWheel>' => [\&adjust,\$distance,1]);
$entry_ratio_x ->bind('<MouseWheel>' => [\&adjust,\$ratio_x,0.1]);
$entry_ratio_y->bind('<MouseWheel>' => [\&adjust,\$ratio_y,0.1]);
$entry_rotate->bind('<MouseWheel>' => [\&adjust,\$rotate,10]);
MainLoop;
sel_options('clear_after');
$f->COM ('sel_clear_feat');
##_________________________________________________
sub exit_this {
	$f->COM ('clear_highlight');
    $f->COM ('sel_clear_feat');
	sel_options('clear_after');
	open (FH, ">c:/tmp/scale") or die $!;
	print FH "$ratio_x\n$ratio_y\n$distance";
	close FH;
	exit;
}###end exit this
sub move {
	my $id = pop;
	my ($dx,$dy);
	return unless get_select_count();
	sel_options('clear_none');
	if ($id eq 'n') {
		$dx=0;
		$dy=$distance/1000;
	}elsif($id eq 's'){
		$dx=0;
		$dy=-$distance/1000;
	}elsif($id eq 'w'){
		$dx=-$distance/1000;
		$dy=0;
	}elsif($id eq 'e'){
		$dx=$distance/1000;
		$dy=0;
	}
	sel_transform(undef,undef,$dx,$dy);
}###end move
sub  mirror {
	my $id =pop;
	return unless get_select_count();
	sel_options('clear_none');
	my $oper;
	($id eq 'x')?($oper='mirror'):($oper='y_mirror');
	sel_copy_other($tmp_layer);
	my($center_x,$center_y)=center_select();
	sel_transform($center_x,$center_y,undef,undef,undef,undef,undef,$oper);
	$f->COM ('delete_layer',layer=>$tmp_layer);

}###end mirror
sub scale{
	my $id=pop;
	return unless get_select_count();
	my ($scale_x,$scale_y);
	if ($id eq 'small') {
		$scale_x=1/$ratio_x;
		$scale_y=1/$ratio_y;
	}else{
		$scale_x=$ratio_x;
		$scale_y=$ratio_y;
	}
	sel_options('clear_none');
	my($center_x,$center_y)=center_select();
	sel_transform($center_x,$center_y,undef,undef,$scale_x,$scale_y,undef,'scale');
}###end scale
sub rotate{
	my $id=pop;
	return unless get_select_count();
	sel_options('clear_none');
	my($center_x,$center_y)=center_select();
	sel_transform($center_x,$center_y,undef,undef,undef,undef,$rotate,'rotate');
}###end rotate
sub center_select {
	$f->VOF;
	$f->COM ('delete_layer',layer=>$tmp_layer);
	$f->VON;
	sel_copy_other($tmp_layer);
	my $ref=info('layer',"$JOB/$STEP/$tmp_layer",'limits');
    my $center_x=($ref->{gLIMITSxmax}+$ref->{gLIMITSxmin})/2;
	my $center_y=($ref->{gLIMITSymax}+$ref->{gLIMITSymin})/2;
	$f->COM ('delete_layer',layer=>$tmp_layer);
	return ($center_x,$center_y);
}
sub adjust{
	my $widget=shift;
	my $value=shift;
	my $fixed=shift;
	my $event=$widget->XEvent;
	my $keysym =$event->K;
	if ($keysym eq 'F9') {
		$$value+=$fixed;
	}elsif($keysym eq '0'){
		$$value-=$fixed;	
	}
}
###______________________________________________end
=head



