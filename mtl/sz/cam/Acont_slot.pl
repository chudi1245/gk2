#!/usr/bin/perl 
#**************************************************************
# �������ƣ�ͳ�Ʋۿ׳���������
# ����汾��v1.0
# ����������: ��DRL�㷴ת����һ��drlslot��Ȼ�����ۿ׳���������
# ������Ա��Ī־��
# ����ʱ�䣺2012-4-5
#**************************************************************
use FBI;
use Tk;
use Win32;
use Win32::API;
use Encode;
use encoding 'euc_cn';
#####################
kysy();

my $mw = MainWindow->new;
$mw->geometry("+200+150");
$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
$mw->title("�ۿ�ͳ��");
$mw->Label(-text => "�ۿ׳ߴ�:",-relief=>'g',-width=>20,-font => [-size => 14],)->grid(-row=>0,-column=>0);
$mw->Label(-text => "�ۿ�����:",-relief=>'g',-width=>10,-font => [-size => 14],)->grid(-row=>0,-column=>1);

open (FILES, "C://tmp//slot_info");
@slotlist=<FILES>;
close(FILES);

$i= 1;
foreach $slot (@slotlist){
($a,$b,$c,$d) = split(' ',$slot);
$a =~ s/r//;
$a=$a/1000;

$slot_long=$a + $b;
$size = "$a"."x"."$slot_long"."mm";

$mw->Label(-text =>$size, -relief=>'g',-width=>20,-font => [-size => 14],)->grid(-row=>$i,-column=>0);
$mw->Label(-text =>$d,    -relief=>'g',-width=>10,-font => [-size => 14],)->grid(-row=>$i,-column=>1);
$i++;
}
MainLoop;

=h


##$d = substr $slot, -3; 
###$a = substr $a,1,;
##$host = shift;
##$f = new Genesis;
##$JOB  = $ENV{JOB};
##$STEP = $ENV{STEP};
##use Genesis;