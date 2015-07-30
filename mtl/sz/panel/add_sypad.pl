use strict;
use warnings;
my $class=\%main::layer_class;
my @sypad=@main::sypad;
my @add_layer;

map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\outer solder_mask silk_screen\);

clear();
affected_layer('yes','single',@add_layer);
map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r122.047') }(0..$#sypad);

if ( exists $class->{drill}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{drill}}, );
    map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r125') }(0..$#sypad);
}


clear();

1;


