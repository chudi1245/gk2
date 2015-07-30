#!/usr/bin/perl 
use strict;
use Net::FTP;
use Win32;
use Tk::BrowseEntry;
use File::Path; 
use Encode;
#kysy();

###_______________________________________________________________
my @all_name=qw( cxh zyf013 xlj  ty  xl owk tcj  dyl1332  zlb  zq  Xucan zhaolibing  xyx);
my ($local_path,$file_number,$use_name,$pass_code,$info,$ftp)=("c:/tmp",undef,@all_name[1],undef,);

chdir $local_path or die "cant chang the path $!";
if (-e "$local_path/fn_get"){
	my $state=open (FH,"$local_path/fn_get") or warn $!;
	chomp ($file_number=<FH>)if $state;
}
###____________________________________________________________________________
my $mw = MainWindow->new;

$mw->title("Better and better");
$mw->geometry("+200+100");
$mw->Label(-text=>decode('cp936','用户名'),-font=>"courier 10")->grid(-column=>0, -row=>0);
$mw->BrowseEntry(-choices=>=>\@all_name,-textvariable=>\$use_name,-width=>6)->grid(-column=>1, -row=>0);
$mw->Label(-text=>decode('cp936','密码'),-font=>"courier 10")                                              ->grid(-column=>2, -row=>0);
$mw->Entry(-textvariable=>\$pass_code, -width=>7, -show=>'*')               ->grid(-column=>3, -row=>0);
$mw->Label(-text=>decode('cp936','档案号'),-font=>"courier 10")                                                 ->grid(-column=>4, -row=>0);
$mw->Entry(-textvariable=>\$file_number, -width=>9)                         ->grid(-column=>5, -row=>0);
$mw->Button(-text=>decode('cp936','菲林发放'),-font=>"courier 10",-command=>[\&put_file,'film'])                ->grid(-column=>0, -row=>1,-columnspan=>2,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','钻带发放'),-font=>"courier 10",-command =>[\&put_file,'drill'])            ->grid(-column=>2, -row=>1,-columnspan=>2,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','字符发放'),-font=>"courier 10",-command =>[\&put_file,'pss'])        ->grid(-column=>4, -row=>1,-ipady=>2,-sticky=>"ew",);
##$mw->Button(-text =>decode('cp936','无周期字符'),-font=>"courier 10",-command =>[\&put_file,'pss'])                 ->grid(-column=>5, -row=>1,-columnspan=>1,-ipady=>2,-sticky=>"ew",);
$mw->Button(-text =>decode('cp936','复投改周期'),-font=>"courier 10",-command =>[\&put_file,'re_periods'])        ->grid(-column=>5, -row=>1,-columnspan=>1,-ipady=>2,-sticky=>"ew",);

$mw->Label(-textvariable=>\$info,-relief => 'sunken',-height=>4)            ->grid(-column=>0, -row=>3,-sticky=>"ew",-columnspan =>10);
MainLoop;

sub check_error {
	return "use name error"  unless $use_name;
	return "pass code error" unless $pass_code;
	return "file name error" if $file_number !~ m/^[mMdDsS]\d{3,5}$/;
	return ;
}

##___________________putfile__start;
sub put_file {
	$info=undef;
	if ( $info=check_error() ) { return  };
	my $file_type=shift;

	$ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@", $info='Cannot connect to mtlfile';
	$ftp->login($use_name,$pass_code)             or die "$@", $info=$ftp->message;

	##re_periods 
	if ($file_type eq 're_periods') {
		$ftp->binary() or die "$@", $info=$ftp->message;
		my $get_path='/engbackup/更改周期/';
		my $put_path='/文件发放/plot/复投改周期/';
		$ftp->cwd($get_path) or die "$!",$info=$ftp->message;
		$ftp->get("z${file_number}.rar") or die "$@", $info=$ftp->message;
		$info=decode('gbk',$ftp->message);
		$ftp->cwd($put_path) or die "$!",$info=$ftp->message;
		$info=decode('gbk',$ftp->message);
		$ftp->put("z${file_number}.rar") or die "$@", $info=$ftp->message;
		$info=decode('gbk',$ftp->message);
		return
	}
	##

    my @path_maybe=path_maybe($file_number);
	my $ok_path=test_ok_path($ftp,@path_maybe);

	if ($ok_path) {
		$ftp->cwd($ok_path) or die "$!",$info=$ftp->message;;
	}else{
    	return $info='error cant find ok_path';
	}

	$ftp->binary() or die "$@", $info=$ftp->message;
 
	my %hash=( 
		film      =>['k', '/文件发放/plot/' ],  
		drill     =>['d', '/文件发放/drill/'],
		pss       =>['s', '/文件发放/字符打印机文件/'],
		pss_week  =>['s', '/文件发放/字符打印机文件/有周期/'],
		re_periods=>['k', '/文件发放/plot/复投改周期'],
	);

	my $catch_file=$hash{$file_type}->[0]."$file_number".'.rar';
	
	$ftp->get($catch_file) or die "$@", $info=$ftp->message;

	###______________put file
	$ftp->cwd($hash{$file_type}->[1]) or die "$@", $info=$ftp->message;
	if (-e "$local_path/$catch_file") {
		$ftp->put($catch_file) or die "$@", $info=$ftp->message;
		$info= decode('gbk',"$catch_file put to $hash{$file_type}->[1]   ok");

        my $path_log="d:/tmp/";
        if (not -e $path_log) {mkpath($path_log) or die $!};
		open(FH,">> $path_log/put_log.txt") or die "$!";
        my $time=(localtime);
        print FH "$time  $use_name  $file_number  $catch_file  $hash{$file_type}->[1]\n";
        close FH;
	    return;
	}


}
##___________________putfile__end


