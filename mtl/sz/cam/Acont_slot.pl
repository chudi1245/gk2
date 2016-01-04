#!/usr/bin/perl 
#**************************************************************
# 程序名称：统计槽孔长度与数量
# 程序版本：v1.0
# 程序功能描述: 将DRL层反转到另一层drlslot，然后计算槽孔长度与数量
# 开发人员：莫志兵
# 创建时间：2012-4-5
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
$mw->title("槽孔统计");
$mw->Label(-text => "槽孔尺寸:",-relief=>'g',-width=>20,-font => [-size => 14],)->grid(-row=>0,-column=>0);
$mw->Label(-text => "槽孔数量:",-relief=>'g',-width=>10,-font => [-size => 14],)->grid(-row=>0,-column=>1);

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