use strict;
use warnings;
##date: 2014-05-25 Modified.  author: Mobin
my $class=\%main::layer_class;
my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\line solder_mask silk_screen \);

my $offset=0.03937;  
my @confine_line=(
 {x=>$main::SR_xmin-$offset,  y=>$main::SR_ymin-$offset,},
 {x=>$main::SR_xmin-$offset,  y=>$main::SR_ymax+$offset,},
 {x=>$main::SR_xmax+$offset,  y=>$main::SR_ymax+$offset,},
 {x=>$main::SR_xmax+$offset,  y=>$main::SR_ymin-$offset,},
);

clear();
affected_layer('yes', 'single', @add_layer );
add_pad($confine_line[0]{x},$confine_line[0]{y},'mtlijx','no',0,  );
add_pad($confine_line[1]{x},$confine_line[1]{y},'mtlijx','no',90, );
add_pad($confine_line[2]{x},$confine_line[2]{y},'mtlijx','no',180,);
add_pad($confine_line[3]{x},$confine_line[3]{y},'mtlijx','no',270,);

#p__("confine line ok");

clear();

1;

