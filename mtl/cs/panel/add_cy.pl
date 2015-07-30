use strict;
use warnings;

###my $class=\%main::layer_class;
###__________________________
my $arc_size=0.19687;
my $symbol='r10';
my $res_x= ($main::px-$main::SR_xmax)*$main::I_M;
my $res_y= ($main::py-$main::SR_ymax)*$main::I_M;
##5mm=0.1968   13mm=0.5118
my $dis_2=0.5118; 
my $dis=0.1968;
my $arc=0.1968;
$main::cy_area={top=>undef,bot=>undef,lef=>undef,rig=>undef,};
my $cy=$main::cy_area;
###
if ($main::layer_number <=2) {
	$cy->{top} = $main::py;
	$cy->{bot} = 0;
	$cy->{lef} = 0;
	$cy->{rig} = $main::px;
	goto LABEL_ADD_CY_END if  $main::layer_number <= 2;

}else{
	if ($res_y >= 18) {
		p__("$res_y");
		$cy->{top} = $main::py - $dis;
		$cy->{bot} = 0         + $dis;
	}else{
		$cy->{top} = $main::SR_ymax + $dis_2;
		$cy->{bot} = $main::SR_ymin - $dis_2;
	}
	if ($res_x >= 18) {
		p__("$res_x");
		$cy->{lef} = 0         + $dis;
		$cy->{rig} = $main::px - $dis;
	}else{
		$cy->{lef} = $main::SR_xmin - $dis_2;
		$cy->{rig} = $main::SR_xmax + $dis_2;
	}
}

####______________________
creat_clear_layer('cy');
clear('cy');
add_arc($cy->{rig}-$dis,$cy->{top}-$dis,
        $cy->{rig}-$dis,$cy->{top},
		$cy->{rig},$cy->{top}-$dis,
		$symbol);
add_arc($cy->{rig}-$dis,$cy->{bot}+$dis,
		$cy->{rig},$cy->{bot}+$dis,
		$cy->{rig}-$dis,$cy->{bot},
		$symbol);
add_arc($cy->{lef}+$dis,$cy->{bot}+$dis,
		$cy->{lef}+$dis,$cy->{bot},
		$cy->{lef},$cy->{bot}+$dis,
		$symbol);
add_arc($cy->{lef}+$dis,$cy->{top}-$dis,
		$cy->{lef},$cy->{top}-$dis,
		$cy->{lef}+$dis,$cy->{top},
		$symbol);
add_line($cy->{rig},$cy->{top}-$dis,   $cy->{rig},$cy->{bot}+$dis,   $symbol);
add_line($cy->{rig}-$dis,$cy->{bot},   $cy->{lef}+$dis,$cy->{bot},   $symbol);
add_line($cy->{lef},$cy->{bot}+$dis,   $cy->{lef},$cy->{top}-$dis,   $symbol);
add_line($cy->{lef}+$dis,$cy->{top},   $cy->{rig}-$dis,$cy->{top},   $symbol);
clear();
####___________________________

LABEL_ADD_CY_END:  ;
1;



=head




