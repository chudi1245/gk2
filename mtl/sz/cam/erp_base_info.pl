#!/usr/bin/perl
use Win32;
use Tk;
use Win32::API;
use DBD::ODBC;
use Genesis;
use FBI;
use Encode;
use encoding 'euc_cn';
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

#__________________________检测是否在pnl中运行，不是则停止并提示。
if ($STEP ne "pnl"){
	$f->PAUSE("Please running at PNL");
	return;
	}
#__________________________清除选择物体，清除显示层，清除影响层，图形归中。
$f->COM ('open_entity',job=>$JOB,type=>'step',name=>'pnl',iconic=>'no');
$f->AUX ('set_group',group=>$f->{COMANS});
clear();
$f->COM("zoom_home");
#__________________________
$f->INFO(units => 'mm',
	entity_type => 'step',
	entity_path => "$JOB/pnl",);
#__________________________
$profxmax = $f->{doinfo}{gPROF_LIMITSxmax};
$profymax = $f->{doinfo}{gPROF_LIMITSymax};
$profxmin = $f->{doinfo}{gPROF_LIMITSxmin};
$profymin = $f->{doinfo}{gPROF_LIMITSymin};

$px = sprintf "%6.2f",($profxmax - $profxmin)/10;
$py = sprintf "%6.2f",($profymax - $profymin)/10;

$pxmax = $f->{doinfo}{gSR_LIMITSxmax};
$pxmin = $f->{doinfo}{gSR_LIMITSxmin};
$pymax = $f->{doinfo}{gSR_LIMITSymax};
$pymin = $f->{doinfo}{gSR_LIMITSymin};

$limitx = $pxmax - $pxmin;
$limity = $pymax - $pymin;

$limitx = sprintf "%6.2f",$limitx/10;
$limity = sprintf "%6.2f",$limity/10;

@pcbnumbers = @{$f->{doinfo}{gREPEATstep}};
$pcbnumber=0;
$zknumber=0;

foreach (@pcbnumbers) {
	if ($_ eq 'pcb' || $_ eq 'pcs') {
		$pcbnumber++;
		} 
    if ($_ eq 'zk') {
		$zknumber++;
		}
}

#**************************计算阻抗条的面积。
if ($zknumber!=0) {

	$f->INFO(units      => 'mm',
			entity_type => 'step',
			entity_path => "$JOB/zk",
		);

	$zkxmax = $f->{doinfo}{gPROF_LIMITSxmax};
	$zkymax = $f->{doinfo}{gPROF_LIMITSymax};
	$zkxmin = $f->{doinfo}{gPROF_LIMITSxmin};
	$zkymin = $f->{doinfo}{gPROF_LIMITSymin};

	$zkx = sprintf "%6.2f",$zkxmax - $zkxmin;
	$zky = sprintf "%6.2f",$zkymax - $zkymin;
	$zkarea = $zkx * $zky * $zknumber;
       }

#**************************获取交货单元尺寸，如果PCS存在，就计算PCS，否则计算PCB。
$f->INFO(entity_type => 'step',
         entity_path => "$JOB/pcs",
         data_type   => 'EXISTS');

$step_exists = $f->{doinfo}{gEXISTS};

if ($step_exists eq 'yes') {
							$spcb = pcs;
			}
else{
	$spcb=pcb;
	}

$f->INFO(	units		=> 'mm',
			entity_type => 'step',
            entity_path => "$JOB/$spcb",);

	$pcbxmax = $f->{doinfo}{gPROF_LIMITSxmax};
	$pcbymax = $f->{doinfo}{gPROF_LIMITSymax};

	$pcbxmin = $f->{doinfo}{gPROF_LIMITSxmin};
	$pcbymin = $f->{doinfo}{gPROF_LIMITSymin};

	$pcbx = sprintf "%6.2f",$pcbxmax - $pcbxmin;
	$pcby = sprintf "%6.2f",$pcbymax - $pcbymin;
	$pcbarea = $pcbx * $pcby * $pcbnumber;  
	$cl_lyn = sprintf "%6.2f",($zkarea + $pcbarea)/($px*$py*100);  

