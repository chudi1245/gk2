#!/usr/bin/perl 
use strict;
use Tk;
use Net::FTP;
use Win32;
use Tk::BrowseEntry;
use File::Path; 
use Encode;
##************************************
#kysy();

my ($use_name,$pass_code,);
open (FILES, "C://genesis//hosts//user");
$use_name=<FILES>;
close(FILES);

open (FILES, "C://genesis//hosts//code");
$pass_code=<FILES>;
close(FILES);
##*************************************
my ($local_path,$mw,$file_number,$use,$passcode,$ftp,$mid_path,$info,@file_dir,@file_name)=('d:/work');

$mw = MainWindow->new(-height => 50000);
$mw->title(decode('cp936','Delete/文件发放/【钻孔，字符，锣带，CY】文件'));
$mw->geometry("+300+150");

$mw->Label(-text=>decode('cp936','用户'),-font=>"courier 14", -width=>10,)->grid(-column=>0, -row=>0);
$mw->Entry(-textvariable=>\$use_name,-font =>[-size => 12], -width=>10, )->grid(-column=>1, -row=>0);
$mw->Label(-text=>decode('cp936','密码'),-font=>"courier 14", -width=>10,) ->grid(-column=>2, -row=>0);
$mw->Entry(-textvariable=>\$pass_code,-font =>[-size => 12], -width=>10,-show=>'*')->grid(-column=>3, -row=>0);
$mw->Label(-text=>decode('cp936','档案号'),-font=>"courier 14",-width=>10,)->grid(-column=>4, -row=>0);
$mw->Entry(-textvariable=>\$file_number,-font =>[-size => 16], -width=>10)->grid(-column=>5,-row=>0)->focus;

##$mw->Button(-text=>decode('cp936','删资料'),-command=>\&del_job,-width=>10,-font=>"courier 14")->grid(-column=>0,-row=>1,-sticky=>"ew",);   

$mw->Button(-text=>decode('cp936','删钻孔'),-command=>[\&del_file,'drill'],-width=>10,-font=>"courier 14")->grid(-column=>0,-row=>1,-sticky=>"ew",);  
$mw->Button(-text=>decode('cp936','删字符'),-command=>[\&del_file,'silk'],-width=>10,-font=>"courier 14")->grid(-column=>1,-row=>1,-sticky=>"ew",);  
$mw->Button(-text=>decode('cp936','删锣带'),-command=>[\&del_file,'rout'],-width=>10,-font=>"courier 14")->grid(-column=>3,-row=>1,-sticky=>"ew",);  
$mw->Button(-text=>decode('cp936','删除CY'),-command=>[\&del_file,'cy'],-width=>10,-font=>"courier 14")->grid(-column=>4,-row=>1,-sticky=>"ew",);  
$mw->Label(-textvariable=>\$info,-relief=>'sun',-font =>[-size => 14],-width=>60)   ->grid(-column=>0,-row=>4,-columnspan=>6);

MainLoop;

####_________________________________________del_file    -command =>[\&put_file,'drill']
sub del_file {
	my $file_type=shift;

	#__________保存用户名，与密码。

	open (FH,"> C://genesis//hosts//user") or die $!;
	print FH "$use_name";
	close FH;
	open (FH,"> C://genesis//hosts//code") or die $!;
	print FH "$pass_code";
	close FH;

	#__________检查输入的档案号名称是否正确。

	( $file_number !~ m/^[mMdDsS]\d{3,5}$/ )  ?  (return $info="file number error")  :  ( $info=undef );
   
	my $path_file;
	my @del_name = undef;
	
	my @del_name=qw(............ ............ ............ ............ ............ ............ ............ ............ );
	my $row=4;
	foreach my $name (@del_name) {
	$mw->Label(-textvariable=>\$name,-font=>[-size=>12],-width=>20,)->grid(-column=>2,-columnspan=>4,-row=>++$row,); 
	
	}

	if ($file_type eq 'drill') {
		$path_file='/文件发放/drill/';
	}elsif($file_type eq 'silk'){
		$path_file='/文件发放/字符打印机文件/';
	}elsif($file_type eq 'rout'){
		$path_file='/文件发放/rout/';
	}elsif($file_type eq 'cy'){
		$path_file='/文件发放/CY/';   
	}
	
	#——————————登录服务器删除资料。
	
	$ftp = Net::FTP->new("192.168.0.8",Debug => 0) or die "$@", $info='Cannot connect to 192.168.0.8';
	$ftp->login($use_name,$pass_code) or die "$@", $info=$ftp->message;
	
	if ($info) {return $info;}
	$ftp->login("szenghw","hwmtleng9")             or die "$@", $info=$ftp->message;
    $ftp->cwd($path_file) or die "$!"; 
    
	my @list=$ftp->ls();
	foreach  (@list) {
       if ($_ =~ m/$file_number/gi) {
		   push(@del_name,$_);
       }

	}
    my $flage = 0;
	my $row=4;

	foreach my $name (@del_name) {
	print "$name\n";
	if ($ftp->delete($name) ) {
	$mw->Label(-textvariable=>\$name,-font=>[-size=>12],-width=>20,)->grid(-column=>2,-columnspan=>4,-row=>++$row,); 
	$flage= 1;
	}	
	}
	if ($flage == 0) {
		 $info="对不起！$file_number 的 $file_type 文件没有找到!";
		 $info=decode('cp936',$info);
		 
	}else{
		 $info="祝贺你！$file_number 的 $file_type 文件删除成功!";
		 $info=decode('cp936',$info);
	}  
	$ftp->quit;			
}


=head 

sub del_job{

open (FH,"> C://genesis//hosts//user") or die $!;
print FH "$use_name";
close FH;
open (FH,"> C://genesis//hosts//code") or die $!;
print FH "$pass_code";
close FH;

#__________检查输入的档案号名称是否正确

( $file_number !~ m/^[mMdDsS]\d{3,5}$/ )  ?  (return $info="file number error")  :  ( $info=undef );
   
my ($path_mtlp,$mid_path,$name);

$name = $file_number;
$name =~s/[MmDdSs]//;
$mid_path = (int ($name/10000) + 1)*10000;
    
   if ($file_number =~ m/[Mm]/i) {$path_mtlp="/engbackup/m/$mid_path/";}
elsif ($file_number =~ m/[Dd]/i) {$path_mtlp="/engbackup/d/$mid_path/";}
elsif ($file_number =~ m/[Ss]/i) {$path_mtlp="/engbackup/s/";} 

#______________________________登录

$ftp = Net::FTP->new("192.168.0.8",Debug => 0) or die "$@", $info='Cannot connect to 192.168.0.8';
$ftp->login($use_name,$pass_code)              or die "$@", $info=$ftp->message;
if ($info) {return $info;}

#——————————————————————————————

$ftp->login("szenghw","hwmtleng9")             or die "$@", $info=$ftp->message;	
$ftp->cwd($path_mtlp) or die "$!"; 
$ftp->rmdir($file_number,[1]) or die "$@",$info=decode('cp936',"服务器上没有找到 $file_number 可能已经删除，请检查！"),$ftp->message;
$ftp->quit;	

$info="祝贺你!  $file_number 删除成功!";
$info=decode('cp936',$info);

}
