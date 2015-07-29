#! /usr/bin/perl
##   zq
##   2010.12.30
use strict;
use Tk;
use Genesis;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$mw,%vcut,%b_edge,%c_depth,%page)=(0,0);
###3.463,4.682 the dd symbol cordiction
###__________________________________
kysy();
unit_set('inch');
$mw=MainWindow->new();
$mw->title("Better and better QQ_190170444");
$mw->geometry("+200+100");
my @vcut_title=qw(Vcut_Number  Angle  Finish_thick Residual_thick  Windage );
foreach  (@vcut_title) {
	$mw->Label(-text=>$_,-width=>12,-relief=>'sunken')->grid(-column=>$column,-row=>$row++);
	$mw->Entry(-width=>10,-textvariable=>\$vcut{$_})->grid(-column=>$column+1,-row=>$row-1);
}; 
$mw->Label(-text=>'B_edge_height',-width=>12,-relief=>'sunken')->grid(-column=>$column+2,-row=>0);
$mw->Entry(-width=>5,-textvariable=>\$b_edge{height})->grid(-column=>$column+3,-row=>0);
$mw->Label(-text=>'Angle',-width=>12,-relief=>'sunken')->grid(-column=>$column+2,-row=>1);
$mw->Entry(-width=>5,-textvariable=>\$b_edge{width})->grid(-column=>$column+3,-row=>1);
my @Control_depth_title=qw(Angle  Control_depth  Board_thick Width_out Width_inner Side_upturned );
foreach  (0..$#Control_depth_title) {
	if ($Control_depth_title[$_] ne 'Side_upturned') {
	    $mw->Label(-text=>$Control_depth_title[$_],-width=>12,-relief=>'sunken')->grid(-column=>$column+4,-row=>$_);
	    $mw->Entry(-width=>5,-textvariable=>\$c_depth{$Control_depth_title[$_]})->grid(-column=>$column+5,-row=>$_);
	}else{
		$mw->Label(-text=>$Control_depth_title[$_],-width=>12,-relief=>'sunken')->grid(-column=>$column+4,-row=>$_);
		$mw->Optionmenu(-options=>[('','Top','Bot')],-width=>2,-textvariable=>\$c_depth{$Control_depth_title[$_]})->grid(-column=>$column+5,-row=>$_);
	}
}; 
$mw->Label(-text=>'='x80,-width=>50,)->grid(-column=>0,-row=>++$row,-columnspan=>6);
$mw->Label(-text=>'The',-width=>8,)->grid(-column=>0,-row=>++$row,);
$page{the}=4;
$mw->Entry(-width=>5,-textvariable=>\$page{the})->grid(-column=>1,-row=>$row,);
$mw->Label(-text=>'page of all',-width=>8,)->grid(-column=>2,-row=>$row,);
$mw->Entry(-width=>5,-textvariable=>\$page{all},-background => 'green')->grid(-column=>3,-row=>$row,);
$mw->Label(-text=>'Page',-width=>8,)->grid(-column=>4,-row=>$row,);
$mw->Button(-text=>'Apply',-width=>8,-command=>\&apply)->grid(-column=>$column+5,-row=>++$row,);
MainLoop;

