#!/usr/bin/perl -w
##use DBD::ODBC;
use Encode;
use Win32;
use Win32::API;
use Genesis;
use encoding 'euc_cn';
$host = shift;
$f = new Genesis;
$JOB  = $ENV{JOB};
$STEP = $ENV{STEP};
$f->COM(units, type =>"mm");

kysy();

####################################################
$f->INFO(units => 'mm', entity_type => 'matrix',
         entity_path => "$JOB/matrix");
@gROWrow = @{$f->{doinfo}{gROWrow}};
##$f->PAUSE("@gROWrow");
@gROWcontext   =@{$f->{doinfo}{gROWcontext}};
@gROWlayer_type=@{$f->{doinfo}{gROWlayer_type}};
@gROWname      =@{$f->{doinfo}{gROWname}};
@gROWtype      =@{$f->{doinfo}{gROWtype}};
@gROWside      =@{$f->{doinfo}{gROWside}};
######################$gROWside[$_] eq 'inner'  && $gROWlayer_type[$_] eq 'signal' 
my $count = 0;
my $cu = 0;
my $bi = 0;
$mw=MainWindow->new;
##$mw->geometry("460x280");
$mw->update;
  Win32::API->new("user32","SetWindowPos",[qw(N N N N N N
N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
#####################
$mw->title("�����ڲ��ͭ�ʣ���ŵ��д");
my ($column,$row,)=(undef,0,0);
my @label=qw{������ ���� ͼ����� ��ͭ��};
##my @label=qw{aa bb cc dd };
###$f->PAUSE("$column");
###$f->PAUSE("@pcbnumbers");
foreach $_ (@label) {  
	##$f->PAUSE("$column");
	$mw->Label(-text=>$_,-width=>10,-relief=>'g',-font => [-size => 16],)->grid(-column=>$column++, -row=>0);}
	
foreach (@gROWrow) {
	
if ($gROWcontext[$_] eq 'board' && $gROWside[$_] eq 'inner' ) {
$f->COM("copper_area,layer1=$gROWname[$_],layer2=,drills=yes,consider_rout=no,drills_source=matrix,thickness=0,resolution_value=25.4,x_boxes=3, y_boxes=3,area=no,dist_map=yes");
$count++;

$x=$f->{COMANS};
($a,$b)=split(' ',$x);
$a = sprintf "%6.2f",$a/10000;
$b = sprintf "%6.2f",$b;
$cu+=$a;
$bi+=$b;
###$f->PAUSE("$a  $b");
$mw->Label(-text=>$JOB,-width=>10,-relief=>'g',-font => [-size => 16],)->grid(-column=>0, -row=>$_+1);
$mw->Label(-text=>$gROWname[$_],-width=>10,-relief=>'g',-font => [-size => 16],)->grid(-column=>1, -row=>$_+1);
$mw->Label(-text=>$a,-width=>10,-relief=>'g',-font => [-size => 16],)->grid(-column=>2, -row=>$_+1);
$mw->Label(-text=>$b,-width=>10,-relief=>'g',-font => [-size => 16],)->grid(-column=>3, -row=>$_+1);

}
}

$avcu = sprintf "%6.2f",$cu/$count;
$avbi = sprintf "%6.2f",$bi/$count;
###$f->PAUSE(" $cu : $count : $avcu : $bi : $count : $avbi ");
if ($count!=0) {

$mw->Label(-text=>'ƽ�����',-width=>10,-relief=>'g',-font => [-size => 16],)->grid(-column=>0, -row=>$_+1);
$mw->Label(-text=>$avcu,-width=>10,-relief=>'g',-background => 'cyan',-foreground => 'black',-font => [-size => 16],)->grid(-column=>1, -row=>$_+1);
$mw->Label(-text=>'ƽ������',-width=>10,-relief=>'g',-font => [-size => 16],)->grid(-column=>2, -row=>$_+1);
$mw->Label(-text=>$avbi,-width=>10,-relief=>'g',-background => 'cyan',-foreground => 'black',-font => [-size => 16],)->grid(-column=>3, -row=>$_+1);

open (OUTFILE,">>d:/tmp/$JOB.txt");
	    print OUTFILE "avcu is$avcu DM2  avbi is $avbi % \n";
        close(OUTFILE);
}

my $CU_thick;
$mw->Label(-text => '�ڲ�ͭ��(OZ)',-relief=>'g',-width=>15,-font => [-size => 16],)->grid(-row=>2,-column=>1);

$mw->Entry(-background => "white",-textvariable =>\$CU_thick,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>2,-column=>2);


$mw->Button(-text => '�������',
	-relief=>'g',-width=>12,-font=>[-size=>14],
	-command =>\&base_help)->grid(-row=>2,-column=>0);


$mw->Button(-text => "�������(mm)",-relief=>'g',-width=>15,-font => [-size => 16], -command =>\&Sun_lose)->grid(-row=>2,-column=>4);

$mw->Entry(-background => "white",-textvariable =>\$Lose_hd,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>2,-column=>3);

MainLoop;
#######################
sub Sun_lose{ 
$CAN_cu = $avbi/100;
$Lose_hd = (1-$CAN_cu) * $count * $CU_thick * 0.035;
           }
#######################�������
sub base_help{
$mw->messageBox(-message=> 'A:������������Ѽ�����ڲ�ÿ��������Ͳ�ͭ��.
B:������ͭ���ٵ���������!!!
C:ͭ��1OZ������1.
D:ͭ��һ��δ����.
��ӭ����ʹ��,��ʹ�������б�����������ϵ��!
Name:Ī־��  QQ:214284213��ŵ  Eaill:mtlmzb@sina.com', -type=> "ok",-icon => "info");
$mw -> deiconify;
}


