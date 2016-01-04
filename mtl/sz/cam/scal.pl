#!/usr/bin/perl -w
use perl_gen;
use Tk;
use Win32;
use FBI;
use Win32::API;
use Encode;
use Data::Dump 'dump';
require 'shellwords.pl';
$JOB=$ENV{JOB};
$STEP=$ENV{STEP};
$f = new perl_gen;

kysy();

#($sec,$min,$hour,$day,$mon,$year,$weekday,$yeardate,$savinglightday) = (localtime(time));
#$day = ($day < 10)? "0$day":$day;
#$mon = ($mon < 9)? "0".($mon+1):($mon+1);
#$year += 1900;  

#$date="$year$mon$day";
#if ($date > 20130612) {#
#	exit;
#}

my $name_ming1 = "调整<比例><偏移><角度><镜像>:";
$name_ming1=decode("cp936",$name_ming1);
my $name_ming2 = "比例:";
$name_ming2=decode("cp936",$name_ming2);
my $name_ming3 = "转换";
$name_ming3=decode("cp936",$name_ming3);
my $name_ming4 = "偏移:";
$name_ming4=decode("cp936",$name_ming4);
my $name_ming5 = "角度:";
$name_ming5=decode("cp936",$name_ming5);
my $name_ming6 = "镜像:";
$name_ming6=decode("cp936",$name_ming6);
my $name_ming7 = "X轴镜像";
$name_ming7=decode("cp936",$name_ming7);
my $name_ming8 = "Y轴镜像";
$name_ming8=decode("cp936",$name_ming8);
my $name_ming9 = "文字缩放";
$name_ming9=decode("cp936",$name_ming9);
my $name_ming10 = "字框缩放";
$name_ming10=decode("cp936",$name_ming10);
my $name_ming11 = "自动缩放";
$name_ming11=decode("cp936",$name_ming11);
my $name_ming12 = "调整<高度><间距><密度>:";
$name_ming12=decode("cp936",$name_ming12);
my $name_ming13 = "高度:";
$name_ming13=decode("cp936",$name_ming13);
my $name_ming14 = "间距:";
$name_ming14=decode("cp936",$name_ming14);
my $name_ming15 = "密度:";
$name_ming15=decode("cp936",$name_ming15);
my $name_ming16 = "文字高度:";
$name_ming16=decode("cp936",$name_ming16);
my $name_ming17 = "文字间距:";
$name_ming17=decode("cp936",$name_ming17);
my $name_ming18 = "文字密度:";
$name_ming18=decode("cp936",$name_ming18);
my $name_ming19 = "高度缩放";
$name_ming19=decode("cp936",$name_ming19);
my $name_ming20 = "替   换";
$name_ming20=decode("cp936",$name_ming20);
my $name_ming21 = "程 序 设 置";
$name_ming21=decode("cp936",$name_ming21);
my $name_ming22 = "退 出 程 序";
$name_ming22=decode("cp936",$name_ming22);
my $name_ming23 = "程 序 帮 助";
$name_ming23=decode("cp936",$name_ming23);
my $name_ming24 = "Genesis2000 字符程序";
$name_ming24=decode("cp936",$name_ming24);
my $name_ming25 = "爱perl,爱生活";
$name_ming25=decode("cp936",$name_ming25);
my $name_ming26 = "没有物件被选中,程序被默认为整层操作,是否继续!";
$name_ming26=decode("cp936",$name_ming26);
my $name_ming27 = "请打开工作层!";
$name_ming27=decode("cp936",$name_ming27);
my $name_ming28 = "提示!";
$name_ming28=decode("cp936",$name_ming28);
my $name_ming29 = "<字符程序>窗口坐标!";
$name_ming29=decode("cp936",$name_ming29);
my $name_ming30 = "窗口坐标设置";
$name_ming30=decode("cp936",$name_ming30);
my $name_ming31 = "X轴坐标:";
$name_ming31=decode("cp936",$name_ming31);
my $name_ming32 = "Y轴坐标:";
$name_ming32=decode("cp936",$name_ming32);
my $name_ming33 = "改变";
$name_ming33=decode("cp936",$name_ming33);
my $name_ming34 = "保存";
$name_ming34=decode("cp936",$name_ming34);
my $name_ming35 = "退出";
$name_ming35=decode("cp936",$name_ming35);
my $name_ming36 = "数据不完整!";
$name_ming36=decode("cp936",$name_ming36);
my $name_ming37 = "数据为空,不能被保存!";
$name_ming37=decode("cp936",$name_ming37);
my $name_ming38 = "数据保存成功,程序坐标被更改为:";
$name_ming38=decode("cp936",$name_ming38);
my $font_name1 = "ansi 20 bold";
my $font_name2 = "ansi 10";
my $font_name3 = "ansi 13 bold";
my $font_name4 = "ansi 15 bold";
my $font_name5 = "ansi 14";
my $font_name6 = "[-size=>14]";
my $font_name7 = "ansi 15";
my $bg_name1 = "#52ceaf";
my $bg_name2 = "#E6E6FA";
my $bg_name3 = "#9bdbdb";
my $fg_name1 = "#FFFF00";
my $fg_name2 = "#000000";
my $fg_name3 = "#0000FF";
my $fg_name4 = "blue1";
my $fg_name5 = "red1";
my $fg_name6 = "bisque";
if($JOB eq "" || $STEP eq ""){
$f->no_step;}else{
loopzhu:;
open (FILES, "C://WINDOWS//system32//config//sacle_ck_x");
$sac_x=<FILES>;
close(FILES);
if($sac_x eq ""){$saac1_x=250;}else{$saac1_x = $sac_x;}
open (FILES, "C://WINDOWS//system32//config//sacle_ck_y");
$sac_y=<FILES>;
close(FILES);
if($sac_y eq ""){$saac1_y=350;}else{$saac1_y = $sac_y;}
$sacle_mw = MainWindow->new(-bg=>"$bg_name1",);
$sacle_mw->geometry("500x320+$saac1_x+$saac1_y");
$sacle_mw->Frame();
$sacle_mw->resizable(0,0);
$sacle_mw->update;
  Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($sacle_mw->frame()),-1,0,0,0,0,3);
$sacle_mw->title("$name_ming25");
my $greeting_frame = $sacle_mw->Frame(-bg=>"$bg_name1")->pack(-side => "top");###标题###
$greeting_frame->Label(-text => "$name_ming24",
               -relief=>"raised",
               -bg=>"$bg_name1",
               -font=>"$font_name1",
               -padx=>180,
               -pady=>5)->pack(-side => "top",-fill =>"x");
