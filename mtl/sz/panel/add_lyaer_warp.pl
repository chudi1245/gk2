use strict;
use warnings;
goto LABEL_LAYER_WARP_END if ($main::layer_number < 3);

my $class=\%main::layer_class;
my %grid=%main::grid;
my %layer_warp=(
  top=>$main::SR_ymax + 0.4 ,
  bot=>$main::SR_ymin - 0.4 ,
  rig=>$main::SR_xmax + 0.4 ,
  lef=>$main::SR_xmin - 0.4 ,
);
#*********************************6.24修改，铆钉受制于工具孔。
my $target_tool=$main::target_tool;
my ($layer_warp_rt,$layer_warp_lb);

    $layer_warp_rt = $main::start_point + 3.76;

if ($main::py >= 16) {
	$layer_warp_lb=$main::start_point - 4.70;	
}else{
	$layer_warp_lb=$main::start_point - 1.07;	
}

if ( exists $class->{inner}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{inner}}, );
    add_layer_warp('dwi');
}
if ( exists $class->{outer}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{outer}}, );
    add_layer_warp('dwo');
}
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}}, );
    add_layer_warp('dws');
}
clear('drl');
add_layer_warp('dwdrill');
clear();



###______________________________
sub add_layer_warp{
	my $symbol=shift;
	##6.24修改
	if ($main::px < $main::py )  {
		add_pad($grid{x}[12],$layer_warp{top},$symbol,'no', 90,  'yes');
		add_pad($grid{x}[1], $layer_warp{bot},$symbol,'no', 90,  'yes');		
	} 
	else {
	    add_pad($layer_warp{rig},$layer_warp_rt,$symbol);
		add_pad($layer_warp{lef},$layer_warp_lb,$symbol);		
    }


#	if ($main::px > $main::py )  {
#		add_pad($grid{x}[12],$layer_warp{top},$symbol,'no', 90,  'yes');
#		add_pad($grid{x}[1], $layer_warp{bot},$symbol,'no', 90,  'yes');		
#	} 

#   if ($main::px <= $main::py ) {
#	    add_pad($layer_warp{rig},$layer_warp_rt,$symbol);
#		add_pad($layer_warp{lef},$layer_warp_lb,$symbol);		
#   }

#       加在左下，右上两个位置
#		add_pad($layer_warp{rig},$grid{y}[12],$symbol);
#		add_pad($layer_warp{lef},$grid{y}[1],$symbol);

}

LABEL_LAYER_WARP_END: ;
1;

=head
