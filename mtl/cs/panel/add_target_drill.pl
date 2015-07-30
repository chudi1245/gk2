use strict;
use warnings;
goto LABEL_TARGET_DRILL_END if ($main::layer_number < 3);
my %grid=%main::grid;

my ($off_setx,$off_sety)=(0.31496,0.31496 );

my $res_x= ($main::px-$main::SR_xmax)*$main::I_M;
my $res_y= ($main::py-$main::SR_ymax)*$main::I_M;

if ($res_x < 15){$off_setx=0.26;} 
if ($res_y < 15){$off_sety=0.26;}

my $rand;
while ( abs($rand) < 0.12) { $rand=rand(0.5)-0.35; }    ####  产生的随机数，必须大于0.12。abs取绝对值，正是正，负变正。

my @target_drill=(
  {x=>$main::SR_xmin-$off_setx,  y=>$grid{y}[5]         },
  {x=>$main::SR_xmax+$off_setx,  y=>$grid{y}[5]         },
  {x=>$main::SR_xmin-$off_setx,  y=>$grid{y}[12]+$rand+0.45  },
  
  {x=>$grid{x}[4]-$rand + 0.2,   y=>$main::SR_ymax+$off_sety},
  {x=>$grid{x}[11]+$rand,        y=>$main::SR_ymax+$off_sety},
  {x=>$grid{x}[11]+$rand,	     y=>$main::SR_ymin-$off_sety},
);

clear();  #####x=>$grid{x}[11]+$rand，         y=>$main::SR_ymax+$off_sety},
affected_layer('yes', 'single', @{$main::layer_class{inner}}, );  ###把内层设为影响层
add_target_drill('zk');

clear();

#affected_layer('yes', 'single', @{$main::layer_class{outer}}, );  ###把外层设为影响层,外层添加避开的物体。
#add_target_drill('r126');
#clear();

#my @add_drl = ();
#push (@add_drl,'drl');
#push (@add_drl,'drl');
#clear('drl','drlp'); 
clear('drl');                      ####打开钻孔层。
add_target_drill('r125.039');
cur_atr_set();
clear();


my $bk_map = "$main::JOB"."-"."bk";   

if ( exists_layer($bk_map) eq 'yes' ) {$main::f->COM("delete_layer,layer=$bk_map");} 

creat_clear_layer($bk_map);

##_______________________________________
my ($gap1x,$gap1y)=($main::px/2,                  $target_drill[0]{y} +0.35);
my ($gap2x,$gap2y)=($target_drill[0]{x} +0.5,     $target_drill[0]{y} +0.35);
my ($gap3x,$gap3y)=($grid{x}[10] + 0.5,            $main::py/2 +0.85);
my ($gap4x,$gap4y)=($grid{x}[9] + 0.1,            $main::py   -0.85);

my($maptx,$mapty)=($main::px/2 + 1.0,             $main::py + 0.4 );
my($jobnx,$jobny)=($maptx-2.75,                   $mapty-0.125    );
##______________________________________
my $bk_gap1=sprintf "%6.2f",(($target_drill[1]{x} - $target_drill[0]{x})*25.4);
my $bk_gap2=sprintf "%6.2f",(($target_drill[2]{y} - $target_drill[0]{y})*25.4);

my $bk_gap3=sprintf "%6.2f",(($target_drill[3]{y} - $target_drill[5]{y})*25.4);
my $bk_gap4=sprintf "%6.2f",(($target_drill[4]{x} - $target_drill[3]{x})*25.4);

my $unit1="$bk_gap1"."MM";
my $unit2="$bk_gap2"."MM";
my $unit3="$bk_gap3"."MM";
my $unit4="$bk_gap4"."MM";

##_____________________________________加6个钻孔。

add_target_drill('r125.039');
##——————————————————添加距离值。

add_bktext($gap1x,$gap1y,$unit1);
add_bktext($gap2x,$gap2y,$unit2);
add_bktext($gap3x,$gap3y,$unit3);
add_bktext($gap4x,$gap4y,$unit4);

