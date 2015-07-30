#!/usr/bin/perl 
use strict;
use Net::FTP;
use Win32;
use DBD::ODBC;
use Encode;
use encoding 'euc_cn';
use File::Path; 

kysy();

my ($file_path,$mw,$file_number,$use,$passcode,$ftp,$mid_path,$info,@file_dir,@file_name,$orig_name)=('d:/work');

my ($mday,$mon,$year) = (localtime(time))[3,4,5];   
$year += 1900;  
##$year="$year"."��";
$mon += 1;   
##$mon="$mon"."��";
my $date = $year."/".$mon."/".$mday;  

###my $pathname="/text/$year/$mon/$mday";
my $mw = MainWindow->new;
##$mw = MainWindow->new(-height => 50000);
$mw->geometry("+400+100");
$mw->title("ȡ�ͻ�Դ�ļ�");
$mw->Label(-text=>"JOB: ",-font =>[-size => 12],-width=>6)                        ->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$file_number,-font =>[-size => 12], -width=>10)         ->grid(-column=>1,-row=>0)->focus;

$mw->Button(-text=>'Dis_Orig_Name',-command=>\&disname,
-font =>[-size => 12],-width=>20)                ->grid(-column=>2,-row=>0,-ipady=>2,-sticky=>"ew",);

$mw->Entry(-textvariable=>\$orig_name,-font =>[-size => 12], -width=>40)         ->grid(-column=>0,-row=>1,-columnspan=>3);

$mw->Label(-text=>"������:$date",-font =>[-size => 12],-width=>20)                  ->grid(-column=>0,-row=>2,-columnspan=>3,);

$mw->Button(-text=>'Get_Orig_File',-command=>\&get_origfile,-font =>[-size => 12],-width=>20)->grid(-column=>2,-row=>3,-columnspan=>3,-ipady=>2,-sticky=>"ew",);
$mw->Label(-textvariable=>\$info,-relief=>'sun',-font =>[-size => 12],-width=>40)   ->grid(-column=>0,-row=>4,-columnspan=>3);

MainLoop;


sub disname{

##my ($datebase, $Server,$orig_name);
##$Server='192.168.0.2';
##$datebase='mtlerp-running';

my $DSN = qq{driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;};
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";
    
	my $sql=qq(select goodsName from tbproduction where (goodscode='$file_number'));
   
	my $sth = $dbh->prepare($sql);
$sth->execute();
$orig_name=$sth->fetchrow_array();
##print @arr;

##$sth->dump_results();
##$orig_name =$sth->dump_results();
##print $orig_name;
##$sth->finish();
##$dbh->disconnect();
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
    $ftp->login("eng-admin","44445555")                     or die "$@", $info=$ftp->message;
	$ftp->binary();
	
	my $mid_path="/newbakup/text/$date/" ;
	print "$mid_path \n";

	$ftp->cwd("$mid_path")                 or die "$@", $info=$ftp->message;	
	
	print "����Ŀ¼OK��";

	$ftp->get($orig_name) or die "$!" ,$info= decode('gbk', $ftp->message);
	
	$info="$orig_name get to $file_path";
	
	exit;
}

=head
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

