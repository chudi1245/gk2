#!/usr/bin/perl
######10-10-2011  ԤͶ����
use Win32;
use Win32::API;
use Tk;
use Genesis;
use Encode;
use encoding 'euc_cn';
$host = shift;
$f = new Genesis;
$JOB  = $ENV{JOB};
$STEP = $ENV{STEP};

kysy();

my ($pcbpnl,$dytn,$jhsn,$dytn,$sheet_num,$pnl_num,$pcbpn);

#####################

if ($STEP ne "pnl"){$f->PAUSE("Please running at PNL"); return;}


#####################��������
$f->INFO(units => 'mm', entity_type => 'matrix',
         entity_path => "$JOB/matrix");
@gROWrow = @{$f->{doinfo}{gROWrow}};

@gROWcontext   =@{$f->{doinfo}{gROWcontext}};
@gROWlayer_type=@{$f->{doinfo}{gROWlayer_type}};
@gROWname      =@{$f->{doinfo}{gROWname}};
@gROWtype      =@{$f->{doinfo}{gROWtype}};
@gROWside      =@{$f->{doinfo}{gROWside}};

######################$gROWside[$_] eq 'inner'  && $gROWlayer_type[$_] eq 'signal' 
my $Layer_num = 0;
foreach (@gROWrow){	
     if ($gROWcontext[$_] eq 'board' && $gROWlayer_type[$_] eq 'signal' || $gROWlayer_type[$_] eq 'power_ground' || $gROWlayer_type[$_] eq 'mixed') 
	 {$Layer_num++;}}

if ($Layer_num > 2) {$core_num = ($Layer_num - 2) / 2;;}

else {$core_num = 1;}


#####################
$f->INFO(units => 'inch',
	entity_type => 'step',
	entity_path => "$JOB/pnl",);
#########################

$profxmax = $f->{doinfo}{gPROF_LIMITSxmax};
$profymax = $f->{doinfo}{gPROF_LIMITSymax};
$profxmin = $f->{doinfo}{gPROF_LIMITSxmin};
$profymin = $f->{doinfo}{gPROF_LIMITSymin};

$px = sprintf "%6.2f",($profxmax - $profxmin);
$py = sprintf "%6.2f",($profymax - $profymin);

@pcbnumbers = @{$f->{doinfo}{gREPEATstep}};
#____________����ƴ������
$pcbnumber=0;
$zknumber=0;
foreach (@pcbnumbers) {if ($_ eq 'pcb' || $_ eq 'pcs') {$pcbnumber++;} 
                       if ($_ eq 'zk') {$zknumber++;}
                       }

if ($zknumber!=0) {

$f->INFO(units => 'mm',entity_type => 'step',
        entity_path => "$JOB/zk",);

$zkxmax = $f->{doinfo}{gPROF_LIMITSxmax};
$zkymax = $f->{doinfo}{gPROF_LIMITSymax};
$zkxmin = $f->{doinfo}{gPROF_LIMITSxmin};
$zkymin = $f->{doinfo}{gPROF_LIMITSymin};

$zkx = sprintf "%6.2f",$zkxmax - $zkxmin;
$zky = sprintf "%6.2f",$zkymax - $zkymin;
$zkarea = $zkx * $zky * $zknumber;
       }

####################��ȡ������Ԫ�ߴ磬���PCS���ڣ��ͼ���PCS���������PCB��
$f->INFO(entity_type => 'step',
         entity_path => "$JOB/pcs",
         data_type => 'EXISTS');

$step_exists = $f->{doinfo}{gEXISTS};

if ($step_exists eq 'yes') { $spcb = pcs;}
else {$spcb=pcb;}

$f->INFO(units => 'mm',entity_type => 'step',
        entity_path => "$JOB/$spcb",);
$pcbxmax = $f->{doinfo}{gPROF_LIMITSxmax};
$pcbymax = $f->{doinfo}{gPROF_LIMITSymax};

$pcbxmin = $f->{doinfo}{gPROF_LIMITSxmin};
$pcbymin = $f->{doinfo}{gPROF_LIMITSymin};

