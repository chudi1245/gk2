#!/usr/bin/perl 
use strict;
use Tk;
use Net::FTP;
use Win32;
use Tk::BrowseEntry;
use POSIX qw(strftime);
use File::Path; 
use Encode;
###_______________________________________________________________
my @all_name=qw( Xucan thx caojing xl ty zyf013 xlj zlb zhaolibing  xyx);

my ($local_path,$file_number,$use_name,$pass_code,$info,$ftp)=("c:/tmp",undef,@all_name[1],undef,);

my $use_name;my $pass_code;
open (FILES, "C://genesis//hosts//user");
$use_name=<FILES>;
close(FILES);

open (FILES, "C://genesis//hosts//code");
$pass_code=<FILES>;
close(FILES);

chdir $local_path or die "cant chang the path $!";
if (-e "$local_path/fn_get"){
	my $state=open (FH,"$local_path/fn_get") or warn $!;
	chomp ($file_number=<FH>)if $state;
}
print "uc: $file_number\n";
###____________________________________________________________________________
my $mw = MainWindow->new;

$mw->title("Write by Mobin");
$mw->geometry("+200+100");
$mw->Label(-text=>decode('cp936','用户名'),-font=>"courier 14")->grid(-column=>0, -row=>0);
$mw->Entry(-textvariable=>\$use_name, -width=>10, )	           ->grid(-column=>1, -row=>0);
$mw->Label(-text=>decode('cp936','密码'),-font=>"courier 14")  ->grid(-column=>2, -row=>0);
$mw->Entry(-textvariable=>\$pass_code, -width=>10, -show=>'*') ->grid(-column=>3, -row=>0);
$mw->Label(-text=>decode('cp936','档案号'),-font=>"courier 14")->grid(-column=>4, -row=>0);
$mw->Entry(-textvariable=>\$file_number, -width=>18)           ->grid(-column=>5, -row=>0,);

$mw->Button(-text=>decode('cp936','菲林发放'),-font=>"courier 14",-command=>[\&put_file,'film'])->grid(-column=>0, -row=>1,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','钻带发放'),-font=>"courier 14",-command =>[\&put_file,'drill'])->grid(-column=>1, -row=>1,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','字符发放'),-font=>"courier 14",-command =>[\&put_file,'pss'])->grid(-column=>2, -row=>1,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','复投改周期'),-font=>"courier 14",-command =>[\&put_file,'re_periods'])->grid(-column=>3,-row=>1,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','CY锣带'),-font=>"courier 14",-command =>[\&put_file,'cy'])->grid(-column=>4, -row=>1,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','V-CUT文件'),-font=>"courier 14",-command =>[\&put_file,'cut'])->grid(-column=>5, -row=>1,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','作废档案号'),-font=>"courier 14",-command =>[\&put_file,'job'])->grid(-column=>6, -row=>1,-ipady=>2,-sticky=>"ew",);

$mw->Label(-textvariable=>\$info,-relief => 'sunken',-height=>4) ->grid(-column=>0, -row=>3,-sticky=>"ew",-columnspan =>10);
MainLoop;

sub check_error {
	return "use name error"  unless $use_name;
	return "pass code error" unless $pass_code;
	return "file name error" if $file_number !~ m/^[mMdDsS]\d{3,6}$/;
	return ;
}

