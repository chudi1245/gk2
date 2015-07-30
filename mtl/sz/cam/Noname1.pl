#!/usr/bin/perl
## Author: melody
## Email: 190170444@qq.com
## Date:  2011.08.09
## Phone: 13424338595
## Describe: 
##_________________________________
use strict;
use Genesis;
use FBI;
use Encode;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

my ($px,$py,);
##______
if ($STEP ne "pnl"){ 
	p__('this must run in pnl step,retun');
	return;
}
my @plimit=prof_limits('pnl', 'mm',);
$px= sprintf "%6.2f",(    $plimit[2] -   $plimit[0]      )/10;
$py= sprintf "%6.2f",(    $plimit[3] -   $plimit[1]      )/10;

my $ref_pnl=info_mm ('step',  "$JOB/pnl",  'MM');
my $limitx =  sprintf  "%6.2f", (  $ref_pnl->{gSR_LIMITSxmax}-$ref_pnl->{gSR_LIMITSxmin}  );
my $limity =  sprintf  "%6.2f", (  $ref_pnl->{gSR_LIMITSymax}-$ref_pnl->{gSR_LIMITSymin}  );

my ($pcb_number,$zk_number,$zk_area)=(0,0,0);
foreach  (  @{$ref_pnl->{gREPEATstep}}  ) {
	if ( $_ =~ m/pc[bs]/i ) { $pcb_number ++	}
	if ( $_ =~ m/zk/i or $_ =~ m/impedance/i ) { $zk_number ++	}
}

if ($zk_number!=0) {
	my $ref_zk=info_mm('step',  "$JOB/zk",  'MM');
    my $zkx = sprintf "%6.2f",$ref_zk->{gPROF_LIMITSxmax} - $ref_zk->{gPROF_LIMITSxmin};
	my $zky = sprintf "%6.2f",$ref_zk->{gPROF_LIMITSymax} - $ref_zk->{gPROF_LIMITSymin};
	$zk_area = $zkx * $zky * $zk_number;
}
####################��ȡ������Ԫ�ߴ磬���PCS���ڣ��ͼ���PCS���������PCB
my $ucs='pcb'; ##������Ԫ
if ( exists_entity('step',"$JOB/pcs") eq 'yes'  ) {  $ucs='pcs'; }
my $ref_ucs=info_mm('step',  "$JOB/$ucs",  'MM');
my $ucs_x= sprintf "%6.2f", $ref_ucs->{gPROF_LIMITSxmax} - $ref_ucs->{gPROF_LIMITSxmin};
my $ucs_y= sprintf "%6.2f", $ref_ucs->{gPROF_LIMITSymax} - $ref_ucs->{gPROF_LIMITSymin};
my $cl_lyn=sprintf "%6.2f", ($ucs_x*$ucs_y*$pcb_number+$zk_area) / ($px*$py*100);

my $ref_pcb=info_mm('layer',  "$JOB/pcb/drl",  'MM');
my $minhole=(    sort{$a<=>$b} @{ $ref_pcb->{gTOOLdrill_size} }   )[0] / 1000;
my $Layer_num= layer_count($JOB); 
###________________________________tk






p__("$Layer_num");


sub info_mm  {
    my ($entity ,$path,$unit)=@_;
	$f->INFO( units => $unit ,
              entity_type =>$entity,
              entity_path =>$path,);
    my $ref=$f->{doinfo};
    return $ref;
}

=head


##########################################



########################
my $mw = MainWindow->new;
##$mw->geometry("280x180");

