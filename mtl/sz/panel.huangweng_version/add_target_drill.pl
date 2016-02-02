use strict;
use warnings;
goto LABEL_TARGET_DRILL_END if ($main::layer_number < 3);
my %grid=%main::grid;

my ($off_setx,$off_sety);##
my $res_x= ($main::px-$main::SR_xmax)*$main::I_M;
my $res_y= ($main::py-$main::SR_ymax)*$main::I_M;

if ($res_x < 15){$off_setx=0.32;} else {$off_setx=0.39;}
if ($res_y < 15){$off_sety=0.32;} else {$off_sety=0.39;}

my $start_point=$main::start_point;
my ($left_top,$left_mid);
$left_top = $start_point + 3.74;
if ($main::py >15 ) {
	$left_mid = $start_point - 1.15;
}else{
	$left_mid = $start_point + 1.15;
}

#my $rlgdy=$grid{y}[7]-0.8;
my $zkbotx=$grid{x}[5]+0.5;

my %target_drill=(
  top=>$main::SR_ymax+$off_sety,
  bot=>$main::SR_ymin-$off_sety,
  rig=>$main::SR_xmax+$off_setx,
  lef=>$main::SR_xmin-$off_setx,
);
#——————————————————————下面产生随机数值。

my $randtop,
my $randsha; 
my $randxia; 
##设定一个数组，存储100个变量，从-0.7英寸 到 正0.7英寸
my @a;
my $b=-0.7; ##初始赋值
foreach (0..70) {
	push @a,$b;
	$b+=0.02;
	}
while ( abs($randtop) < 0.04){
	$randtop=rand(0.5)-0.35;
	}
##第一次取数组中的某一个值
my $flag=int(rand(70));
my $randsha=$a[$flag];
##第二次取数组中的某一个值
my $flag1=int(rand(70));
my $randxia=$a[$flag1];
##上面的变化值设为randSmall，下面的变化值为randSmall
##如果上面为负数，则反方向移动。如果上面为正数，则相对移动。

if($randsha<=0){ 
	$randxia =   abs($randxia);
}else{  
	$randxia = -(abs($randxia));
}

##p__("$randSmall,$randBig");
clear();
affected_layer('yes', 'single', @{$main::layer_class{inner}}, );
add_target_drill('zk');
clear();

#affected_layer('yes', 'single', @{$main::layer_class{outer}}, );
#add_target_drill('r126');
#clear();

if ( exists_layer('zkout')  eq  'yes' ) {
	$main::f->COM('delete_layer',layer => "zkout");
}
creat_clear_layer('zkout');
clear('zkout');
add_target_drill('s408');
clear();

clear('drl');
add_target_drill('r125.039');   ###my $symb='r125.039'; ##3.176
cur_atr_set();
clear();


#————————————加5个靶孔，右边一个，左边两个，上边一个，下边一个。
sub add_target_drill {
	my $symbol=shift;
    #右边中间
    add_pad($target_drill{rig},$left_mid + $randxia,    $symbol,);
	#左边中间
	add_pad($target_drill{lef},$left_mid + $randxia,    $symbol,);
    #左边靠上
    add_pad($target_drill{lef},$left_top + $randsha,    $symbol,);
    #上边。
    add_pad($grid{x}[9]+($randtop/2),$target_drill{top},$symbol,);
	#下边。
	add_pad($zkbotx+($randtop/2),    $target_drill{bot},$symbol,);
}


LABEL_TARGET_DRILL_END: ;

1;





=head


clear('drl');
	my $symb='r125.039'; ##3.176

	add_pad($target_drill{rig},$rlgdy+$randSmall,$symb,'no',0,'yes');
	add_pad($target_drill{lef},$rlgdy+$randSmall,$symb,'no',0,'yes');
	
	add_pad($target_drill{lef},$grid{y}[9]+$randBig,$symb,'no',0,'yes');
	
	add_pad($grid{x}[9]+($rand1/2),$target_drill{top},$symb,'no',0,'yes');
	add_pad($zkbotx+($rand1/2),$target_drill{bot},$symb,'no',0,'yes');
	
	cur_atr_set();
	clear();
