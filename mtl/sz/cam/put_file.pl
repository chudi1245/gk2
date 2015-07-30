#!/usr/bin/perl 
##   zhouqing 
##   2009.08.12
use strict;
use Net::FTP;
use Win32;
use FileHandle;
my @qae_name=qw(cxh xlj ty  xl   owk tcj lf1341  dyl1332 zq zlb);
my ($mw,$use_name,$pass_code,$info,$file_number,);

kysy();

###_______________________________________
chdir "c:/tmp" or die "cant chang the path $!";
if (-e "c:/tmp/fn_get"){
	my $fh = FileHandle->new("c:/tmp/fn_get");
	   $file_number=<$fh>;
	   chomp $file_number;
}
###_____________________________________
$mw = MainWindow->new;
$mw->title("Better and better");
$mw->Label(-text=>"UseName",)                                             ->grid(-column=>0, -row=>0);
$mw->Optionmenu(-options =>\@qae_name,-textvariable=>\$use_name,-width=>1)->grid(-column=>1, -row=>0);
$mw->Label(-text=>"PassWord",)                                            ->grid(-column=>2, -row=>0);
$mw->Entry(-textvariable=>\$pass_code, -width=>7, -show=>'*')             ->grid(-column=>3, -row=>0);
$mw->Label(-text=>"F/N",)                                                 ->grid(-column=>4, -row=>0);
$mw->Entry(-textvariable=>\$file_number, -width=>9)                       ->grid(-column=>5, -row=>0);
$mw->Button(-text=>'Put_Flim',-command=>\&put_film)                       ->grid(-column=>0, -row=>1,-columnspan=>2,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>'Put_Drill',-command =>\&put_drill)                   ->grid(-column=>2, -row=>1,-columnspan=>2,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>'Put_SS8888',-command =>\&put_ss8888)                 ->grid(-column=>4, -row=>1,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>'Put_SS',-command =>\&put_ss)                         ->grid(-column=>5, -row=>1,-columnspan=>1,-ipady=>2,-sticky=>"ew",);
$mw->Label(-textvariable=>\$info,-relief => 'sunken',-height=>4)          ->grid(-column=>0, -row=>3,-sticky=>"ew",-columnspan =>6);
MainLoop;
###________________________________________
sub put_film{
	my ($ftp,$time,$mid_path,$cs_mid_path,$number);
	$info="";
    if (! $file_number) { $info=" Error! Pls input f/n";  return 0;}
	($mid_path,$cs_mid_path)=mid_set($file_number);
	print "$mid_path $cs_mid_path -------";
    $ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@",   $info="cant conect to ftp-ip";
    $ftp->login("$use_name","$pass_code")         or die "$!",   $info="Cannot login ", $ftp->message;
    $ftp->binary();
    $ftp->cwd("/engbackup/$mid_path/$file_number")or $ftp->cwd("/engbackup/长沙工程制作文件/$cs_mid_path/$file_number")
	                                              or die "$!",   $info="Cannot change working directory",  $ftp->message; 
    $ftp->get("k$file_number.rar")                or die "$!",   $info="get failed",                       $ftp->message;
    $ftp->cwd("/文件发放/plot")                   or die "$!",   $info="cant change to plot" ,             $ftp->message;
    $ftp->put("k$file_number.rar")                or die "$!",   $info="put failed",                       $ftp->message;
    $info="$file_number plot_file put to plot sucesess!";
    open(FH,">> d:/tmp/put_log.txt") or die "$!";
    $time=(localtime);
    print FH "$time  $use_name  $file_number -- film put ok\n";
    close FH;
}  
sub put_drill{
	my ($ftp,$time,$mid_path,$cs_mid_path,$number);
	$info="";
    if (! $file_number) { $info=" Error! Pls input f/n";  return 0;}
	($mid_path,$cs_mid_path)=mid_set($file_number);
	print "$mid_path $cs_mid_path -------";
    $ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@",   $info="cant conect to ftp-ip";
    $ftp->login("$use_name","$pass_code")         or die "$!",   $info="Cannot login ", $ftp->message;
    $ftp->binary();
    $ftp->cwd("/engbackup/$mid_path/$file_number")or $ftp->cwd("/engbackup/长沙工程制作文件/$cs_mid_path/$file_number")
	                                              or die "$!",   $info="Cannot change working directory",  $ftp->message; 
    $ftp->get("d$file_number.rar")                or die "$!",   $info="get failed",                       $ftp->message;
    $ftp->cwd("/文件发放/drill")                   or die "$!",   $info="cant change to plot" ,             $ftp->message;
    $ftp->put("d$file_number.rar")                or die "$!",   $info="put failed",                       $ftp->message;
    $info="$file_number drill_file put to drill sucesess!";
    open(FH,">> d:/tmp/put_log.txt") or die "$!";
    $time=(localtime);
    print FH "$time  $use_name  $file_number -- drill put ok\n";
    close FH;
}  
sub put_ss8888{
	my ($ftp,$time,$mid_path,$cs_mid_path,$number);
	$info="";
    if (! $file_number) { $info=" Error! Pls input f/n";  return 0;}f
	($mid_path,$cs_mid_path)=mid_set($file_number);
	print "$mid_path $cs_mid_path -------";
    $ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@",   $info="cant conect to ftp-ip";
    $ftp->login("$use_name","$pass_code")         or die "$!",   $info="Cannot login ", $ftp->message;
    $ftp->binary();
    $ftp->cwd("/engbackup/$mid_path/$file_number")or $ftp->cwd("/engbackup/长沙工程制作文件/$cs_mid_path/$file_number")
	                                              or die "$!",   $info="Cannot change working directory",  $ftp->message; 
    $ftp->get("s$file_number.rar")                or die "$!",   $info="get failed",                       $ftp->message;
    $ftp->cwd("/文件发放/字符打印机文件/有周期")                   or die "$!",   $info="cant change to plot" ,             $ftp->message;
    $ftp->put("s$file_number.rar")                or die "$!",   $info="put failed",                       $ftp->message;
    $info="$file_number ss_file put  sucesess!";
    open(FH,">> d:/tmp/put_log.txt") or die "$!";
    $time=(localtime);
    print FH "$time  $use_name  $file_number -- silk8888 put ok\n";
    close FH;
}  
sub put_ss{
	my ($ftp,$time,$mid_path,$cs_mid_path,$number);
	$info="";
    if (! $file_number) { $info=" Error! Pls input f/n";  return 0;}
	($mid_path,$cs_mid_path)=mid_set($file_number);
	print "$mid_path $cs_mid_path -------";
    $ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@",   $info="cant conect to ftp-ip";
    $ftp->login("$use_name","$pass_code")         or die "$!",   $info="Cannot login ", $ftp->message;
    $ftp->binary();
    $ftp->cwd("/engbackup/$mid_path/$file_number")or $ftp->cwd("/engbackup/长沙工程制作文件/$cs_mid_path/$file_number")
	                                              or die "$!",   $info="Cannot change working directory",  $ftp->message; 
    $ftp->get("s$file_number.rar")                or die "$!",   $info="get failed",                       $ftp->message;
    $ftp->cwd("/文件发放/字符打印机文件/无周期")                   or die "$!",   $info="cant change to plot" ,             $ftp->message;
    $ftp->put("s$file_number.rar")                or die "$!",   $info="put failed",                       $ftp->message;
    $info="$file_number ss_file put  sucesess!";
    open(FH,">> d:/tmp/put_log.txt") or die "$!";
    $time=(localtime);
    print FH "$time  $use_name  $file_number -- silk put ok\n";
    close FH;
}  

###______________________________________________
sub mid_set {
	my $fn=shift;
	my $mid_path=substr($fn,0,1);
	my $cs_mid_path=substr($fn,0,1);
	my $number=substr($fn,1,10);
	if ($mid_path eq 'm') {
		if ($number < 10001) {
			$mid_path="$mid_path/10000";
		}elsif($number < 20001){
			$mid_path="$mid_path/20000";
		}elsif($number < 30001){
			$mid_path="$mid_path/30000";
		}elsif($number < 40001){
			$mid_path="$mid_path/40000";
		}elsif($number < 50001){
			$mid_path="$mid_path/50000";
		}
	};
	if ($mid_path eq 'd') {
		if ($number < 10001) {
			$mid_path="$mid_path/10000";
		}elsif($number < 20001){
			$mid_path="$mid_path/20000";
		}elsif($number < 30001){
			$mid_path="$mid_path/30000";
		}elsif($number < 40001){
			$mid_path="$mid_path/40000";
		}
	};
	return ($mid_path,$cs_mid_path);
}


