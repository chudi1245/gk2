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

#__________________________����Ƿ���pnl�����У�������ֹͣ����ʾ��
if ($STEP ne "pnl"){
	$f->PAUSE("Please running at PNL");
	return;
	}
#__________________________���ѡ�����壬�����ʾ�㣬���Ӱ��㣬ͼ�ι��С�
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

#**************************�����迹���������
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

#**************************��ȡ������Ԫ�ߴ磬���PCS���ڣ��ͼ���PCS���������PCB��
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

#**************************����С���
$f->INFO(units=>'mm',entity_type => 'layer',entity_path => "$JOB/pcb/drl");

@Drl = @{$f->{doinfo}{gTOOLdrill_size}};

@Drl = sort{$a<=>$b} @Drl;
$minhole = $Drl[0] / 1000;

#**************************������ӵĲ���
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
#*****************************�����򴰿ڿ�ʼ
my $mw = MainWindow->new;

$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
#**********************��֤������ʾ����ǰ��

$mw->title("Base_info Super_version");

$mw->Label(-text => "������:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>0);
$mw->Label(-text =>$JOB,
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>1);

$mw->Label(-text => "$Layer_num ���:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>2);
$mw->Label(-text => "����������:",
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

my  @jinweis = qw(γ ��);
my $jinwei = "γ";
$mw->Optionmenu(-options =>\@jinweis,
              -textvariable=>\$jinwei,-width=>12,-background => "mediumturquoise",-font => [-size => 12],)->grid(-row=>1,-column=>4); 

#**********************
$pinx = 1;
$piny = $pcbnumber;
$mw->Label(-text => 'X����ƴ(��):',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>2,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable => \$pinx,-width=>15,-font => [-size => 12],-foreground =>'black')->grid(-row=>2,-column=>1);

$mw->Label(-text => 'Y����ƴ(��):',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>2,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$piny,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>2,-column=>3);

#**********************

$mw->Label(-text => "ƴ�����:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>0);
$mw->Label(-text => "$pcbnumber",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>1);
$mw->Label(-text => '��Ʒ���(mm)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>2);
$mw->Entry(-background => "white",-textvariable =>\$boardthick,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>3,-column=>3);
my $error = undef();

#**********************

$mw->Label(-text => "��Ч��X(cm):",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>0);
$mw->Label(-text => "$limitx",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>1);
$mw->Label(-text => "��Ч��(cm)Y:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>2);
$mw->Label(-text =>"$limity",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>3);

#**********************
my ($ddx,$ddy);
$mw->Label(-text => '��Ʊ�X(mm)',-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>5,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddx,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>1);
$mw->Label(-text => '��Ʊ�Y(mm)',-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>5,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddy,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>3);

#*********************
$mw->Label(-text => 'ͼ��TOP��DM2��',
	-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>6,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable => \$tarea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>6,-column=>1);
$mw->Label(-text => 'ͼ��BOT��DM2��',
	-relief=>'g', -width=>15,-font => [-size => 12],)->grid(-row=>6,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$barea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>6,-column=>3);
$mw->Button(-text => "��Ϣ��ȡ",
-relief=>'raised',-width=>15,-font => [-family=>'����',-size => 16], 
-command =>\&sunarea)->grid(-row=>3,-column=>4);

#*********************
$mw->Label(-text => '��������DM2��',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>7,-column=>0);
$mw->Label(-background => "tan",-textvariable => \$boardarea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>7,-column=>1);
$mw->Label(-text => '�񾶱ȣ�',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>7,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$Bi_hole,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>7,-column=>3);

#*********************
$mw->Label(-text => '�����ߴ�(mm)X',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>0);
$mw->Label(-text => "$pcbx",
	-relief=>'g',-background => "tan",-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>1);
$mw->Label(-text => '�����ߴ�(mm)Y',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>2);
$mw->Label(-text => "$pcby",
	-relief=>'g',-background => "tan",-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>3);

#*********************
$borance = 0.1;
$mw->Label(-text => '��ѹ���(mm)',-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>9,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable =>\$Lamithick,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>9,-column=>1);

$mw->Label(-text => '��񹫲�',-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>9,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$borance,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>9,-column=>3);

#*********************
$mw->Button(-text => "����ERP",
	-relief=>'raised',-width=>15,-font => [-family=>'����',-size => 16], 
	-command =>\&output_base)->grid(-row=>5,-column=>4);
$mw->Button(-text => '�ر��˳�',
	-relief=>'raised',-width=>15,-font=>[-family=>'����',-size=>16],
	-command => sub { exit })->grid(-row=>9,-column=>4);

$mw->Label(-text => '��Ϣ��ʾ',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>11,-column=>0);

$mw->Label(-textvariable => \$error,-foreground =>'red',-background => "bisque",-width=>70,-font => [-size => 12],)->grid(-row=>11,-column=>1,-columnspan=>110,);

$mw->Button(-text => 'ʹ�ñض�',-foreground => "red",
	-relief=>'g',-width=>12,-font=>[-size=>14],
	-command =>\&base_help)->grid(-row=>12,-column=>0);

$mw->Label(-text => 'TOP(�ٷֱ�)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>10,-column=>0);

$mw->Label(-background => "mediumturquoise",-textvariable => \$topbi,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>10,-column=>1);

$mw->Label(-text => 'BOT(�ٷֱ�)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>10,-column=>2);

$mw->Label(-background => "mediumturquoise",-textvariable => \$botbi,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>10,-column=>3);

$mw->Label(-text => '��������',
	-relief=>'g',-width=>12,-font => [-size => 14],)->grid(-row=>12,-column=>3);
$mw->Entry(-background => "white",-textvariable => \$mima,-width=>15,-font => [-size => 12], -foreground =>'black',-show=>'*')->grid(-row=>12,-column=>4);

MainLoop;


#********************��Ϣ��ȡ�ӳ���ʼ,���Ӹ���Ƭ����ͭ��
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
		 $error = "��ܰ��ʾ����û�������Ʒ�������1.6mm����1.6 ";
		 return;
	}else{
		 $error = undef();
	}
#********************�����Ʊߵĳ���˫���Ϊƴ��ߴ磬����ΪCY�ĳ���   
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

##__________________�������;
if ( exists_layer('areat') eq 'yes' ) {
	$f->COM("delete_layer,layer=areat");
	}
if ( exists_layer('areab') eq 'yes' ) {
	$f->COM("delete_layer,layer=areab");
	}
creat_bsp_layer('areat','gtl');
creat_bsp_layer('areab',$b_layer);

##______________________________________����������
	$bzhd = $boardthick * 1000;
	copper_area('areat','areab',$bzhd);
	$drl=$f->{COMANS};
	($areadrl,$bidrl)=split(' ',$drl);
	$areadrl = sprintf "%6.2f",$areadrl/20000;
#_______________________________________����ͭ����

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

#*******************************����GTL������
$f->COM("matrix_layer_context,job=$JOB,matrix=matrix,layer=areat,context=misc");
copper_area('gtl','areab',$bzhd);
$x=$f->{COMANS};
($tarea,$bit)=split(' ',$x);

##$tarea = sprintf "%6.2f",$tarea/10000 - $areadrl;
$tarea = sprintf "%6.2f",$tarea/10000;
$tarea=$tarea- $areadrl;

#*******************************����GBL������
$f->COM("delete_layer,layer=areab");
$f->COM("matrix_layer_context,job=$JOB,matrix=matrix,layer=areat,context=board");
copper_area('areat','gbl',$bzhd);
$y=$f->{COMANS};
($barea,$bib)=split(' ',$y);

$barea = sprintf "%6.2f",$barea/10000;
$barea=$barea - $areadrl;
$f->COM("delete_layer,layer=areat");

if ($Layer_num > 2){$f->COM("undo") ; }

$Bi_hole = sprintf "%6.2f",$boardthick / $minhole;   #�񾶱�


foreach  (@layer_drl){
	if ($_ ne 'drl') {
		$f->COM('matrix_layer_context',
						job=>$JOB,
						matrix=>'matrix',
						layer=>$_ ,
						context=>'board');
		}
}

#*******************************�����ѹ���
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
    #***��ͭ�ʰٷֱ�
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

	#***��ͭ�ʰٷֱ�
	$topbi = "$topbi"."%";
	$botbi = "$botbi"."%";
	return;
	}
}   

#����ERP�ӳ���ʼ  erp20120629   mtlerp-running
sub output_base { 
	my ($datebase, $Server);
	$Server='192.168.10.2';
	$datebase='mtlerp-running';

my $DSN = qq{driver={SQL Server};Server=$Server; database=$datebase;uid=sa;pwd=719799;};

$dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";

@ttt=usr_pass($mima);
if (! $ttt[0]) {$error="$ttt[6]";return}
$error= "$ttt[2]����ӭ��";

my $yesno_button = $mw->messageBox(-message => "Ҫ�������ݿ���?��ȷ��!",-type => "yesno", -icon => "question");
 
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

if ($flagrr == 1) {$error="�������ݿ�ɹ�";}else{$error="�������ݿ�ʧ��"; return };

}
}

#**********************������֤

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

#**********************�������
sub base_help{

$mw->messageBox(-message=> '
ʹ�÷�����
A: �������Ʒ����ٵ������Ϣ��ȡ��
B: ����������֮�����龭γ�Ƿ���ȷ
C: �����������ٵ㡾����ERP��
D: ��������ݿ�ɹ�����Ϣ��ʾ��������ʾ


ע�����
1����Ƭ�׽����Զ���ͭ��
2: ��·�����躸��֮�䲻Ҫ����������
3: δ���ǵ�����ʹ�ã�����������У��벻Ҫ����ERP
4: ����ƴ��ʱ���ܼ��������.�벻Ҫ����ERP
5��ä�װ����ʱ���뽫�����������Ϊ�ǰ����ԣ��ټ����������
6: ����GTL-M,GBL-Mʱ���벻Ҫ����Ϊ��·��
7: ����ERPʱֻ���±�׼������������Ϣ���������
8: ʹ��ʱ�벻Ҫ������������ERP�������ݣ���Ϊ����������Ȼ���Ե���

��ӭ����ʹ��,��ʹ�������б�����������ϵ��!
Name:��Խ����  QQ:214284213  Eaill:mtlmzb@sina.com', -type=> "ok",-icon => "info");
$mw -> deiconify;
}



=head
  �񾭱�   xƴ��Ŀ      yƴ����Ŀ   ��ѹ���      ����               ������      ƴ�泤       ƴ���      ��γ    ƽ�����     ��Ч�߳�  ��Ч�߿�      ��Ʊ߳�     ��Ʊ߿�    top������   bot������
  DeepSpan  LongSpell    WidthSpell  GoodsHeight  Tolerance         GoodsCode  GoodsPlength  GoodsPWidth  MDirect     PS        EffectX    EffectY    RoutEffectX   RoutEffectY    GTLArea       GBLArea
VBEngSub
MDirect='$jinwei',	                       
$sql=qq( insert TBlindHolye (GoodsCode,GoodsPlength,GoodsPWidth, PS,        EffectX,    EffectY,   RoutEffectX, RoutEffectY,  GTLArea,  GBLArea) values
	                         ('$JOB',       '$px',   '$py',     '$pcbnumber','$limitx', '$limity', '$ddx',       '$ddy',      '$areat','$areab') );


#**************************�������Ƭ�׷�ͭƤ����������㡣

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
    #***��ͭ�ʰٷֱ�
	$topbi = "$topbi"."%";
	$botbi = "$botbi"."%";
	$STEP = $ENV{STEP};
	if ($STEP eq 'pnl') {
	$f->COM ('open_entity',job=>$JOB,type=>'step',name=>'pnl',iconic=>'no');
	$f->AUX ('set_group',group=>$f->{COMANS});

	my $sure_button = $mw->messageBox(-message => "��Ƭ������ͭ,���ֶ���ͭ!ǧ�������!",-type => "yesno", -icon => "question");
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
	#***��ͭ�ʰٷֱ�
	$topbi = "$topbi"."%";
	$botbi = "$botbi"."%";
	return;
	}
