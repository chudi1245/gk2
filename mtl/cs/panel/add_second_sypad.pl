use strict;
use warnings;
##30mm = 1.1812 icnch  ##5mm=0.1968
my $judge_dis=1.1812;
my $off=0.1968;  
my $cy=$main::cy_area;

if ($main::px-$main::SR_xmax > $judge_dis or $main::py-$main::SR_ymax > $judge_dis 
    or $main::SR_xmin - 0    > $judge_dis or $main::SR_ymin - 0       > $judge_dis ) {

	my @pos=( $cy->{lef}+$off,  $cy->{bot}+$off,  $cy->{rig}-$off,    $cy->{top}-$off,);
	
	clear('drl');
	
	add_pad($pos[0], $pos[1],'r125');
	add_pad($pos[2], $pos[1],'r125');
	add_pad($pos[2], $pos[3],'r125');
	add_pad($pos[0], $pos[3],'r125');
	add_pad($pos[2], $pos[3]-0.23624, 'r125');	
}

1;
=head







