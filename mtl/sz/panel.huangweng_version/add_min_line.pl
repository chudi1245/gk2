use strict;
use warnings;

my $class=\%main::layer_class;
my @butfly=@main::butfly;
@main::min_line=(
  { x=>$butfly[0]{x}-0.32, y=>$butfly[0]{y} },
  { x=>$butfly[1]{x}-0.20, y=>$butfly[2]{y} },
  { x=>$butfly[2]{x}+0.20, y=>$butfly[2]{y} },
  { x=>$butfly[3]{x}+0.32, y=>$butfly[3]{y} },
);
my @min_line=@main::min_line;


if ( exists $class->{line}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{line}} );
    add_min_line('min-line',90);
	clear();
}
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}} );
    add_min_line('rect200x120');
}

clear();



sub add_min_line {
	my $symbol=shift;
	my $rorate=shift||0;
	map { add_pad($min_line[$_]{x}, $min_line[$_]{y}, $symbol, 'no', $rorate) } (0..$#min_line);
}
#p__('min line ok');
1;
=head

$min_line[0]{x}=$butfly[0]{x}-0.22;
$min_line[0]{y}=$butfly[0]{y};
$min_line[1]{x}=$butfly[1]{x}-0.22;
$min_line[1]{y}=$butfly[2]{y};
$min_line[2]{x}=$butfly[2]{x}+0.22;
$min_line[2]{y}=$butfly[2]{y};
$min_line[3]{x}=$butfly[3]{x}+0.22;
$min_line[3]{y}=$butfly[3]{y};
foreach  ( @{$layer_class{route}} ) {
	clear($_);
	add_pad($min_line[0]{x},$min_line[0]{y},'min-line','no',90);
	add_pad($min_line[1]{x},$min_line[1]{y},'min-line','no',90);
	add_pad($min_line[2]{x},$min_line[2]{y},'min-line','no',90);
	add_pad($min_line[3]{x},$min_line[3]{y},'min-line','no',90);
}
foreach  ( @{$layer_class{solder_mask}} ) {
	clear($_);
	add_pad($min_line[0]{x},$min_line[0]{y},'rect200x120',);
	add_pad($min_line[1]{x},$min_line[1]{y},'rect200x120',);
	add_pad($min_line[2]{x},$min_line[2]{y},'rect200x120',);
	add_pad($min_line[3]{x},$min_line[3]{y},'rect200x120',);
}
#p__("add min line ok");
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


