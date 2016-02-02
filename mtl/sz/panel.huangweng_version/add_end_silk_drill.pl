use strict;
use warnings;

my $JOB=$main::JOB;

my @end_size=@{info('layer',"$JOB/pcb/drl",'tool')->{gTOOLdrill_size}};
if (exists_entity('step',"$JOB/pcs") eq 'yes') {
	@end_size= (  @end_size, @{info('layer',"$JOB/pcs/drl",'tool')->{gTOOLdrill_size}}  );
}

@end_size=sort{$a<=>$b}@end_size;

#$main::f->COM ('cur_atr_set',attribute=>'.drill_first_last',option=>'last');

cur_atr_set('.drill_first_last','last');

foreach  ( 'drl',@{$main::layer_class{outer}}  ) {
	my $name=$_;
	my $symbol='r1';

	clear($_);
	my ($end_drill_x, $end_drill_y) = ($main::sypad[4]{x},  $main::sypad[4]{y}+0.7,  );

	foreach   (@end_size){
	   $end_drill_y = $end_drill_y + $_/1000 + 0.0195; 
	   if ($name eq 'drl') { 
		   $symbol="r$_"; 
	   }else{
		   my $size = $_ + 12;
	       $symbol="r$size"; 
	   }

	   add_pad($end_drill_x,$end_drill_y,$symbol,'no', 0, 'yes',);
	  
	   if ($end_drill_y +0.5 > $main::grid{y}[3]) {
		   $end_drill_y=$main::sypad[4]{y}+0.2;
		   $end_drill_x+=0.2;
	   }
	   #p__("please see attr")
	}
}

cur_atr_set();

#$main::f->COM ('cur_atr_reset');

##add________________________________________

1;

=head

clear('drl');
my $cy=$main::cy_area;
my $off;
my $mm5=0.1968;
my $mm4=0.1575;

if($main::layer_number <= 2) {
	$off=$mm4;
}else{
	$off=$mm5;
}

my $drill_pss={
	top=>{x=>$main::grid{x}[7]-0.3   ,y=> $cy->{top}-$off  },
	bot=>{x=>$main::grid{x}[7]-0.3   ,y=> $cy->{bot}+$off  },
};
cur_atr_set('.zk','top');
add_pad($drill_pss->{top}{x},$drill_pss->{top}{y}, 'r125','no',0,'yes');
cur_atr_set('.zk','bot');
add_pad($drill_pss->{bot}{x},$drill_pss->{bot}{y}, 'r125','no',0,'yes');
cur_atr_set();
clear();





	my $ref=info('layer', "$main::JOB/$main::STEP/cy",'LIMITS');
	##5mm=0.1968
	my $off_set=0.1968;
	my @pos=( $ref->{gLIMITSxmin}+$off_set,  $ref->{gLIMITSymin}+$off_set,  $ref->{gLIMITSxmax}-$off_set,   $ref->{gLIMITSymax}-$off_set);