sub path_maybe {
	my $name=shift;
	my ($path_mtl,$path_cs,$path_hxx,$path_la,$mid_path);
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
		$path_mtl="/engbackup/$flage/$mid_path/$name/";
	}
	elsif($flage =~ m/[Ss]/){
		$path_mtl="/engbackup/$flage/$name/";
	}
	$path_hxx="/华新迅工程制作文件/$flage/$name/";
	$path_la="/莱奥工程制作文件/$flage/$name/";
	$path_cs="/engbackup/长沙工程制作文件/$flage/$name/";

	return ($path_mtl,$path_cs,$path_hxx,$path_la);
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

=head


my ($local_path,$mw,$file_number,$use,$passcode,$ftp,$mid_path,$info,@file_dir,@file_name)=('d:/work');

$mw = MainWindow->new(-height => 50000);
$mw->geometry("+200+100");
$mw->Label(-text=>"F/N::   ",-width=>10)                      ->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$file_number, -width=>20)          ->grid(-column=>1,-row=>0);
$mw->Button(-text=>'Get File',-command=>\&get_file,-width=>30)->grid(-column=>0,-row=>1,-columnspan=>3,-ipady=>2,-sticky=>"ew",);
$mw->Label(-textvariable=>\$info,-relief=>'sun',-width=>30)   ->grid(-column=>0,-row=>2,-columnspan=>2);

MainLoop;
####___________________________________________________________________________________
sub get_file {
	###initialize variable
	my ($cwd_ok,$cwd_ok_path,)=(0,undef);

	###file name check
	( $file_number !~ m/^[mMdDsS]\d{3,5}$/ )  ?  (return $info="file number error")  :  ( $info=undef );

    ###local path set
	if (not -e $local_path) { mkpath($local_path) or die $!; };
	chdir $local_path or die $!;
	system ('rm','-rf','d:/work/*') or warn $!;  ###becareful


    ### ftp login
	$ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@", $info='Cannot connect to mtlfile';
	$ftp->login("zq","12358")                     or die "$@", $info=$ftp->message;

    ###test which path is ok 
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
    ### if one path is ok, set binary ,get file ,else retrun 'cant find'
	if ($cwd_ok) {
		$ftp->binary();
		my @list=$ftp->ls();
		foreach  (@list) {  $ftp->get($_) or die "$!"; }
		$info="$file_number get ok";
		$ftp->quit;

		mkdir 't'   or warn $!;
		mkdir 'pcb' or warn $!;
		system ('d:/xxx/camp/exe/unrar', 'e', "d${file_number}.rar", "$local_path/pcb");
		system ('d:/xxx/camp/exe/unrar', 'e', "k${file_number}.rar", "$local_path/pcb");
		open  FH, "> c:/tmp/fn_get" or die "$!"  ;
        print FH "$file_number";
        close FH;

		##system ('start','d:/work') or warn $!;
		##system ('D:/xxx/camp/exe/start.bat') or warn $!;
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

	($number < 10000)  ?  ($mid_path='10000')  :
    ($number < 20000)  ?  ($mid_path='20000')  :
	($number < 30000)  ?  ($mid_path='30000')  :
    ($number < 40000)  ?  ($mid_path='40000')  :
    ($number < 50000)  ?  ($mid_path='50000')  :
    ($number < 60000)  ?  ($mid_path='60000')  :
    ($number < 70000)  ?  ($mid_path='70000')  : ();

	if ($flage =~ m/[md]/i) {
		$path_mtl="/engbackup/$flage/$mid_path/$name/";
	}
	elsif($flage =~ m/[Ss]/){
		$path_mtl="/engbackup/$flage/$name/";
	}
	$path_hxx="/华新迅工程制作文件/$flage/$name/";
	$path_la="/莱奥工程制作文件/$flage/$name/";
	$path_cs="/engbackup/长沙工程制作文件/$flage/$name/";

	return ($path_mtl,$path_cs,$path_hxx,$path_la);
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