$mw->update;
  Win32::API->new("user32","SetWindowPos",[qw(N N N N N N
N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);

########################
$mw->title("������Ϣ��2011-10-11��ŵ��д");

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
##########################
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
##########################
$pinx = 1;
$piny = $pcbnumber;
$mw->Label(-text => 'X����ƴ(��):',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>2,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable => \$pinx,-width=>15,-font => [-size => 12],-foreground =>'black')->grid(-row=>2,-column=>1);

$mw->Label(-text => 'Y����ƴ(��):',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>2,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$piny,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>2,-column=>3);
############################

$mw->Label(-text => "ƴ�����:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>0);
$mw->Label(-text => "$pcbnumber",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>1);
$mw->Label(-text => '��Ʒ���(mm)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>2);
$mw->Entry(-background => "white",-textvariable =>\$boardthick,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>3,-column=>3);
my $error = undef();

################################

$mw->Label(-text => "��Ч��X(cm):",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>0);
$mw->Label(-text => "$limitx",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>1);
$mw->Label(-text => "��Ч��(cm)Y:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>2);
$mw->Label(-text =>"$limity",
	-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>3);
###############################
my $ddx = 0;
my $ddy = 0;
if ($Layer_num == 2) {$ddx = $px * 10;$ddy = $py * 10;}
#####$f->PAUSE("$ddx,$ddy");
$mw->Label(-text => '��Ʊ�X(mm)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>5,-column=>0);

$mw->Label(-background => "mediumturquoise",-textvariable => \$ddx,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>1);

$mw->Label(-text => '��Ʊ�Y(mm)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>5,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddy,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>3);


#####################
sub copypanel {$ddx = $px * 10;
               $ddy = $py * 10;
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddx,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>1);
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddy,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>3);
  }
#########################
$mw->Label(-text => 'ͼ��TOP��DM2��',
	-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>6,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable => \$tarea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>6,-column=>1);
$mw->Label(-text => 'ͼ��BOT��DM2��',
	-relief=>'g', -width=>15,-font => [-size => 12],)->grid(-row=>6,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$barea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>6,-column=>3);
$mw->Button(-text => "��Ϣ��ȡ",
-relief=>'raised',-width=>15,-font => [-family=>'����',-size => 16], 
-command =>\&sunarea)->grid(-row=>3,-column=>4);
#################
my $error = undef();
sub sunarea{

	$f->COM(units, type =>"mm");
	my ($bit,$bib,$x,$y,);
####my $boardarea;


if (!$boardthick) {$error = "��ܰ��ʾ����û�������Ʒ���������1.6mm����1.6 "; return;}
else {$error = undef();}
    
$bzhd = $boardthick * 1000;


	
	
if ($Layer_num > 2) {
$f->COM("display_layer,name=cy,display=no,number=1");
$f->COM("display_layer,name=cy,display=yes,number=1");
$f->COM("work_layer,name=cy");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("sel_create_profile");
$f->COM("display_layer,name=cy,display=no,number=1");
#########################
    $f->INFO(units => 'mm',
	entity_type => 'step',
	entity_path => "$JOB/pnl",);
#########################
$cyxmax = $f->{doinfo}{gPROF_LIMITSxmax};
$cyymax = $f->{doinfo}{gPROF_LIMITSymax};
$cyxmin = $f->{doinfo}{gPROF_LIMITSxmin};
$cyymin = $f->{doinfo}{gPROF_LIMITSymin};
$ddx = sprintf "%6.2f",($cyxmax - $cyxmin);
$ddy = sprintf "%6.2f",($cyymax - $cyymin); 
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddx,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>1);
$mw->Label(-background => "mediumturquoise",-textvariable => \$ddy,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>3);
    
   }
###########�������㣬��������Ϊboard�㡣
$f->INFO(entity_type => 'layer',
         entity_path => "$JOB/pnl/areat",
         data_type => 'EXISTS');

$areat_exists = $f->{doinfo}{gEXISTS};

##############$f->PAUSE("$areat_exists, $areab_exists ");

if ($areat_exists eq 'yes') { $f->COM("delete_layer,layer=areat"); }

$f->INFO(entity_type => 'layer',
         entity_path => "$JOB/pnl/areab",
         data_type => 'EXISTS');

$areab_exists = $f->{doinfo}{gEXISTS};
if ($areab_exists eq 'yes') { $f->COM("delete_layer,layer=areab"); }

######$f->PAUSE("$areat_exists, $areab_exists ");

$f->COM("create_layer,layer=areat,context=board,type=signal,polarity=positive,ins_layer=gtl");
$f->COM("create_layer,layer=areab,context=board,type=signal,polarity=positive,ins_layer=box");

###########����������
$f->COM("copper_area,layer1=areat,layer2=areab,drills=yes,consider_rout=no,drills_source=matrix,thickness=$bzhd,resolution_value=25.4,x_boxes=3,y_boxes=3,area=no,dist_map=yes");
$drl=$f->{COMANS};
($areadrl,$bidrl)=split(' ',$drl);
$areadrl = sprintf "%6.2f",$areadrl/20000;
#####################################���������
$f->COM ("display_layer,name=areat,display=yes,number=1");
$f->COM ("work_layer,name=areat");
$f->COM ("fill_params,type=solid,origin_type=datum,solid_type=fill,std_type=line,min_brush=508,use_arcs=yes,symbol=,dx=2.54,dy=2.54,std_angle=45,std_line_width=254,std_step_dist=1270,std_indent=odd,break_partial=yes,cut_prims=no,outline_draw=no,outline_width=0,outline_invert=no");
$f->COM ("sr_fill,polarity=positive,step_margin_x=0,step_margin_y=0,step_max_dist_x=2540,step_max_dist_y=2540,sr_margin_x=-2540,sr_margin_y=-2540,sr_max_dist_x=0,sr_max_dist_y=0,nest_sr=yes,consider_feat=no,consider_drill=no,consider_rout=no,dest=affected_layers,attributes=no,use_profile=use_profile");
#################################
$f->COM ("display_layer,name=areab,display=yes,number=1");
$f->COM ("work_layer,name=areab");
$f->COM("sr_fill,polarity=positive,step_margin_x=0,step_margin_y=0,step_max_dist_x=2540,step_max_dist_y=2540,sr_margin_x=-2540,sr_margin_y=-2540,sr_max_dist_x=0,sr_max_dist_y=0,nest_sr=yes,consider_feat=no,consider_drill=no,consider_rout=no,dest=affected_layers,attributes=no,use_profile=use_profile");

##############################
$f->COM("copper_area,layer1=areat,layer2=areab,drills=yes,consider_rout=no,drills_source=matrix,thickness=$bzhd,resolution_value=25.4,x_boxes=3,y_boxes=3,area=no,dist_map=yes");
$karea=$f->{COMANS};
($areak,$bik)=split(' ',$karea);
$boardarea = sprintf "%6.2f", $areak/20000;

###$areak = sprintf "%6.2f",$areak/10000;
###$boardarea = sprintf "%6.2f", $areak - $areadrl;
####$boardarea = sprintf "%6.2f", $ddx * $ddy/10000 + $areadrl;
$f->COM("undo") ;
$f->COM("undo") ;
##########################����GTL���
$f->COM("open_entity,job=$JOB,type=matrix,name=matrix,iconic=no");
$f->COM("matrix_layer_context,job=$JOB,matrix=matrix,layer=areat,context=misc");
$f->COM("matrix_page_close,job=$JOB,matrix=matrix");

$f->COM("copper_area,layer1=gtl,layer2=areab,drills=yes,consider_rout=no,drills_source=matrix,thickness=$bzhd,resolution_value=25.4,x_boxes=3, y_boxes=3,area=no,dist_map=yes");
$x=$f->{COMANS};
($tarea,$bit)=split(' ',$x);
$tarea = sprintf "%6.2f",$tarea/10000 - $areadrl;

###########����GBL
$f->COM("open_entity,job=$JOB,type=matrix,name=matrix,iconic=no");
$f->COM("delete_layer,layer=areab");
$f->COM("matrix_layer_context,job=$JOB,matrix=matrix,layer=areat,context=board");
$f->COM("matrix_page_close,job=$JOB,matrix=matrix");

$f->COM("copper_area,layer1=areat,layer2=gbl,drills=yes,consider_rout=no,drills_source=matrix,thickness=$bzhd,resolution_value=25.4,x_boxes=3, y_boxes=3,area=no,dist_map=yes");
$y=$f->{COMANS};
($barea,$bib)=split(' ',$y);
$barea = sprintf "%6.2f",$barea/10000 - $areadrl;

$f->COM("delete_layer,layer=areat");

##################
if ($Layer_num > 2){$f->COM("undo") ; }
##################�����������
$Bi_hole = sprintf "%6.2f",$boardthick / $minhole;
$mw->Label(-text => '��������DM2��',
	-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>7,-column=>0);
$mw->Label(-background => "tan",-textvariable => \$boardarea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>7,-column=>1);

$mw->Label(-text => '�񾶱ȣ�',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>7,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$Bi_hole,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>7,-column=>3);

$Lamithick = $boardthick - 0.1;

$mw->Label(-text => '��ѹ���(mm)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>9,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable =>\$Lamithick,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>9,-column=>1);
####$mw->Label(-text => '��񹫲�',
####	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>9,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$borance,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>9,-column=>3);

}
##################�����������
$mw->Label(-text => '��������DM2��',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>7,-column=>0);
$mw->Label(-background => "tan",-textvariable => \$boardarea,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>7,-column=>1);
$mw->Label(-text => '�񾶱ȣ�',-relief=>'g',-width=>15, -font => [-size => 12],)->grid(-row=>7,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$Bi_hole,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>7,-column=>3);
##################
$mw->Label(-text => '�����ߴ�(mm)X',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>0);
$mw->Label(-text => "$pcbx",
	-relief=>'g',-background => "tan",-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>1);
$mw->Label(-text => '�����ߴ�(mm)Y',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>2);
$mw->Label(-text => "$pcby",
	-relief=>'g',-background => "tan",-width=>15,-font => [-size => 12],)->grid(-row=>8,-column=>3);

#######################
$borance = 0.1;

$mw->Label(-text => '��ѹ���(mm)',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>9,-column=>0);
$mw->Label(-background => "mediumturquoise",-textvariable =>\$Lamithick,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>9,-column=>1);
$mw->Label(-text => '��񹫲�',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>9,-column=>2);
$mw->Label(-background => "mediumturquoise",-textvariable => \$borance,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>9,-column=>3);
#######################
$mw->Button(-text => "����ERP",
	-relief=>'raised',-width=>15,-font => [-family=>'����',-size => 16], 
	-command =>\&output_base)->grid(-row=>5,-column=>4);
$mw->Button(-text => '�ر��˳�',
	-relief=>'raised',-width=>15,-font=>[-family=>'����',-size=>16],
	-command => sub { exit })->grid(-row=>7,-column=>4);

$mw->Label(-text => '��Ϣ��ʾ',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>10,-column=>0);

$mw->Label(-textvariable => \$error,-foreground =>'red',-background => "bisque",-width=>70,-font => [-size => 12],)->grid(-row=>10,-column=>1,-columnspan=>110,);

$mw->Button(-text => '�������',
	-relief=>'g',-width=>12,-font=>[-size=>14],
	-command =>\&base_help)->grid(-row=>11,-column=>0);

$mw->Label(-text => '��������',
	-relief=>'g',-width=>12,-font => [-size => 14],)->grid(-row=>11,-column=>3);
$mw->Entry(-background => "white",-textvariable => \$mima,-width=>15,-font => [-size => 12], -foreground =>'black',-show=>'*')->grid(-row=>11,-column=>4);

MainLoop;

#######################����ERP
sub output_base {
####$DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;';
$DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;  uid=sa;pwd=719799;';
$dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";

@ttt=usr_pass($mima);
if (! $ttt[0]) {$error="$ttt[6]";return}

$error= "$ttt[2]";
return;
my $yesno_button = $mw->messageBox(-message => "Ҫ�������ݿ���. ��ȷ��?",-type => "yesno", -icon => "question");
 
if ($yesno_button eq "No") {return;} else{

$sql=qq( update TBlindHolye set GoodsPlength= '$px',GoodsPWidth='$py',MDirect='$jinwei',DeepSpan='$Bi_hole',
	     LongSpell='$pinx',WidthSpell='$piny',GoodsHeight='$Lamithick',Tolerance='$borance',PS='$pcbnumber',
	     EffectX='$limitx',EffectY='$limity', RoutEffectX='$ddx',RoutEffectY='$ddy',
	     GTLArea='$tarea',GBLArea='$barea' where GoodsCode='$JOB' );

$sql=encode('gb2312',$sql);

$sth = $dbh->prepare ($sql );

###my $flagrr=$sth->execute();
 
###$sql=qq(Insert into tblog(LogContent) select  ($JOB.$ttt[2],)); 

if ($flagrr == 1) {$error="�������ݿ�ɹ�";}

}
}
#######################������֤
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
#######################�������
sub base_help{
####my $base_mw = MainWindow->new;
####$base_mw -> withdraw;
$mw->messageBox(-message=> 'A:����������֮�����龭γ�Ƿ���ȷ.
B:�������Ʒ����ٵ����Ϣ��ȡ!!!
C:����ERPǰ����������.
D:��������ݿ�ɹ�����Ϣ��ʾ��������ʾ.
E:δ���ǵ�����ʹ�ã�����������У��벻Ҫ����ERP.
F:����ƴ��ʱ���ܼ��������.�벻Ҫ����ERP.
G:����ERP��������genesis������ɫɫ��ʾ��������ERP��������ݱɫ��ʾ!
H:����ERPʱֻ���±�׼������������Ϣ���������.
I:ʹ��ʱ�벻Ҫ������������ERP�������ݣ���Ϊ����������Ȼ���Ե���.
��ӭ����ʹ��,��ʹ�������б�����������ϵ��!
Name:Ī־��  QQ:214284213��ŵ  Eaill:mtlmzb@sina.com', -type=> "ok",-icon => "info");
$mw -> deiconify;
}

##  �񾭱�   xƴ��Ŀ      yƴ����Ŀ   ��ѹ���      ����               ������      ƴ�泤       ƴ���      ��γ    ƽ�����     ��Ч�߳�  ��Ч�߿�      ��Ʊ߳�     ��Ʊ߿�    top������   bot������
##  DeepSpan  LongSpell    WidthSpell  GoodsHeight  Tolerance         GoodsCode  GoodsPlength  GoodsPWidth  MDirect     PS        EffectX    EffectY    RoutEffectX   RoutEffectY    GTLArea       GBLArea
##VBEngSub
##MDirect='$jinwei',	                       
##$sql=qq( insert TBlindHolye (GoodsCode,GoodsPlength,GoodsPWidth, PS,        EffectX,    EffectY,   RoutEffectX, RoutEffectY,  GTLArea,  GBLArea) values
##	                         ('$JOB',       '$px',   '$py',     '$pcbnumber','$limitx', '$limity', '$ddx',       '$ddy',      '$areat','$areab') );



============================

my $ref_matrix=info_mm('matrix',  "$JOB/matrix",  'MM');
my @gROWcontext   =@{$ref_matrix->{gROWcontext}};
my @gROWlayer_type=@{$ref_matrix->{gROWlayer_type}};
my @gROWname      =@{$ref_matrix->{gROWname}};
my @gROWtype      =@{$ref_matrix->{gROWtype}};
my @gROWside      =@{$ref_matrix->{gROWside}};
