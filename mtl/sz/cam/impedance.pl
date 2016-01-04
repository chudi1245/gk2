#! /usr/bin/perl
use strict;
use encoding "utf8";
use Win32;
use Tk;
use Tk::Pane;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$cu_symbol,$max_row,$mw,$long,$imp_long,$error)=(0,0,25,0,undef,7.5);
my (@layer,@button_type,@entry_space,%col_type,%layer_sort)=('',);
###线路层；
my (@imp_layer,@ref_top,@ref_bot,@line_space,@cu_space,@layer_ref_top,@layer_ref_bot,@line_width,@imp_value,@expiate,@pos_col,@pos_row,@u_sig);
my (@checkbutton_u,@coord_x,);
my @number_list=(0..39);
###__________________________
kysy();

my @gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
my @gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
my @gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
foreach (0..$#gROWname){
	 if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
		 push @layer,$gROWname[$_];
		 $layer_sort{$gROWname[$_]}=$_;
	 }
}
#while (my( $key,$value) = each (%layer_sort) ) {
#    p__("$key=$value");
#}

###___________________________________________________mw
my $franm=MainWindow->new;   $franm->title("Better and better QQ_190170444");    $franm->geometry("+200+100");
$mw=$franm->Scrolled("Frame", -scrollbars =>'w',-height=>400 )->pack();
my @title=qw(阻抗层 类型 上参考层 下参考层 线宽 差距 共距 阻值 补偿 排 列 绕线 Dif2sig);
foreach(0..$#title) {
	my $width;($_ > 3) ? ($width=7) : ($width=10);
    $mw->Label(-text=>$title[$_],-relief=>'sunken',-font => [-family=>'黑体',-size=>12],-width=>$width)->grid(-column=>$column++,-row=>$row);  
} ;  $row++;
#p__("$row");
foreach  (@number_list) {
	$row++;
	$mw->Optionmenu(-options =>\@layer,-variable=>\$imp_layer[$_],-width=>4,)->grid(-column=>0,-row=>$row-1); ##阻抗层
	$button_type[$_]=$mw->Button(-text=>'dif',-width=>10,-command=>[\&chang_type,$_])->grid(-column=>1,-row=>$row-1); #类型：单线，差分。
	$mw->Optionmenu(-options =>\@layer,-textvariable=>\$ref_top[$_],-width=>4)->grid(-column=>2,-row=>$row-1); #上参考层
	$mw->Optionmenu(-options =>\@layer,-textvariable=>\$ref_bot[$_],-width=>4)->grid(-column=>3,-row=>$row-1); #下参考层
	$mw->Entry(-textvariable=>\$line_width[$_],-width=>6)->grid(-column=>4,-row=>$row-1); #线宽
	$entry_space[$_]=$mw->Entry(-textvariable=>\$line_space[$_],-width=>6,)->grid(-column=>5,-row=>$row-1); #补偿值
	$mw->Entry(-textvariable=>\$cu_space[$_],-width=>6,)->grid(-column=>6,-row=>$row-1); #参考铜的距离
	$mw->Entry(-textvariable=>\$imp_value[$_],-width=>6)->grid(-column=>7,-row=>$row-1); #阻抗值
	$mw->Entry(-textvariable=>\$expiate[$_],-width=>6)->grid(-column=>8,-row=>$row-1);   #补偿值
	$mw->Entry(-textvariable=>\$pos_col[$_],-width=>6)->grid(-column=>9,-row=>$row-1);   #排
	$mw->Entry(-textvariable=>\$pos_row[$_],-width=>6)->grid(-column=>10,-row=>$row-1);  #列
	$checkbutton_u[$_]=$mw->Checkbutton(-width=>4,-state=>'disabled',-variable =>\$u_sig[$_])->grid(-column=>11,-row=>$row-1); #绕线

}
$franm->Label(-textvariable=>\$error,-width=>120,-height=>1,-relief=>'ridge')->pack(-side => 'top' ,-fill=>'x'); #错误信息栏
$franm->Label(-text=>'阻抗条长',-width=>13,)->pack(-side => 'top',-anchor => 'w' ); #标答
$franm->Entry(-textvariable=>\$long,-width=>10,)->pack(-side => 'top' ,-anchor => 'w');  #阻抗条长度
$franm->Button(-text=>'刷新',-width=>10,-command=>\&brush,)->pack(-side => 'top' ,-anchor => 'w'); #刷新
$franm->Button(-text=>'Apply',-width=>10,-command=>\&apply,)->pack(-side => 'top' );  #执行
MainLoop;

