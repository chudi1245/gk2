use strict;
use warnings;
my $class=\%main::layer_class;
my @sypad=@main::sypad;

###���ü�˿ӡ��λpad�Ĳ� 
my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\solder_mask silk_screen\);

###���ü����������� 2013.6.29�޸�
my $flag=0;
my ($pin_cent,$pin1_x,$pin1_y,$pin2_x,$pin2_y);

if	($main::px <= $main::py and $main::py >= 12){

	$pin_cent = $main::py /2;
	if ($main::layer_number < 3){
		$pin1_x= $sypad[2]{x} ;          #### $main::Prof_xmin + 0.157480 ;
	}else{
		$pin1_x= $pin1_x= $sypad[2]{x};         #### $main::SR_xmin - 0.27559;
	}
	$pin2_x = $pin1_x;
	$pin1_y = $pin_cent - 5.0196850;
	$pin2_y = $pin_cent + 5.0196850;
	$flag=1;
}elsif  ($main::px > $main::py and $main::px >= 12) {
	$pin_cent = $main::px / 2;
	$pin1_x = $pin_cent - 5.0196850;
	$pin2_x = $pin_cent + 5.0196850;
	if ($main::layer_number < 3){
		$pin1_y =  $sypad[4]{y};    ####   $main::Prof_ymin + 0.15748 ;		
	}else{
		$pin1_y =  $sypad[4]{y};    ####   $main::SR_ymin - 0.27559;
	}
	$pin2_y= $pin1_y;
	$flag=1;
}else{
    p__("The Panel size is too small,please check");
}
##������
clear();
add_pin();
add_syspad();
add_Mark_line();
add_Mark_solder();

##�ڴ�Ӷ�λpad
if ( exists $class->{inner}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{inner}}, );
    map { add_pad($sypad[$_]{x},$sypad[$_]{y},'inmark') }(0..$#sypad);
	add_second_pad('inmark',0);
}

##˫��壬��1.0mm�İ�ǿ�
if ($main::layer_number < 3) {clear('drl');
       add_pad(0.03937,                          0.03937, 'r38.976',);
	   add_pad(0.03937,              $main::py - 0.03937, 'r38.976',);
	   add_pad($main::px - 0.03937,  $main::py - 0.03937, 'r38.976',);
	   add_pad($main::px - 0.03937,              0.03937, 'r38.976',);
}
#######################################################
##�����壬�ӹҿס�
my ($hasx1,$hasy1,$hasx2,$hasy2);
if ( $main::layer_number > 1 ) {	
	if ($main::face_type eq 'hasl' or $main::face_type eq 'nled') {
    #p__("add gua hole");


	$hasx1 = $main::grid{x}[7] + 0.85;
    $hasy1 = $sypad[0]{y};

    $hasx2 = $sypad[0]{x};
	$hasy2 = $main::grid{y}[7] + 0.85;

	my $res_x= ($main::px-$main::SR_xmax)*$main::I_M;
	my $res_y= ($main::py-$main::SR_ymax)*$main::I_M;

    #2014-6-10 ע��
	#if ($res_x > 13){$hasy1=$main::SR_ymax + 0.315;} else {$hasy1=$main::py - 0.15;}
	#if ($res_y > 13){$hasx2=$main::SR_xmax + 0.315;} else {$hasx2=$main::px - 0.15;}

	clear('drl');
	add_pad($hasx1,$hasy1,'r125');
	add_pad($hasx2,$hasy2,'r125');

	}
}

#######################################################��˿ӡ��λ 2013.6.29�޸�
sub add_syspad{
	##�躸���ַ�����3.1mm��pad.
	if ($add_layer[0]) {
		clear();
		affected_layer('yes','single',@add_layer);
		map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r122.047') }(0..$#sypad);
		add_second_pad('r122.047');
	}
	##��ײ��3.175�Ŀס�
	if ( exists $class->{drill}  ){
		my @add_drl = @{$class->{drill}};
		push (@add_drl,'drlp');
		clear();
		affected_layer('yes', 'single', @add_drl, );
		map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r125') }(0..$#sypad);
		add_second_pad('r125');
	}	
}


###########################################�����׵����Ҫ��

