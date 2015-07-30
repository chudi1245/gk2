#!/usr/bin/perl 
##    zhouqing 
use strict;
use Net::FTP;
use Win32;
use Encode;
###__________________________________
use encoding "utf8";

kysy();

my $text_cn={fn=>'档案号' ,  filename=>'使用文件名称' ,  getfile=>'取外形文件' ,
             error_1=>'请输入档案号' ,path=>'文件发放', slogan=>'MTL 高 精 特 快'};
no encoding "utf8";
###__________________________________
my ($mw,$file_number,$check_value,$info,$use,$passcode,$ftp,$mid_path,@file_dir,@file_name);
my $file_path="D:/rout";
####_____________________________________tk
$mw = MainWindow->new;
$mw->geometry("+200+100");
$mw->title("$text_cn->{slogan}");
$mw->Checkbutton(-text=>$text_cn->{filename},-variable=>\$check_value)->grid(-column=>0,-row=>0,-columnspan=>2,-sticky =>'w' );

$mw->Label(-text=>$text_cn->{fn},)->grid(-column=>0,-row=>1,);
$mw->Entry(-textvariable=>\$file_number, -width=>18)->grid(-column=>1,-row=>1);
$mw->Button(-text=>$text_cn->{getfile},-command=>\&get_file) ->grid(-column=>0,-row=>2,-columnspan=>3,-ipady=>2,-sticky=>"ew",);
$mw->Label(-textvariable=>\$info,-width=>30)                  ->grid(-column=>0,-row=>3,-columnspan=>2);
MainLoop;

sub get_file{

	$info=undef;
	unless ( $file_number ) { $info=$text_cn->{error_1}; return;  };

    chdir $file_path or die "$!",$info="$! $file_path";
	$ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@", $info=$@;
    $ftp->login("zq","12358")                     or die "$@", $info=$ftp->message;
	$ftp->binary();
	my $mid_path=encode('gb2312', $text_cn->{path} );
	$ftp->cwd("/$mid_path/rout/")                 or die "$@", $info=$ftp->message;

	my $real_name;
	( $check_value ) ? ( $real_name=$file_number ) : ( $real_name='r'.$file_number.'.rar' );
	print "$real_name \n";

	$ftp->get($real_name) or die "$!" ,$info= decode('gbk', $ftp->message);
	$info="$real_name get to $file_path";
	return;
}
###___________________________________________

=head













