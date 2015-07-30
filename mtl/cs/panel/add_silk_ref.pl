use strict;
use warnings;

my $class=\%main::layer_class;
my @min_line=@main::min_line;
@main::silk_ref=(
  { x=>$min_line[0]{x}+0.22, y=>$min_line[0]{y}, },
  { x=>$main::SR_xmax+0.12, y=>$main::SR_ymin+0.3, },
  { x=>$min_line[2]{x}+0.22, y=>$min_line[2]{y}, },
  { x=>$min_line[3]{x}-0.22, y=>$min_line[3]{y}, },
);
my @silk_ref=@main::silk_ref;
###外层加光学点
if ( exists $class->{line}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{outer}} );
    add_silk_ref('r59.055');
    add_silk_ref('donut_r150x135');
}
###阻焊层加光学点开窗
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}} );
    add_silk_ref('r130');
}


###_________________________
sub add_silk_ref {
	my $symbol=shift;
	my $rorate=shift||0;
	map { add_pad($silk_ref[$_]{x}, $silk_ref[$_]{y}, $symbol, 'no', $rorate) } (0..$#silk_ref);
}

clear();
#p__('sile ref ok');
1;


=he
@main::butfly=(
  {x=>$main::SR_xmax, y=>$main::SR_ymax+0.12},
  {x=>$main::SR_xmax, y=>$main::SR_ymin-0.12},
  {x=>$main::SR_xmin, y=>$main::SR_ymin-0.12},
  {x=>$main::SR_xmin, y=>$main::SR_ymax+0.12},
);

@main::min_line=(
  { x=>$butfly[0]{x}-0.32, y=>$butfly[0]{y} },
  { x=>$butfly[1]{x}-0.32, y=>$butfly[2]{y} },
  { x=>$butfly[2]{x}+0.20, y=>$butfly[2]{y} },
  { x=>$butfly[3]{x}+0.32, y=>$butfly[3]{y} },
);

@main::silk_ref=(
  { x=>$min_line[0]{x}+0.22, y=>$min_line[0]{y}, },
  { x=>$min_line[1]{x}-0.22, y=>$min_line[1]{y}, },
  { x=>$min_line[2]{x}+0.22, y=>$min_line[2]{y}, },
  { x=>$min_line[3]{x}-0.22, y=>$min_line[3]{y}, },
);