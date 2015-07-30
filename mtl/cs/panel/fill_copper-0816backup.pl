use strict;
use warnings;
my $class=\%main::layer_class;
my ($step_margin_x, $step_margin_y, $x, $y );
##3mm = 0.1181inch  15mm=0.55906inch  10mm=0.3937inch  5mm=0.1968


my $mm_1 = 0.03937;
my $mm_2 = 0.078;
my $mm_3 = 0.1181; 
my $mm_4 = 0.15748;
my $mm_5 = 0.19685;
my $mm_33= 0.1183;
my $mm_5 = 0.1968;
my $mm_7 = 0.27559;
my $mm_8 = 0.31496;
my $mm_10= 0.3937;
my $mm_15= 0.55906;
my $mm_18= 0.7087;

## 电镀边，x,y长宽。
my $res_x= ($main::px-$main::SR_xmax);
my $res_y= ($main::py-$main::SR_ymax);

##__________________________________________________fill inner
if ($main::tech_type =~ m/Thick_Cu/i) {
	fill_params('pattern', 'l2', 0.1295,0.1295);
}else{
    fill_params('pattern', 'l1', 0.2,0.2 );
}

foreach  ( @{$class->{inner}} ) { 
	sr_fill($_,   0.06,0.06,   48,48,  0.1,0.1,  10,10,  0.01) ;
}

##inner positive fill   ####内层正片
my @layer_line=@{$main::layer_class{line}};
fill_params('solid',  '',1,1);  
foreach  (1..$#layer_line-1 ) {
	if ( $main::polarity[$_] eq '+') {
		sr_fillp($layer_line[$_],  -$mm_5, -$mm_5, 0.1, 0.1  );
	}
}


##__________________________________________________fill out ###外层铺铜
if ($main::layer_number <= 2 ) {
	$step_margin_x=-$mm_5;
	$step_margin_y=-$mm_5;
	$x=$mm_10;
	$y=$mm_10;
}else{
	
	if (    ($main::px-$main::SR_xmax) < $mm_18  ) {
		$step_margin_x=($main::px-$main::SR_xmax)-$mm_18  ;
	}else{
		$step_margin_x=0;
	}
	
	if (    ($main::py-$main::SR_ymax) < $mm_18  ) {
		$step_margin_y=($main::py-$main::SR_ymax)-$mm_18    ;
	}else{
		$step_margin_y=0;
	}
	$x=$mm_15;
	$y=$mm_15;
}

#=head 
fill_params('pattern', 'cu_pad', 0.1113506,0.1113506 );  
foreach  ( @{$class->{outer}} ) { 
	sr_fill($_,    $res_x,$res_y,     48,48,    $mm_2,$mm_2,    10,10,   0.05); 
}
#=cut


my $dis_x = ($main::px - $main::cyx) / 2;    
my $dis_y = ($main::py - $main::cyy) / 2; 
my $outx = -0.31496 + $dis_x;
my $outy = -0.31496 + $dis_y;

fill_params('solid',  '',1,1);
if ($main::layer_number < 3) { 
	foreach  ( @{$class->{outer}} ) { 
		#sr_fill($_,  $step_margin_x,$step_margin_y,  $res_x, $res_y,   $mm_3,$mm_3,  10,10,  0.024);
		##sr_fill($_,  -$mm_5,-$mm_5,  $mm_7, $mm_7,   $mm_3,$mm_3,  10,10,  0.024);  2014-6-10 双面板向外铺10mm.
		##sr_fill($_,  -$mm_8,-$mm_8,  $mm_7, $mm_7,   $mm_3,$mm_3,  10,10,  0.0315);
		sr_fill($_,  -$mm_8,-$mm_8,  $res_x, $res_y,  $mm_3,$mm_3,  10,10,  0.0315);
	}
}else{
	foreach  ( @{$class->{outer}} ) { 
		# sr_fill($_,  $step_margin_x,$step_margin_y,  $res_x, $res_y,   $mm_3,$mm_3,  10,10,  0.024);

		# sr_fill($_,  0,0,  $mm_8+$dis_x, $mm_8+$dis_y,   $mm_3,$mm_3,  10,10,  0.024);  2014-6-10 修改

		# sr_fill($_, $outx, $outy,  $mm_8+$dis_x, $mm_8+$dis_y,   $mm_3,$mm_3,  10,10,  0.024); #2014-6-28修改

		sr_fill($_,  $outx,$outy,  $res_x-$mm_3, $res_y-$mm_3,   $mm_3,$mm_3,  10,10,  0.0315);
	}
}


=head  2014-6-28 修改
if ( $res_x > $mm_15 &&  $res_y > $mm_15 ) {
    my $start_x = $mm_7 + ($res_x - $mm_7) / 2 - $mm_4 ;
	my $start_y = $mm_7 + ($res_y - $mm_7) / 2 - $mm_4 ;
	my $end_x = $start_x +  $mm_8 ;
	my $end_y = $start_y +  $mm_8 ;
	foreach  ( @{$class->{outer}} ) { 
		#sr_fill($_,  $step_margin_x,$step_margin_y,  $res_x, $res_y,   $mm_3,$mm_3,  10,10,  0.024);
		sr_fill($_, $start_x, $start_y, $end_x, $end_y, $mm_3, $mm_3,  10, 10, 0.024);
	}
}
=cut 



