#!/usr/bin/perl
#use strict;
use Net::FTP;
use DBD::ODBC;
use File::Path; 

my ($info,$schedule,$local_version,$server_version,)=();
my $down_path="d:/xxx/camp/exe";
my $version_file="C:/genesis/e92/nt/script_version";
####_____________________________________________________get local version

kysy();
##read local version
if (-e $version_file) {
	my $state=open (FH, $version_file);
    if ($state){
		chomp( $local_version=<FH> );
		close FH;
	}
}
print "Local_version     $local_version\n";
###________________________________________________________get sever version
my $datebase;
my $Server;
my $user = mzb;
my $password = mzb147258;

if ($ENV{USERDNSDOMAIN}  =~ m/mtlpcb/i) {
	$Server='192.168.0.2';
	$datebase='mtlerp-running';
	$host_name='192.168.0.8';

}elsif($ENV{USERDNSDOMAIN}  =~ m/mtlcs/i){
	$Server='192.168.10.2';
	$datebase='mtlcs-running';
	$host_name='192.168.10.8';

}
my $DSN = qq{driver={SQL Server};Server=$Server; database=$datebase;uid=sa;pwd=719799;};
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";
my $sql=qq{select DataValue from  TSSystemSet  WHERE SystemSetCode = 'GnsVersion'} ;  
my $sth=$dbh->prepare($sql);
$sth->execute();
$server_version= $sth->fetchrow; 
print "Server_version    $server_version\n";

exit if ($server_version == $local_version);
######_________________________________________________________________________download file
print "file update , please dont exit\n";
if (not -d $down_path) { mkpath($down_path ) or die $!; }
chdir $down_path or die $!;

my $ftp = Net::FTP->new($host_name, Debug => 0) or die "$@" ;
$ftp->login("$user","$password")               or die "$@", $ftp->message;
$ftp->binary()                                 or die "$@", $ftp->message;;
$ftp->get("/engscript/exe/unrar.exe")          or die "$@", $ftp->message;
$ftp->get("/engscript/exe/exe.rar")            or die "$@", $ftp->message;
$ftp->quit                                     or die "$@", $ftp->message;
###__________________________________________________________________________install 
system ( "$down_path/unrar",  'e',   '-o+',   "$down_path/exe.rar",  $down_path) or warn $!;
print "unrar exe.rar ok\n";
sleep 3;

foreach my $i  (qw\ install_exe.exe install_drill.exe install_lyr_rule.exe install_symbols.exe install_233_whells.exe  install_drill_add_M48.exe  install_adm.exe\) {
	system("$i",) or warn "$i $!";
	print "unrar $i ok \n";
}
####_______________________________________________ rewrite local version
open (FH_w, ">", $version_file) or die $!; 
print FH_w $server_version;  
close FH_w;
print "rewrite version ok\n";
print "script  update ok \n";

sleep 3;
exit;

###_______________________________












###————————————————————————————————————————————————————————————————————————————————————

=head