$pcbx = sprintf "%6.2f",$pcbxmax - $pcbxmin;
$pcby = sprintf "%6.2f",$pcbymax - $pcbymin;
$pcbarea = $pcbx * $pcby * $pcbnumber;
#������������������������������������������������ ����������
$cl_lyn = sprintf "%6.2f",($zkarea + $pcbarea) / ($px *$py * 25.4 * 25.4);  

########################����
my $mw = MainWindow->new;

#$mw->geometry("200x100");
$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
$mw->title("Better and better!");

########################
$mw->Label(-text => "������:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>0);
$mw->Label(-text =>$JOB,-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>1);


$mw->Label(-text => "����������:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>2);
$mw->Label(-text => "$cl_lyn",-relief=>'g',-background => "tan",-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>3);

##########################
$mw->Label(-text => "Panel(X)inch:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>0);
$mw->Label(-text => "$px",-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>1);

$mw->Label(-text => "Panel(Y)inch:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>2);
$mw->Label(-text => "$py",-relief=>'g',-background => "mediumturquoise",-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>3);


$mw->Label(-text => "ÿpnlƴ��:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>2,-column=>0);

$mw->Entry(-background => "cornsilk",-textvariable =>\$pcbnumber,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>2,-column=>1);


$mw->Label(-text => "ÿ����pnl��:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>0);

$mw->Entry(-background => "cornsilk",-textvariable =>\$pcbpnl,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>3,-column=>1);


$mw->Label(-text => "��������:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>0);

$mw->Entry(-background => "cornsilk",-textvariable =>\$jhsn,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>4,-column=>1);


$mw->Label(-text => "ԤͶ��(0.?) :",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>5,-column=>0);

$mw->Entry(-background => "cornsilk",-textvariable =>\$dytn,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>1);

##########################��ʾ������

$mw->Label(-text => "�����:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>2,-column=>2);
$mw->Entry(-background => "cornsilk",-textvariable =>\$Layer_num,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>2,-column=>3);

$mw->Label(-text => "о����:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>3,-column=>2);
$mw->Entry(-background => "cornsilk",-textvariable =>\$core_num,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>3,-column=>3);

$mw->Label(-text => "������:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>4,-column=>2);
$mw->Entry(-background => "cornsilk",-textvariable =>\$sheet_nums,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>4,-column=>3);

$mw->Label(-text => "panel��:",-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>5,-column=>2);
$mw->Entry(-background => "cornsilk",-textvariable =>\$pnl_num,-width=>15,-font => [-size => 12], -foreground =>'black')->grid(-row=>5,-column=>3);


$mw->Button(-text => '���ϼ���',-relief=>'raised',-width=>15,-font=>[-family=>'����',-size=>16],-command =>\&Count_sheet)->grid(-row=>4,-column=>4);

$mw->Button(-text => '�ر��˳�',-relief=>'raised',-width=>15,-font=>[-family=>'����',-size=>16],-command => sub { exit })->grid(-row=>6,-column=>4);

###$f->PAUSE("$core_num");

MainLoop;

####################�ӳ���1
sub Count_sheet { 
	
	$sheet_num = ($jhsn * (1 + $dytn) )/ ($pcbnumber * $pcbpnl ) ;
	$sheet_nums = $sheet_num * $core_num;
	$pnl_num = $sheet_num * $pcbpnl;

               }
####################�ӳ���2
sub base_help{

$mw->messageBox(-message=> 'A:�������ڴ��ϼ�����Ͷ��panel����.
B:���ϼ�����Ҫ����ÿ����PNL��������������ԤͶ��.
C:���ֻҪ�ô��ϼ��㣬����ֻҪ��GENESIS�Ϳ�������.
��ӭ����ʹ��,��ʹ�������б�����������ϵ��!
Name:Ī־��  QQ:214284213��ŵ  Eaill:mtlmzb@sina.com', -type=> "ok",-icon => "info");
$mw -> deiconify;
 
			  }


























