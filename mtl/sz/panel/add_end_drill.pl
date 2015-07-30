use strict;
use warnings;

my $JOB=$main::JOB;
my @end_size=@{info('layer',"$JOB/pcb/drl",'tool')->{gTOOLdrill_size}};

if (exists_entity('step',"$JOB/pcs") eq 'yes') {
	@end_size= (  @end_size, @{info('layer',"$JOB/pcs/drl",'tool')->{gTOOLdrill_size}}  );
}

@end_size=sort{$a<=>$b}@end_size;
clear('drl');

my ($end_drill_x,$end_drill_y)=($main::sypad[4]{x},  $main::sypad[4]{y}+0.2,  );
foreach   (@end_size){
   $end_drill_y = $end_drill_y + $_/1000 + 0.0195; 
   add_pad($end_drill_x,$end_drill_y,"r$_",);
   if ($end_drill_y +0.5 > $main::grid{y}[3]) {
	   $end_drill_y=$main::sypad[4]{y}+0.2;
	   $end_drill_x+=0.2;
   }
}

##add print ss drill  .zk{top}  .zk{bot}
;  ##drill print silk screen
my $drill_pss={
	top=>{x=>$main::grid{x}[7]-0.3   ,y=> $main::py-0.25   },
	bot=>{x=>$main::grid{x}[7]-0.3   ,y=>    0.25   },
};

cur_atr_set('.zk','top');
add_pad($drill_pss->{top}{x},$drill_pss->{top}{y}, 'r125','no',0,'yes');
cur_atr_set('.zk','bot');
add_pad($drill_pss->{bot}{x},$drill_pss->{bot}{y}, 'r125','no',0,'yes');
cur_atr_set();


clear();



1;


=head
$grid{y}[3]

#!/usr/bin/csh
COM display_layer,name=drl,display=yes,number=1
COM work_layer,name=drl
COM units,type=inch  
COM info,out_file=c:/tmp/wdrl,write_mode=replace,\
args=-t layer -e $JOB/pcb/drl 
source c:/tmp/wdrl
COM info,out_file=c:/tmp/wstep,write_mode=replace,\
args=-t step -e $JOB/$step
source c:/tmp/wstep
COM info,out_file=c:/tmp/wmatrix,write_mode=replace,\
args=-t matrix -e $JOB/matrix 
source c:/tmp/wmatrix

set wkx = $syp3x
set wky = `echo "scale=10;$syp3y + 0.39685" | bc` 

foreach  j  ($gTOOLdrill_size)
   set wky = `echo "scale=10;$wky + $j/1000 + 0.0195" | bc` 
   COM add_pad,attributes=no,x=$wkx,y=$wky,symbol=r$j,\
   polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1


endif
end
