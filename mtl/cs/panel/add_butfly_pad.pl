use strict;
use warnings;

my $class=\%main::layer_class;
@main::butfly=(
  {x=>$main::SR_xmax, y=>$main::SR_ymax+0.12},
  {x=>$main::SR_xmax, y=>$main::SR_ymin-0.12},
  {x=>$main::SR_xmin, y=>$main::SR_ymin-0.12},
  {x=>$main::SR_xmin, y=>$main::SR_ymax+0.12},
);
##$sypad[$_]{x}

my $offset=0.12;
@main::butfly_A=(
  {x=>$main::sypad[1]{x}+$offset,  y=>$main::sypad[1]{y}+$offset},
  {x=>$main::sypad[2]{x}-$offset,  y=>$main::sypad[2]{y}+$offset},
  {x=>$main::sypad[3]{x}-$offset,  y=>$main::sypad[3]{y}-$offset},
  {x=>$main::sypad[4]{x}+$offset,  y=>$main::sypad[4]{y}-$offset},
);



my @butfly=@main::butfly_A;

#######给外层加对位pad.
if ( exists $class->{outer}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{outer}} );
    add_butfly('bfr160');
    add_butfly('donut_r176x160');
	clear();
}

####把阻焊字符层放到 @add_layer数组；
my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\solder_mask silk_screen\);
#####给阻焊字会加对位图形。与线路的形成互补。可以用来丝印对位。
if (@add_layer) {
    clear();
    affected_layer('yes', 'single', @add_layer, );
    add_butfly('bfr160',90);
	clear();
}

###____________________________
sub add_butfly {
	my $symbol=shift;
	my $rorate=shift||0;
	map { add_pad($butfly[$_]{x},$butfly[$_]{y},$symbol,'no',$rorate) } (0..$#butfly);
}

clear();
#p__("butfly ok");
1;