sub apply {
$f->COM ('cre_drills_map',
    layer=>'drl',
	map_layer=>'tmp',
	preserve_attr=>'yes',
	draw_origin=>'no',
	units=>'mm',
	mark_dim=>'50');
clear('box');
sel_copy_other('tmp');
$f->VOF;
$f->COM ('create_layer',layer=>'dd_map',context=>'misc',type=>'signal',polarity=>'positive',ins_layer =>'tmp');
clear('dd_map');
$f->COM ('sel_delete');
$f->VON;

add_pad(3.463,4.682,'dd');
add_if_text( uc($JOB), 0.611,4.997);
add_if_text( $vcut{Vcut_Number}, -2.40,  4.427 );
add_if_text( $vcut{Angle}, -3.055, 4.206 );
add_if_text( $vcut{Finish_thick}, -2.008, 3.894 );
add_if_text( $vcut{Residual_thick}, -2.782, 3.930,0.06,0.1 );
my $vcut_depth=( $vcut{Finish_thick}-$vcut{Residual_thick} )/2;
add_if_text( $vcut_depth, -2.481, 3.446 );
add_if_text( $vcut{Windage}, -3.463, 3.859 );
add_if_text( $b_edge{height}, -0.104, 3.631   );
add_if_text( $b_edge{width},  -0.805, 3.521   );
add_if_text( $c_depth{Angle},2.760, 4.733);
add_if_text( $c_depth{Control_depth}, 1.786, 4.446);
add_if_text( $c_depth{Board_thick}, 1.123, 4.065);
add_if_text( $c_depth{Width_out}, 2.580, 3.336);
add_if_text( $c_depth{Width_inner}, 2.242, 3.656);
add_if_text( $c_depth{Side_upturned}, 3.884, 4.376);
if (  $c_depth{Side_upturned} eq 'Top') {
	add_if_text( 'Bot', 3.884, 3.85);
}elsif($c_depth{Side_upturned} eq 'Bot'){
	add_if_text( 'Tot', 3.884, 3.85);
}
add_if_text($page{the} , 2.298, 5.239);
add_if_text($page{all} , 3.352, 5.239);
clear('tmp','dd_map');

my @prof_limits = prof_limits($STEP);
my $width =round( ($prof_limits[2]-$prof_limits[0])*25.397  ,2) ;
my $height=round( ($prof_limits[3]-$prof_limits[1])*25.397  ,2) ;
add_if_text("$width x $height MM",0-3.463, $prof_limits[3]-4.682+0.1);
exit;
}##end apply

sub  add_if_text {
	my $text=shift;
    my $x=shift;
	my $y=shift;
	my $x_size=shift||0.12;
	my $y_size=shift||0.15;
	$x+=3.463;
	$y+=4.682;
if ($text) {
	$f->COM ('add_text',
    attributes         =>'no',
	type               =>'string',
	x                  =>$x,
	y                  =>$y,
	text               =>$text,
	x_size             =>$x_size,
	y_size             =>$y_size,
	w_factor           =>1,
	polarity           =>'positive',
	angle              =>0,
	mirror             =>'no',
	fontname           =>'standard',
	bar_type           =>'UPC39',
	bar_char_set       =>'full_ascii',
	bar128_code        =>'none',
	bar_checksum       =>'no',
	bar_background     =>'yes',
	bar_add_string     =>'yes',
	bar_add_string_pos =>'top',
	bar_width          =>0.008,
	bar_height         =>0.2,
	ver                =>1);
}else{
	return;
}
};###end add_if_text;





=head
clear('tmp','dd_map');
my @prof=prof_limits ($STEP);
my $scale;
( ($prof[2]-$prof[0])/($prof[3]-$prof[1]) > 7.36/8.04 ) ? ( $scale=7.3/($prof[2]-$prof[0]) ) : ( $scale=8.0/($prof[3]-$prof[1]) );

	$f->COM ('filter_reset',filter_name=>'popup');
    $f->COM ('filter_set',filter_name=>'popup',update_popup=>'no',profile=>'in');
    $f->COM ('filter_area_strt');
    $f->COM ('filter_area_end',layer=>'',filter_name=>'popup',operation=>'select',area_type=>'none',inside_area=>'no',intersect_area=>'no',lines_only=>'no',ovals_only=>'no',min_len=>0,max_len=>0,min_angle=>0,max_angle=>0);
	sel_move_other($$);
    clear($$);
	sel_transform($prof[0],$prof[1],$prof[0]-3.389,$prof[1]-4.700,$scale,$scale,0,'scale');
	clear('tmp');
    my $tmp_min_x=info('layer',"$JOB/$STEP/tmp",'LIMITS')->{gLIMITSxmin};
	my $tmp_min_y=info('layer',"$JOB/$STEP/tmp",'LIMITS')->{gLIMITSymin};
	if ( ($prof[2]-$prof[0])/($prof[3]-$prof[1]) > 7.36/8.04 ) {
		my $move_y=$prof[3]*$scale-4.7-$tmp_min_y+0.1;
	    sel_transform($prof[0],$prof[1], -3.389-$tmp_min_x, $move_y,);
	}else{
		my $move_y=$prof[3]*$scale-4.7-$tmp_min_y+0.1;
	}
	sel_move_other('dd_map');
	clear($$);
	sel_move_other('dd_map');
	clear('dd_map');
	$f->COM ('delete_layer',layer=>$$);
=cut





