#**************************找最小钻孔
$f->INFO(units=>'mm',entity_type => 'layer',entity_path => "$JOB/pcb/drl");

@Drl = @{$f->{doinfo}{gTOOLdrill_size}};

@Drl = sort{$a<=>$b} @Drl;
$minhole = $Drl[0] / 1000;

#**************************计算板子的层数
$f->INFO(units => 'mm', entity_type => 'matrix',entity_path => "$JOB/matrix");

@gROWrow = @{$f->{doinfo}{gROWrow}};
##$f->PAUSE("@gROWrow");
@gROWcontext   =@{$f->{doinfo}{gROWcontext}};
@gROWlayer_type=@{$f->{doinfo}{gROWlayer_type}};
@gROWname      =@{$f->{doinfo}{gROWname}};
@gROWtype      =@{$f->{doinfo}{gROWtype}};
@gROWside      =@{$f->{doinfo}{gROWside}};

#**************************$gROWside[$_] eq 'inner'  && $gROWlayer_type[$_] eq 'signal' 
my $Layer_num = 0;
foreach (@gROWrow){	
	if ($gROWcontext[$_] eq 'board'){
		if ($gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or 
		    $gROWlayer_type[$_] eq 'mixed' ) {
		    $Layer_num++;
		}
	}
}
###______________________________
my $b_layer;
my @layer_drl;
my $ref=info("matrix","$JOB/matrix","row");
my @gROWcontext   =@{$ref->{gROWcontext}};
my @gROWlayer_type=@{$ref->{gROWlayer_type}};
my @gROWname      =@{$ref->{gROWname}};
foreach  (0..$#gROWname) {
	if ($gROWname[$_] eq 'gbl'){$b_layer= $gROWname[$_+1];}
	if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] eq 'drill') {	push @layer_drl,$gROWname[$_];  }
}
###______________________________
#*****************************主程序窗口开始
my $mw = MainWindow->new;

$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
#**********************保证程序显示在最前边

$mw->title("Base_info Super_version");

