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


if ( exists $class->{outer}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{outer}} );
    add_butfly('bfr160');
    add_butfly('donut_r176x160');
	clear();
}


my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\solder_mask silk_screen\);

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
	add_pad($butfly[0]{x}-0.24,$butfly[0]{y},$symbol,'no',$rorate);
	add_pad($butfly[1]{x},$butfly[1]{y},$symbol,'no',$rorate);
	add_pad($butfly[2]{x},$butfly[2]{y},$symbol,'no',$rorate);
	add_pad($butfly[3]{x},$butfly[3]{y},$symbol,'no',$rorate);

#	map { add_pad($butfly[$_]{x},$butfly[$_]{y},$symbol,'no',$rorate) } (0..$#butfly);

}

clear();
#p__("butfly ok");
1;
