#!/usr/bin/perl
use strict;
use DBD::ODBC;
####_______________________________________________________________________________________________
my $v='2.4';
update($v, '192.168.0.2',  'mtlerp-running');
update($v, '192.168.10.2', 'mtlcs-running');

sub update {
	my ($new_version,$Server,$database)=@_;
	my $DSN = qq{driver={SQL Server};Server=$Server; database=$database;uid=sa;pwd=719799;};
	my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";
	my $sql=qq\select DataValue from  TSSystemSet WHERE systemsetcode='GnsVersion'\;  
	my $sth=$dbh->prepare($sql);
	$sth->execute();
	my $old_version= $sth->fetchrow; 
	my $sql=qq{update TSSystemSet set DataValue=$new_version  WHERE   systemsetcode='GnsVersion'};    ###¸üÐÂ°æ±¾ 
	my $sth=$dbh->prepare($sql);
	$sth->execute();
	my $sql=qq\select DataValue from  TSSystemSet WHERE systemsetcode='GnsVersion'\ ;  
	my $sth=$dbh->prepare($sql);
	$sth->execute();
	my $new_version= $sth->fetchrow; 
	print "$database   $old_version ==> $new_version\n";
}









