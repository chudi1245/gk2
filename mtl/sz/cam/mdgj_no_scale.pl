#! /usr/bin/perl
use strict;
use Win32;
use Tk;
use Tk::Pane;
use Genesis;
use FBI;
use Encode;
use Encode::CN;


our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________________
kysy();
unit_set('inch');

my (@gROWname,@gROWlayer_type,@gROWcontext,@gROWside,);

@gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
@gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
@gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
@gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};

my (@inner,@checkbutton_value);

foreach  (0..$#gROWname) {
	if ($gROWcontext[$_] eq 'board' and $gROWside[$_] eq 'inner' ){
		push @inner,$gROWname[$_];
	}
}

my $mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->title("Better and better");

my $row=0;

foreach  (0..$#inner) {
$mw->Label(-text=>$inner[$_],-relief=>'sunken',-font => [-family=>'黑体',-size=>14],-width=>14)->grid(-column=>0,-row=>++$row);
$mw->Checkbutton(-variable=>\$checkbutton_value[$_],-width=>8)->grid(-column=>1,-row=>$row);
}

$mw->Button(-text=>'Apply',-width=>8,-command=>\&apply,-font => [-family=>'黑体',-size=>14],-width=>8)->grid(-column=>1,-row=>$row+1,);
  
MainLoop;

sub apply{

foreach my $id (0..$#inner){
if ($checkbutton_value[$id]==1) {
	clear($inner[$id]);
	$f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=md\;gj");
	$f->COM("filter_area_strt");
	$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
	$f->COM("filter_reset,filter_name=popup");
	$f->COM("sel_change_atr,mode=replace");
	}
    }
    clear();
	exit;
}


=h
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
check_error();

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

1 检查层是否含有叠层  负片

2 正负专换
      根据虚拟框创建铜皮
	  叠加，移动曾

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



























