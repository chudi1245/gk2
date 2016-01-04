#!/usr/bin/perl 
###zq 2011.05.16
##_________________________________________
use strict;
use Tk;
use Genesis;
use FBI;
use Win32;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###________________________
kysy();
my ($column,$row,@layer_neg,@checkbutton_value,$press_count,)=(0,0);
my $ref=info("matrix","$JOB/matrix","row");
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
}

###__________________tk
my $mw=MainWindow->new;   $mw->geometry("+200+100");   $mw->title("Better and better QQ_190170444");
foreach  (0..$#layer_neg) {
		$mw->Label(-text=>$layer_neg[$_],-relief=>'sunken',-width=>10)->grid(-column=>$column,-row=>$row++);
		$mw->Checkbutton(-variable=>\$checkbutton_value[$_])->grid(-column=>$column+1,-row=>$row-1);
}
$mw->Button(-text=>'Apply',-width=>8,-command=>\&apply)->grid(-column=>$column,-row=>$row,);
$mw->Button(-text=>'SW',-command=>\&sw)->grid(-column=>$column+1,-row=>$row,);
sw();
MainLoop;

###_________________
sub sw {
	$press_count?($press_count=0):($press_count=1);
	map {$checkbutton_value[$_]=$press_count}(0..$#layer_neg);
}

sub apply {

##check_error();

foreach my $id (0..$#layer_neg){
	next unless $checkbutton_value[$id];
	my $layer_bak=$layer_neg[$id].'++p_n';
	if ( exists_entity('layer',"$JOB/$STEP/$layer_bak") eq 'yes' ) {
		clear($layer_bak);
		$f->COM ('sel_delete');
	}

	clear( $layer_neg[$id] );
    sel_copy_other( $layer_bak );  ##backup 

	creat_clear_layer('tmp');
	$f->COM ('profile_to_rout',layer=>'tmp',width=>1.1);
    $f->COM ('sel_cut_data',
		det_tol              =>1,
		con_tol              =>1,
		rad_tol              =>0.1,
		filter_overlaps      =>'no',
		delete_doubles       =>'no',
		use_order            =>'yes',
		ignore_width         =>'yes',
		ignore_holes         =>'none',
		start_positive       =>'yes',
		polarity_of_touching =>'same');
	clear($layer_neg[$id]);
	sel_move_other('tmp','yes');
	copy_layer('tmp',$layer_neg[$id],$STEP,);
}
exit;
}

sub check_error {
foreach my $id (0..$#layer_neg){
	next unless $checkbutton_value[$id];
	clear($layer_neg[$id]);
	filter( { polarity=>'negative' } );
	if ( get_select_count() ) {
		clear();
		p__( "$layer_neg[$id] exists negative feature, exit");  
		exit;
	};
}
}


=head
filter

1 �����Ƿ��е���  ��Ƭ

2 ����ר��
      ��������򴴽�ͭƤ
	  ���ӣ��ƶ���

3

	filter( { polarity=>'negative' } );
	if ( get_select_count() ) { p__( "$layer_neg[$id] exists negative feature, exit");  exit  };


COM filter_reset,filter_name=popup
COM filter_set,filter_name=popup,update_popup=no,polarity=negative
COM filter_area_strt
COM filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0

	creat_clear_layer('tmp');
	$f->COM ('profile_to_rout',layer=>'tmp',width=>1.1);

	##p__(2);
	$f->COM ('sel_cut_data',
		det_tol              =>1,
		con_tol              =>1,
		rad_tol              =>0.1,
		filter_overlaps      =>'no',
		delete_doubles       =>'no',
		use_order            =>'yes',
		ignore_width         =>'yes',
		ignore_holes         =>'none',
		start_positive       =>'yes',
		polarity_of_touching =>'same');
	clear($layer_neg[$id]);
	##$f->COM ('sel_move_other',target_layer=tmp,invert=yes,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none);
	sel_move_other('tmp','yes');
