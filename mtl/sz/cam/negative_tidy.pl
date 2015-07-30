#!/usr/bin/perl
use strict;
use Win32;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$ref,$mw,@checkbutton_value,@layer_neg,@layer_drill,$press_count)=(0,0);
###______________________________________________
kysy();
unit_set('inch');
$ref=info("matrix","$JOB/matrix","row");
my @gROWcontext   =@{$ref->{gROWcontext}};
my @gROWside      =@{$ref->{gROWside}};
my @gROWname      =@{$ref->{gROWname}};
my @gROWtype      =@{$ref->{gROWtype}};
my @gROWpolarity  =@{$ref->{gROWpolarity}};
my @gROWlayer_type=@{$ref->{gROWlayer_type}};

foreach  (0..$#gROWname) {
	if ($gROWcontext[$_] eq 'board' and $gROWside[$_] eq 'inner' and  $gROWpolarity[$_] eq 'negative'){
		push @layer_neg,$gROWname[$_];
	}
	if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] eq 'drill')  {
		push @layer_drill,$gROWname[$_];
	}
}

$mw=MainWindow->new;   $mw->geometry("+200+100");   $mw->title("Better and better QQ_190170444");
foreach  (0..$#layer_neg) {
		$mw->Label(-text=>$layer_neg[$_],-relief=>'sunken',-width=>10)->grid(-column=>$column,-row=>$row++);
		$mw->Checkbutton(-variable=>\$checkbutton_value[$_])->grid(-column=>$column+1,-row=>$row-1);
}

$mw->Button(-text=>'Apply',-width=>8,-command=>\&apply)->grid(-column=>$column,-row=>$row,);
$mw->Button(-text=>'SW',-command=>\&sw)->grid(-column=>$column+1,-row=>$row,);
sw();
MainLoop;
###_______________________________________
sub apply{
foreach my $id (0..$#layer_neg){
	next unless $checkbutton_value[$id];
	my $new_name=$layer_neg[$id].'++tidy';
	if ( exists_entity('layer',"$JOB/$STEP/$new_name") eq 'yes' ) {
		clear($new_name);
		$f->COM ('sel_delete');
	}
	clear( $layer_neg[$id] );
    sel_copy_other( $new_name );  ##backup 
	filter( {feat_types=>'pad', polarity=>'positive',include_syms=>'r*'} );
	$f->COM ('sel_change_sym',symbol=>'r1.1',reset_angle=>'no',) if ( get_select_count() );

    foreach my $lay_drl (@layer_drill) {
	    clear($lay_drl);  
	    $f->COM ('sel_ref_feat',
		    layers       =>$layer_neg[$id],
		    use          =>'filter',
		    mode         =>'include',
		    pads_as      =>'shape',
		    f_types      =>'pad',
		    polarity     =>'positive',
		    include_syms =>'',
		    exclude_syms =>'',);
	    sel_copy_other( $layer_neg[$id], 'no' , 4 ) if ( get_select_count() );
	}

	clear( $layer_neg[$id] );
	filter( {feat_types=>'pad', polarity=>'positive',include_syms=>'r1.1;th*'} );  ###ths  i99x99   
	$f->COM ('sel_delete');
}
exit;
}#######end apply

sub sw {
	$press_count?($press_count=0):($press_count=1);
	map {$checkbutton_value[$_]=$press_count}(0..$#layer_neg);
}