sub add_pin{

	##��ײ��3.175��˿ӡ��λpad
	if (exists $class->{drill} and $flag==1 ) {
		clear();
        affected_layer('yes', 'single', 'drl', );  
		### affected_layer('yes', 'single', @{$class->{drill}}, );   2014-6-10 �޸�
		add_pinpad('r125');
	}

	##�����·��5mm pad
	if (exists $class->{outer} and $flag==1 ) {
		clear();
        affected_layer('yes', 'single', @{$class->{outer}}, );	
		add_pinpad('r196.85');
		##ƴ����ɾ���ܿ���pad
		add_pinpad('r200.75');
	}
	##�躸���3.1mm pad
	if (exists $class->{solder_mask} and $flag==1 ) {
		clear();
        affected_layer('yes', 'single', @{$class->{solder_mask}}, );
		add_pinpad('r122.05');
	}
}

sub add_pinpad{
	my $symbol=shift;
	add_pad($pin1_x,$pin1_y,$symbol);
	add_pad($pin2_x,$pin2_y,$symbol);
}

#############################################�����·�Զ��ع���ֹ�ѧ��λ������  2013.6.29�޸�
sub add_Mark_line {
	if ( exists_layer('gtl') eq 'yes' ) {
		clear('gtl');
		add_pad($sypad[0]{x},$sypad[0]{y},'r122.047');  ##��һ��˿ӡ��λpad ���Ͻ�
		map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r39.37') }(1..$#sypad);
		map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r118.11') }(1..$#sypad);
		add_second_pad('r39.37');
		add_second_pad('r118.11');
		}
	if ( exists_layer('gbl') eq 'yes' ) {
		clear('gbl');
		add_pad($sypad[0]{x},$sypad[0]{y},'r122.047');  ##��һ��˿ӡ��λpad  ���Ͻ�
		map { add_pad($sypad[$_]{x},$sypad[$_]{y},'donut_r89.614x70.866') }(1..$#sypad);
#		map { add_pad($sypad[$_]{x},$sypad[$_]{y},'rect12x100' , 'no', 0,  'yes') }(1..$#sypad);
#		map { add_pad($sypad[$_]{x},$sypad[$_]{y},'rect12x100' , 'no', 90, 'yes') }(1..$#sypad);
		
		add_second_pad('donut_r89.614x70.866');
#		add_second_pad('rect12x100',0);
#		add_second_pad('rect12x100',90);
		
		}
}


###########################################�躸�Զ��ع���ֹ�ѧ������
sub add_Mark_solder{
	if (exists $class->{outer} ){
		clear();
        affected_layer('yes', 'single', @{$class->{outer}}, );
		#p__("add_solderpad ok!");
		add_solderpad('r98.425');  #��·���2.5mm��pad.

		add_solderpad('r187.05');  #��·��ӱܿ���pad��ƴ����Զ�ɾ��
	}
	if (exists $class->{solder_mask} ){
		clear();
        affected_layer('yes', 'single', @{$class->{solder_mask}}, );
		#p__("add_solderpad ok!");
		add_solderpad('r39.37');  #�躸���1.0mm��pad����
		
	}
}


sub add_solderpad {
	my $symbol=shift;
	my $off=0.1181;    
	my $nea=0.46378;

	add_pad($main::SR_xmin - $off, $main::SR_ymin + $nea,$symbol); #����
	add_pad($main::SR_xmin + $nea, $main::SR_ymin - $off,$symbol); 

	add_pad($main::SR_xmax - $nea, $main::SR_ymin - $off,$symbol); #����
	add_pad($main::SR_xmax + $off, $main::SR_ymin + $nea,$symbol);

	add_pad($main::SR_xmax + $off, $main::SR_ymax - $nea,$symbol); #����
	add_pad($main::SR_xmax - $nea, $main::SR_ymax + $off,$symbol);

	add_pad($main::SR_xmin + $nea, $main::SR_ymax + $off,$symbol); #����
	add_pad($main::SR_xmin - $off, $main::SR_ymax - $nea,$symbol);
}


####################################################����ĸ�˿ӡ��λ�ף��ӳ���
sub add_second_pad{	
	my $symbol=shift;
	my $rorate=shift||0;

	my $off=0.23622;    
	add_pad($sypad[0]{x},$sypad[0]{y}-$off-$off,$symbol, 'no', $rorate);
	add_pad($sypad[2]{x},$sypad[2]{y}-$off,$symbol, 'no', $rorate);
	add_pad($sypad[3]{x},$sypad[3]{y}+$off,$symbol, 'no', $rorate);
	add_pad($sypad[4]{x},$sypad[4]{y}+$off,$symbol, 'no', $rorate);
}

clear();

1;




=head

265.75 

2014-01-01 ���ݡ�
sub add_solderpad {
	my $symbol=shift;
	my $off=0.70;    
	my $nea=0.12;

	add_pad($sypad[0]{x} - $off,$sypad[0]{y}-$nea,$symbol);
	add_pad($sypad[0]{x}-$nea,$sypad[0]{y} - $off,$symbol);
	add_pad($sypad[2]{x} + $off,$sypad[2]{y}-$nea,$symbol);
	add_pad($sypad[2]{x}+$nea,$sypad[2]{y} - $off,$symbol);
	add_pad($sypad[3]{x} + $off,$sypad[3]{y}+$nea,$symbol);
	add_pad($sypad[3]{x}+$nea,$sypad[3]{y} + $off,$symbol);
	add_pad($sypad[4]{x} - $off,$sypad[4]{y}+$nea,$symbol);
	add_pad($sypad[4]{x}-$nea,$sypad[4]{y} + $off,$symbol);
}

#���������׵����Ҫ��
#1����ײ�����2���׾�Ϊ3.175mm����ף���˿ӡ��λ��һ�ѵ����������׵����ļ��Ϊ255mm��
#   һ�������ƴ��ĳ���(�̱�Ҳ����ӣ����ǳ��������12 inch)�����������ĵ���Ӧ��ߵ�
#   ���ĵľ���Ϊ127.5mm�����������ĵ���Ч�ߵľ����7mm��
#2���������׶�Ӧλ�ã������·��8mmԲPAD��ͭ��������5mmԲPAD��
#3���躸����������λ������3.1mm�Ŀ���

#p__("add_syspad end");
foreach (1..13) {
	$main::grid{x}[$_]=$main::SR_xmin + ($_*2-1)*($main::SR_xmax - $main::SR_xmin)/26;
	$main::grid{y}[$_]=$main::SR_ymin + ($_*2-1)*($main::SR_ymax - $main::SR_ymin)/26;
}


##########�����Լ�PAD
my %grid=%main::grid;
foreach  (1..13) {

	clear('drl');
   add_pad(   $main::grid{x}[$_],   0.3,                'r128');
   add_pad(   0.3,                 $main::grid{y}[$_],  'r128');
}
##########


clear('gtl','gbl','gts','gbs');
p__('text ok');

set pxgkx1 = `echo "scale=10;$coordx5 + 0.338" | bc`
set pxgky2 = `echo "scale=10;$coordy5 + 0.338" | bc`

if ( `echo "if ($gybsx < 13) 1" | bc` ) then
set pxgky1 = `echo "scale=10;$gSR_LIMITSymax + 0.19685" | bc`
endif 
if ( `echo "if ($gybsx >= 13) 1" | bc` ) then
set pxgky1 = `echo "scale=10;$py - 0.3385" | bc`
endif 
if ( `echo "if ($gybzy < 13) 1" | bc` ) then
set pxgkx2 = `echo "scale=10;$gSR_LIMITSxmax + 0.19685" | bc`
endif
if ( `echo "if ($gybzy >= 13) 1" | bc` ) then
set pxgkx2 = `echo "scale=10;$px - 0.3385" | bc`
endif
if ($hals == 2) then
COM add_pad,attributes=no,x=$pxgkx1,y=$pxgky1,symbol=r125,\
polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
COM add_pad,attributes=no,x=$pxgkx2,y=$pxgky2,symbol=r125,\
polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
endif

###6-29�޸�

my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\outer solder_mask silk_screen drill\);

clear();
affected_layer('yes','single',@add_layer);
map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r125') }(0..$#sypad);

