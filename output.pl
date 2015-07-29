#! /usr/bin/perl
use strict;
use Tk;
use Tk::Pane;
use Genesis;
use Encode;
use Encode::CN;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________________
kysy();
unit_set('inch');
my (@gROWrow,@gROWside,@gROWcontext,@gROWlayer_type,@gROWname,@gROWtype,@prof_limits,%prof_center);
my ($flage_tgz,$out_path,$mw,$encode,$tgz_info)=(1,);
my (%mirror,%button_mirror,%checkbutton_out,%checkbutton_value,%entry_scale_x,%entry_scale_y,%scale_x,%scale_y,%label_info,%out_info);
my ($column, $row,$number_set_all)=(0,0,0);
@gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
@gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
@gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
@gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};

@prof_limits=prof_limits($STEP);
$prof_center{x}=($prof_limits[2]+$prof_limits[0])/2;
$prof_center{y}=($prof_limits[3]+$prof_limits[1])/2;

###______________________
my $franm=MainWindow->new;

$franm->title("Better and better");
$franm->geometry("+200+100");
$mw=$franm->Scrolled("Frame", -scrollbars => 'w',-height=>600 )->pack();

my @head_text=('layer','out','mirror','%%-x','%%-y');
foreach  (@head_text) {   $mw->Button(-text=>$_,-width=>5,-command=>[\&set_all,$_])->grid(-column=>$column++, -row=>$row,)   };
$mw->Button(-text=>'Path',-width=>4,-command=>\&choose_path,)->grid(-column=>++$column,-row=>$row,);
unless ($encode) {$encode="D:/work/output/"};
unless ($out_path) {$out_path="D:/work/output/"};

$mw->Label(-textvariable=>\$encode,-width=>16,-relief=>'groove')->grid(-column=>++$column, -row=>$row,);
foreach  (0..@gROWname) {
	if ($gROWname[$_] ){
	    $mw->Label(-text=>$gROWname[$_],-width=>20,-anchor=>'c')->grid(-column=>0, -row=>++$row,);
	    $checkbutton_out{$_}=$mw->Checkbutton(-variable=>\$checkbutton_value{$_})->grid(-column=>1, -row=>$row,);
	    $button_mirror{$_}=$mw->Button(-text=>"---",-command=>[\&set_mirror,$_],-width=>4,)->grid(-column=>2, -row=>$row,);
		$entry_scale_x{$_}=$mw->Entry(-textvariable=>\$scale_x{$_},-width=>7,)->grid(-column=>3, -row=>$row,);
		$entry_scale_y{$_}=$mw->Entry(-textvariable=>\$scale_y{$_},-width=>7,)->grid(-column=>4, -row=>$row,);
		if ($gROWside[$_] eq 'inner') {
			$entry_scale_x{$_}->configure(-background=>'green');
			$entry_scale_y{$_}->configure(-background=>'green');
		}
		$out_info{$_}='-'x20;
		$label_info{$_}=$mw->Label(-textvariable=>\$out_info{$_},-width=>22,-anchor=>'w')->grid(-column=>5,-columnspan=>5, -row=>$row,);
	}
}

$tgz_info='-'x20;
$mw->Label(-textvariable =>\$tgz_info,-width=>22,-anchor=>'w')->grid(-column=>5,-columnspan=>5, -row=>++$row,);
$franm->Button(-text=>"Set Ref",-command=>\&set_ref,-width=>6,)->pack(-side => 'left',);
$franm->Button(-text=>"Defualt",-command=>\&default,-width=>8,)->pack(-side => 'left');
$franm->Button(-text=>"Brush",-command=>\&brush,-width=>8,)->pack(-side => 'left');
$franm->Checkbutton(-text=>" => TGZ",-variable =>\$flage_tgz,)->pack(-side => 'left');
$franm->Button(-text=>"OK OUTPUT",-command=>\&out_put,-width=>15,)->pack(-side => 'left');
$franm->Button(-text=>"EXIT",-command=>sub{exit})->pack(-side =>'right'); 