##——————————————————加档案号
add_bktext($jobnx,$jobny,$main::JOB);
##——————————————————加文字“靶标示意图”
add_pad( $maptx,$mapty, 'bbsy');
##_________________________________靶孔之间连线。
add_line($target_drill[0]{x},$target_drill[0]{y},$target_drill[1]{x},$target_drill[1]{y},'r10');
add_line($target_drill[0]{x},$target_drill[0]{y},$target_drill[2]{x},$target_drill[2]{y},'r10');

add_line($target_drill[4]{x},$target_drill[4]{y},$target_drill[3]{x},$target_drill[3]{y},'r10');
add_line($target_drill[4]{x},$target_drill[4]{y},$target_drill[5]{x},$target_drill[5]{y},'r10');
##__________________________________加拼板尺寸，框。
add_line(0,          0,                0,          $main::py,  'r10');
add_line(0,          $main::py,        $main::px,  $main::py,  'r10');
add_line($main::px,  $main::py,        $main::px,  0,          'r10');
add_line($main::px,  0,                0,          0,          'r10');

 clear();


sub add_target_drill {
	my $symbol=shift;
    add_pad($target_drill[0]{x},$target_drill[0]{y},$symbol,);
    add_pad($target_drill[1]{x},$target_drill[1]{y},$symbol,);
    add_pad($target_drill[2]{x},$target_drill[2]{y},$symbol,);
    
	add_pad($target_drill[3]{x},$target_drill[3]{y},$symbol,);
	add_pad($target_drill[4]{x},$target_drill[4]{y},$symbol,);
	add_pad($target_drill[5]{x},$target_drill[5]{y},$symbol,);
}

sub add_bktext  {
       my $x=shift||0;
       my $y=shift||0;
       my $text=shift||'nothing';
       my $mirror=shift||'no';
       my $angle=shift||0; 

       $main::f->COM ('add_text',
       attributes         =>'no',
       type               =>'string',
       x                  =>$x,
       y                  =>$y,
       text               =>$text,
       x_size             =>0.26,
       y_size             =>0.32,
       w_factor           =>1.25,
       polarity           =>'positive',
       angle              =>$angle ,
       mirror             =>$mirror,
       fontname           =>'standard',
       bar_type           =>'UPC39',
       bar_char_set       =>'full_ascii',
       bar128_code        =>'none',
       bar_checksum       =>'no',
       bar_background     =>'yes',
       bar_add_string     =>'yes',
       bar_add_string_pos =>'top',
       bar_width          =>0.001,
       bar_height         =>0.2,
       ver               =>1);
}

##p__("targer is no "); 

LABEL_TARGET_DRILL_END:  ;

1;



=head
my $drl_pp = "$main::JOB"."-"."pp";

if ( exists_layer($drl_pp) eq 'yes' ) {$main::f->COM("delete_layer,layer=$drl_pp");}
	creat_clear_layer($drl_pp);
    add_pad($ope_lefx, $ope_lefy, 'zkpt', 'no', 90,   'yes');
	add_pad($ope_botx, $ope_boty, 'zkpt', 'no', 0,  'yes');
	add_pad($ope_rigx, $ope_rigy, 'zkpt', 'no', 90,  'yes');
	add_pad($ope_topx, $ope_topy, 'zkpt', 'no', 0,   'yes');
  
	#################加圆形铆钉。
	add_pad($ope_lefx, $ope_lefy-0.53, 'r157.48',);
	add_pad($ope_botx-0.53, $ope_boty, 'r157.48',);
	add_pad($ope_rigx, $ope_rigy-0.53, 'r157.48',);
	add_pad($ope_topx-0.53, $ope_topy, 'r157.48',);

    add_pad(0.03937,                         0.03937, 'r39.37',);
	add_pad(0.03937,             $main::py - 0.03937, 'r39.37',);
	add_pad($main::px - 0.03937, $main::py - 0.03937, 'r39.37',);
	add_pad($main::px - 0.03937,             0.03937, 'r39.37',);
    clear();