####_________________________________________________________________________________________-
##类型改变子程序，在差分和单线中更换
sub chang_type{
	my $id=shift;
	my $text=$button_type[$id]->cget(-text);
	if ($text eq 'sig') {
		$button_type[$id]->configure(-text=>'dif'); #类型变为差分
		$entry_space[$id]->configure(-state=>'normal'); #差分间距输入栏变正常
 		$u_sig[$id]=undef; #绕线一栏的值变未定义
		$checkbutton_u[$id]->configure(-state=>'disabled'); #关闭绕线
	}else{
		$button_type[$id]->configure(-text=>'sig');  #类型变为单线
		$line_space[$id]=undef;  #线间距为未定义
		$entry_space[$id]->configure(-state=>'disabled'); ##关闭线间距输入栏
		$checkbutton_u[$id]->configure(-state=>'normal'); #绕线功能变为可用
	}
}
##刷新子程序，恢复默认状态，所有数据清空。
sub brush {
	foreach  (@number_list) {
		$imp_layer[$_]=$layer[0];
		$ref_top[$_]=$layer[0];
		$ref_bot[$_]=$layer[0];
		$button_type[$_]->configure(-text=>'dif'); #默认为差分
		$line_width[$_]=undef;
		$entry_space[$_]->configure(-state=>'normal'); #差分输入框，默认可输入
		$line_space[$_]=undef;
		$cu_space[$_]=undef;
		$imp_value[$_]=undef;
		$expiate[$_]=undef;
		$pos_col[$_]=undef;
		$pos_row[$_]=undef;
		$checkbutton_u[$_]->configure(-state=>'disabled'); #默认，关闭绕线
		$u_sig[$_]=undef;
		$error=undef;
	}
}
##删除所有层物体
sub del_all{
	clear();
    $f->COM ('affected_layer',mode=>'all',affected=>'yes');
    $f->COM ('sel_delete');
}
##打散物件，与加大阻焊。更改钻孔大小。
sub break_resize {
    clear();
	##$f->COM ('affected_layer',mode=>'all',affected=>'yes');
	affected_layer('yes','single','gts','gbs','drl');  #打散 阻焊，钻孔层，物件
    $f->COM ('sel_break');
    clear();
	affected_layer('yes','single','gts','gbs');
    $f->COM ('sel_resize',size=>4,corner_ctl=>'no');  #将阻焊层pad加大4mil
	clear('drl');
    $f->COM ('sel_change_sym',symbol=>'r46.85',reset_angle=>'no');  #将孔变为1.19  即1.2
}

