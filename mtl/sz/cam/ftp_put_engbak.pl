#!/usr/bin/perl 

## Author: melody
## Email: 190170444@qq.com
## Date:  2011.08.09
## Phone: 13424338595
## Describe:  ftp, save to engbackup

##_________________________
use strict;
use Net::FTP;
use Win32;
use Tk;
use Tk::BrowseEntry;
use Tk::Dialog;
use File::Path; 
use Encode;
##
#kysy();
##my @eng_name=(undef, qw\xdb cxj\);

my ($use_name,$pass_code,$file_number,$info);

open (FILES, "C://genesis//logs//user");
$use_name=<FILES>;
close(FILES);
open (FILES, "C://genesis//logs//code");
$pass_code=<FILES>;
close(FILES);

$use_name='temp-eng';
$pass_code=='PCBmtl147258';


my $local_path="d:/work/output";
my $local_path_utf8=decode('utf8',$local_path);
#####__________________________

####____________________________
my $mw = MainWindow->new;  
$mw->title("Better and better");
$mw->geometry("+200+100");
$mw->Label(-text=>decode('utf8','用户名'),-font=>"courier 10")->grid(-column=>0, -row=>0);
$mw->Entry(-textvariable=>\$use_name, -width=>8, )			  ->grid(-column=>1, -row=>0);
##$mw->BrowseEntry(-choices=>=>\@eng_name,-textvariable=>\$use_name,-width=>6)->grid(-column=>1, -row=>0);
$mw->Label(-text=>decode('utf8','密码'),-font=>"courier 10")->grid(-column=>2, -row=>0);
$mw->Entry(-textvariable=>\$pass_code, -width=>8, -show=>'*')->grid(-column=>3, -row=>0);
$mw->Label(-text=>decode('utf8','档案号'),-font=>"courier 10")->grid(-column=>4, -row=>0);
$mw->Entry(-textvariable=>\$file_number, -width=>9, -state=>'disabled')->grid(-column=>5, -row=>0) ;
$mw->Button(-text=>decode('utf8','开始上传'),-font=>"courier 10",-command =>\&main,-width=>10)->grid(-column=>6, -row=>0);
$mw->Button(-text=>decode('utf8','档案号目录'),-font=>"courier 10",-command =>\&select_path,-width=>10)->grid(-column=>0, -row=>1,);
$mw->Label(-textvariable=>\$local_path_utf8,-relief=>'sun')->grid(-column=>1, -row=>1,-columnspan=>10,-sticky=>"ew");
$mw->Label(-textvariable=>\$info,-relief => 'sunken',-height=>'25',-anchor=>'nw',-justify => 'left')->grid(-column=>0, -row=>3,-sticky=>"ew",-columnspan =>10);
MainLoop;

