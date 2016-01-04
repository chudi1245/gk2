#!/usr/bin/perl
######10-14
use Tk;
use Win32;
use Win32::API;
use Genesis;
use encoding 'euc_cn';
$host = shift;
$f = new Genesis;
$JOB  = $ENV{JOB};
####$STEP = $ENV{STEP};
$f->INFO(entity_type => 'step',
         entity_path => "$JOB/pcs",
         data_type => 'EXISTS');
$pcs_exists = $f->{doinfo}{gEXISTS};

if ($pcs_exists eq 'yes') { $STEP = pcs;} else {$STEP=pcb;}
#########################
$f->INFO(units => 'inch',entity_type => 'step',
        entity_path => "$JOB/$STEP",);
$pcbxmax = $f->{doinfo}{gPROF_LIMITSxmax};
$pcbymax = $f->{doinfo}{gPROF_LIMITSymax};

$pcbxmin = $f->{doinfo}{gPROF_LIMITSxmin};
$pcbymin = $f->{doinfo}{gPROF_LIMITSymin};

$pcbx = sprintf "%6.6f",$pcbxmax - $pcbxmin;
$pcby = sprintf "%6.6f",$pcbymax - $pcbymin;

$pcbmx = $pcbx * 25.4;
$pcbmy = $pcby * 25.4;

#####################
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
     if ($gROWcontext[$_] eq 'board' && $gROWlayer_type[$_] eq 'signal' ) 
	 {$Layer_num++;}}


   if ($Layer_num == 2 ) {$borderx = 0.315;$bordery = 0.315;}
elsif ($Layer_num == 4 ) {$borderx = 0.512;$bordery = 0.512;}
elsif ($Layer_num >= 6) {$borderx = 0.709;$bordery = 0.709;}
##################################
my $mw = MainWindow->new;

##$mw->geometry("280x180");
$mw->update;
  Win32::API->new("user32","SetWindowPos",[qw(N N N N N N
N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
##################################

$mw->title("ƴ����� ��ŵ2011-10-24");

$mw->Label(-text => "������:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>0);
$mw->Label(-text =>$JOB,
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>1);

$mw->Label(-text => "$Layer_num ���:",
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>0,-column=>2);


$mw->Label(-text => '��ֻ�ߴ�(inch)X',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>0);
$mw->Label(-text => "$pcbx",
	-relief=>'g',-width=>15,-bg=>'beige',-font => [-size => 12],)->grid(-row=>1,-column=>1);
$mw->Label(-text => '��ֻ�ߴ�(inch)Y',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>1,-column=>2);
$mw->Label(-text => "$pcby",
	-relief=>'g',-width=>15,-bg=>'beige',-font => [-size => 12],)->grid(-row=>1,-column=>3);


$mw->Label(-text => '��ֻ�ߴ�(mm)X',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>2,-column=>0);
$mw->Label(-text => "$pcbmx",
	-relief=>'g',-width=>15,-bg=>'beige',-font => [-size => 12],)->grid(-row=>2,-column=>1);
$mw->Label(-text => '��ֻ�ߴ�(mm)Y',
	-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-row=>2,-column=>2);
$mw->Label(-text => "$pcbmy",
	-relief=>'g',-width=>15,-bg=>'beige',-font => [-size => 12],)->grid(-row=>2,-column=>3);

$mw->Label(-text => "��ʾ:���ȼ���PCS��û�������PCB",
	-relief=>'g',-width=>48,-font => [-size => 12],)->grid(-row=>3,-column=>0,-columnspan=>3);

$mw->Button(-text => "����ƴ��",
	-relief=>'g',-width=>12,-bg=>'darkturquoise',-font=>[-family=>'����',-size=>14],
	-command =>\&output_base)->grid(-row=>3,-column=>3);

$mw->Button(-text => '�������',-relief=>'g',-width=>12,-font=>[-family=>'����',-size=>14],
	-command =>\&base_help)->grid(-row=>4,-column=>2);

$mw->Button(-text => '�ر��˳�',-relief=>'g',-width=>12,-font=>[-family=>'����',-size=>14],
	-command => sub { exit })->grid(-row=>4,-column=>3);

MainLoop;

####################C:\WINDOWS\system32
sub output_base {
	open (OUTFILE,">c:/WINDOWS/system32/ispsysnet.dll");	
	print OUTFILE "num= \n";
	print OUTFILE "Tnum= \n";
	print OUTFILE "s(y=a?d!=gJa2gRa3GRiYGq\n";
	close(OUTFILE); 
	  open (OUTFILE,">c:/genesis/Panel/IPSinitS.int");	
	  print OUTFILE "Set_L=$pcbx\n";
	  print OUTFILE "Set_W=$pcby\n";
      print OUTFILE "Set_C=0.078740157480315\n";
	  print OUTFILE "BorderX_L=$borderx\n";
	  print OUTFILE "BorderX_W=$bordery\n";
	  print OUTFILE "Min_PL=6\n";
	  print OUTFILE "Min_PW=4\n";
	  print OUTFILE "Max_PL=24\n";
	  print OUTFILE "Max_PW=21.5\n";
	  print OUTFILE "PLPW_ratio=2.5\n";
	  print OUTFILE "Min_lv=50.00\n";
	  print OUTFILE "Part_L=1.9\n";
      print OUTFILE "Part_W=1.3\n";
      print OUTFILE "Part_C=0.078740157480315\n";
      print OUTFILE "Min_SetL=5\n";
      print OUTFILE "Min_SetW=4\n";
      print OUTFILE "Max_SetL=12\n";
      print OUTFILE "Max_SetW=8\n";
      print OUTFILE "SetBorder_L=0.4\n";
      print OUTFILE "SetBorder_W=0.4\n";
      print OUTFILE "PanelNumber=1\n";
      print OUTFILE "AUTOPanel=False\n";
      print OUTFILE "GoodBase=True\n";
      print OUTFILE "BothPanel=True\n";
      print OUTFILE "BothBase=False\n";
      print OUTFILE "Tooling=False\n";
	  print OUTFILE "CompName=������̩����·�������޹�˾";
      
      close(OUTFILE); 
      exec("start C:/genesis/Panel/Pcb_panel.exe"); 
###	  system("cmd /c START C:/genesis/Panel/Pcb_panel.exe");
      exit;
	  }

sub base_help{
$mw->messageBox(-message=> 'A:������������Ѽ������ֻ�ߴ�.
B:�������ƴ�彫����ƴ�������ֻ�ߴ磬��Ʊߴ�С!!!
C:ƴ���������������.
D:ƴ��������Ը�����Ҫ�Լ���������.
��ӭ����ʹ��,��ʹ�������б�����������ϵ��!
Name:Ī־��  QQ:214284213��ŵ  Eaill:mtlmzb@sina.com', -type=> "ok",-icon => "info");
$mw -> deiconify;
              }






