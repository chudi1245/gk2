use strict;
use warnings;
##30mm = 1.1812 icnch  ##5mm=0.1968  3mm  =  0.11811 

my $judge_dis;
my $off=0.15748; 

if ($main::layer_number < 3){
	$judge_dis=0.74803;
}else{
	$judge_dis=0.94488;
}

my $cy=$main::cy_area;

if ($main::px-$main::SR_xmax > $judge_dis or $main::py-$main::SR_ymax > $judge_dis 
    or $main::SR_xmin - 0    > $judge_dis or $main::SR_ymin - 0       > $judge_dis ) {

	my @pos=( $cy->{lef}+$off,  $cy->{bot}+$off,  $cy->{rig}-$off,    $cy->{top}-$off,);
	clear('drl');
	add_pad($pos[0], $pos[1],'r125');
	add_pad($pos[2], $pos[1],'r125');
	add_pad($pos[2], $pos[3],'r125');
	add_pad($pos[0], $pos[3],'r125');
	add_pad($pos[2], $pos[3] - 0.15748 , 'r125');	

}    

1;


