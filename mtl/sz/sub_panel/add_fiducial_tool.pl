use strict;
no strict "vars";

my (@gROWrow ,@gROWcontext,@gROWside ,@gROWlayer_type,@gROWname,@gROWtype );
###____________________________________________
@gROWrow       =@{info("matrix","$JOB/matrix","row")->{gROWrow}};
@gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
@gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};
@gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
@gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
@gROWtype      =@{info("matrix","$JOB/matrix","row")->{gROWtype}};
###____________________________________________________

foreach  (0..$#gROWrow) {
	if ($gROWcontext[$_] eq 'board'){
		push @{$layer_class{board}},$gROWname[$_];
		if ($gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
			push @{$layer_class{route}},$gROWname[$_];
		    if ($gROWside[$_] eq 'inner'){
			    push @{$layer_class{inner}},$gROWname[$_];
		    }else{
				push @{$layer_class{outer}},$gROWname[$_];
			}
		}elsif ($gROWlayer_type[$_] eq 'solder_mask'){
			push @{$layer_class{solder_mask}},$gROWname[$_];
		}elsif ($gROWlayer_type[$_] eq 'drill'){
			push @{$layer_class{drill}},$gROWname[$_];
		}elsif ($gROWlayer_type[$_] eq 'rout'){
			push @{$layer_class{rout}},$gROWname[$_];
		}elsif ($gROWlayer_type[$_] eq 'silk_screen'){
			push @{$layer_class{silk_screen}},$gROWname[$_];
		}
	}
}
###__________________________fiducial  $size_fiducial,$size_mask,$size_tool,
my $symbol_ring;
if ($size_ring) {
    $size_ring =~ m{x};
    $symbol_ring='donut_r'.(substr $`/$I2M*1000,0,7 ).($&).(substr $'/$I2M*1000,0,7);
}else{
    $symbol_ring=undef;
}

my $symbol_fiducial='r'.($size_fiducial/$I2M*1000);
my $symbol_mask='r'.($size_mask/$I2M*1000);
my $symbol_tool='r'.($size_tool/$I2M*1000);
my $symbol_tool_mask='r'.($size_tool/$I2M*1000+8);
my $i=0;
foreach    (    @{$layer_class{outer}} ,@{$layer_class{solder_mask}}   ) {
	clear($_);
	if ($button_fiducial{11}{5}->cget(-text) eq "@" and $direction ne 'W' and $direction ne 'S') {
			my $x=$px-$fiducial{12}{5};
			my $y=$py-$fiducial{11}{4};
			if ($i<2) {
			    add_pad($x,$y,$symbol_fiducial);
			    add_pad($x,$y,$symbol_ring) if $symbol_ring;
			}else{
				add_pad($x,$y,$symbol_mask);				
			}
	}
	if ($button_fiducial{1}{5}->cget(-text) eq "@" and $direction ne 'S' and $direction ne 'E') {
			my $x=0+$fiducial{0}{5};
			my $y=$py-$fiducial{1}{4};
			if ($i<2) {
			    add_pad($x,$y,$symbol_fiducial);
			    add_pad($x,$y,$symbol_ring) if $symbol_ring;
			}else{
				add_pad($x,$y,$symbol_mask);
			}
	}
	if ($button_fiducial{1}{9}->cget(-text) eq "@" and $direction ne 'N' and $direction ne 'E') {
			my $x=$0+$fiducial{0}{9};
			my $y=$0+$fiducial{1}{10};
			if ($i<2) {
			    add_pad($x,$y,$symbol_fiducial);
			    add_pad($x,$y,$symbol_ring) if $symbol_ring;
			}else{
				add_pad($x,$y,$symbol_mask);
			}
	}
	if ($button_fiducial{11}{9}->cget(-text) eq "@" and $direction ne 'N' and $direction ne 'W') {
			my $x=$px-$fiducial{12}{9};
			my $y=$0+$fiducial{11}{10};
			if ($i<2) {
			    add_pad($x,$y,$symbol_fiducial);
			    add_pad($x,$y,$symbol_ring) if $symbol_ring;
			}else{
				add_pad($x,$y,$symbol_mask);
			}	
	}
    $i++;
}
###___________________
my $ii=0;
foreach  ('drl', @{$layer_class{solder_mask}}) {
	clear($_);
	if ($button_tool{11}{13}->cget(-text) eq "D" and $direction ne 'W' and $direction ne 'S') {
		my $x=$px-$tool{12}{13};
		my $y=$py-$tool{11}{12};
		if ($ii==0) {
			add_pad($x,$y,$symbol_tool);
		}else{
			add_pad($x,$y,$symbol_tool_mask);
		}
	}
	if ($button_tool{1}{13}->cget(-text) eq "D" and $direction ne 'S' and $direction ne 'E') {
		my $x=0+$tool{0}{13};
		my $y=$py-$tool{1}{12};
		if ($ii==0) {
			add_pad($x,$y,$symbol_tool);
		}else{
			add_pad($x,$y,$symbol_tool_mask);
		}
	}
	if ($button_tool{1}{17}->cget(-text) eq "D" and $direction ne 'N' and $direction ne 'E') {
		my $x=0+$tool{0}{17};
		my $y=0+$tool{1}{18};
		if ($ii==0) {
			add_pad($x,$y,$symbol_tool);
		}else{
			add_pad($x,$y,$symbol_tool_mask);
		}
	}
	if ($button_tool{11}{17}->cget(-text) eq "D" and $direction ne 'W' and $direction ne 'N') {
		my $x=$px-$tool{12}{17};
		my $y=0+$tool{11}{18};
		if ($ii==0) {
			add_pad($x,$y,$symbol_tool);
		}else{
			add_pad($x,$y,$symbol_tool_mask);
		}
	}
    $ii++;
}


1;