##添加单线阻抗
sub add_sig_imp{  
	my $i=shift;
    my  ($x,                     $y,               $line_width,                   $layer,         $ref_top,     $ref_bot,     $cu_space    , $u_sig, )
	   =($coord_x[$pos_col[$i]], $pos_row[$i]*0.2, $line_width[$i]+$expiate[$i],  $imp_layer[$i], $ref_top[$i], $ref_bot[$i], $cu_space[$i], $u_sig[$i] );
     ##      X座标                    Y座标            线宽                         层次           上参教层      下参考层       到铜的距离      绕线
	my $excursion=0.07; ##偏移值设为70mil 
	my $imp_line_x=$x+$excursion/2; ##X座标
	my @imp_line_y=($y+0.135, $imp_long-$y-0.135); #Y方向，起点，终点。
    p__("x=$x y=$y line_width=$line_width layer=$layer ref_top=$ref_top ref_bot=$ref_bot cu_space=$cu_space u_sig=$u_sig");
	clear($layer);
	if ($cu_space) {
		add_line($imp_line_x, $y+0.035,$imp_line_x, $imp_long-$y-0.035, 's101') ; ##添加方形线
		my $neg_symbol='r'.($line_width+$cu_space*2-2*$expiate[$i]);  ##负片symbol 大小
		add_line($imp_line_x, $imp_line_y[0], $imp_line_x, $imp_line_y[1], "$neg_symbol",'no','negative'); ## 添加负片线
		add_pad( $x,$y,'imp_sig_neg'); ## #添加下面的单线阻抗pad
        add_pad( $x+$excursion,$imp_long-$y,'imp_sig_neg','no',180); ## #添加上面的单线阻抗pad
	}
   
	affected_layer('yes','single','gts','gbs','drl','gtl','gbl');  #将线路，阻焊，钻孔设为影响层。
	add_pad( $x,$y,"imp_sig"); #添加下面的单线阻抗pad
	add_pad( $x+$excursion,$imp_long-$y,"imp_sig",'no',180);  #添加上面的单线阻抗pad

	clear();
	affected_layer('yes','single', @layer[2..$#layer-1]);
	affected_layer('no','single', $layer);
	add_pad( $x,$y,'imp_sig_neg_oth');  #在下面加负片，叠开。
	add_pad( $x+$excursion,$imp_long-$y,'imp_sig_neg_oth','no',180);#在上面加负片，叠开
	clear($layer);

    #绕线
	if ( $u_sig ){
		my $imp_line_x=$x+$excursion+$line_width/2000+0.006;
		add_line($imp_line_x, $imp_line_y[0]+$excursion/2, $imp_line_x, $imp_line_y[1]-$excursion/2, "r$line_width");
		add_line($x+$excursion/2, $imp_line_y[0], $imp_line_x, $imp_line_y[0]+$excursion/2, "r$line_width");
		add_line($x+$excursion/2, $imp_line_y[1], $imp_line_x, $imp_line_y[1]-$excursion/2, "r$line_width");
	}else{
		add_line($imp_line_x, $imp_line_y[0], $imp_line_x, $imp_line_y[1], "r$line_width");  ##直接画阻抗线
	};
    ##如果不是共面，也不绕线
	if (! $cu_space and ! $u_sig ) {
    	my $cu_lef_x=$imp_line_x - $line_width/2000 - 0.02 - $cu_symbol/2000;
    	my $cu_rig_x=$imp_line_x + $line_width/2000 + 0.02 + $cu_symbol/2000;
		my $cu_yt = $imp_line_y[0] + 0.05 + ($max_row*0.2-$pos_row[$i]*0.2);
		my $cu_yb = $imp_line_y[1] - 0.05 - ($max_row*0.2-$pos_row[$i]*0.2);  
		add_line($cu_lef_x, $cu_yt   ,$cu_lef_x, $cu_yb    ,"r$cu_symbol");  ##画阻抗线  左边
		add_line($cu_rig_x, $cu_yt   ,$cu_rig_x, $cu_yb    ,"r$cu_symbol");  ##画阻抗线  右边
	}
	
	foreach  ($ref_top,$ref_bot) {
		if ($_) {
			clear($_);
    		add_line($imp_line_x, $y+0.035,$imp_line_x, $imp_long-$y-0.035, 's101') ;
			my $imp_pad;
			($_ eq $layer[1] or $_ eq $layer[-1] ) ? ($imp_pad = 'imp_sig_out') : ($imp_pad = 'imp_sig_neg');
			add_pad( $x,$y,$imp_pad);
        	add_pad( $x+$excursion,$imp_long-$y,$imp_pad,'no',180);
		}
	}
    ##添加文字
	clear('tmp');
	my $text= uc "$layer";
	add_text($x+0.015,$y+0.165,$text,'no',270);
}###end sig

sub add_dif_imp {
	my $i=shift;
	my ($x,                     $y,               $line_width,                  $line_space,                  $layer,         $ref_top,     $ref_bot,     $cu_space     )  
	  =($coord_x[$pos_col[$i]], $pos_row[$i]*0.2, $line_width[$i]+$expiate[$i], $line_space[$i]-$expiate[$i], $imp_layer[$i], $ref_top[$i], $ref_bot[$i], $cu_space[$i] );

	my $excursion=0.17;
	my $line_x1=$x+$excursion/2-($line_width+$line_space)/2000;
	my $line_x2=$line_x1+($line_width+$line_space)/1000;
	my $neck_long=0.19;
	my $line_yt=$y+$neck_long;
	my $line_yb=$imp_long-($y+$neck_long);
    my $half_pad=0.035;
	my $center_space=0.1;

	clear($layer);
	if ($cu_space) {
		add_line($x+0.085,$y+0.085,$x+0.085,$imp_long-$y-0.085,'s201');
		my $neg_symbol='r'.($line_width*2+$line_space+$cu_space*2-2*$expiate[$i]);
		my $neg_neck='r'.($line_width+$cu_space*2-2*$expiate[$i]);

	    add_pad( $x,$y,'imp_dif_neg');
   	    add_pad( $x+$excursion,$imp_long-$y,'imp_dif_neg','no',180);
		add_line($x+$excursion/2, $line_yt, $x+$excursion/2, $line_yb, "$neg_symbol",'no','negative');

	    add_line($line_x1, $line_yt, $x+$half_pad,     $y+$half_pad+$center_space, $neg_neck,'no','negative'); ###-bot--/----
	    add_line($line_x2, $line_yt, $x+$half_pad+$center_space, $y+$half_pad+$center_space, $neg_neck,'no','negative'); ###-bot--\----
	    add_line($line_x1, $imp_long-$line_yt, $x+$half_pad,     $imp_long-($y+$half_pad+$center_space), $neg_neck,'no','negative'); ###-top--\----
	    add_line($line_x2, $imp_long-$line_yt, $x+$half_pad+$center_space, $imp_long-($y+$half_pad+$center_space), $neg_neck,'no','negative'); ###-top--/----
	}
	affected_layer('yes','single','gts','gbs','drl','gtl','gbl');
	add_pad( $x,$y,"imp_dif");
	add_pad( $x+$excursion,$imp_long-$y,"imp_dif",'no',180);

	clear();
	affected_layer('yes','single', @layer[2..$#layer-1]);
#	p__("sotp");
	affected_layer('no','single', $layer);

	add_pad( $x,$y,"imp_dif_neg_oth");
	add_pad( $x+$excursion,$imp_long-$y,"imp_dif_neg_oth",'no',180);
	clear($layer);

	if ( ($layer eq $layer[1] or $layer eq $layer[$#layer]) and  $cu_space ) {
		$f->COM ('affected_layer',mode=>'all',affected=>'no');
		affected_layer('yes','single', @layer[1,$#layer]);
	    add_pad( $x,$y,"imp_dif_neg");
	    add_pad( $x+$excursion,$imp_long-$y,"imp_dif_neg",'no',180);
	    add_pad( $x,$y,"imp_dif");
	    add_pad( $x+$excursion,$imp_long-$y,"imp_dif",'no',180);
	}
	clear($layer);




	add_line($line_x1, $line_yt, $line_x1, $line_yb, "r$line_width");
	add_line($line_x2, $line_yt ,$line_x2, $line_yb, "r$line_width");

	add_line($line_x1, $line_yt, $x+$half_pad,     $y+$half_pad+$center_space, "r$line_width"); ###-bot--/----
	add_line($line_x2, $line_yt, $x+$half_pad+$center_space, $y+$half_pad+$center_space, "r$line_width"); ###-bot--\----
	add_line($line_x1, $imp_long-$line_yt, $x+$half_pad,     $imp_long-($y+$half_pad+$center_space), "r$line_width"); ###-top--\----
	add_line($line_x2, $imp_long-$line_yt, $x+$half_pad+$center_space, $imp_long-($y+$half_pad+$center_space), "r$line_width"); ###-top--/----

	if (! $cu_space) {
		my $cu_lef_x=$line_x1 - ($line_width + $cu_symbol)/2000 - 20/1000;
		my $cu_rig_x=$line_x2 + ($line_width + $cu_symbol)/2000 + 20/1000; 
		my $cu_yt=$line_yt+0.03+$max_row*0.2-$pos_row[$i]*0.2;
		my $cu_yb=$line_yb-0.03-$max_row*0.2+$pos_row[$i]*0.2;
		add_line($cu_lef_x, $cu_yt,  $cu_lef_x, $cu_yb,  "r$cu_symbol");
		add_line($cu_rig_x, $cu_yt,  $cu_rig_x, $cu_yb,  "r$cu_symbol");
	}

	foreach  ($ref_top,$ref_bot) {
		if ($_) {
			clear($_);
		    add_line($x+0.085,$y+0.085,$x+0.085,$imp_long-$y-0.085,'s201');
			my $imp_pad;
			($_ eq $layer[1] or $_ eq $layer[-1] ) ? ($imp_pad = 'imp_dif_out') : ($imp_pad = 'imp_dif_neg');
		    add_pad( $x,$y,$imp_pad);
    	    add_pad( $x+$excursion,$imp_long-$y,$imp_pad,'no',180);
		}
	}
	clear('tmp');
	my $text= uc "$layer";
	add_text($x+0.015,$y+0.165,$text,'no',270);
}###end dif

sub clear_creat_step {
	my $name=shift;
    $f->VOF;
    creat_step($JOB,$name);
    $f->VON;
    $f->COM ('open_entity',
	    job=>$JOB,
		type=>'step',
		name=>$name,
		iconic=>'no');
    $f->AUX ('set_group',group=>$f->{COMANS});
    clear();
    $f->COM('affected_layer',mode=>'all',affected=>'yes');
    $f->COM('sel_delete');
}

##对输入参数进行检查。
sub check_parameter{
	my $imp_number=0;
	my @pos=undef;
	foreach  (@number_list) {
		if ($imp_layer[$_]) {
			my $j=$_+1;  #如果定义了阻抗层，则进行检查
			$imp_number++;
		    if ( !$line_width[$_] )  { $error="第 $j 组线宽错误";   return 'bad';}
			if ( !$imp_value[$_]  )  { $error="第 $j 组阻抗值错误";   return 'bad';}
			if ( !$expiate[$_]    )  { $error="第 $j 补偿错误";   return 'bad';}
		    if ( $button_type[$_]->cget(-text) eq 'dif' and !$line_space[$_]) { $error="第 $j 差分线距错误";   return 'bad';}
		    if ( !$ref_top[$_] && !$ref_bot[$_]) { $error="第 $j 组无参考层";   return 'bad';}
		    if ( $layer_sort{$ref_top[$_]} >= $layer_sort{$imp_layer[$_]}) { $error="第 $j 组上参考层错误";   return 'bad';}
		    if ( $ref_bot[$_] and $layer_sort{$ref_bot[$_]} <= $layer_sort{$imp_layer[$_]}) { $error="第 $j 组下参考层错误";   return 'bad';}
			if ( $button_type[$_]->cget(-text) eq 'dif' and  $line_width[$_]*2+$line_space[$_] > 32) {   $error="第 $j 组线宽加间距值大于32 ";  return 'bad'  ;        }
			if ( $long < 6 or $long >24 ) { $error="阻抗条长度错误";  return 'bad' }
			if ( $cu_space[$_] and $u_sig[$_] ) { $error="第 $j 组 同层参考不能绕线";  return 'bad' }
			my ( $col,$row )=($pos_col[$_],$pos_row[$_]);
			$col='z' unless $col;
			$row='z' unless $row;
			my $col_row=$col.$row;
			if (  grep m{$col_row},@pos  ) {  $error="第 $j 组位置重复  ";  return 'bad'} ##检查位置是否重复
			push @pos,$col_row;
		}
	}
	if ($imp_number == 0) {$error="阻抗层未定义";  return 'bad'};
}

sub add_imp_text  {
	clear('tmp');
	my %imp_text;
	foreach  (@number_list) {
		if ($imp_layer[$_]) {
		    $imp_text{$imp_layer[$_]}=$imp_text{$imp_layer[$_]}."$line_width[$_]/$line_space[$_]mil-$imp_value[$_]ohm ";
		}
	}
	my $all_text;
	foreach  (keys %imp_text) {   $all_text=$all_text."$_=$imp_text{$_}";   }
	$all_text=uc "$JOB ".$all_text;
	add_text( -0.02,  0.05,$all_text, 'no',  0 );
}
###主程序
#####________________________________________________________________________________
sub apply { 
if (check_parameter() eq 'bad') { return; }  ## 参数检查，如果有问题，即返回。
creat_clear_layer('tmp'); #创建层 tmp
clear_creat_step('zk');	 #创建step zk
unit_set('inch'); #将单位改成inch
my (%col_type,$pre_symbol_half,$symbol,$symbol_half,$x,$y);
$imp_long=$long-0.05; #减少50mil,单边离板边25mil
foreach (reverse @number_list){    ##0..39
	$col_type{$pos_col[$_]}=$button_type[$_]->cget(-text) if $imp_layer[$_] ;  ##用哈希存储 1 => dif  2=>sig 排
	$max_row=$pos_row[$_] if $pos_row[$_] > $max_row ; #最大行数
} 
foreach  (sort keys %col_type) {
	( $col_type{$_} eq 'sig' ) ? ( $symbol_half=0.075 ) : ( $symbol_half=0.175 ); #单线，半距离为75mil ,差分为175mil 
    ( $pre_symbol_half ) ? ( $x=$x+$pre_symbol_half+0.025 ) : ( $x=0 );		
	push @coord_x,$x;  ##存储座标。
	$pre_symbol_half=$symbol_half;
}
foreach  (@number_list) {
	my $symbol=$button_type[$_]->cget(-text);
	if ( $imp_layer[$_]  ) {
	    if  ( $symbol eq 'sig' ) {  add_sig_imp($_)  } else {  add_dif_imp($_)  }; #添加阻抗
	}
}
break_resize(); ##打散物件，与加大阻焊。并更改孔大小。

clear();
p__("Pause");
$f->COM ('affected_layer',mode=>'all',affected=>'yes');
sel_transform(0,0,0,0,1,1,90,'rotate');

my $ref=info('step',"$JOB/zk",'limits');
my @zk_limits=( $ref->{gLIMITSxmin}, $ref->{gLIMITSymin}, $ref->{gLIMITSxmax},  $ref->{gLIMITSymax}, );
$f->COM ('profile_rect',
	x1=> $ref->{gLIMITSxmin}-0.01,
	y1=> $ref->{gLIMITSymin}-0.01,
	x2=> $ref->{gLIMITSxmax}+0.01,
	y2=> $ref->{gLIMITSymax}+0.01,
);
$f->COM ('profile_to_rout',layer=>'box',width=>10); 

add_imp_text();
exit;
} ###end_apply
####______________________________________