###################
sub put_file {
	$info=undef;
	if ( $info=check_error() ) { return  };
	my $file_type=shift;

	##进入 c:/tmp
	chdir $local_path or die "cant chang the path $!";
    
	open (FH,"> C://genesis//hosts//user") or die $!;
	print FH "$use_name";
	close FH;
	open (FH,"> C://genesis//hosts//code") or die $!;
	print FH "$pass_code"; 
	close FH;	  
	
	##自动发放 作废档案号
	if ( $file_type eq 'job') {
        if ( -e "c:/tmp/$file_number") {
			system ('rm','-rf',"c:/tmp/$file_number/*") or warn $!;  ###becareful
        }
        mkdir "c:/tmp/$file_number";
		chdir "c:/tmp/$file_number" or die "cant chang the path $!";

		my $get_path = path_maybe($file_number);
		$ftp = Net::FTP->new("192.168.10.20", Debug => 0) or die "$@", $info='Cannot connect to 10.20';
		$ftp->login('eng85','Yy5565160')  or die "$@", $info=$ftp->message;
		$ftp->cwd($get_path) or die "$!",$info=$ftp->message;		
		$ftp->binary() or die "$@", $info=$ftp->message;
		
		##下载文件
		my @job_files =  $ftp->ls();
		foreach  ( @job_files ) {
			$ftp->get($_) or die "$@", $info=$ftp->message;
		}

		##上传文件        /深圳工程--作废档案号/档案号/
		my $date = strftime( "%Y-%m-%d",localtime);
		my $new_file_number = $file_number.$date;
		$ftp->cwd("/深圳工程--作废档案号/") or die "$!",$info=$ftp->message;
		$ftp->mkdir($new_file_number) or die "$@", $info=$ftp->message;
		$ftp->cwd($new_file_number) or die "$!",$info=$ftp->message;
		
		foreach  ( @job_files ) {
			$ftp->put($_) or die "$@", $info=$ftp->message;
		}
		$info=decode('gbk',"$file_number backup $new_file_number ok!");	

		return;
	}
	

	my %hash=( 
		film      =>['k', '/文件发放/plot/' ],  
		drill     =>['d', '/文件发放/drill/'],
		pss       =>['s', '/文件发放/字符打印机文件/'],
        cy        =>['r', '/文件发放/CY/'],
		cut       =>['v', '/文件发放/自动V-CUT文件/'],
		pss_week  =>['s', '/文件发放/字符打印机文件/有周期/'],
		re_periods=>['k', '/文件发放/plot/复投改周期/'],
	);

    my $get_path = path_maybe($file_number);
	my $get_file=$hash{$file_type}->[0]."$file_number".'.rar';

	if ($file_type eq 'cy') {
		$get_file=$hash{$file_type}->[0]."$file_number".'-cy.rar';
	}
	my $put_path=$hash{$file_type}->[1];
	if ($file_type eq 're_periods') {		
		$get_path='/深圳工程--更改周期/';
		$get_file=uc("z${file_number}.rar");	
		$put_path='/文件发放/plot/复投改周期/';
	}
    get_csfile(uc($get_path),uc($get_file));
    put_szfile(uc($put_path),uc($get_file));
}

sub get_csfile{
	my $get_path=shift;
	my $get_file=shift;
    print "$get_path  $get_file\n";
	$ftp = Net::FTP->new("192.168.10.20", Debug => 0) or die "$@", $info='Cannot connect to 10.20';
	$ftp->login('eng85','Yy5565160')  or die "$@", $info=$ftp->message;
	$ftp->cwd($get_path) or die "$!",$info=$ftp->message;
	$ftp->binary() or die "$@", $info=$ftp->message;
	$ftp->get($get_file) or die "$@", $info=$ftp->message;
	$info=decode('gbk',"from $get_path get $get_file ok!");	
}

sub put_szfile{
    my $put_path=shift;
	my $put_file=shift;	
    print "$put_path  $put_file\n";

	$ftp = Net::FTP->new("192.168.0.8", Debug => 0)  or die "$@", $info='Cannot connect to 0.8';
	 print "start 1 \n";
	$ftp->login($use_name,$pass_code) or die "$@", $info=$ftp->message;
    print "start  2\n";
	if (-e "$local_path/$put_file") {
	
        print "start 3\n";
		$ftp->cwd($put_path) or die "$@", $info=$ftp->message;
		$ftp->binary() or die "$@", $info=$ftp->message;
		print "cwd \n";
		$ftp->put($put_file) or die "$@", $info=$ftp->message;
		print "ok ,end \n";
		$info= decode('gbk',"$put_file put to $put_path ok!");

		my $path_log="d:/tmp/";
		if (not -e $path_log) {mkpath($path_log) or die $!};
		my $time=(localtime);
		open(FH,">> $path_log/put_log.txt") or die "$!";
		print FH "$time  $use_name  $file_number  $put_file  $put_path\n";
		close FH;
		return;
	}				
}

sub path_maybe {
	my $name=shift;
	my ($path_mtl,$mid_path);
	my ($flage,$number)= $name =~ m/([msd])(\d+)/i;

	($number < 10000)  ?  ($mid_path='10000')  :
    ($number < 20000)  ?  ($mid_path='20000')  :
	($number < 30000)  ?  ($mid_path='30000')  :
    ($number < 40000)  ?  ($mid_path='40000')  :
    ($number < 50000)  ?  ($mid_path='50000')  :
    ($number < 60000)  ?  ($mid_path='60000')  :
	($number < 70000)  ?  ($mid_path='70000')  :
    ($number < 80000)  ?  ($mid_path='80000')  :
	($number < 90000)  ?  ($mid_path='90000')  :
    ($number < 100000)  ?  ($mid_path='100000')  : ();

	if ($flage =~ m/[md]/i) {
		$path_mtl="/eng/engbakup/$flage/$mid_path/$name/";
	}
	elsif($flage =~ m/[Ss]/){
		$path_mtl="/eng/engbakup/$flage/$name/";
	}
	return uc($path_mtl);
}

sub test_ok_path {
	my ($ftp,@path_maybe)=@_;
	my $state=0;
	foreach  (@path_maybe) { 
		my $state=$ftp->cwd($_) or warn $!;
		if ($state) { return $_ }
	}
	return $state;
}