$mw->Label(-text => "档案号:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>0);
$mw->Label(-text =>$JOB,
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>1);

$mw->Label(-text => "$Layer_num 层板:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>2);
$mw->Label(-text => "材料利用率:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>3);
$mw->Label(-text => "$cl_lyn",
	-relief=>'g',-background => "tan",-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>4);

#**********************
$mw->Label(-text => "Panel(X)CM:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>0);

$mw->Label(-text => "$px",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>1);

$mw->Label(-text => "Panel(Y)CM:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>2);
$mw->Label(-text => "$py",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>3);

my  @jinweis = qw(纬 经);
my $jinwei = "纬";
$mw->Optionmenu(-options =>\@jinweis,
              -textvariable=>\$jinwei,-width=>12,-background => "mediumturquoise",-font => [-size => 12],)->grid(-row=>1,-column=>4); 

#**********************
$pinx = 1;
$piny = $pcbnumber;
$mw->Label(-text => 'X方向拼(个):',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>2,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable => \$pinx,-width=>15,-font => [-size => 12],-foreground =>'black')->grid(-row=>2,-column=>1);

$mw->Label(-text => 'Y方向拼(个):',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>2,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$piny,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>2,-column=>3);

#**********************

$mw->Label(-text => "拼板块数:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>0);
$mw->Label(-text => "$pcbnumber",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>1);
$mw->Label(-text => '成品板厚(mm)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>2);
$mw->Entry(-background => "white",-textvariable =>\$boardthick,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>3,-column=>3);
my $error = undef();

#**********************

$mw->Label(-text => "有效边X(cm):",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>0);
$mw->Label(-text => "$limitx",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>1);
$mw->Label(-text => "有效边(cm)Y:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>2);
$mw->Label(-text =>"$limity",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>3);

#**********************
my ($ddx,$ddy);
$mw->Label(-text => '电镀边X(mm)',-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>5,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddx,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>1);
$mw->Label(-text => '电镀边Y(mm)',-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>5,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddy,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>3);

#*********************
$mw->Label(-text => '图电TOP（DM2）',
	-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>6,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable => \$tarea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>6,-column=>1);
$mw->Label(-text => '图电BOT（DM2）',
	-relief=>'g', -width=>15,-font => [-size => 12],)->grid(-row=>6,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$barea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>6,-column=>3);
$mw->Button(-text => "信息提取",
-relief=>'raised',-width=>15,-font => [-family=>'黑体',-size => 16], 
-command =>\&sunarea)->grid(-row=>3,-column=>4);

#*********************
$mw->Label(-text => '板电面积（DM2）',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>7,-column=>0);
$mw->Label(-background => "tan",-textvariable => \$boardarea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>7,-column=>1);
$mw->Label(-text => '厚径比：',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>7,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$Bi_hole,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>7,-column=>3);

#*********************
$mw->Label(-text => '出货尺寸(mm)X',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>0);
$mw->Label(-text => "$pcbx",
	-relief=>'g',-background => "tan",-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>1);
$mw->Label(-text => '出货尺寸(mm)Y',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>2);
$mw->Label(-text => "$pcby",
	-relief=>'g',-background => "tan",-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>3);

#*********************
$borance = 0.1;
$mw->Label(-text => '层压板厚(mm)',-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>9,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable =>\$Lamithick,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>9,-column=>1);

$mw->Label(-text => '板厚公差',-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>9,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$borance,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>9,-column=>3);

#*********************
$mw->Button(-text => "导入ERP",
	-relief=>'raised',-width=>15,-font => [-family=>'黑体',-size => 16], 
	-command =>\&output_base)->grid(-row=>5,-column=>4);
$mw->Button(-text => '关闭退出',
	-relief=>'raised',-width=>15,-font=>[-family=>'黑体',-size=>16],
	-command => sub { exit })->grid(-row=>9,-column=>4);

$mw->Label(-text => '信息提示',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>11,-column=>0);

$mw->Label(-textvariable => \$error,-foreground =>'red',-background => "bisque",-width=>70,-font => [-size => 12],)->grid(-row=>11,-column=>1,-columnspan=>110,);

$mw->Button(-text => '使用必读',-foreground => "red",
	-relief=>'g',-width=>12,-font=>[-size=>14],
	-command =>\&base_help)->grid(-row=>12,-column=>0);

$mw->Label(-text => 'TOP(百分比)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>10,-column=>0);

$mw->Label(-background => "mediumturquoise",-textvariable => \$topbi,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>10,-column=>1);

$mw->Label(-text => 'BOT(百分比)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>10,-column=>2);

$mw->Label(-background => "mediumturquoise",-textvariable => \$botbi,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>10,-column=>3);

$mw->Label(-text => '密码输入',
	-relief=>'g',-width=>12,-font => [-size => 14],)->grid(-row=>12,-column=>3);
$mw->Entry(-background => "white",-textvariable => \$mima,-width=>15,-font => [-size => 12], -foreground =>'black',-show=>'*')->grid(-row=>12,-column=>4);

MainLoop;


#********************信息提取子程序开始,增加给切片孔铺铜。
sub sunarea{
	$f->COM ('open_entity',job=>$JOB,type=>'step',name=>'pnl',iconic=>'no');
	$f->AUX ('set_group',group=>$f->{COMANS});
	
	foreach  (@layer_drl){
		if ($_ ne 'drl') {
			$f->COM('matrix_layer_context',
						job=>$JOB,
						matrix=>'matrix',
						layer=>$_ ,
						context=>'misc');
		}
	}

	my ($bit,$bib,$x,$y,);
	$f->COM(units, type =>"mm");
	if(!$boardthick) {
		 $error = "温馨提示：您没有输入成品板厚！如板厚1.6mm请输1.6 ";
		 return;
	}else{
		 $error = undef();
	}
#********************计算电镀边的长宽，双面板为拼板尺寸，多层板为CY的长宽   
if ($Layer_num < 3) {
	$ddx = $px * 10;
	$ddy = $py * 10;
}else{
	$f->COM("display_layer,name=cy,display=no,number=1");
	$f->COM("display_layer,name=cy,display=yes,number=1");
	$f->COM("work_layer,name=cy");
	$f->COM("filter_area_strt");
	$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
	$f->COM("sel_create_profile");
	$f->COM("display_layer,name=cy,display=no,number=1");

    $f->INFO(units => 'mm',entity_type => 'step',entity_path => "$JOB/pnl",);
	$cyxmax = $f->{doinfo}{gPROF_LIMITSxmax};
	$cyymax = $f->{doinfo}{gPROF_LIMITSymax};
	$cyxmin = $f->{doinfo}{gPROF_LIMITSxmin};
	$cyymin = $f->{doinfo}{gPROF_LIMITSymin};
	$ddx = sprintf "%6.2f",($cyxmax - $cyxmin);
	$ddy = sprintf "%6.2f",($cyymax - $cyymin);  
 }

##__________________算板电面积;
if ( exists_layer('areat') eq 'yes' ) {
	$f->COM("delete_layer,layer=areat");
	}
if ( exists_layer('areab') eq 'yes' ) {
	$f->COM("delete_layer,layer=areab");
	}
creat_bsp_layer('areat','gtl');
creat_bsp_layer('areab',$b_layer);

##______________________________________计算钻孔面积
	$bzhd = $boardthick * 1000;
	copper_area('areat','areab',$bzhd);
	$drl=$f->{COMANS};
	($areadrl,$bidrl)=split(' ',$drl);
	$areadrl = sprintf "%6.2f",$areadrl/20000;
#_______________________________________先铺铜算板电

fill_mm_params();
clear('areat');
sr_fill_mm();
clear('areab');
sr_fill_mm();
clear();
copper_area('areat','areab',$bzhd);

###_____________________________________
$karea=$f->{COMANS};
($areak,$bik)=split(' ',$karea);
$boardarea = sprintf "%6.2f", $areak/20000;

$f->COM("undo") ;
$f->COM("undo") ;

#*******************************计算GTL电度面积
$f->COM("matrix_layer_context,job=$JOB,matrix=matrix,layer=areat,context=misc");
copper_area('gtl','areab',$bzhd);
$x=$f->{COMANS};
($tarea,$bit)=split(' ',$x);

##$tarea = sprintf "%6.2f",$tarea/10000 - $areadrl;
$tarea = sprintf "%6.2f",$tarea/10000;
$tarea=$tarea- $areadrl;

#*******************************计算GBL电度面积
$f->COM("delete_layer,layer=areab");
$f->COM("matrix_layer_context,job=$JOB,matrix=matrix,layer=areat,context=board");
copper_area('areat','gbl',$bzhd);
$y=$f->{COMANS};
($barea,$bib)=split(' ',$y);

$barea = sprintf "%6.2f",$barea/10000;
$barea=$barea - $areadrl;
$f->COM("delete_layer,layer=areat");

if ($Layer_num > 2){$f->COM("undo") ; }

$Bi_hole = sprintf "%6.2f",$boardthick / $minhole;   #厚径比


foreach  (@layer_drl){
	if ($_ ne 'drl') {
		$f->COM('matrix_layer_context',
						job=>$JOB,
						matrix=>'matrix',
						layer=>$_ ,
						context=>'board');
		}
}

#*******************************计算层压板厚
$Lamithick = $boardthick - 0.1;
$topbi = sprintf "%6.2f",($tarea / $boardarea) * 100 ; 
$botbi = sprintf "%6.2f",($barea / $boardarea) * 100 ;

unit_set('inch');
my ($slicetopx,$slicetopy,$slicebotx,$slicebotx);
if ($Layer_num <= 2) {
	my $off_x=0.6;
	my $off_y=0.0375;
	$slicetopx=($pxmin/25.4)+0.32+$off_x;     
	$slicetopy=($pymax/25.4)+0.12+0.06+0.0375-$off_y;
	$slicebotx=($pxmax/25.4)-0.32-0.38-$off_x;  
	$sliceboty=($pymin/25.4)-0.12-0.06+0.0375-$off_y;
}else{
	my $off_x=0.2;
	my $off_y=0.25;
	$slicetopx=($pxmin/25.4)+0.32+$off_x;    
	$slicetopy=($pymax/25.4)+0.14+0.0375+$off_y;
	$slicebotx=($pxmax/25.4)-0.32-0.38-$off_x; 
	$sliceboty=($pymin/25.4)-0.14+0.0375-$off_y;
}

if ($topbi>39 or $botbi>39) {
    #***残铜率百分比
	$topbi = "$topbi"."%";
	$botbi = "$botbi"."%";
	$STEP = $ENV{STEP};
	if ($STEP eq 'pnl') {
	$f->COM ('open_entity',job=>$JOB,type=>'step',name=>'pnl',iconic=>'no');
	$f->AUX ('set_group',group=>$f->{COMANS});

	clear('gtl');
	add_pad($slicetopx,$slicetopy,'rect580x148'); 
	add_pad($slicebotx,$sliceboty,'rect580x148'); 
	clear('gbl');
	add_pad($slicetopx,$slicetopy,'rect580x148'); 
	add_pad($slicebotx,$sliceboty,'rect580x148'); 
	clear();	 
    } 
	}else{

	#***残铜率百分比
	$topbi = "$topbi"."%";
	$botbi = "$botbi"."%";
	return;
	}
}   

#输入ERP子程序开始  erp20120629   mtlerp-running
sub output_base { 
	my ($datebase, $Server);
	$Server='192.168.10.2';
	$datebase='mtlerp-running';

my $DSN = qq{driver={SQL Server};Server=$Server; database=$datebase;uid=sa;pwd=719799;};

$dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";

@ttt=usr_pass($mima);
if (! $ttt[0]) {$error="$ttt[6]";return}
$error= "$ttt[2]，欢迎你";

my $yesno_button = $mw->messageBox(-message => "要更新数据库吗?请确认!",-type => "yesno", -icon => "question");
 
if ($yesno_button eq "No") {return;} else{
$error= "update ing";
$sql=qq( update TBlindHolye set GoodsPlength= '$px',GoodsPWidth='$py',MDirect='$jinwei',DeepSpan='$Bi_hole',
	     LongSpell='$pinx',WidthSpell='$piny',GoodsHeight='$Lamithick',Tolerance='$borance',PS='$pcbnumber',
	     EffectX='$limitx',EffectY='$limity', RoutEffectX='$ddx',RoutEffectY='$ddy',
	     GTLArea='$tarea',GBLArea='$barea' where GoodsCode='$JOB' );

$sql=encode('gb2312',$sql);
$sth = $dbh->prepare ($sql );

my $flagrr=$sth->execute();
$sql=qq(Insert into tblog(LogContent) select  ($JOB.$ttt[2],)); 

if ($flagrr == 1) {$error="更新数据库成功";}else{$error="更新数据库失败"; return };

}
}

#**********************密码认证

sub usr_pass {	
	my $code = shift;
	my ($v1, $v2, $v3, $v4, $v5, $v6,$v7);
    my ($output,$creturn);
    my $sth1 = $dbh->prepare ("{? = call PCheckEmployeeCodeValidate(?,?,?,?,?,?) }");
    $sth1->bind_param_inout(1, \$output, 1);
    $sth1->bind_param(2, $code);
    $sth1->bind_param_inout(3, \$v1, 1);
    $sth1->bind_param_inout(4, \$v2, 1);
    $sth1->bind_param_inout(5, \$v3, 1);
    $sth1->bind_param_inout(6, \$v4, 1);
    $sth1->bind_param_inout(7, \$creturn, 500);
    $sth1->execute();
    return ($v1, $v2, $v3, $v4, $v5, $v6,$creturn);       		 
}

#**********************程序帮助
sub base_help{

$mw->messageBox(-message=> '
使用方法：
A: 请输入成品板厚再点击【信息提取】
B: 程序运行完之后，请检查经纬是否正确
C: 请输入密码再点【导入ERP】
D: 如更新数据库成功，信息提示栏将会显示


注意事项：
1：切片孔将会自动铺铜，
2: 线路层与阻焊层之间不要放置其它层
3: 未考虑单面板的使用，程序可以运行，请不要导入ERP
4: 阴阳拼板时不能计算电镀面积.请不要导入ERP
5：盲孔板计算时，请将其它钻带定义为非板属性，再计算电镀面积。
6: 当有GTL-M,GBL-M时，请不要定义为线路层
7: 导入ERP时只更新标准卡制作基本信息里面的数据
8: 使用时请不要随意点击《导入ERP》的数据，因为单制作完仍然可以导入

欢迎您的使用,在使用中您有宝贵的意见请联系我!
Name:超越自我  QQ:214284213  Eaill:mtlmzb@sina.com', -type=> "ok",-icon => "info");
$mw -> deiconify;
}



=head
  厚经比   x拼数目      y拼版数目   层压板厚      公差               档案号      拼版长       拼版宽      经纬    平板块数     有效边长  有效边宽      电镀边长     电镀边宽    top电镀面积   bot电镀面积
  DeepSpan  LongSpell    WidthSpell  GoodsHeight  Tolerance         GoodsCode  GoodsPlength  GoodsPWidth  MDirect     PS        EffectX    EffectY    RoutEffectX   RoutEffectY    GTLArea       GBLArea
VBEngSub
MDirect='$jinwei',	                       
$sql=qq( insert TBlindHolye (GoodsCode,GoodsPlength,GoodsPWidth, PS,        EffectX,    EffectY,   RoutEffectX, RoutEffectY,  GTLArea,  GBLArea) values
	                         ('$JOB',       '$px',   '$py',     '$pcbnumber','$limitx', '$limity', '$ddx',       '$ddy',      '$areat','$areab') );


#**************************定义给切片孔封铜皮的两个座标点。

@main::butfly=(
  {x=>$main::SR_xmax, y=>$main::SR_ymax+0.12},
  {x=>$main::SR_xmax, y=>$main::SR_ymin-0.12},
  {x=>$main::SR_xmin, y=>$main::SR_ymin-0.12},
  {x=>$main::SR_xmin, y=>$main::SR_ymax+0.12},
);

my @butfly=@main::butfly;
@main::min_line=(
  { x=>$butfly[0]{x}-0.32, y=>$butfly[0]{y} },
  { x=>$butfly[1]{x}-0.20, y=>$butfly[2]{y} },
  { x=>$butfly[2]{x}+0.20, y=>$butfly[2]{y} },
  { x=>$butfly[3]{x}+0.32, y=>$butfly[3]{y} },
);
my ($nx,$ny,$dx,$dy)=(5,2,118,75);
my $symbol_half_long=$dx*2/1000;


if ($main::layer_number <= 2) {
	my $off_x=0.6;
	my $off_y=($dy/1000)/2 ;
	$slice=[
	  {x=>$min_line[3]{x}+$off_x-$symbol_half_long,  y=>$min_line[3]{y}-$off_y+$mm1_5,},
	  {x=>$min_line[1]{x}-0.5-$off_x-$symbol_half_long,  y=>$min_line[1]{y}-$off_y-$mm1_5,},
	];
}else{
	my $off_x=0.2;
	my $off_y=0.25;
	
	$slice=[
	  {x=>$min_line[3]{x}+$off_x-$symbol_half_long,  y=>$min_line[3]{y}+$off_y,},
	  {x=>$min_line[1]{x}-0.5-$off_x-$symbol_half_long,  y=>$min_line[1]{y}-$off_y,},
	];
}









if ($topbi>39 or $botbi>39) 
	{
    #***残铜率百分比
	$topbi = "$topbi"."%";
	$botbi = "$botbi"."%";
	$STEP = $ENV{STEP};
	if ($STEP eq 'pnl') {
	$f->COM ('open_entity',job=>$JOB,type=>'step',name=>'pnl',iconic=>'no');
	$f->AUX ('set_group',group=>$f->{COMANS});

	my $sure_button = $mw->messageBox(-message => "切片孔需铺铜,请手动铺铜!千万别忘了!",-type => "yesno", -icon => "question");
	if ($sure_button eq "No"){
	return;
	}else{
#	clear('gtl');
#	add_pad($slicetopx,$slicetopy,'rect600x190'); 
#	add_pad($slicebotx,$sliceboty,'rect600x190'); 
	
#	clear('gbl');
#	add_pad($slicetopx,$slicetopy,'rect600x190'); 
#	add_pad($slicebotx,$sliceboty,'rect600x190'); 
#	clear();
		 } 
    }else
		{
		return;
		}

}else{
	#***残铜率百分比
	$topbi = "$topbi"."%";
	$botbi = "$botbi"."%";
	return;
	}