###___________________________________________________sub
sub sr_fill {
	my $layer           =shift;
	my $step_margin_x   =shift||0;
	my $step_margin_y   =shift||0;
	my $step_max_dist_x =shift||0;
	my $step_max_dist_y =shift||0;
	my $sr_margin_x     =shift||0;
	my $sr_margin_y     =shift||0;
	my $sr_max_dist_x   =shift||10;
	my $sr_max_dist_y   =shift||10;
	my $feat_margin     =shift||0.01;
	
    $main::f->COM ('sr_fill',
	polarity        =>'positive',
	step_margin_x   =>$step_margin_x,
	step_margin_y   =>$step_margin_y,
	step_max_dist_x =>$step_max_dist_x,
	step_max_dist_y =>$step_max_dist_y,
	sr_margin_x     =>$sr_margin_x,
	sr_margin_y     =>$sr_margin_y,
	sr_max_dist_x   =>$sr_max_dist_x,
	sr_max_dist_y   =>$sr_max_dist_y,
	nest_sr         =>'no',
	consider_feat   =>'yes',
	feat_margin     =>$feat_margin,
	consider_drill  =>'no',
	drill_margin    =>0,
	consider_rout   =>'no',
	dest            =>'layer_name',
	layer           =>$layer,
	attributes      =>'no');
}

sub sr_fillp {
	my $layer           =shift;
	my $step_margin_x   =shift||0;
	my $step_margin_y   =shift||0;
	my $step_max_dist_x =shift||0;
	my $step_max_dist_y =shift||0;
	my $sr_margin_x     =shift||0;
	my $sr_margin_y     =shift||0;
	my $sr_max_dist_x   =shift||10;
	my $sr_max_dist_y   =shift||10;
	my $feat_margin     =shift||0.01;
	
    $main::f->COM ('sr_fill',
	polarity        =>'positive',
	step_margin_x   =>$step_margin_x,
	step_margin_y   =>$step_margin_y,
	step_max_dist_x =>$step_max_dist_x,
	step_max_dist_y =>$step_max_dist_y,
	sr_margin_x     =>$sr_margin_x,
	sr_margin_y     =>$sr_margin_y,
	sr_max_dist_x   =>$sr_max_dist_x,
	sr_max_dist_y   =>$sr_max_dist_y,
	nest_sr         =>'no',
	consider_feat   =>'no',
	feat_margin     =>$feat_margin,
	consider_drill  =>'no',
	drill_margin    =>0,
	consider_rout   =>'no',
	dest            =>'layer_name',
	layer           =>$layer,
	attributes      =>'no');
}


clear();
#p__('fill cu ok');
1;


=head

    if ($params eq 'outer') {
        $f->COM ('fill_params',
                 type          =>'solid',
                 origin_type   =>'datum',
                 solid_type    =>'surface',
                 std_type      =>'line',
                 min_brush     =>5,
                 use_arcs      =>'no',
                 symbol        =>'',
                 dx            =>0.1,
                 dy            =>0.1,
                 std_angle     =>45,
                 std_line_width=>10,
                 std_step_dist =>50,
                 std_indent    =>'odd',
                 break_partial =>'yes',
                 cut_prims     =>'no',
                 outline_draw  =>'no',
                 outline_width =>0,
                 outline_invert=>'no');
    }elsif($params eq 'inner'){
        $f->COM ('fill_params',
                 type=>'pattern',
                 origin_type=>'datum',
                 solid_type=>'surface',
                 std_type=>'line',
                 min_brush=>10,
                 use_arcs=>'yes',
                 symbol=>$symbol,
                 dx=>$dxy,
                 dy=>$dxy,
                 std_angle=>45,
                 std_line_width=>1056,
                 std_step_dist=>1270,
                 std_indent=>'odd',
                 break_partial=>'yes',
                 cut_prims=>'no',
                 outline_draw=>'no',
                 outline_width=>1056,
                 outline_invert=>'no');


my $fill_cu_width;
if ($main::layer_number > 2) {
	##m layer 15mm=0.5906inch
	$fill_cu_width=0.5906;
}else{
	##d layer 10mm=0.3937inch
	$fill_cu_width=0.3973;
}


sub _fill_set {

	my $symbol=shift;
	my $dx=shift||0.1;
	my $dy=shift||0.1;
	my $break_partial=shift||'yes';
	my $cut_prims=shift||'no';


$main::f->COM ('fill_params',
type           =>'pattern',
origin_type    =>'datum',
solid_type     =>'surface',
std_type       =>'line',
min_brush      =>1,
use_arcs       =>'no',
symbol         =>$symbol,
dx             =>$dx,
dy             =>$dy,
std_angle      =>45,
std_line_width =>10,
std_step_dist  =>50,
std_indent     =>'odd',
break_partial  =>$break_partial,
cut_prims      =>$cut_prims,
outline_draw   =>'no',
outline_width  =>0,
outline_invert =>'no',
);