brush();
MainLoop;
###________________________________________________
#sub set_mirror{
#	my $id=shift;
#	($button_mirror{$id}->cget(-text)  eq  '---' ) ? ( $button_mirror{$id}->configure(-text=>'M') ) : ( $button_mirror{$id}->configure(-text=>'---') ) ;
#
#}
sub set_all {
	my $id=shift;
	my $value;
	if ($id eq 'out') {
		(++$number_set_all % 2)?($value=1):($value=0);
		foreach  (keys %checkbutton_value) {   $checkbutton_value{$_}=$value;	}
	}elsif ($id eq 'mirror'){
		foreach  (keys %button_mirror) {  $button_mirror{$_}->configure(-text=>"---");  }
	}elsif ($id eq '%%-x'){
		foreach  (keys %scale_x) {  $scale_x{$_}='';  }
	}elsif ($id eq '%%-y'){
		foreach  (keys %scale_y) {  $scale_y{$_}='';  }
	}
}###________________________________________________________end set all
sub out_put {
	my ($mirror,$x,$y);
	foreach  (keys %checkbutton_value) {
		if ($checkbutton_value{$_}) {
			$mirror=$button_mirror{$_}->cget(-text);
			($mirror eq 'M')?($mirror='yes'):($mirror='no'); 
			$scale_x{$_} ? ($x=1+$scale_x{$_}/10000) : ($x=1);
			$scale_y{$_} ? ($y=1+$scale_y{$_}/10000) : ($y=1);
		    output_layer($gROWname[$_],$out_path,$mirror,$x,$y,$prof_center{x},$prof_center{y});
			$out_info{$_}="$gROWname[$_] $mirror $x $y $encode";
			$mw->update();
		}
	}
	if ($flage_tgz){
		export_job($JOB,$out_path);
		$tgz_info="$JOB.TGZ export to $encode";
		$mw->update();
	}
	sleep 1;
	exit;
}###___________________________________________________________end output
sub set_ref{
	my $print_silk_layer='gtl gbl gto gbo ref_t ref_b ref-t ref-b';
    foreach  (keys %checkbutton_value) {
		$scale_x{$_}='';
		$scale_y{$_}='';
		if ($print_silk_layer =~ m/$gROWname[$_]/){
			$checkbutton_value{$_}=1;
			###($gROWname[$_] =~ m/.+[Bb]/)?($button_mirror{$_}->configure(-text=>"M")):($button_mirror{$_}->configure(-text=>"---"));
		}else{
			$checkbutton_value{$_}=0;
			###$button_mirror{$_}->configure(-text=>"---");
		}
	}
}####___________________________________________________________end set_ref

sub default {
foreach  (0..@gROWname) {
if ($gROWname[$_] ){
	$scale_x{$_}='';
	$scale_y{$_}='';
	if (  $gROWlayer_type[$_] ne 'solder_paste' and  $gROWlayer_type[$_] ne 'document'   ###$gROWlayer_type[$_] ne 'drill' and
	     and $gROWcontext[$_] eq 'board'  or $gROWname[$_] =~ m{cy} ) {
		$checkbutton_value{$_}=1;
		###($gROWname[$_] =~ m/.+[Bb]/)?($button_mirror{$_}->configure(-text=>"M")):($button_mirror{$_}->configure(-text=>"---"));
	}else{
		$checkbutton_value{$_}=0;
		###$button_mirror{$_}->configure(-text=>"---");
	}

}
}
}###____________________________________________________________###ebd default
sub choose_path {
	$out_path=$mw->chooseDirectory(-initialdir => "D:/work/output/");
	$encode=decode("gbk",odd_decode($out_path)); 
	unless ($encode) {$encode="D:/work/output/"};
    unless ($out_path) {$out_path="D:/work/output/"}
}

sub adjust {
	my $widget=shift;
	my $value=shift;
	my $event=$widget->XEvent;
	my $keysym =$event->K;
	if ($keysym eq 'F9') {
		$$value++;
	}elsif($keysym eq '0'){
		$$value-- if  $$value>0;	
	}
}

sub brush {
foreach  (0..@gROWname) {
    if ($gROWname[$_] ){
	    $scale_x{$_}='';
	    $scale_y{$_}='';
        $button_mirror{$_}->configure(-text=>"---");
        $checkbutton_value{$_}=0;
	}
}
}

1;
=head








