use strict;
use warnings;
my $class=\%main::layer_class;
my $off_set=0.2;
my $zfl={
	toff=>$main::SR_ymax + $off_set,
    boff=>$main::SR_ymin - $off_set,
    loff=>$main::SR_xmin - $off_set,
    roff=>$main::SR_xmax + $off_set,
};

my (@layer_solder);

if ( exists $class->{solder_mask}  ){
	@layer_solder=@{$class->{solder_mask}};
	}else{
	@layer_solder=undef;
	}

my @layer_outer =@{$class->{outer}};

my @layer_drill =@{$class->{drill}};

###add top
foreach my $name ($layer_solder[0],$layer_outer[0],$layer_drill[0],$layer_outer[1]) {
	next unless $name;
	my ($excursion,$symbol)=(-0.18); 
	($name =~ m/gtl/i) ? ($symbol='zfl')  :
	($name =~ m/gts/i) ? ($symbol='zfls') :
	($name =~ m/gts1/i) ? ($symbol='zfls') :
	($name =~ m/gts\-ir/i) ? ($symbol='zfls') :
	($name =~ m/drl/i) ? ($symbol='zfld') : 
	($name =~ m/gbl/i) ? ($symbol='zflc')   :();

	clear($name);
	add_black_film($excursion,$symbol);
}


##add bot~
foreach my $name ($layer_solder[1],$layer_outer[1],$layer_drill[0],$layer_outer[0]) {
	next unless $name;
	my ($excursion,$symbol)=(0.18); 
	($name =~ m/gbl/i) ? ($symbol='zfl')  :
	($name =~ m/gbs/i) ? ($symbol='zfls') :
	($name =~ m/gbs1/i) ? ($symbol='zfls') :
	($name =~ m/gbs\-ir/i) ? ($symbol='zfls') :
	($name =~ m/drl/i) ? ($symbol='zfld') : 
	($name =~ m/gtl/i) ? ($symbol='zflc') :();

	clear($name);
	add_black_film($excursion, $symbol);
}

sub add_black_film {
	my $excursion=shift;
    my $symbol=shift;
	add_pad($main::grid{x}[5]+$excursion,  $zfl->{toff}, $symbol,);
	add_pad($main::grid{x}[8]+$excursion,  $zfl->{boff}, $symbol,);
	add_pad($zfl->{roff},  $main::grid{y}[8]+$excursion+0.15, $symbol, 'no', 90);
    add_pad($zfl->{loff},  $main::grid{y}[5]+$excursion, $symbol, 'no', 90);
}

##p__("blak is end");

1;



=head
2014-03-29 ±¸·Ý£¡£¡£¡
###add top
foreach my $name ($layer_solder[0],$layer_outer[0],$layer_drill[0],$layer_outer[1]) {
	next unless $name;
	my ($excursion,$symbol)=(-0.18); 
	($name =~ m/gtl/i) ? ($symbol='zfl')  :
	($name =~ m/gts/i) ? ($symbol='zfls') :
	($name =~ m/gts1/i) ? ($symbol='zfls') :
	($name =~ m/gts\-ir/i) ? ($symbol='zfls') :
	($name =~ m/drl/i) ? ($symbol='zfld') : 


	($name =~ m/gbl/i) ? ($symbol='zflb')   :();
###gts-ir
	clear($name);
	add_black_film($excursion,$symbol);
}
##  add by Mobin 2014-01-18
if ( exists_layer('gtl') eq 'yes' ) {
	my ($excursion)=(0.18); 
	clear('gtl');
	
	add_black_film($excursion, 'zflc');
}

##add bot~
foreach my $name ($layer_solder[1],$layer_outer[1],$layer_drill[0],$layer_outer[0]) {
	next unless $name;
	my ($excursion,$symbol)=(0.18); 
	($name =~ m/gbl/i) ? ($symbol='zfl')  :
	($name =~ m/gbs/i) ? ($symbol='zfls') :
	($name =~ m/gbs1/i) ? ($symbol='zfls') :
	($name =~ m/gbs\-ir/i) ? ($symbol='zfls') :
	($name =~ m/drl/i) ? ($symbol='zfld') : 

	($name =~ m/gtl/i) ? ($symbol='zflb') :();

	clear($name);
	add_black_film($excursion, $symbol);
}

##  add by Mobin 2014-01-18
if ( exists_layer('gbl') eq 'yes' ) {
	my ($excursion)=(-0.18); 
	clear('gbl');
	
	add_black_film($excursion, 'zflc');
}

sub add_black_film {
	my $excursion=shift;
    my $symbol=shift;
	add_pad($main::grid{x}[5]+$excursion,  $zfl->{toff}, $symbol,);
	add_pad($main::grid{x}[8]+$excursion,  $zfl->{boff}, $symbol,);
	add_pad($zfl->{roff},  $main::grid{y}[8]+$excursion+0.15, $symbol, 'no', 90);
    add_pad($zfl->{loff},  $main::grid{y}[5]+$excursion, $symbol, 'no', 90);
}

1;

=cut