########################################
sub get_origfile {

	my $DSN = qq{driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;};
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";
    
	my $sql=qq(select goodsName from tbproduction where (goodscode='$file_number'));
   
	my $sth = $dbh->prepare($sql);
$sth->execute();
$orig_name=$sth->fetchrow_array();

###initialize variable
	my ($cwd_ok,$cwd_ok_path,)=(0,undef);

	###file name check

	( $file_number !~ m/^[mMdDsS]\d{3,5}$/ )  ?  (return $info="file number error")  :  ( $info=undef );
###my ($local_path,$mw,$file_number,$use,$passcode,$ftp,$mid_path,$info,@file_dir,@file_name,$orig_name)=('d:/work');
   
	###local path set
	if (not -e $local_path) { mkpath($local_path) or die $!; };
	chdir $local_path or die $!;

##	system ('rm','-rf','d:/work/*') or warn $!;  ###becareful
####$path_mtl="/engbackup/$flage/$name/";   /text/2012��/2��/23/  my $pathname="/text/$year/$mon/$mday";   
	
	$ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@", $info='Cannot connect to mtlfile';

	$ftp->login("tw","12345")                     or die "$@", $info=$ftp->message;	
     print "123  $pathname \n";
###my $pathname="/text/$year/$mon/$mday";  

	$ftp->cwd("$pathname"),$info=$ftp->message;
	
	$ftp->binary();
	 print "$orig_name \n";
	
	$ftp->get($orig_name) or die "$!" ,$info= decode('gbk', $ftp->message);
	
	return;
}
###################################################
##FTP�ϴ�
use Net::FTP;
$ftp=Net::FTP->new("$FTP_ADDR",Timeout=>30) or die "Could not connect.n";
#��¼��FTP
$ftp->login($FTP_username,$FTP_pass) or die "Could not login.n";
#�л�Ŀ¼
$ftp->cwd("/$FTP_dir[0]") ,$FTP_error=$ftp->message;
if ( $FTP_error =~ /Failed/){
print "FTP����Ŀ¼�����ڴ�����Ϣ,��ʼ����Ŀ¼$FTP_dir[0]...,n";
$ftp->mkdir($FTP_dir[0]);
print "$FTP_dir[0]Ŀ¼�������..���л���Ŀ¼����Ŀ¼,n";
$ftp->cwd("/$FTP_dir[0]");
print "��ʼ�ϴ��ļ�$file...n";
$ftp->put($file) or die "�ϴ�$fileʧ��...,n";
$ftp->put($charactorfile) or die "�ϴ�$charactorfileʧ��...,n";
$ftp->put($accountfile) or die "�ϴ�$accountfileʧ��...,n";
$ftp->quit;
}
else
{
$ftp->put($file) or die "�ϴ�$fileʧ��...,n";
$ftp->put($charactorfile) or die "�ϴ�$charactorfileʧ��...,n";
$ftp->put($accountfile) or die "�ϴ�$accountfileʧ��...,n";
$ftp->quit;
}
print "�ϴ��ļ�$file,$charactorfile,$accountfile��FTP��$FTP_dir[0]���...,n"; ��������ǰ��shell�ű� #!/bin/bash
str=`date %Y-%m-%d` 
path="/database/setup/data"
logpath="/var/log/ftpdata.log" #��/database/mcsh�ű���ȡ���FTP���û���Ŀ¼�ֶβ��ж��Ƿ���ȷ��ȷ���ϴ���FTP
dir=` cat /database/mcsh |grep str=|awk -F = '{print $2}'|awk -F _ '{print $1}'`
user=`echo $dir|sed 's/[0-9]{2}$//'`
ftppath="/DataCenter/DataCenter/$user/$dir" if [ ! -f /database/mcsh ]
then
exit
echo "��˶�/database/mcsh�ļ��Ƿ����" >> $logpath 2>&1
fi string="`echo $user|grep .gz`" if [ -z "$user" ]
then
echo "`date %Y-%m-%d %R` FTP���ݲ���������˶�/database/mcsh�ļ���str���=��_����Ƿ���FTP���û���Ŀ¼��Ӧ" >> $logpath 
elif [ ! -z "$string" ]
then
echo "`date %Y-%m-%d %R` FTP���ݲ��������������Ĳ�����$ftppathĿ¼��˶�/database/mcsh�ļ���str���=��_����Ƿ���FTP���û���Ŀ¼��Ӧ" >> $logpath
else
mysql -ppassword -e 'select * from gameLog.log_everyday;' > $path/log_everyday.txt
cd $path
#sed 1d log_everyday.txt > log_everyday.csv
#rm -rf log_everyday.txt
mv log_everyday.txt log_everyday.csv ftp -n <<EOF
open xxx 21
user $user password
binary
prompt off
cd $dir
mput *
bye
EOF
echo "`date %Y-%m-%d %R` �ϴ���FTP��$ftppath !!!" >> $logpath 
fi



sub get_origfile {

	my $DSN = qq{driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;};
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";
    
	my $sql=qq(select goodsName from tbproduction where (goodscode='$file_number'));
   
	my $sth = $dbh->prepare($sql);
$sth->execute();
$orig_name=$sth->fetchrow_array();

###initialize variable
	my ($cwd_ok,$cwd_ok_path,)=(0,undef);

	###file name check

	( $file_number !~ m/^[mMdDsS]\d{3,5}$/ )  ?  (return $info="file number error")  :  ( $info=undef );
###my ($local_path,$mw,$file_number,$use,$passcode,$ftp,$mid_path,$info,@file_dir,@file_name,$orig_name)=('d:/work');
   
	###local path set
	if (not -e $local_path) { mkpath($local_path) or die $!; };
	chdir $local_path or die $!;

##	system ('rm','-rf','d:/work/*') or warn $!;  ###becareful
   

	### ftp login
	$ftp = Net::FTP->new("mtlfile", Debug => 0)   or die "$@", $info='Cannot connect to mtlfile';
	$ftp->login("zq","12358")                     or die "$@", $info=$ftp->message;
####$path_mtl="/engbackup/$flage/$name/";   /text/2012��/2��/23/
	
	my $pathname="/text/$year/$mon/$mday";   ###my $date = $year."/".$mon."/".$mday; 
		$ftp->cwd($pathname);
		$ftp->binary();
		$ftp->get($orig_name) or die "$!"; 
		$info="$orig_name get ok";		
		$ftp->quit;
}
