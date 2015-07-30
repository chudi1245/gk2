use strict;
use warnings;
my $class=\%main::layer_class;
my $off_set=0.23;
my $zfl={
	toff=>$main::SR_ymax + $off_set,
    boff=>$main::SR_ymin - $off_set,
    loff=>$main::SR_xmin - $off_set,
    roff=>$main::SR_xmax + $off_set,
};

my @layer_solder=@{$class->{solder_mask}};
my @layer_outer =@{$class->{outer}};
my @layer_drill =@{$class->{drill}};


###add top

foreach my $name (@layer_solder,$layer_outer[0],$layer_drill[0],$layer_outer[1]) {
	next unless $name;
	my ($excursion,$symbol)=(-0.315); 

if ($name =~ m/ts/i    ) { $symbol='bfls'; clear($name); addt_black_film($excursion,$symbol);   }
if ($name =~ m/gtl/i   ) { $symbol='bfl';  clear($name); addt_black_film($excursion,$symbol);   }
if ($name =~ m/drl/i   ) { $symbol='bfld'; clear($name); addt_black_film($excursion,$symbol);   }
if ($name =~ m/gbl/i   ) { $symbol='bflc'; clear($name); addt_black_film($excursion,$symbol);   }

}
	
##add bot

foreach my $name (@layer_solder,$layer_outer[1],$layer_drill[0],$layer_outer[0]) {
	next unless $name;
	my ($excursion,$symbol)=(0.315); 
if ($name =~ m/bs/i    ) { $symbol='bfls'; clear($name); addb_black_film($excursion,$symbol);   }
if ($name =~ m/gbl/i   ) { $symbol='bfl';  clear($name); addb_black_film($excursion,$symbol);   }
if ($name =~ m/drl/i   ) { $symbol='bfld'; clear($name); addb_black_film($excursion,$symbol);   }
if ($name =~ m/gtl/i   ) { $symbol='bflc'; clear($name); addb_black_film($excursion,$symbol);   }

}


sub addt_black_film {
	my $excursion=shift;
    my $symbol=shift;
	add_pad($main::grid{x}[5]+$excursion+0.35,  $zfl->{toff}, $symbol,'no', 0);
	add_pad($main::grid{x}[10]-$excursion-0.4,  $zfl->{boff}, $symbol,'no',180);
	add_pad($zfl->{roff},  $main::grid{y}[10]-$excursion+0.3, $symbol, 'no', 90);
    add_pad($zfl->{loff},  $main::grid{y}[3]+$excursion-0.3, $symbol, 'no', 270);
}

sub addb_black_film {
	my $excursion=shift;
    my $symbol=shift;
	add_pad($main::grid{x}[5]+$excursion+0.35,  $zfl->{toff}, $symbol,'no',180);
	add_pad($main::grid{x}[10]-$excursion-0.4,  $zfl->{boff}, $symbol,'no',0);
	add_pad($zfl->{roff},  $main::grid{y}[10]-$excursion+0.3, $symbol,'no',270);
    add_pad($zfl->{loff},  $main::grid{y}[3]+$excursion-0.3, $symbol, 'no', 90);
}


1;


=head
#!/usr/bin/csh


foreach my $name ($layer_solder[0],$layer_outer[0],$layer_drill[0],$layer_outer[1]) {
	next unless $name;
	my ($excursion,$symbol)=(-0.18); 
	($name =~ m/gtl/i) ? ($symbol='zfl')  :
##  ($name =~ m/gts-1/i) ? ($symbol='zfls') :
	($name =~ m/gts/i) ? ($symbol='zfls') :
	($name =~ m/gts1/i) ? ($symbol='zfls') :
	
	($name =~ m/drl/i) ? ($symbol='zfld') : 
	($name =~ m/gbl/i) ? ($symbol='zflc')   :();

	clear($name);
	add_black_film($excursion,$symbol);
}
##add bot
foreach my $name ($layer_solder[1],$layer_outer[1],$layer_drill[0],$layer_outer[0]) {
	next unless $name;
	my ($excursion,$symbol)=(0.18); 
	($name =~ m/gbl/i) ? ($symbol='zfl')  :
##	($name =~ m/gbs-1/i) ? ($symbol='zfls') :
	($name =~ m/gbs/i) ? ($symbol='zfls') :
	($name =~ m/gbs1/i) ? ($symbol='zfls') :
	
	($name =~ m/drl/i) ? ($symbol='zfld') : 
	($name =~ m/gtl/i) ? ($symbol='zflc') :();

	clear($name);
	add_black_film($excursion, $symbol);
}
