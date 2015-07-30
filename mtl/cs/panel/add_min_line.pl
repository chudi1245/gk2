use strict;
use warnings;
my $class=\%main::layer_class;
@main::min_line=(
  { x=>$main::SR_xmax-0.85, y=>$main::SR_ymax+0.12},
  { x=>$main::SR_xmax-0.20, y=>$main::SR_ymin-0.12},
  { x=>$main::SR_xmin+0.80, y=>$main::SR_ymin-0.12},
  { x=>$main::SR_xmin+0.52, y=>$main::SR_ymax+0.12},
);
my @min_line=@main::min_line;

###给线路层加蚀刻线图形。
if ( exists $class->{line}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{line}} );
    add_min_line('min-line',90);
	clear();
}
###给阻焊层加蚀刻线的开窗图形。
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}} );
    add_min_line('rect200x120');
}
clear();

sub add_min_line {
	my $symbol=shift;
	my $rorate=shift||0;
	map { add_pad($min_line[$_]{x}, $min_line[$_]{y}, $symbol, 'no', $rorate) } (0,2,);
}

####p__('min line ok');

1;



=head
