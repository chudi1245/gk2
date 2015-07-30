use strict;
use warnings;

my $class=\%main::layer_class;
######################################
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
###################################

my $offset=0.24;
my @dwzhsm=(
  {x=>$main::sypad[1]{x},       y=>$main::sypad[1]{y} - 0.45   },
  {x=>$main::sypad[2]{x},		y=>$main::sypad[2]{y} - $offset},
  {x=>$main::sypad[3]{x},		y=>$main::sypad[3]{y} + $offset},
  {x=>$main::sypad[4]{x},		y=>$main::sypad[4]{y} + $offset},
);

if ( exists $class->{outer}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{outer}} );
    add_butfly('dw-zh');   
	clear();
}


my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\solder_mask silk_screen\);
if (@add_layer) {
    clear();
    affected_layer('yes', 'single', @add_layer, );
    add_butfly('dw-sm');
	clear();
}


###____________________________
sub add_butfly {
	my $symbol=shift;
	my $rorate=shift||0;
	add_pad($dwzhsm[0]{x},$dwzhsm[0]{y},$symbol,'no',$rorate);
	add_pad($dwzhsm[1]{x},$dwzhsm[1]{y},$symbol,'no',$rorate);
	add_pad($dwzhsm[2]{x},$dwzhsm[2]{y},$symbol,'no',$rorate);
	add_pad($dwzhsm[3]{x},$dwzhsm[3]{y},$symbol,'no',$rorate);

#	map { add_pad($butfly[$_]{x},$butfly[$_]{y},$symbol,'no',$rorate) } (0..$#butfly);

}

clear();

#p__("butfly ok");


1;