sub main {

my $iinfo=undef;
my @local_files;

##测试本地目录是否存在，不存在，返回错误，存在，chdir本地目录，取得目录下所有.rar文件，不递归目录查找文件。
if ( $info=check_local($local_path)  ) {
	return;
}else{
    chdir $local_path;
    opendir (DH,$local_path) or die $!;
    @local_files=grep m/\.rar/i, readdir(DH);
	##不存在压缩文件返回
	if ($#local_files < 0) {
		$info="not found any .rar file in the $local_path";
		return;
	}
}
##参数检查，用户名是否为空，档案号是否符合命令规则	
if ( $info=check_parameter()  ) {
	return;
}

##根据档案号确定ftp的目标路径
my ($aim_path,$second_path,$mid_path) = figure_ftp_path($file_number);

##print $aim_path;
##将用户名密码写入文件
open (FH,"> C://genesis//logs//user") or die $!;
print FH "$use_name";
close FH;
open (FH,"> C://genesis//logs//code") or die $!;
print FH "$pass_code";
close FH;
##建立ftp对象
#my $ftp = Net::FTP->new("192.168.0.8", Debug => 0)   or die "$@", $info='Cannot connect to mtlfile';
my $ftp = Net::FTP->new("192.168.10.20", Debug => 0)   or die "$@", $info='Cannot connect to mtlfile';

##测试账户和密码
$ftp->login($use_name,$pass_code) or die "$@", $info=$ftp->message;
if ($info) {
	##测试失败，显示信息返回主程序
	return $info;
}else{
	##测试成功继续
	##print "pass ok and go on\n";
	$info="pass ok and go on\n";
}

##使用权限用户登录

#my $login_name=$use_name.'_mtl';
#$ftp->login($login_name,'pwd@mtl')               or die "$@", $info=$ftp->message;

#my $login_name='temp-eng';
#$ftp->login($login_name,'PCBmtl147258')           or die "$@", $info=$ftp->message;


## 设置文件传送方式
$ftp->binary()                                   or die "$@", $info=$ftp->message;
$info=$ftp->message;

###目标文件存在，覆盖旧文件 ， 如果不存在，进入二级目录测试，（注意不删除任何文件，是否先删除所有文件？？）
if (  test_ftp_path($ftp,$aim_path)  ) {
	##提示文件夹已经存在，选择是否覆盖
	my $answer=$mw->Dialog(-title => decode('utf8','警告'), -text => decode('utf8', "ftp目录 $aim_path 已经存在，是否覆盖旧文件"), 
            -default_button => decode('utf8','yay'), -buttons => [ 'yes', 'exit'], -bitmap => 'question' )->Show( );
	if ($answer eq 'exit') {
		exit;
	}
	$info.=$ftp->message;
	##back old file
	my($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time());
    my $format_time=sprintf("%d-%d-%d-%d-%d-%d",$year+1990,$mon+1,$mday,$hour,$min,$sec);
	foreach  (  $ftp->ls()  ) {
		my $sever_file=$_;
		if (grep m/^$sever_file$/, @local_files) {
			print "$_   is in  @local_files  \n";
			$ftp->rename($_,  "/engbackup/deleted/$_$format_time"  );
		}
	}
	###back old file
	ftp_put($ftp,@local_files);
	return;

}else{
	###测试二级目录
	if ( test_ftp_path($ftp,$second_path) ){
		##存在，建立档案号文件夹，上传文件
		$ftp->mkdir($file_number) or die "$@", $info=$ftp->message;
		$info.=$ftp->message;
		$ftp->cwd($aim_path) or die "$@", $info=$ftp->message;
		$info.=$ftp->message;
		ftp_put($ftp,@local_files);
		return;
	}else{
		####二级目录不存在，创建后，进入，上传
		$ftp->mkdir($second_path) or die "$@", $info=$ftp->message;
		$info.=$ftp->message;
		$ftp->mkdir($aim_path) or die "$@", $info=$ftp->message;
		$info.=$ftp->message;
		$ftp->cwd($aim_path) or die "$@", $info=$ftp->message;
		$info.=$ftp->message;
		ftp_put($ftp,@local_files);
		return;
	}
}
}###end main 


###__________________________________________________________________sub

sub check_local ($) {
	my $path=shift;
	if (not -d $path) {
		return "not found Loacal path $path ";	
	}else{
		return;
	}
}
sub check_parameter  {
	if (not $use_name ) {
		return "Use name eroor";
	}

	if ( $file_number !~ m/^[msd]\d{3,5}$/i ) {   
		return "FN Error";
	}

}

sub figure_ftp_path ($) {
	my $name=shift;
	return unless $name;
	my $root="/engbackup";
	my $type=substr($name,0,1);
	my $number=substr($name,1,);

	my $mid_path;
	if ($type =~ m/s/i ) {
		$mid_path=undef;
	}elsif($type =~ m/[dm]/i){
		$mid_path=( int($number/10000)+1 ) * 10000;
	}else{
		return ;
	}
	return  ("$root/$type/$mid_path/$name", "$root/$type/$mid_path",$mid_path);

	
}

sub test_ftp_path ($$){
	my $ftp=shift;
	my $path=shift;
	my $state= $ftp->cwd($path);
	$info.=$ftp->message;
	return $state;
}

sub ftp_put (){
	my $ftp=shift;
	my @files=@_;
	foreach  (@files) {
	   	$ftp->put($_) or die "$@", $info=$ftp->message;
	    $info.=$ftp->message;
	}
}

sub select_path {
	 $local_path=$mw->chooseDirectory(-initialdir => "");
	 $local_path_utf8=decode('cp936',$local_path);
	 $local_path=encode('cp936',decode('cp936',$local_path));

	 ##根据目录提取档案号
	 $local_path =~ m{\/([msd]\d{3,5})$}i;
	 $file_number= $1;
}

sub odd_decode{
	my ($orig_string) = @_;
	my $string = "";
	Encode::_utf8_off($orig_string);
	$orig_string = encode("UCS-2", decode("utf8", $orig_string));
	my @bytes = unpack("C*", $orig_string);
	@bytes = @bytes[grep { $_ % 2 } 0 .. $#bytes];
	foreach my $byte (@bytes)
	{
		$string .= pack("C", $byte);
	}
	return $string;
}







=head
	$ftp->mkdir($aim_path) or die $@; 
	$info.$ftp->message;
	$ftp->cwd($aim_path) or die $@;
	$info.$ftp->message;