my $xin = $sacle_mw->Frame(-background => "$bg_name1")->pack(-side => "top");
my $aa = $xin->LabFrame(-label => "$name_ming1",
               -font=>"$font_name2",
               -relief=>"raised",
               -width => 400,
               -height => 400,
               -labelside => 'acrosstop',
               -fg=>"$fg_name1",
               -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
my $af = $aa->Frame(-background => "$bg_name1")->pack(-side => "top");
my $aj = $af->LabFrame(-label => "$name_ming2",
               -font=>"$font_name2",
               -width => 400,
               -height => 400,
               -labelside => 'acrosstop',
               -fg=>"$fg_name2",
               -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
my $ac = $aj->Frame(-background => "$bg_name1")->pack(-side => "top");
open (FILES, "C://WINDOWS//system32//config//x_sacle");
$red_xsacle=<FILES>;
close(FILES);
if($red_xsacle eq ""){$x_sacle = "1.0";}else{$x_sacle = "$red_xsacle";}
$ac->Label(-text => "X:",
               -font=>"$font_name3",
               -background => "$bg_name1",
               -pady => 3)->pack(-side => 'left');
$ac->Entry(-textvariable=> \$x_sacle,
               -font => "$font_name4",
               -width=>7,
               -foreground => "$fg_name3",
               -background=>"$bg_name2")->pack(-side => 'left');
open (FILES, "C://WINDOWS//system32//config//y_sacle");
$red_ysacle=<FILES>;
close(FILES);
if($red_ysacle eq ""){$y_sacle = "1.0";}else{$y_sacle = "$red_ysacle";}
$ac->Label(-text => "Y:",
                -font=>"$font_name3",
                -background => "$bg_name1",
                -pady => 3)->pack(-side => 'left');
$ac->Entry(-textvariable=> \$y_sacle,
                -font => "$font_name4",
                -width=>7,
                -foreground => "$fg_name3",
                -background=>"$bg_name2")->pack(-side => 'left');
$ac->Button(-text => "$name_ming3", 
                -font=>"$font_name3",
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&sacle_x_to_y)->pack(-side => "left");
my $ak = $aa->Frame(-background => "$bg_name1")->pack(-side => "top");
my $ad = $ak->LabFrame(-label => "$name_ming4",
                -font=>"$font_name2",
                -width => 400,
                -height => 400,
                -labelside => 'acrosstop',
                -fg=>"$fg_name2",
                -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
my $ae = $ad->Frame(-bg=>"$bg_name1")->pack(-side => "top");
$ae->Label(-text => "X:",
                -font=>"$font_name3",
                -background => "$bg_name1",
                -pady => 3)->pack(-side => "left");
$x_offset = "0";
$ae->Entry(-textvariable =>\$x_offset,
                -font => "$font_name4",
                -width=>5,
                -foreground => "$fg_name3",
                -background=>"$bg_name2")->pack(-side => "left");
$ae->Label(-text => "Y:",
                -font=>"$font_name3",
                -background => "$bg_name1",
                -pady => 3)->pack(-side => "left");
$y_offset = "0";
$ae->Entry(-textvariable =>\$y_offset,
                -font => "$font_name4",
                -width=>5,
                -foreground => "$fg_name3",
                -background=>"$bg_name2")->pack(-side => "left");
$ae->Label(-text => " ",
                -font=>"$font_name3",
                -background => "$bg_name1",
                -padx=>5,
                -pady => 3)->pack(-side => "left");
my $ap = $ak->LabFrame(-label => "$name_ming5",
                -font=>"$font_name2",
                -width => 400,
                -height => 400,
                -labelside => 'acrosstop',
                -fg=>"$fg_name2",
                -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
$angle = "0";
$ap->Entry(-textvariable =>\$angle,
                -font => "$font_name4",
                -width=>5,
                -foreground => "$fg_name3",
                -background=>"$bg_name2")->pack(-side => "left");
my $al = $aa->Frame(-background => "$bg_name1")->pack(-side => "top");
my $pet_info_frame = $al->LabFrame(-label => "$name_ming6",
                -font=>"$font_name2",
                -width => 400,
                -height => 400,
                -labelside => 'acrosstop',
                -fg=>"$fg_name2",
                -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
$mir = "NO";
my $mir_mode1=$pet_info_frame->Radiobutton(-text => "NO", 
                -background => "$bg_name1",
                -value => "NO",
                -activebackground=>"$bg_name1",
                -activeforeground=>"$fg_name5",
                -fg=>"$fg_name4",
                -font=>"$font_name5",
                -variable => \$mir)->pack(-side => "left");
$pet_info_frame->Label(-text => " ",
                -font=>"$font_name3",
                -padx=>"5",
                -background => "$bg_name1",
                -pady => 3)->pack(-side => "left");
my $mir_mode2=$pet_info_frame->Radiobutton(-text => "$name_ming7", 
                -background => "$bg_name1",
                -value => "$name_ming7",
                -activebackground=>"$bg_name1",
                -activeforeground=>"$fg_name5",
                -fg=>"$fg_name4",
                -font=>"$font_name5",
                -variable => \$mir)->pack(-side => "left");
my $mir_mode3=$pet_info_frame->Radiobutton(-text => "$name_ming8", 
                -background => "$bg_name1",
                -value => "$name_ming8",
                -activebackground=>"$bg_name1",
                -activeforeground=>"$fg_name5",
                -fg=>"$fg_name4",
                -font=>"$font_name5",
                -variable => \$mir)->pack(-side => "left");
my $button_frame = $aa->Frame(-bg=>"$bg_name3")->pack(-side => "top");
$button_frame->Button(-text => "$name_ming9", 
                -relief=>"raised",
                -font=>"$font_name3",
                -width=>8,
                -padx=>3,
                -pady=>4,
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&sacle_text)->pack(-side => "left");
$button_frame->Button(-text => "$name_ming10", 
                -relief=>"raised",
                -font=>"$font_name3",
                -width=>8,
                -padx=>3,
                -pady=>4,
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&sacle_from)->pack(-side => "left");
$button_frame->Button(-text => "$name_ming11", 
                -relief=>"raised",
                -font=>"$font_name3",
                -width=>8,
                -padx=>3,
                -pady=>4,
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&Auto_sacle)->pack(-side => "left");
my $ab = $xin->LabFrame(-label => "$name_ming12",
                -relief=>"raised",
                -font=>"$font_name2",
                -width => 400,
                -height => 400,
                -labelside => 'acrosstop',
                -fg=>"$fg_name1",
                -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
my $ax = $ab->Frame(-background => "$bg_name1")->pack(-side => "top");
my $pet_info_framnu = $ax->LabFrame(-label => "$name_ming16",
                -font=>"$font_name2",
                -width => 400,
                -height => 400,
                -labelside => 'acrosstop',
                -fg=>"#000000",
                -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
my $bc = $pet_info_framnu->Frame(-background => "$bg_name1")->pack(-side => "top");
$gaodu = "0.85";
$bc->Label(-text => "$name_ming13",
                -font=>"$font_name3",
                -background => "$bg_name1",
                -pady => 3)->pack(-side => 'left');
$bc->Entry(-textvariable=> \$gaodu,
                -font => "$font_name4",
                -width=>7,
                -foreground => "$fg_name3",
                -background=>"$bg_name2")->pack(-side => 'left');
$bc->Label(-text => "mm",
                -font=>$font_name5,
                -background => "$bg_name1",
                -pady => 3)->pack(-side => 'left');
my $av = $ab->Frame(-background => "$bg_name1")->pack(-side => "top");
my $pet_info_framn = $av->LabFrame(-label => "$name_ming17",
                -font=>"$font_name2",
                -width => 400,
                -height => 400,
                -labelside => 'acrosstop',
                -fg=>"$fg_name2",
                -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
my $bd = $pet_info_framn->Frame(-background => "$bg_name1")->pack(-side => "top");
$bd->Label(-text => "$name_ming14",
                -font=>"$font_name3",
                -background => "$bg_name1",
                -pady => 3)->pack(-side => 'left');
my $ring = "0.00";
my $stae="disabled";
$bd->Entry(-textvariable=> \$ring,
                -state => $stae,
                -font => "$font_name4",
                -width=>7,
                -foreground => "$fg_name3",
                -background=>"$bg_name2")->pack(-side => 'left');
$bd->Label(-text => "mm",-font=>$font_name5,
                -background => "$bg_name1",
                -pady => 3)->pack(-side => 'left');
my $am = $ab->Frame(-background => "$bg_name1")->pack(-side => "top");
my $pet_info_frammk = $am->LabFrame(-label => "$name_ming18",
                -font=>"$font_name2",
                -width => 400,
                -height => 400,
                -labelside => 'acrosstop',
                -fg=>"$fg_name2",
                -background => "$bg_name1")->pack(-side => "left",-expand => 1 ,-fill =>"both");
my $by = $pet_info_frammk->Frame(-background => "$bg_name1")->pack(-side => "top");
$txt_spring = "150";
$by->Label(-text => "$name_ming15",
                -font=>"$font_name3",
                -background => "$bg_name1",
                -pady => 3)->pack(-side => 'left');
$by->Entry(-textvariable=> \$txt_spring,
                -font => "$font_name4",
                -width=>7,
                -foreground => "$fg_name3",
                -background=>"$bg_name2")->pack(-side => 'left');
$by->Label(-text => "my",
                -font=>$font_name5,
                -background => "$bg_name1",
                -pady => 3)->pack(-side => 'left');
my $button_frame2 = $ab->Frame(-bg=>"$bg_name3")->pack(-side => "top");
$button_frame2->Button(-text => "$name_ming19", 
                -relief=>"raised",
                -font=>"$font_name3",
                -width=>7,
                -padx=>5,
                -pady=>4,
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&go_hight)->pack(-side => "left");
$button_frame2->Button(-text => "$name_ming20", 
                -relief=>"raised",
                -font=>"$font_name3",
                -width=>7,
                -padx=>5,
                -pady=>4,
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&subtive)->pack(-side => "left");
my $button_frame3 = $sacle_mw->Frame(-background => "$bg_name1")->pack(-side => "top");
$button_frame3->Button(-text => "$name_ming21", 
                -relief=>"raised",
                -font=>"$font_name3",
                -width=>14,
                -padx=>5,
                -pady=>4,
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&sacle_set)->pack(-side => "left");
$button_frame3->Button(-text => "$name_ming23", 
                -relief=>"raised",
                -font=>"$font_name3",
                -width=>14,
                -padx=>5,
                -pady=>4,
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&sacle_help)->pack(-side => "left");
$button_frame3->Button(-text => "$name_ming22", 
                -relief=>"raised",
                -font=>"$font_name3",
                -width=>14,
                -padx=>5,
                -pady=>4,
                -activebackground => "$fg_name6",
                -background => "$bg_name3",
                -command => \&sacle_close)->pack(-side => "left");

MainLoop;

sub sacle_close{
exit;}

sub sacle_help{
$sacle_mw -> withdraw;
$sacle_mw->messageBox(-message=> decode("cp936","A:比例数值请在比例框内输入,比1大的就放大,比1小的就缩小.
B:在改变角度时,比例默认为1,请注意!!!
C:改变字符高度，需输入相应的高度即可,程序默认最大高度为10.00mm,最小高度为0.20MM.
D:改变字符间距，需输入相应的间距即可,程序默认最大间距为10.00mm,最小间距为0.01MM.
E:运行程序时界面会自动隐藏,如果要显示程序界面,则选择时不用框选住物件即可呼出程序界面!
欢迎您的使用,在使用中您有宝贵的意见请联系我!
Name:李明成  QQ:475569501執筆寫童話  Eaill:www.15013582237 @ 139.com"), -type=> "ok",-icon => "info");
$sacle_mw -> deiconify;
}

sub sacle_set{
if($cs_ck_yes_no20 eq "1"){$ck_sacle_text -> deiconify;}
if($cs_ck_yes_no20 eq ""){
$ck_sacle_text = new MainWindow(-title => "$name_ming29");
$ck_sacle_text->geometry("250x160+5+5");
$ck_sacle_text->update;
$ck_sacle_text->Frame();
$ck_sacle_text->resizable(0,0);
$ck_sacle_text->Frame();
$ck_sacle_text->update;
  Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($ck_sacle_text->frame()),-1,0,0,0,0,3);
$ck_sacle_text->Label(-text=>"$name_ming30",
              -relief=>"\x{0072}\x{0061}\x{0069}\x{0073}\x{0065}\x{0064}",
              -highlightbackground => "yellow",
              -foreground =>"$fg_name2",
              -bg=>"$bg_name3",
              -pady => "5",
              -font=>"ansi 18 bold")
              ->pack(-side => 'top', -fill => 'x')->pack;
$ck_sacle_text->Label(-text=>"",
              -relief=>"\x{0072}\x{0061}\x{0069}\x{0073}\x{0065}\x{0064}",
              -highlightbackground => "yellow",
              -foreground =>"$fg_name2",
              -bg=>"$bg_name3",
              -pady => "5",
              -font => [-size => 50])
              ->pack(-side => 'top', -fill => 'x')->pack;
$ck_sacle_text->Label(-text=>"$name_ming31",
              -bg=>"$bg_name3",
              -highlightbackground => 'yellow',
              -foreground =>"$fg_name2",
              -font=>"$font_name4")->place(-x=>8,-y=>47);
$saac_x1 = "$saac1_x";
$ck_sacle_text->Entry(-textvariable => \$saac_x1,
              -insertwidth => 2,
              -borderwidth=>'3',
              -insertontime => 500,
              -insertborderwidth => 1000,
              -background=>"$bg_name2",
              -foreground => '#0000FF',
              -selectbackground => 'dodgerblue4',
              -selectforeground => '#FFFFFF',
              -width=>12,
              -font=>"$font_name4")->place(-x=>100,-y=>47);
$ck_sacle_text->Label(-text=>"$name_ming32",
              -bg=>"$bg_name3",
              -highlightbackground => 'yellow',
              -foreground =>"$fg_name2",
              -font=>"$font_name4")->place(-x=>8,-y=>82);
$saac_y1 = "$saac1_y";
$ck_sacle_text->Entry(-textvariable => \$saac_y1,
              -insertwidth => 2,
              -borderwidth=>'3',
              -insertontime => 500,
              -insertborderwidth => 1000,
              -background=>"$bg_name2",
              -foreground => '#0000FF',
              -selectbackground => 'dodgerblue4',
              -selectforeground => '#FFFFFF',
              -width=>12,
              -font=>"$font_name4")->place(-x=>100,-y=>82);
my $button_1 = $ck_sacle_text->Button (-activebackground => "$fg_name6",
              -background => "$bg_name3",
              -font=>"$font_name4",
              -text => "$name_ming33",
              -width => '6',
              -command => \&APPLY20)->pack(qw/-side left -fill both -expand 1/);  
my $button_2 = $ck_sacle_text->Button (-activebackground => "$fg_name6",
              -background => "$bg_name3",
              -font=>"$font_name4",
              -text => "$name_ming34",
              -width => '6',
              -command => \&SAVE_APPLY20)->pack(qw/-side left -fill both -expand 1/); 
my $button_3 = $ck_sacle_text->Button (-activebackground => "$fg_name6",
              -background => "$bg_name3",
              -font=>"$font_name4",
              -text => "$name_ming35",
              -width => '6',
              -command => \&ck_remjob_close)->pack(qw/-side left -fill both -expand 1/);   
$cs_ck_yes_no20=1;
MainLoop;
sub ck_remjob_close{
$cs_ck_yes_no20="";
$ck_sacle_text->destroy();
}
sub APPLY20{
if($saac_x1 eq "" || $saac_y1 eq ""){
$ck_sacle_text->messageBox(-message=>"$name_ming36", -type=> "ok", -icon => "error");
}
   else{
$saac_x1 =~ tr/0-9/./cs;
$saac_x1 =~s/\.+//g;
$saac_y1 =~ tr/0-9/./cs;
$saac_y1 =~s/\.+//g;
$sacle_mw->update;
$sacle_mw->Frame();
$sacle_mw->resizable(0,0);
$sacle_mw->Frame();
$sacle_mw->geometry("500x320+$saac_x1+$saac_y1");
$sacle_mw->update;
$ck_zt="-1";
  Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($sacle_mw->frame()),$ck_zt,0,0,0,0,3);
}
}
sub SAVE_APPLY20{
if($saac_x1 eq "" || $saac_y1 eq ""){
$ck_sacle_text->messageBox(-message=>"$name_ming37", -type=> "ok", -icon => "error");
}
  else{
$saac_x1 =~ tr/0-9/./cs;
$saac_x1 =~s/\.+//g;
$saac_y1 =~ tr/0-9/./cs;
$saac_y1 =~s/\.+//g;
if($saac_x1 eq ""){}else{
open(OUTFILE, ">C://WINDOWS//system32//config//sacle_ck_x");
print OUTFILE ("$saac_x1");
close(OUTFILE);
}
if($saac_y1 eq ""){}else{
open(OUTFILE, ">C://WINDOWS//system32//config//sacle_ck_y");
print OUTFILE ("$saac_y1");
close(OUTFILE);
}
$ck_sacle_text->messageBox(-message=>"$name_ming38  x=$saac_x1,y=$saac_y1  !!!", -type=> "ok", -icon => "info");
}}}}

sub sacle_x_to_y{
my $x_sacle1="$x_sacle";
my $y_sacle1="$y_sacle";
$y_sacle = $x_sacle1;
$x_sacle = $y_sacle1;
}

sub subtive{
$sacle_mw -> withdraw;
loop77:;
$f->COM("get_work_layer");
$work_layermm2=$f->{COMANS};
if($work_layermm2 eq ""){
$yesno_button = $sacle_mw->messageBox(-title=>"$name_ming28",-message => "$name_ming27",-type => "ok", -icon => "error");
$f-> MOUSE("r next open work layer1!");
$sacle_mw -> deiconify;
}else{
loop88:;
$f->COM("snap_mode,mode=off");
$f->COM("units,type=mm");
$f->COM("affected_layer,mode=all,affected=no");
$f->COM("multi_layer_disp,mode=many,show_board=no");
$f->COM("zoom_to_cursor,zoom_to_cursor=yes");
$f-> MOUSE("r Please Select Create symbol.....");
@MOUSEANS=$f->{MOUSEANS};
($x1,$y1,$x2,$y2)=split /\s+/,$f->{MOUSEANS}; 
$f->COM("get_work_layer");
$work_layermm2=$f->{COMANS};
if($work_layermm2 eq ""){
$yesno_button = $sacle_mw->messageBox(-title=>"$name_ming28",-message => "$name_ming27",-type => "ok", -icon => "error");
$f-> MOUSE("r next open work layer2!");
$sacle_mw -> deiconify;
}else{
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x1,y=$y1");
$f->COM("filter_area_xy,x=$x2,y=$y2");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$select_yes_no=$f->{COMANS};
######检测是否被选中#######
if($select_yes_no eq "0"){
$sacle_mw -> deiconify;
}
else{
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/sillk+++",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=sillk+++");
}
$f->COM("sel_copy_other,dest=layer_name,target_layer=sillk+++,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,\n
rotation=0,mirror=none");
$f->INFO(entity_type => 'layer',entity_path => "$JOB/$STEP/sillk+++",data_type => 'LIMITS');
$xmin_c=$f->{doinfo}{gLIMITSxmin};######左######
$ymin_c=$f->{doinfo}{gLIMITSymin};######下######
$xmax_c=$f->{doinfo}{gLIMITSxmax};######右######
$ymax_c=$f->{doinfo}{gLIMITSymax};######上######
$xmin_c=$xmin_c*25.4;
$ymin_c=$ymin_c*25.4;
$xmax_c=$xmax_c*25.4;
$ymax_c=$ymax_c*25.4;
$cenx_c = ($xmax_c-$xmin_c)/2+$xmin_c;
$ceny_c = ($ymax_c-$ymin_c)/2+$ymin_c;
$f->COM("display_layer,name=sillk+++,display=yes,number=4");
$f->COM("work_layer,name=sillk+++");
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x1,y=$y1");
$f->COM("filter_area_xy,x=$x2,y=$y2");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$f->COM("sel_create_sym,symbol=carte_text_sym,x_datum=$cenx_c,y_datum=$ceny_c,delete=no,fill_dx=2.54,fill_dy=2.54,attach_atr=no,retain_atr=no");
$f->COM("delete_layer,layer=sillk+++");
$f-> MOUSE("r Please Select Substitution......");
@MOUSEANS=$f->{MOUSEANS};
($x1,$y1,$x2,$y2)=split /\s+/,$f->{MOUSEANS}; 
$f->COM("get_work_layer");
$work_layermm2=$f->{COMANS};
if($work_layermm2 eq ""){
$yesno_button = $sacle_mw->messageBox(-title=>'$name_ming28',-message => "$name_ming27",-type => "ok", -icon => "error");
$f-> MOUSE("r next open work layer!");
$sacle_mw -> deiconify;
}else{
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x1,y=$y1");
$f->COM("filter_area_xy,x=$x2,y=$y2");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$select_yes_no=$f->{COMANS};
######检测是否被选中#######
if($select_yes_no eq "0"){
goto loop88;
}
else{
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/sillk1+++",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=sillk1+++");
}
$f->COM("sel_copy_other,dest=layer_name,target_layer=sillk1+++,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,\n
rotation=0,mirror=none");
$f->INFO(entity_type => 'layer',entity_path => "$JOB/$STEP/sillk1+++",data_type => 'LIMITS');
$xmin_c1=$f->{doinfo}{gLIMITSxmin};######左######
$ymin_c1=$f->{doinfo}{gLIMITSymin};######下######
$xmax_c1=$f->{doinfo}{gLIMITSxmax};######右######
$ymax_c1=$f->{doinfo}{gLIMITSymax};######上######
$xmin_c1=$xmin_c1*25.4;
$ymin_c1=$ymin_c1*25.4;
$xmax_c1=$xmax_c1*25.4;
$ymax_c1=$ymax_c1*25.4;
$cenx_c1 = ($xmax_c1-$xmin_c1)/2+$xmin_c1;
$ceny_c1 = ($ymax_c1-$ymin_c1)/2+$ymin_c1;
$f->COM("delete_layer,layer=sillk1+++");
$f->COM("work_layer,name=$work_layermm2");
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x1,y=$y1");
$f->COM("filter_area_xy,x=$x2,y=$y2");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$f->COM("sel_substitute,mode=substitute,symbol=carte_text_sym,tol=25.4,x_datum=$cenx_c1,y_datum=$ceny_c1,dcode=0");
$f->COM("sel_multi_feat,operation=select,feat_types=pad,include_syms=carte_text_sym");
$f->COM("sel_break");
goto loop77;
}}}}}}

sub sacle_text{
open(OUTFILE, ">C://WINDOWS//system32//config//x_sacle");
print OUTFILE ("$x_sacle");
close(OUTFILE);
open(OUTFILE, ">C://WINDOWS//system32//config//y_sacle");
print OUTFILE ("$y_sacle");
close(OUTFILE);
$sacle_mw -> withdraw;
if($mir eq "$name_ming7"){
$mirror_ss="\;mirror";}
if($mir eq "$name_ming8"){
$mirror_ss="\;y_mirror";}
if($mir eq "NO"){
$mirror_ss="";}
loop55:;
$f->COM("get_work_layer");
$work_layermm=$f->{COMANS};
if($work_layermm eq ""){
$yesno_button = $sacle_mw->messageBox(-title=>'$name_ming28',-message => "$name_ming28",-type => "ok", -icon => "error");
$f-> MOUSE("r next open work layer!");
$sacle_mw -> deiconify;
}else{
$f->COM("snap_mode,mode=off");
$f->COM("units,type=mm");
$f->COM("affected_layer,mode=all,affected=no");
$f->COM("multi_layer_disp,mode=many,show_board=no");
$f->COM("zoom_to_cursor,zoom_to_cursor=yes");
if($angle ne "0" || $x_offset ne "0" || $y_offset ne "0"){
$x_sacle = "1";
$y_sacle = "1";
}else{}
$f-> MOUSE("r Sacle_text,x_sacle=$x_sacle,y_sacle=$y_sacle");
@MOUSEANS=$f->{MOUSEANS};
($x1,$y1,$x2,$y2)=split /\s+/,$f->{MOUSEANS}; 
$f->COM("get_work_layer");
$work_layermm=$f->{COMANS};
if($work_layermm eq ""){
$yesno_button = $sacle_mw->messageBox(-title=>'$name_ming28',-message => "$name_ming27",-type => "ok", -icon => "error");
$f-> MOUSE("r next open work layer!");
$sacle_mw -> deiconify;
}else{
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x1,y=$y1");
$f->COM("filter_area_xy,x=$x2,y=$y2");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$select_yes_no=$f->{COMANS};
######检测是否被选中#######
if($select_yes_no eq "0"){
$sacle_mw -> deiconify;
}
else{
$f->COM("sel_create_sym,symbol=sacle_text_sym,x_datum=0,y_datum=0,delete=no,fill_dx=2.54,fill_dy=2.54,attach_atr=no,retain_atr=no");
$f->INFO(entity_type => "symbol",entity_path => "$JOB/sacle_text_sym",data_type => "LIMITS");
$xmin=$f->{doinfo}{gLIMITSxmin};######左######
$ymin=$f->{doinfo}{gLIMITSymin};######下######
$xmax=$f->{doinfo}{gLIMITSxmax};######右######
$ymax=$f->{doinfo}{gLIMITSymax};######上######
$xmin=$xmin*25.4;
$ymin=$ymin*25.4;
$xmax=$xmax*25.4;
$ymax=$ymax*25.4;
$cenx = ($xmax-$xmin)/2+$xmin;
$ceny = ($ymax-$ymin)/2+$ymin;
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x1,y=$y1");
$f->COM("filter_area_xy,x=$x2,y=$y2");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$f->COM("sel_transform,mode=anchor,oper=rotate\;scale$mirror_ss,duplicate=no,x_anchor=$cenx,y_anchor=$ceny,\n
angle=$angle,x_scale=$x_sacle,y_scale=$y_sacle,x_offset=$x_offset,y_offset=$y_offset");
$f->COM("sel_options,clear_mode=clear_after,display_mode=all_layers,area_inout=inside,area_select=select,\n
select_mode=standard,area_touching_mode=exclude");
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
goto loop55;
}}}}

sub sacle_from{
open(OUTFILE, ">C://WINDOWS//system32//config//x_sacle");
print OUTFILE ("$x_sacle");
close(OUTFILE);
open(OUTFILE, ">C://WINDOWS//system32//config//y_sacle");
print OUTFILE ("$y_sacle");
close(OUTFILE);
$sacle_mw -> withdraw;
if($mir eq "$name_ming7"){$mirror_ss="\;mirror";}
if($mir eq "$name_ming8"){$mirror_ss="\;y_mirror";}
if($mir eq "NO"){$mirror_ss="";}
loop66:;
$f->COM("get_work_layer");
$work_layermm=$f->{COMANS};
if($work_layermm eq ""){
$yesno_button = $sacle_mw->messageBox(-title=>'$name_ming28',-message => "$name_ming27",-type => "ok", -icon => "error");
$f-> MOUSE("p next open work layer!");
$sacle_mw -> deiconify;
}else{
$f->COM("snap_mode,mode=off");
$f->COM("units,type=mm");
$f->COM("affected_layer,mode=all,affected=no");
$f->COM("multi_layer_disp,mode=many,show_board=no");
$f->COM("zoom_to_cursor,zoom_to_cursor=yes");
$f-> MOUSE("r Sacle_from,x_scale=$x_sacle,y_scale=$y_sacle");
@MOUSEANS=$f->{MOUSEANS};
($x1,$y1,$x2,$y2)=split /\s+/,$f->{MOUSEANS}; 
$f->COM("get_work_layer");
$work_layermm=$f->{COMANS};
if($work_layermm eq ""){
$yesno_button = $sacle_mw->messageBox(-title=>'$name_ming28',-message => "$name_ming27",-type => "\x{006F}\x{006B}", -icon => "error");
$f-> MOUSE("r next open work layer!");
$sacle_mw -> deiconify;
}else{
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x1,y=$y1");
$f->COM("filter_area_xy,x=$x2,y=$y2");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$select_yes_no=$f->{COMANS};
######检测是否被选中#######
if($select_yes_no eq "0"){
$sacle_mw -> deiconify;
$f->COM("filter_reset,filter_name=popup");
}
else{
######复制到silk_from_sss层中#######
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/silk_from_sss",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=silk_from_sss");
}
$f->COM("sel_copy_other,dest=layer_name,target_layer=silk_from_sss,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,\n
rotation=0,mirror=none");
$f->COM("display_layer,name=silk_from_sss,display=yes,number=4");
$f->COM("work_layer,name=silk_from_sss");
$f->INFO(entity_type => 'layer',entity_path => "$JOB/$STEP/silk_from_sss",data_type => 'LIMITS');
$xmin=$f->{doinfo}{gLIMITSxmin};######左######
$ymin=$f->{doinfo}{gLIMITSymin};######下######
$xmax=$f->{doinfo}{gLIMITSxmax};######右######
$ymax=$f->{doinfo}{gLIMITSymax};######上######
$xmin=$xmin*25.4;
$ymin=$ymin*25.4;
$xmax=$xmax*25.4;
$ymax=$ymax*25.4;
$cenjx=$xmin+($xmax-$xmin)/2;
$cenjy=$ymin+($ymax-$ymin)/2;
$f->COM("sel_transform,mode=anchor,oper=scale,duplicate=no,x_anchor=$cenjx,y_anchor=$cenjy,\n
angle=$angle,x_scale=$x_sacle,y_scale=$y_sacle,x_offset=$x_offset,y_offset=$y_offset");
$f->COM("filter_area_strt");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,\n
intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("sel_create_sym,symbol=pcb168,x_datum=$cenjx,y_datum=$cenjy,delete=no,fill_dx=2.54,fill_dy=2.54,attach_atr=no,retain_atr=no");
$f->COM("sel_delete");
$f->COM("display_layer,name=$work_layermm,display=yes,number=1");
$f->COM("work_layer,name=$work_layermm");
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x1,y=$y1");
$f->COM("filter_area_xy,x=$x2,y=$y2");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$f->COM("sel_substitute,mode=substitute,symbol=pcb168,tol=25.4,x_datum=$cenjx,y_datum=$cenjy,dcode=0");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=negative");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");
$f->COM("get_select_count");
$select_yes_no_neg=$f->{COMANS};
if($select_yes_no_neg eq "0"){
$f->COM("sel_break");
}else{
$f->COM("sel_clear_feat");
$f->COM("filter_area_strt");
$f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=pcb168");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$f->COM("sel_move_other,target_layer=silk_from_sss,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("display_layer,name=silk_from_sss,display=yes,number=4");
$f->COM("work_layer,name=silk_from_sss");
$f->COM("sel_break");
$f->COM("display_layer,name=$work_layermm,display=yes,number=2");
$f->COM("work_layer,name=$work_layermm");
$f->COM("sel_move_other,target_layer=silk_from_sss,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("display_layer,name=silk_from_sss,display=yes,number=4");
$f->COM("work_layer,name=silk_from_sss");
$f->COM("sel_move_other,target_layer=$work_layermm,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("display_layer,name=$work_layermm,display=yes,number=2");
$f->COM("work_layer,name=$work_layermm");
$f->COM("filter_reset,filter_name=popup");
}
$f->COM("delete_layer,layer=silk_from_sss");
$f->COM("filter_reset,filter_name=popup");
goto loop66;
}}}}

sub Auto_sacle{
$sacle_mw -> withdraw;
$f->COM("get_work_layer");
$work_layer=$f->{COMANS};
if($work_layer eq ""){
$sacle_mw -> withdraw;
$yesno_button = $sacle_mw->messageBox(-title=>'$name_ming28',-message => "$name_ming27",-type => "ok", -icon => "error");
$f-> MOUSE("p next open work layer!");
$sacle_mw -> deiconify;
}else{
$f->INFO(entity_type => 'layer',
         entity_path => "$JOB/$STEP/$work_layer",
         data_type => 'FEAT_HIST',
         parameters => "total",
         options => "select");
$yes_o = $f->{doinfo}{gFEAT_HISTtotal};
if($yes_o == "0"){
$yesno_button=$sacle_mw->messageBox(-message=>"$name_ming26", -type=> "yesno",-icon => "question");
if($yesno_button eq "Yes"){goto liop;}
if($yesno_button eq "No"){$sacle_mw -> deiconify;}}
if($yes_o != "0"){
liop:;
$f->COM("snap_mode,mode=off");
$f->COM("units,type=mm");
$f->COM("display_width,mode=on");
$f->COM("affected_layer,mode=all,affected=no");
$f->COM("multi_layer_disp,mode=many,show_board=no");
$f->COM("zoom_to_cursor,zoom_to_cursor=yes");
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/edit_sam.$work_layer",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=edit_sam.$work_layer");}
$f->COM("sel_move_other,target_layer=edit_sam.$work_layer,invert=no,dx=0,dy=0,\n
size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("clear_layers");
$f->COM("display_layer,name=edit_sam.$work_layer,display=yes,number=1");
$f->COM("work_layer,name=edit_sam.$work_layer");
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/back.$work_layer",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=back.$work_layer");}
$f->COM("sel_copy_other,dest=layer_name,target_layer=back.$work_layer,invert=no,\n
dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/tmp1.$work_layer",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=tmp1.$work_layer");}
$f->COM("sel_copy_other,dest=layer_name,target_layer=tmp1.$work_layer,invert=no,\n
dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("clear_layers");
$f->COM("display_layer,name=tmp1.$work_layer,display=yes,number=1");
$f->COM("work_layer,name=tmp1.$work_layer");
$f->COM("sel_resize,size=$txt_spring,corner_ctl=no");
$f->COM("sel_contourize,accuracy=6.35,break_to_islands=yes,clean_hole_size=76.2,\n
clean_hole_mode=x_and_y");
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("sel_reverse");
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/tmp1.pt",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=tmp1.pt");}
$f->INFO(entity_type => 'layer',
         entity_path => "$JOB/$STEP/tmp1.$work_layer",
         data_type => 'FEAT_HIST',
         parameters => "total",
         options => "select");
$total = $f->{doinfo}{gFEAT_HISTtotal};
$p=1;
while ($n < $total){
$f->COM("display_layer,name=tmp1.$work_layer,display=yes,number=1");
$f->COM("work_layer,name=tmp1.$work_layer");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=unselect,\n
area_type=none,inside_area=no,intersect_area=no,lines_only=no,\n
ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("sel_layer_feat,operation=select,layer=tmp1.$work_layer,index=$p");
$f->COM("sel_move_other,target_layer=tmp1.pt,invert=no,dx=0,dy=0,size=0,\n
x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("display_layer,name=edit_sam.$work_layer,display=yes,number=1");
$f->COM("work_layer,name=edit_sam.$work_layer");
$f->COM("sel_ref_feat,layers=tmp1.pt,use=filter,mode=touch,pads_as=shape,\n
f_types=line\;pad\;surface\;arc\;text,polarity=positive\;negative,\n
include_syms=,exclude_syms=");
$f->INFO(entity_type => 'layer',entity_path => "$JOB/$STEP/tmp1.pt",data_type => 'LIMITS');
$xmin=$f->{doinfo}{gLIMITSxmin};
$ymin=$f->{doinfo}{gLIMITSymin};
$xmax=$f->{doinfo}{gLIMITSxmax};
$ymax=$f->{doinfo}{gLIMITSymax};
$xmin=$xmin*25.4;
$ymin=$ymin*25.4;
$xmax=$xmax*25.4;
$ymax=$ymax*25.4;
$cenjx=$xmin+($xmax-$xmin)/2;
$cenjy=$ymin+($ymax-$ymin)/2;
$f->COM("sel_transform,mode=anchor,oper=scale,duplicate=no,x_anchor=$cenjx,\n
y_anchor=$cenjy,angle=0,x_scale=$x_sacle,y_scale=$y_sacle,x_offset=0,\n
y_offset=0");
$f->COM("display_layer,name=tmp1.pt,display=yes,number=1");
$f->COM("work_layer,name=tmp1.pt");
$f->COM("sel_delete");
$n++;
$p++;}
$f->COM("display_layer,name=edit_sam.$work_layer,display=yes,number=1");
$f->COM("work_layer,name=edit_sam.$work_layer");
$f->COM("sel_move_other,target_layer=$work_layer,invert=no,dx=0,dy=0,size=0,\n
x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/tmp1.$work_layer",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=tmp1.$work_layer");}
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/tmp1.pt",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=tmp1.pt");}
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/edit_sam.$work_layer",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){
$f->COM("delete_layer,layer=edit_sam.$work_layer");}
$f->COM("display_layer,name=$work_layer,display=yes,number=1");
$f->COM("work_layer,name=$work_layer");
$f->COM("display_layer,name=back.$work_layer,display=yes,number=2");
$sacle_mw -> deiconify;
}}}

sub go_hight{
$sacle_mw -> withdraw;
if($gaodu > "10" || $gaodu < "0.2"){}else{
loop_hight:;
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/tmp1",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){$f->COM("delete_layer,layer=tmp1");}
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/tmp2",data_type=>"exists");
if($f->{doinfo}{gEXISTS} eq "yes"){$f->COM("delete_layer,layer=tmp2");}
$f->COM("get_work_layer");
$work_layer=$f->{COMANS};
if($work_layer eq ""){
$sacle_mw -> withdraw;
$yesno_button = $sacle_mw->messageBox(-title=>'$name_ming28',-message => "$name_ming27",-type => "ok", -icon => "error");
$f-> MOUSE("p next open work layer!");
$sacle_mw -> deiconify;
}else{
$f->COM("units,type=mm");
$f->COM("snap_mode,mode=off");
$f->COM("affected_layer,mode=all,affected=no");
$f->COM("sel_clear_feat");
$f->COM("sel_options,clear_mode=clear_none,display_mode=all_layers,area_inout=inside,\n
area_select=select,select_mode=standard,area_touching_mode=exclude");
$f-> MOUSE("r hight=$gaodu mm");
@MOUSEANS=$f->{MOUSEANS};
($x_hig_1,$y_hig_1,$x_hig_2,$y_hig_2)=split /\s+/,$f->{MOUSEANS}; 
$f->COM("get_work_layer");
$work_layer=$f->{COMANS};
$f->COM("display_layer,name=$work_layer,display=yes,number=1");
$f->COM("work_layer,name=$work_layer");
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x_hig_1,y=$y_hig_1");
$f->COM("filter_area_xy,x=$x_hig_2,y=$y_hig_2");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$select_yes_no=$f->{COMANS};
if($select_yes_no eq "0"){
$sacle_mw -> deiconify;
$f->COM("filter_reset,filter_name=popup");}else{
$f->COM("sel_copy_other,dest=layer_name,target_layer=tmp1,invert=no,dx=0,dy=0,size=-300,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->INFO(entity_type => 'layer',entity_path => "$JOB/$STEP/tmp1",data_type => 'LIMITS');
$xmin_4=$f->{doinfo}{gLIMITSxmin};######左######
$ymin_4=$f->{doinfo}{gLIMITSymin};######下######
$xmax_4=$f->{doinfo}{gLIMITSxmax};######右######
$ymax_4=$f->{doinfo}{gLIMITSymax};######上######
$xmin_4=$xmin_4*25.4;
$ymin_4=$ymin_4*25.4;
$xmax_4=$xmax_4*25.4;
$ymax_4=$ymax_4*25.4;
$hx_4 = $xmax_4-$xmin_4;
$hy_4 = $ymax_4-$ymin_4;
$f->COM("delete_layer,layer=tmp1");
$f->COM("sel_copy_other,dest=layer_name,target_layer=tmp2,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->INFO(entity_type => 'layer',entity_path => "$JOB/$STEP/tmp2",data_type => 'LIMITS');
$xmin_2=$f->{doinfo}{gLIMITSxmin};######左######
$ymin_2=$f->{doinfo}{gLIMITSymin};######下######
$xmax_2=$f->{doinfo}{gLIMITSxmax};######右######
$ymax_2=$f->{doinfo}{gLIMITSymax};######上######
$xmin_2=$xmin_2*25.4;
$ymin_2=$ymin_2*25.4;
$xmax_2=$xmax_2*25.4;
$ymax_2=$ymax_2*25.4;
$hx_2 = $xmax_2-$xmin_2;
$hy_2 = $ymax_2-$ymin_2;
$cenjx=$xmin_2+($xmax_2-$xmin_2)/2;
$cenjy=$ymin_2+($ymax_2-$ymin_2)/2;
$sacle_qx=$xmax_2-$xmax_4;
$sacle_qy=$ymax_2-$ymax_4;
###############判断字体的方向###############
if($hx_4 > $hy_4){$hight_pa = $hy_4;}
if($hx_4 < $hy_4){$hight_pa = $hx_4;}
if($hx_4 eq $hy_4){$hight_pa = $hx_4;}
###############判断高度###############
##^^^^^^^^^^^^^^^^大于输入的高度^^^^^^^^^^^^##
if($hight_pa > $gaodu){
$f->COM("display_layer,name=tmp2,display=yes,number=4");
$f->COM("work_layer,name=tmp2");
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x_hig_1,y=$y_hig_1");
$f->COM("filter_area_xy,x=$x_hig_2,y=$y_hig_2");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$gaodu2= $gaodu-$sacle_qx*2;
$sacle_x = $gaodu2/$hight_pa;
$sacle_y = $gaodu2/$hight_pa;
$f->COM("sel_transform,mode=anchor,oper=scale,duplicate=no,x_anchor=$cenjx,y_anchor=$cenjy,angle=0,x_scale=$sacle_x,y_scale=$sacle_y,x_offset=0,y_offset=0");
$f->COM("sel_create_sym,symbol=pcb169,x_datum=$cenjx,y_datum=$cenjy,delete=no,fill_dx=2.54,fill_dy=2.54,attach_atr=no,retain_atr=no");
$f->COM("delete_layer,layer=tmp2");
$f->COM("display_layer,name=$work_layer,display=yes,number=1");
$f->COM("work_layer,name=$work_layer");
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x_hig_1,y=$y_hig_1");
$f->COM("filter_area_xy,x=$x_hig_2,y=$y_hig_2");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$f->COM("sel_substitute,mode=substitute,symbol=pcb169,tol=25.4,x_datum=$cenjx,y_datum=$cenjy,dcode=0");
$f->COM("sel_multi_feat,operation=select,feat_types=pad,include_syms=pcb169");
$f->COM("sel_break");
goto loop_hight;
}
##^^^^^^^^^^^^^^^^小于输入的高度^^^^^^^^^^^^##
if($hight_pa < $gaodu){
$f->COM("display_layer,name=tmp2,display=yes,number=4");
$f->COM("work_layer,name=tmp2");
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x_hig_1,y=$y_hig_1");
$f->COM("filter_area_xy,x=$x_hig_2,y=$y_hig_2");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$gaodu2= $gaodu-$sacle_qx*2;
$sacle_x = $gaodu2/$hight_pa;
$sacle_y = $gaodu2/$hight_pa;
$f->COM("sel_transform,mode=anchor,oper=scale,duplicate=no,x_anchor=$cenjx,y_anchor=$cenjy,angle=0,x_scale=$sacle_x,y_scale=$sacle_y,x_offset=0,y_offset=0");
$f->COM("sel_create_sym,symbol=pcb169,x_datum=$cenjx,y_datum=$cenjy,delete=no,fill_dx=2.54,fill_dy=2.54,attach_atr=no,retain_atr=no");
$f->COM("delete_layer,layer=tmp2");
$f->COM("display_layer,name=$work_layer,display=yes,number=1");
$f->COM("work_layer,name=$work_layer");
$f->COM("filter_area_strt");
$f->COM("filter_area_xy,x=$x_hig_1,y=$y_hig_1");
$f->COM("filter_area_xy,x=$x_hig_2,y=$y_hig_2");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no,\n
lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("get_select_count");
$f->COM("sel_substitute,mode=substitute,symbol=pcb169,tol=25.4,x_datum=$cenjx,y_datum=$cenjy,dcode=0");
$f->COM("sel_multi_feat,operation=select,feat_types=pad,include_syms=pcb169");
$f->COM("sel_break");
goto loop_hight;
}
##^^^^^^^^^^^^^^^^等于输入的高度^^^^^^^^^^^^##
if($hight_pa eq $gaodu){$f-> MOUSE("r hight=0.80mm");}
}}}}}