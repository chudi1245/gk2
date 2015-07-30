#!/usr/bin/perl 
##    zhouqing 
##    2010.06.17
use strict;
use Net::FTP;
use Win32;
use File::Find;

kysy();

###______________________________________
    my $CLIP = Win32::Clipboard();
    $CLIP->Empty();
    $CLIP->Set('E:/work/pcb/');
###_______________________________________
my ($mw,$file_number,$use,$passcode,$ftp,$mid_path,@file_dir,@file_name);
my ($info)=("------",);
my $file_path="e:/work";
####_____________________________________tk
$mw = MainWindow->new(-height => 50000);
$mw->geometry("+200+100");
$mw->title("get_file____ZQ");
$mw->Label(-text=>"F/N__",)                         ->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$file_number, -width=>18)->grid(-column=>1,-row=>0);
$mw->Button(-text=>'Get File',-command=>\&get_file) ->grid(-column=>0,-row=>1,-columnspan=>3,-ipady=>2,-sticky=>"ew",);
$mw->Label(-textvariable=>\$info,)                  ->grid(-column=>0,-row=>2,-columnspan=>2);
MainLoop;
####_____________________________________
sub get_file{
     ###___________________________del_all
     chdir $file_path or die "$!",$info="$!";
     find(\&del_all,$file_path);
     sub del_all {
	     unshift @file_dir,  $File::Find::dir;
         unshift @file_name, $_;
     }
     foreach  (0..$#file_name) {
	     my $ob="$file_dir[$_]/$file_name[$_]";
         if (-f $ob) {
		     unlink $ob or die"$!",$info="$!";
         }
         if (-d $ob and $ob ne "$file_path/\.") {
		      rmdir $ob or die"$!",$info="$!";
         }

     }
	 mkdir "t"   or die "$!",$info="$!";
	 mkdir "pcb" or die "$!",$info="$!";
     ###_________________________________
     my  $mid_path=substr($file_number,0,1);
     $info="";
     if (! $file_number) { $info="Error! Pls input f/n";  return 0;}
     $ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@", $info='Cannot connect to mtlfile';
     $ftp->login("zq","12358")                     or die "$@", $info='Cannot login',                    $ftp->message;
     $ftp->cwd("/engbackup/$mid_path/$file_number") or die "$@", $info='Cannot change working directory', $ftp->message;
     $ftp->binary();
     my @list=$ftp->ls();
     foreach  (@list) {
	     $ftp->get($_) or die "$!";
     }
     $info="file get ok";
     $ftp->quit;
     open  FH, "> c:/tmp/fn_get" ||die "$!"  ;
     print FH "$file_number";
     close FH;

}
###___________________________________________


#!perl
use Win32;
use strict;
use Encode;
#use encoding("gb2312");
#BEGIN {
#  if ($^O eq 'MSWin32') {
#    require Win32::Console;
#    Win32::Console::Free( );
#  }
#}
=h

my $owner_dbfile;
my $log_file;
my $owner_dbfile_v;
my $log_file_v;

my $mw = MainWindow->new();
$mw->geometry("800x250+400+450");
$mw->title('OwnChk');

my $selfile1 = $mw->Button(-text => decode("gb2312", '选择owner_db文件'),
                           -command => \&open_file1)->pack;
$mw->Label(-textvariable => \$owner_dbfile_v)->pack;

my $selfile2 = $mw->Button(-text => decode("gb2312" ,'选择clearcase log文件'),
                           -command => \&open_file2)->pack;
$mw->Label(-textvariable => \$log_file_v)->pack;

my $exit = $mw->Button(-text => 'run check',
                       -command => [$mw => 'destroy']);
$exit->pack;

my $types1 = [ ['excel files', '.xls'],
              ['All Files', '*'],];
my $types2 = [ ['excel files', '.txt'],
              ['All Files', '*'],];
MainLoop;




###解压缩----??使用系统函数
##if (-e "k$file_number.rar") {
##	system ("unrar","e","k$file_number.rar");
##if (-e "d$file_number.rar") {
##	system ("unrar","e","d$file_number.rar");
###启动genesis
###保存档案号









