#!/usr/bin/perl 
use strict;
use Tk;
use Net::FTP;
use Win32;
use DBD::ODBC;
use Encode;
use encoding 'euc_cn';
use File::Path; 

kysy();

my ($file_path,$local_path,$mw,$file_number,$use,$passcode,$ftp,$mid_path,$info,@file_dir,@file_name,$orig_name)=('d:/work','d:/work');

my ($mday,$mon,$year) = (localtime(time))[3,4,5];   
$year += 1900;  
##$year="$year"."年";
$mon += 1;   
##$mon="$mon"."月";
my $date = $year."/".$mon."/".$mday;  

###my $pathname="/text/$year/$mon/$mday";
my $mw = MainWindow->new;
##$mw = MainWindow->new(-height => 50000);
$mw->geometry("+400+100");
$mw->title("QAE专用取文件");
$mw->Label(-text=>"JOB: ",-font =>[-size => 12],-width=>6)                        ->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$file_number,-font =>[-size => 12], -width=>10)         ->grid(-column=>1,-row=>0)->focus;

$mw->Button(-text=>'显示原名',-command=>\&disname,
-font =>[-size => 12],-width=>20)                ->grid(-column=>2,-row=>0,-ipady=>2,-sticky=>"ew",);

$mw->Entry(-textvariable=>\$orig_name,-font =>[-size => 12], -width=>40)         ->grid(-column=>0,-row=>1,-columnspan=>3);

$mw->Label(-text=>"今天是:$date",-font =>[-size => 12],-width=>20)                  ->grid(-column=>0,-row=>2,-columnspan=>3,);

$mw->Button(-text=>'下载文件',-command=>\&get_file,-font =>[-size => 12],-width=>20)->grid(-column=>2,-row=>3,-columnspan=>3,-ipady=>2,-sticky=>"ew",);

$mw->Button(-text=>'检查名称',-command=>\&check_file,
-font =>[-size => 12],-width=>20)                ->grid(-column=>2,-row=>4,-ipady=>2,-sticky=>"ew",);

$mw->Label(-textvariable=>\$info,-relief=>'sun',-font =>[-size => 12],-width=>40)   ->grid(-column=>0,-row=>5,-columnspan=>3);

MainLoop;

sub disname{
my $DSN = qq{driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;};
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";   
	my $sql=qq(select goodsName from tbproduction where (goodscode='$file_number'));
	my $sth = $dbh->prepare($sql);
$sth->execute();
$orig_name=$sth->fetchrow_array();

}

###___________________________________
sub get_origfile {

	my $DSN = qq{driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;};
    my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";
    
	my $sql=qq(select goodsName from tbproduction where (goodscode='$file_number'));
   
	my $sth = $dbh->prepare($sql);
    $sth->execute();
    $orig_name=$sth->fetchrow_array();

	$info=undef;
	unless ( $orig_name ) { $info='is not filename'; return;  };

    chdir $file_path or die "$!",$info="$! $file_path";
	
	$ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@", $info=$@;
    $ftp->login("tw","12345")                     or die "$@", $info=$ftp->message;
	$ftp->binary();
	
	my $mid_path="/newbakup/text/$date/" ;
	print "$mid_path \n";

	$ftp->cwd("$mid_path")                 or die "$@", $info=$ftp->message;	
	
	print "进入目录OK！";

	$ftp->get($orig_name) or die "$!" ,$info= decode('gbk', $ftp->message);
	
	$info="$orig_name get to $file_path";
	
###	exit;
}

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
        system ('d:/xxx/camp/exe/unrar', 'e', "j${file_number}.rar", "$local_path"    );
		open  FH, "> c:/tmp/fn_get" or die "$!"  ;
        print FH "$file_number";
        close FH;

		##system ('start','d:/work') or warn $!;
		##system ('D:/xxx/camp/exe/start.bat') or warn $!;
	    return;
	##	exit;
		
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

	#($number < 10000)  ?  ($mid_path='10000')  :
    #($number < 20000)  ?  ($mid_path='20000')  :
	#($number < 30000)  ?  ($mid_path='30000')  :
    #($number < 40000)  ?  ($mid_path='40000')  :
    #($number < 50000)  ?  ($mid_path='50000')  :
    #($number < 60000)  ?  ($mid_path='60000')  :
    #($number < 70000)  ?  ($mid_path='70000')  : ();

	if ($flage =~ m/[md]/i) {
		$path_mtl="/engbackup/$flage/$mid_path/$name/";
	}
	elsif($flage =~ m/[Ss]/){
		$path_mtl="/engbackup/$flage/$name/";
	}
	$path_hxx="/华新迅工程制作文件/$flage/$name/";
	$path_la="/莱奥工程制作文件/$flage/$name/";
	$path_cs="/engbackup/长沙工程制作文件/$flage/$name/";

	return ($path_mtl,$path_cs,$path_la,$path_hxx,);
}

sub check_file{

my @filename = undef;

opendir (TMP, "$file_path") or die "cant open d:/work : $!"; 
my @dirname=readdir(TMP);
closedir (TMP);
foreach my $name (@dirname)  {       
    
     
	     if ($name =~ /z ip$/) { $name =~ s/z ip/zip/ ;unshift(@filename,$name); }
	  elsif ($name =~ /zi p$/) { $name =~ s/zi p/zip/ ;unshift(@filename,$name); }
	  elsif ($name =~ /z.ip$/) { $name =~ s/z.ip/zip/ ;unshift(@filename,$name); }
	  elsif ($name =~ /zi.p$/) { $name =~ s/zi.p/zip/ ;unshift(@filename,$name); }
	
	  elsif ($name =~ /r ar$/) { $name =~ s/r ar/rar/ ;unshift(@filename,$name); }
	  elsif ($name =~ /ra r$/) { $name =~ s/ra r/rar/ ;unshift(@filename,$name); }
	  elsif ($name =~ /r.ar$/) { $name =~ s/r.ar/rar/ ;unshift(@filename,$name); }
	  elsif ($name =~ /ra.r$/) { $name =~ s/ra.r/rar/ ;unshift(@filename,$name); }

	  elsif ($name =~ /t gz$/) { $name =~ s/t tz/tgz/ ;unshift(@filename,$name); }
	  elsif ($name =~ /tg z$/) { $name =~ s/tg z/tgz/ ;unshift(@filename,$name); }
	  elsif ($name =~ /t.gz$/) { $name =~ s/t.gz/tgz/ ;unshift(@filename,$name); }
	  elsif ($name =~ /tg.z$/) { $name =~ s/tg.z/tgz/ ;unshift(@filename,$name); }	

      elsif ($name =~ /l z$/) { $name =~ s/l z/lz/ ;unshift(@filename,$name); }	
      elsif ($name =~ /l.z$/) { $name =~ s/l.z/lz/ ;unshift(@filename,$name); }	
       else {unshift(@filename,$name); }	
   }



my $flage=0;

foreach  (@filename) {	
    print "$_  \n";
	
	if ($_ eq $orig_name) {
		
		$flage=1;

	}
	

}

if ($flage==1) {

	$info="源文件名一致。";
}else {
		
		$info="源文件名不一致！请检查是否有误。";}



}