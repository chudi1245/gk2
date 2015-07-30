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

####加层偏对位图形。
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
	add_pad($layer_warp{lef},$grid{y}[1],$symbol);    ###左下加PAD
	add_pad($layer_warp{rig},$grid{y}[12],$symbol);   ###右上加PAD
}

LABEL_LAYER_WARP_END: ;
1;

=head
