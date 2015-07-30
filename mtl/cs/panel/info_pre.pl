use strict;
no strict 'vars';
##p__("ok!");
my $info_ref=info('matrix',"$JOB/matrix",'row');
@gROWrow       =@{$info_ref->{gROWrow}};
@gROWcontext   =@{$info_ref->{gROWcontext}};
@gROWside      =@{$info_ref->{gROWside}};
@gROWlayer_type=@{$info_ref->{gROWlayer_type}};
@gROWname      =@{$info_ref->{gROWname}};
@gROWtype      =@{$info_ref->{gROWtype}};
@gROWfoil_side =@{$info_ref->{gROWfoil_side}};


$layer_number=0;
foreach  (0..$#gROWrow) {
	if ($gROWcontext[$_] eq 'board'){
		push @{$layer_class{board}},$gROWname[$_];
		if ($gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
			$layer_number++;
			push @{$layer_class{line}},$gROWname[$_];
		    
			if ($gROWside[$_] eq 'inner'){
			    push @{$layer_class{inner}},$gROWname[$_];
		    }else{
				push @{$layer_class{outer}},$gROWname[$_];
			}
		}elsif ($gROWlayer_type[$_] eq 'solder_mask'){
			push @{$layer_class{solder_mask}},$gROWname[$_];
		}elsif ($gROWlayer_type[$_] eq 'drill'){
			push @{$layer_class{drill}},$gROWname[$_];
		}elsif ($gROWlayer_type[$_] eq 'silk_screen'){
			push @{$layer_class{silk_screen}},$gROWname[$_];
		}
	}
}


###________________________
if ($layer_number<=2) {
	map{ $main::margin->{$_} = 8   }keys %{$main::margin};
}elsif($layer_number<=5 and @{$main::layer_class{inner}}[0] !~ m/l2b/i  ){
	map{ $main::margin->{$_} = 13   }keys %{$main::margin};
}else{
	map{ $main::margin->{$_} = 18   }keys %{$main::margin};
}

1;