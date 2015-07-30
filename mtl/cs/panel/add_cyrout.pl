use strict;
use warnings;
###__________________________
my $arc_size=0.19687;
my $dis=0.1968;
my $arc=0.1968;
my $symbol='r10';
##5mm=0.1968   13mm=0.5118

my $dis_x= ($main::px - $main::cyx) / 2;    
my $dis_y= ($main::py - $main::cyy) / 2;

$main::cy_area={top=>undef,bot=>undef,lef=>undef,rig=>undef,};

if ($main::layer_number <=2) {
	$main::cy_area->{top} = $main::py;
	$main::cy_area->{bot} = 0;
	$main::cy_area->{lef} = 0;
	$main::cy_area->{rig} = $main::px;
	goto LABEL_ADD_CY_END if  $main::layer_number <= 2;
}else{
	$main::cy_area->{lef} = 0         + $dis_x;
	$main::cy_area->{rig} = $main::px - $dis_x;
	$main::cy_area->{top} = $main::py - $dis_y;
	$main::cy_area->{bot} = 0         + $dis_y;
}

##p__("$main::cy_area->{bot}, $main::cy_area->{lef}"); 
my $cy=$main::cy_area;
#####
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
LABEL_ADD_CY_END:  ;
1;



=head




