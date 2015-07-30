#!/usr/bin/perl
use strict;
use Win32;
use Tk::BrowseEntry;
use DBD::ODBC;
use Encode;

kysy();

my ($day,$moth,$year)=(localtime())[3,4,5];
($day,$moth,$year)=($day,$moth+1,$year+1900);

my @sql_sentence=(
qq\<菲林待光绘>   select * from VPFilmVieW where (FilmStateName='待光绘')\,
qq\<菲林待光绘 外层 阻焊 字符> select * from VPFilmVieW where (FilmStateName='待光绘' and FilmType='外层')\,
qq\<工程下单总数> select count(*) as Total from VBEng where (EngBillDate>='${year}-${moth}-${day}' and EngBillDate<='${year}-${moth}-${day} 23:59:59' )\, 
qq\<首次制板数>   select count(*) as Total from VBEng where (EngBillDate>='${year}-${moth}-${day}' and EngBillDate<='${year}-${moth}-${day} 23:59:59' and BoardType='首次制板')\, 
qq\<复投无更改数> select count(*) as Total from VBEng where (EngBillDate>='${year}-${moth}-${day}' and EngBillDate<='${year}-${moth}-${day} 23:59:59' and BoardType='复投无更改')\, 
qq\<复投有更改数> select count(*) as Total from VBEng where (EngBillDate>='${year}-${moth}-${day}' and EngBillDate<='${year}-${moth}-${day} 23:59:59' and BoardType='复投有更改')\, 
qq\<查看钻孔表>   select * from TBGoodsPara  where goodscode='m30000'\,  
qq\<异常待光绘>   select * from VBException where (BillState='20' and HelpDepartCode='E01')\,
qq\<成品库存>     select * from VBProductionStore  where  GoodsCode='m30000'\, 
qq\<生产在线>     select * from VIwip  where GoodsCode like '%m30000%'\,
);
map {$_=decode('utf8',$_)}@sql_sentence;
my $run_sentence=$sql_sentence[0];
###______________________________________tk
my $mw=MainWindow->new;  $mw->title("Better and better");  $mw->geometry("+200+100");
$mw->BrowseEntry(-choices=>=>\@sql_sentence,-textvariable=>\$run_sentence,-width=>114,-font=>"courier 9")->grid(-column=>0, -row=>0);
$mw->Button(-text=>'Apply',-command=>\&apply,-width=>10,-font=>"courier 9")->grid(-column=>1, -row=>0);
my $t = $mw->Scrolled("Text", -width => 100, -height=>35,-wrap => 'none',-font=>"courier 11")->grid(-column=>0,-row=>1,-columnspan=>4);
###tie to text in the scrolled,easy to use prntf
my $scrolled_text=$t->{ConfigSpecs}{-background}[0];  
tie *STDOUT ,ref $scrolled_text,$scrolled_text;
MainLoop;
###______________________________________sub
sub apply{
###my $DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtltest;uid=sa;pwd=719799;';
my $DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;';
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";
##delt text
$t->delete('1.0',"end");
##tk use utf8,  sql use cp936

my $sql=$run_sentence;
##del the <note> 
$sql=~s{\<.*?\>\s*}{};   
my $sql=encode(  'cp936',$sql);
my $sth = $dbh->prepare($sql);
$sth->execute();
###get the record
my $number_of_record=0;
my $ref;
my $len_column;
while (my @arr=$sth->fetchrow_array() ) {
	$ref->[$number_of_record]=[@arr];
	my $len=$#arr;
	$len_column=$len if $len > $len_column;
	$number_of_record++;
};
###cout the max length of column
my @col_max_len;
foreach  (0..$len_column) {
	my $flag=$_;
    foreach  ( @{$ref} ) {
		my $length=length( $_->[$flag] );
		$col_max_len[$flag] =  $length if  $length > $col_max_len[$flag];
	}
}
####print the result
foreach  ( @{$ref} ) {
	my @line=@{$_};
	foreach  (0..$#line) {
		my $len_p=$col_max_len[$_]+2;
		printf( "%-${len_p}s",  decode('cp936',$line[$_])  );
	}
	print "\n";
}
print "\n_______END_______ \n";
print "Record of all $number_of_record \n";
return;
}

###end


=head
while (my @arr=$sth->fetchrow_array() ) {
	$number_of_record++;
	my @utf8=map{decode('cp936',$_)}@arr;  
	map {print $_,'# '}@utf8;
	$t->insert('end', "\n");
};



##select name from sysobjects where type='U' 


my ($table_name) = $run_sentence =~ m/\bfrom\b\s+\b(.*?)\b\s+/;
my $sql_type= qq{ select name from syscolumns where id=object_id('$table_name') };
my $sth = $dbh->prepare($sql_type);
$sth->execute();
while (my @arr=$sth->fetchrow_array() ) {
	my @utf8=map{decode('cp936',$_)}@arr;
	foreach  (@arr) {
		my $w= $t->Label(-text=>$_ ,-width=>10,-relief=>'sun');  ###state[2]
	    $t->windowCreate('end', -window => $w);
	}
	##$t->insert('end', "\n");
}
$t->insert('end', "\n");
###________________________________________________


while (my @arr=$sth->fetchrow_array() ) {
	$number_of_record++;
	my @utf8=map{decode('cp936',$_)}@arr;
	##print "@utf8 \n";
  
	foreach  (@utf8) {
		 my $w= $t->Label(-text=>$_ ,-width=>10,-relief=>'sun');  ###state[2]
		 $t->windowCreate('end', -window => $w);
	}
	$t->insert('end', "\n");

};

print "\n_______END_______ \n";
print "Record of all $number_of_record \n";
return;
}













