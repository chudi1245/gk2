use strict;
use warnings;

my $class=\%main::layer_class;
my @min_line=@main::min_line;

###$slice->[0]{x}
my ($nx,$ny,$dx,$dy)=(5,2,118,75);
my $symbol_half_long=$dx*2/1000;

my $slice;
my $mm1_5=0.06;

if ($main::layer_number <= 2) {
	my $off_x=0.6;
	my $off_y=($dy/1000)/2 ;
	$slice=[
	  {x=>$min_line[3]{x}+$off_x-$symbol_half_long,y=>$min_line[3]{y}-$off_y+$mm1_5,},
	  {x=>$min_line[1]{x}-0.5-$off_x-$symbol_half_long,y=>$min_line[1]{y}-$off_y-$mm1_5 - 0.02,},
	];
}else{
	my $off_x=0.2;
	my $off_y=0.25;
	
	$slice=[
	  {x=>$min_line[3]{x}+$off_x-$symbol_half_long,      y=>$min_line[3]{y}+$off_y,},
	  {x=>$min_line[1]{x}-0.5-$off_x-$symbol_half_long,  y=>$min_line[1]{y}-$off_y,},
	];
}

my($slice_drill_size)=sort{$a<=>$b}@{info('layer',"$main::JOB/pcb/drl",'tool')->{gTOOLdrill_size}};
$slice_drill_size+=0.0394; ##0.0394mil = 0.01mm

clear('drl');
_add_slice("r$slice_drill_size",$nx,$ny,$dx,$dy);
clear();

if ( exists $class->{line}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{line}} );
	my $symbol='r'.($slice_drill_size+12);
	_add_slice($symbol,$nx,$ny,$dx,$dy);
	my $r_line='r20';
	add_line($slice->[0]{x} , $slice->[0]{y}, $slice->[0]{x}+$symbol_half_long*2 , $slice->[0]{y},$r_line);
	add_line($slice->[0]{x} , $slice->[0]{y}+$dy/1000, $slice->[0]{x}+$symbol_half_long*2 , $slice->[0]{y}+$dy/1000,$r_line);
	add_line($slice->[1]{x} , $slice->[1]{y}, $slice->[1]{x}+$symbol_half_long*2 , $slice->[1]{y},$r_line);
	add_line($slice->[1]{x} , $slice->[1]{y}+$dy/1000, $slice->[1]{x}+$symbol_half_long*2 , $slice->[1]{y}+$dy/1000,$r_line);

}
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}} );
	my $symbol='r'.($slice_drill_size+20);
	_add_slice($symbol,$nx,$ny,$dx,$dy);
}

sub _add_slice {
	my $symbol=shift;
	my ($nx,$ny,$dx,$dy)=@_;
	add_pad($slice->[0]{x},$slice->[0]{y},$symbol,'no',0,'no','positive',$nx,$ny,$dx,$dy);
	add_pad($slice->[1]{x},$slice->[1]{y},$symbol,'no',0,'no','positive',$nx,$ny,$dx,$dy);
}
###
###p__("slice is end");

1;
=head
sub _add_slice {
$main::f->COM ('add_pad',
    'attributes'=>no,
    'x'=>1.0022780512,
    'y'=>11.7245017717,
    'symbol'=>r10,
    'polarity'=>positive,
    'angle'=>0,
    'mirror'=>no,
    'nx'=>5,
    'ny'=>2,
    'dx'=>118,
    'dy'=>75,
    'xscale'=>1,
    'yscale'=>1);
	}
	

$slice->[0]{x}


@main::min_line=(
  { x=>$butfly[0]{x}-0.22, y=>$butfly[0]{y} },
  { x=>$butfly[1]{x}-0.22, y=>$butfly[2]{y} },
  { x=>$butfly[2]{x}+0.22, y=>$butfly[2]{y} },
  { x=>$butfly[3]{x}+0.22, y=>$butfly[3]{y} },
);


COM add_pad,attributes=no,x=1.997296063,y=9.3062716535,symbol=r20,polarity=positive,angle=0,mirror=no,nx=5,ny=2,dx=118,dy=75,xscale=1,yscale=1

=head
use strict;
use warnings;

my $class=\%main::layer_class;
my @min_line=@main::min_line;

my $off_set=0.2;
my @slice=(
  {x=>$min_line[3]{x}+$off_set,  y=>$min_line[3]{y}+0.25,},
  {x=>$min_line[1]{x}-$off_set,  y=>$min_line[1]{y}-0.25,},
);

if ( exists $class->{line}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{line}} );
    add_slice('qp_line');
}
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}} );
    add_slice('qp_solder');
}

clear('drl');
add_slice('qpd');
clear();


sub add_slice {
	my $symbol=shift;
	map { add_pad($slice[$_]{x}, $slice[$_]{y}, $symbol, ) } (0..$#slice);
}

1;

my ($mm_2,$mm_8)=(7.87,31.5);
if ($end_size[0] > $mm_8) {
	$slice_drill_size=$mm_8;
}elsif($end_size[0] > $mm_2){
	$slice_drill_size=$end_size[0];
}else{
	$slice_drill_size=$mm_2;
}
