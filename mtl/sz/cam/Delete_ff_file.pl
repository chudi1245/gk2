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
$mw->title(decode('cp936','Delete/�ļ�����/����ף��ַ��������CY���ļ�'));
$mw->geometry("+300+150");

$mw->Label(-text=>decode('cp936','�û�'),-font=>"courier 14", -width=>10,)->grid(-column=>0, -row=>0);
$mw->Entry(-textvariable=>\$use_name,-font =>[-size => 12], -width=>10, )->grid(-column=>1, -row=>0);
$mw->Label(-text=>decode('cp936','����'),-font=>"courier 14", -width=>10,) ->grid(-column=>2, -row=>0);
$mw->Entry(-textvariable=>\$pass_code,-font =>[-size => 12], -width=>10,-show=>'*')->grid(-column=>3, -row=>0);
$mw->Label(-text=>decode('cp936','������'),-font=>"courier 14",-width=>10,)->grid(-column=>4, -row=>0);
$mw->Entry(-textvariable=>\$file_number,-font =>[-size => 16], -width=>10)->grid(-column=>5,-row=>0)->focus;

##$mw->Button(-text=>decode('cp936','ɾ����'),-command=>\&del_job,-width=>10,-font=>"courier 14")->grid(-column=>0,-row=>1,-sticky=>"ew",);   

$mw->Button(-text=>decode('cp936','ɾ���'),-command=>[\&del_file,'drill'],-width=>10,-font=>"courier 14")->grid(-column=>0,-row=>1,-sticky=>"ew",);  
$mw->Button(-text=>decode('cp936','ɾ�ַ�'),-command=>[\&del_file,'silk'],-width=>10,-font=>"courier 14")->grid(-column=>1,-row=>1,-sticky=>"ew",);  
$mw->Button(-text=>decode('cp936','ɾ���'),-command=>[\&del_file,'rout'],-width=>10,-font=>"courier 14")->grid(-column=>3,-row=>1,-sticky=>"ew",);  
$mw->Button(-text=>decode('cp936','ɾ��CY'),-command=>[\&del_file,'cy'],-width=>10,-font=>"courier 14")->grid(-column=>4,-row=>1,-sticky=>"ew",);  
$mw->Label(-textvariable=>\$info,-relief=>'sun',-font =>[-size => 14],-width=>60)   ->grid(-column=>0,-row=>4,-columnspan=>6);

MainLoop;

####_________________________________________del_file    -command =>[\&put_file,'drill']
sub del_file {
	my $file_type=shift;

	#__________�����û����������롣

	open (FH,"> C://genesis//hosts//user") or die $!;
	print FH "$use_name";
	close FH;
	open (FH,"> C://genesis//hosts//code") or die $!;
	print FH "$pass_code";
	close FH;

	#__________�������ĵ����������Ƿ���ȷ��

	( $file_number !~ m/^[mMdDsS]\d{3,5}$/ )  ?  (return $info="file number error")  :  ( $info=undef );
   
	my $path_file;
	my @del_name = undef;
	
	my @del_name=qw(............ ............ ............ ............ ............ ............ ............ ............ );
	my $row=4;
	foreach my $name (@del_name) {
	$mw->Label(-textvariable=>\$name,-font=>[-size=>12],-width=>20,)->grid(-column=>2,-columnspan=>4,-row=>++$row,); 
	
	}

	if ($file_type eq 'drill') {
		$path_file='/�ļ�����/drill/';
	}elsif($file_type eq 'silk'){
		$path_file='/�ļ�����/�ַ���ӡ���ļ�/';
	}elsif($file_type eq 'rout'){
		$path_file='/�ļ�����/rout/';
	}elsif($file_type eq 'cy'){
		$path_file='/�ļ�����/CY/';   
	}
	
	#����������������������¼������ɾ�����ϡ�
	
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
		 $info="�Բ���$file_number �� $file_type �ļ�û���ҵ�!";
		 $info=decode('cp936',$info);
		 
	}else{
		 $info="ף���㣡$file_number �� $file_type �ļ�ɾ���ɹ�!";
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

#__________�������ĵ����������Ƿ���ȷ

( $file_number !~ m/^[mMdDsS]\d{3,5}$/ )  ?  (return $info="file number error")  :  ( $info=undef );
   
my ($path_mtlp,$mid_path,$name);

$name = $file_number;
$name =~s/[MmDdSs]//;
$mid_path = (int ($name/10000) + 1)*10000;
    
   if ($file_number =~ m/[Mm]/i) {$path_mtlp="/engbackup/m/$mid_path/";}
elsif ($file_number =~ m/[Dd]/i) {$path_mtlp="/engbackup/d/$mid_path/";}
elsif ($file_number =~ m/[Ss]/i) {$path_mtlp="/engbackup/s/";} 

#______________________________��¼

$ftp = Net::FTP->new("192.168.0.8",Debug => 0) or die "$@", $info='Cannot connect to 192.168.0.8';
$ftp->login($use_name,$pass_code)              or die "$@", $info=$ftp->message;
if ($info) {return $info;}

#������������������������������������������������������������

$ftp->login("szenghw","hwmtleng9")             or die "$@", $info=$ftp->message;	
$ftp->cwd($path_mtlp) or die "$!"; 
$ftp->rmdir($file_number,[1]) or die "$@",$info=decode('cp936',"��������û���ҵ� $file_number �����Ѿ�ɾ�������飡"),$ftp->message;
$ftp->quit;	

$info="ף����!  $file_number ɾ���ɹ�!";
$info=decode('cp936',$info);

}
