use strict;
use warnings;
goto JIAO_DRILL_END if ($main::layer_number < 3);

my $class=\%main::layer_class;
my @jiaopad = @main::jiaopad;

clear();
affected_layer( 'yes', 'single', @{$class->{inner}} );
map { add_pad($jiaopad[$_]{x},$jiaopad[$_]{y},'r125.988') }(0..$#jiaopad);


clear();
affected_layer( 'yes', 'single', 'drl' );
map { add_pad($jiaopad[$_]{x},$jiaopad[$_]{y},'r114.252') }(0..$#jiaopad);


JIAO_DRILL_END: ;
clear();

1;


