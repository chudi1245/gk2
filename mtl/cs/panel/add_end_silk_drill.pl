use strict;
use warnings;

my $JOB=$main::JOB;
my @sypad=@main::sypad;   
########  $sypad[2]{x}

my @end_size=@{info('layer',"$JOB/pcb/drl",'tool')->{gTOOLdrill_size}};
if (exists_entity('step',"$JOB/pcs") eq 'yes') {
	@end_size= (  @end_size, @{info('layer',"$JOB/pcs/drl",'tool')->{gTOOLdrill_size}}  );
}
@end_size=sort{$a<=>$b}@end_size;

@main::end_drill = @end_size;

clear('drl');
my ($end_drill_x,$end_drill_y)=($sypad[1]{x} + 0.05,  $main::sypad[4]{y}+1.0,  );    ####尾孔添加座标：

###2014-01-06 修改
if ($main::layer_number >= 3){
   ($end_drill_x,$end_drill_y)=($sypad[1]{x} + 0.05,  $main::sypad[4]{y}+1.0,  );    ####尾孔添加座标：
}
foreach   (@end_size){
    $end_drill_y = $end_drill_y + $_/1000 + 0.0195; 
    my $symbol="r$_";
	####钻孔单位是MIL，座标单位是inch；
	##cur_atr_set('.drill_first_last','last');
	add_pad($end_drill_x,$end_drill_y,$symbol,,'no',0,'yes'); 
    if ($end_drill_y +0.5 > $main::grid{y}[3]) {
	   $end_drill_y=$main::sypad[4]{y}+0.2;
	   $end_drill_x+=0.2;
    }
}

cur_atr_set(); 

##add________________________________________

1;

=head

COM sel_single_feat,operation=select,x=1.7054622047,y=1.4587318898,tol=2.9229330709,cyclic=no
COM cur_atr_set,attribute=.drill_first_last,option=last
COM sel_change_atr,mode=add

	cur_atr_set('.out_scale');
	_add_rivet('md');
	cur_atr_set();
$f->COM ('cur_atr_set',attribute=>$attribute);


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


foreach  ( 'drl',@{$main::layer_class{outer}}  ) {
my $name=$_;
my $symbol='r1';

clear($_);

my ($end_drill_x,$end_drill_y)=($main::sypad[4]{x},  $main::sypad[4]{y}+0.7,  );   ####尾孔添加座标：

foreach   (@end_size){
   $end_drill_y = $end_drill_y + $_/1000 + 0.0195; 

   if ($name eq 'drl') {  $symbol="r$_";}
   ####钻孔单位是MIL，座标单位是inch；
   add_pad($end_drill_x,$end_drill_y,$symbol,);
   
   if ($end_drill_y +0.5 > $main::grid{y}[3]) {
	   $end_drill_y=$main::sypad[4]{y}+0.2;
	   $end_drill_x+=0.2;
     }
}

}







