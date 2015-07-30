#!/usr/bin/perl 
use strict;
use Net::FTP;
use Win32;
use File::Path; 
#use FBI;
#kysy();

my ($local_path,$mw,$file_number,$use,$passcode,$ftp,$mid_path,$info,@file_dir,@file_name)=('d:/work');

$mw = MainWindow->new();
$mw->title("Better and better!");
$mw->geometry("+200+100");
$mw->Label(-text=>"F/N::   ",-width=>10)                      ->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$file_number, -width=>20)          ->grid(-column=>1,-row=>0)->focus;
$mw->Button(-text=>'Get Files',-command=>\&get_file,-width=>30)->grid(-column=>0,-row=>1,-columnspan=>3,-ipady=>2,-sticky=>"ew",);
$mw->Label(-textvariable=>\$info,-relief=>'sun',-width=>30)   ->grid(-column=>0,-row=>2,-columnspan=>2);
MainLoop;
####___________________________________________________________________________________
sub get_file {
    ###local path set
    if (not -d $local_path) { mkpath($local_path) or die $!; };
	chdir $local_path or die $!;

	###initialize variable
	my ($cwd_ok,$cwd_ok_path,)=(0,undef);

	###file name check
	( $file_number !~ m/^[mMdDsS]\d{3,5}$/ )  ?  (return $info="file number error")  :  ( $info=undef );

    ### ftp login and set bin mode
	$ftp = Net::FTP->new("mtlfile",Port=>2121, Debug => 0)   or die "$@", $info='Cannot connect to mtlfile';
	$ftp->login("zq","12358")                     or die "$@", $info=$ftp->message;
	$ftp->binary();

    ###test which path is ok ？如果存在多个合适的文件夹？？
	my @path_maybe=path_maybe($file_number);

    foreach my $id (@path_maybe) { 
		next unless $id;
		if ( $ftp->cwd($id) ){
		    print "$id";
			$cwd_ok++;
			$cwd_ok_path=$id;
			last;
		}
    }

    ### if one path is ok, get file ,else retrun 'cant find'
	if ($cwd_ok) {
		##下载改目录下文件，不递归
		my @list=$ftp->ls();   
		foreach  (@list) {  $ftp->get($_) or die "$!"; }
		$info="$file_number get ok";
		$ftp->quit;
		exit;
		
	}else{
		$info="cant find the file $file_number";
	}
}
###_________________________________________________________________________sub
sub path_maybe {
	my $name=shift;
	my ($path_mtl,$path_cs,$path_hxx,$path_la,$mid_path);
	my ($flage,$number)= $name =~ m/([msd])(\d+)/i;

	$mid_path=( int($number/10000)+1 ) * 10000;

	if ($flage =~ m/[md]/i) {
		$path_mtl="/engbackup/$flage/$mid_path/$name/";
	}
	elsif($flage =~ m/[Ss]/){
		$path_mtl="/engbackup/$flage/$name/";
	}
	$path_hxx="/华新迅工程制作文件/$flage/$name/";
	$path_la="/莱奥工程制作文件/$flage/$name/";
	$path_cs="/engbackup/长沙工程制作文件/$flage/$name/";

    ####注意本地文件与外发文件的更改！！
	return ($path_mtl,$path_cs,$path_la,$path_hxx,);  
}






=head
    if ($mid_path == d) then
         set number=`echo $fn|cut -b 2-20`
         if ($number < 10000) then
             set  mid_path = "$mid_path/10000" 
         else if ($number < 20000) then
             set  mid_path = "$mid_path/20000"
         else if ($number < 30000) then
             set  mid_path = "$mid_path/30000" 
         else
             set  mid_path = "$mid_path/40000" 
         endif
    endif


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

###解压缩----??使用系统函数
##if (-e "k$file_number.rar") {
##	system ("unrar","e","k$file_number.rar");
##if (-e "d$file_number.rar") {
##	system ("unrar","e","d$file_number.rar");
###启动genesis
###保存档案号













