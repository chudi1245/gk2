use strict;
use warnings;
my $class=\%main::layer_class;
my ($step_margin_x, $step_margin_y, $x, $y );
##3mm = 0.1181inch  15mm=0.55906inch  10mm=0.3937inch  5mm=0.1968
my $mm_3=0.1181; 
my $mm_5=0.1968;
my $mm_10=0.3937;
my $mm_15=0.55906;
my $mm_18=0.7087;
##__________________________________________________fill inner
fill_params('pattern', 'new_fill_x', 0.385827,0.338583);
foreach  ( @{$class->{inner}} ) { 
	sr_fill($_,   0.04,0.01,    48,48,   10,$mm_3,    10,10,   0.01) ;
}
fill_params('pattern', 'new_fill_y', 0.338583,0.385827);
foreach  ( @{$class->{inner}} ) { 
	sr_fill($_,   0.01,0.04,    48,48,   $mm_3,10,    10,0.15,  0.01) ;
}
##__________________________________________________fill middle
fill_params('pattern', 'cu_pad', 0.1113506,0.1113506 );  
foreach  ( @{$class->{line}} ) { 
	sr_fill($_, $main::SR_xmin, $main::SR_ymin,  50 , 50,   $mm_3, $mm_3,    0,0,  0.08) ;
}

##__________________________________________________fill out
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

fill_params('pattern', 'cu_pad', 0.1113506,0.1113506 );  
foreach  ( @{$class->{outer}} ) { 
	sr_fill($_,    $x,$y,     48,48,    $mm_3,$mm_3,    10,10,   0.04); 
}

fill_params('solid',  '',1,1);   
foreach  ( @{$class->{outer}} ) { 
	sr_fill($_,  $step_margin_x,$step_margin_y,  $x, $y,   $mm_3,$mm_3,  10,10,  0.04);
}


##inner positive fill 
my @layer_line=@{$main::layer_class{line}};
fill_params('solid',  '',1,1);  
foreach  (1..$#layer_line-1 ) {
	if ( $main::polarity[$_] eq '+') {
		sr_fillp($layer_line[$_],  -$mm_5, -$mm_5, 0.1, 0.1  );
	}
}

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
