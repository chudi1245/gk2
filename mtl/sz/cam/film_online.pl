#!/usr/bin/perl
## Author: melody
## Email: 190170444@qq.com
## Date:  2011.09.15
## Phone: 13424338595
## Describe:  filmonline erp  approve
##_________________________________
use strict;
use DBD::ODBC;
use Encode;
use Win32;
use M_SQL;
##____________
my ($new_date,$old_date,$view_content);  ##数据结构
my $button_count=0;
my ($row,$column)=(0,0);
##eng 14286  qae 79584
kysy();

my ($use,$password,$file_number,$dpt,$china_name,$employ_code,@pass_info)=(undef,undef,undef,undef);
##$file_number='m40158';
my $DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;';
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";

my $mw=MainWindow->new;   
$mw->title("Better and better");    
$mw->geometry("+200+30");
top_use_pass();
$mw->withdraw;

$mw->title($china_name);
my %title=(
	fn_entry         =>['Entry',   0,  1,  '-textvariable', \$file_number,],
	fn_button        =>['Button',  1,  1,  '-text', '档案号查询',],
	inner            =>['Button',  0,  2,  '-text', '内层',],
	outer            =>['Button',  1,  2,  '-text', '外层',],
	solder           =>['Button',  2,  2,  '-text', '阻焊',],
	silk             =>['Button',  3,  2,  '-text', '字符',],
	film_all         =>['Button',  4,  2,  '-text', 'ALL',],
	id               =>['Label',   0,  4,  '-text', 'ID',],
	film_fn          =>['Label',   1,  4,  '-text', '档案号',],
	film_name        =>['Label',   2,  4,  '-text', '名称',],
	film_type        =>['Label',   3,  4,  '-text', '类型',],
	film_check       =>['Label',   4,  4,  '-text', '选择',],
	film_beizhu      =>['Label',   5,  4,  '-text', '备注：保存',],
	apply            =>['Button',  7,  4,  '-text', '审批',],
);

my $widget={};
foreach  (sort keys %title) { 
	my ($wid_type, $text_type)=($title{$_}[0], $title{$_}[3]);
	if (not ref $title{$_}[4]) { $title{$_}[4]=decode('utf8',$title{$_}[4]); }
	$widget->{$_}=$mw->$wid_type($text_type=>$title{$_}[4],-width=>10,)->grid(-column=>$title{$_}[1], -row=>$title{$_}[2]);
};
$widget->{fn_entry}->focus;
$widget->{fn_button}->configure(-command=>\&fn_select);
$widget->{apply}->configure(-command=>\&apply);
foreach  (qw\inner outer solder silk film_all\) {
	$widget->{$_}->configure(-command=>[  \&set_type, $title{$_}->[4]  ]);
}

####fn_select();
MainLoop;
exit;


sub fn_select {

	undis_date($old_date);
	$new_date={}; 
    my $sql=qq(select id ,GoodsCode, FilmName, Filmtype , Memo from VPFilmOnline  where (DepartmenCode='$dpt')
		      and (GoodsCode like '%$file_number%')  order by Outputdate, PintoDate);
    my $sth = $dbh->prepare($sql);
	$sth->execute();
	while (my @arr=$sth->fetchrow_array() ) {
		$new_date->{$arr[0]}=[$arr[1],$arr[2],$arr[3],undef,  decode('gb2312', $arr[4])];  
	};

	dis_date($new_date);
	$old_date=$new_date;  ## store date
	return;
}

sub apply {
my @id=sort keys %{$new_date};
my $result=check_error(@id);
if ($result) {
	$mw->title(   decode('utf8',$result)  );
	return;
}

foreach  (0..$#id) {
	my @rec;
	##if checkbutton ture,
	if ($new_date->{$id[$_]}[3]) {
		##if memo , delet memo and shenpi
		if ($new_date->{$id[$_]}[4]) {
			my $sql=qq{ UPDATE TPFilmOnline set Memo = ''  where ID = '$id[$_]' };
			my $sth = $dbh->prepare($sql);
			$sql=encode('gb2312',$sql);
			$sth->execute();
		}
		## shen pi print "$id[$_],  $employ_code,  $dpt,  '0552',   \n";
		@rec=M_SQL::film_online($id[$_],  $employ_code,  $dpt,  '0552',  $dbh );
		if ( $rec[5] ) {
			$mw->title(   decode('cp936',$rec[5])  );
			return;
	    }
	}else{
		##checkbutton false, if memo ,save
		if ($new_date->{$id[$_]}[4]) {

			my $memo=encode('gb2312', $new_date->{$id[$_]}[4]);
			##my $memo=$new_date->{$id[$_]}[4];
			my $sql=qq{ UPDATE TPFilmOnline set Memo = '$memo' where ID = '$id[$_]' };
			my $sth = $dbh->prepare($sql);
			$sql=encode('gb2312',$sql);
			$sth->execute();
			##update memo  save
		}
	}
}

##rush date
fn_select();
}   ##end apply

sub dis_date {
	my $date=shift;
	my @id=sort keys %{$date};
	my $row=10;
	foreach  (0..$#id) {
		$view_content->{id}{$_}=$mw->Label(-text=>$id[$_],-relief=>'sun',-width=>10)->grid( -column=>0, -row=>$row+$_ );
		$view_content->{fn}{$_}=$mw->Label( -text=>$date->{$id[$_]}[0],-relief=>'sun' ,-width=>10)->grid( -column=>1, -row=>$row+$_);
		$view_content->{name}{$_}=$mw->Label( -text=>$date->{$id[$_]}[1],-relief=>'sun',-width=>10 )->grid( -column=>2, -row=>$row+$_);
		$view_content->{type}{$_}=$mw->Label( -text=>decode('cp936', $date->{$id[$_]}[2]),-relief=>'sun',-width=>10 )->grid( -column=>3, -row=>$row+$_);
		$view_content->{check}{$_}=$mw->Checkbutton( -variable=>\$date->{$id[$_]}[3] )->grid( -column=>4, -row=>$row+$_);
		$view_content->{memo}{$_}=$mw->Entry( -textvariable=>\$date->{$id[$_]}[4] )->grid( -column=>5, -row=>$row+$_);
	}
}

sub undis_date{
	my $date=shift;
	my @id=sort keys %{$date};
	foreach  (0..$#id) {
		 $view_content->{id}{$_}   ->destroy;
		 $view_content->{fn}{$_}   ->destroy;
		 $view_content->{name}{$_} ->destroy;
		 $view_content->{type}{$_} ->destroy;
		 $view_content->{check}{$_}->destroy;
		 $view_content->{memo}{$_} ->destroy;
	}
}

sub set_type{
my @id=sort keys %{$new_date};
my $type=shift;
$type=encode('cp936',$type);
$button_count=not $button_count;
foreach  (0..$#id) {
	if ($type eq 'ALL') {
		$new_date->{$id[$_]}[3]=$button_count;
	}else{
		if ($new_date->{$id[$_]}[2]  eq  $type ) {
			$new_date->{$id[$_]}[3]=1;
		}else{
			##$new_date->{$id[$_]}[3]=0;
		}
	}
}
}##set type

sub top_use_pass{
my $tl = $mw->Toplevel( );
$tl->geometry("+200+30");  $tl->title( decode('utf8', '请输入过卡账号') );
$tl->Entry(-textvariable=>\$use,-show=>'*')->pack->focus;
$tl->Button(-text=>decode('utf8','登录',) , -width=>40,-command=>
sub { 
	##@rec=( flage , use&password, use::id, $employ_code, use::china_name, department  , return );
	my (@rec)= M_SQL::usr_pass($use, $dbh);
	if($rec[5] =~  m/Q04/i){
		my $sql= qq{select top 1 goodscode from tbeng where qaejdman='$rec[3]' and billstate in ('86') order by id desc};
		my $sth=$dbh->prepare($sql);
		$sth->execute();
		my ($fn)=$sth->fetchrow_array();
		if ($fn) {
			$file_number=$fn;
		}
	}

	if (not $rec[6]) {
		$tl->withdraw;
		$mw->title(  decode('utf8','欢迎你 --').decode('cp936', $rec[4])  );
		$mw->deiconify;
		$employ_code=  $rec[3];
		$dpt=$rec[5];
	}else{
		$tl->title(   decode('cp936', $rec[6])   );
	}
}
)->pack;

$tl->protocol('WM_DELETE_WINDOW', \&onclose);
}##end top use pass

sub onclose {
	exit;
}

sub check_error {
my @id=@_;
foreach  (0..$#id) {
	if (    ($new_date->{$id[$_]}[3]  and  $new_date->{$id[$_]}[4])  
		    or (!$new_date->{$id[$_]}[3]  and  !$new_date->{$id[$_]}[4])    ){
		return "$new_date->{$id[$_]}[1] 错误，请选择审批或者填写异常原因";
	}
}
}





















=head





















	ALTER PROCEDURE [dbo].[PPFilmOnline] 
		id				           	int,                      
		@LoginUserEmployeeCode   	varchar(30),                
		工号	                    varchar(8),
		0552				        varchar(6),
		@cReturn					varchar(100)  OUTPUT


$mw->withdraw;
$mw->deiconify;

    my ($v1,$v2,$v3,$v4,$v5,$v6,$v7); ##( flage , use&password, use::id, use, use::china_name, department  , return );
	my $v2=$passcode;
    my $sth = $oop->prepare ("{? = call PCheckEmployeeCodeValidate(?,?,?,?,?,?) }");
    $sth->bind_param_inout(1, \$v1, 1);
    $sth->bind_param      (2, $v2    );
    $sth->bind_param_inout(3, \$v3, 20);
    $sth->bind_param_inout(4, \$v4, 20);
    $sth->bind_param_inout(5, \$v5, 20);
    $sth->bind_param_inout(6, \$v6, 20);
    $sth->bind_param_inout(7, \$v7, 200);
    $sth->execute();
	return ($v1,$v2,$v3,$v4,$v5,$v6,$v7);

select * from VPFilmOnline  where FilmState = '20' and BillState = '20'  and (GoodsCode='m30777')  order by Outputdate, PintoDate
select * from VPFilmOnline where FilmState =  '20' and BillState = '20'  order by Outputdate, PintoDate


our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###________________________
my( $count_button,$pass_code,$error_info,%hash,%wid,$DSN,$dbh)=(0,);
use encoding "utf8";
my @title_cn=([ '-',    2  ],['档案号',11 ],['菲林',  12 ], ['＋↑',   3  ],  ['＋↓',   3  ],  ['―↑',    3  ],  
              ['―↓',    3  ],['＋↑',   3  ],['＋↓',   3  ], ['―↑',    3  ],  ['―↓',    3  ],  ['更改',  10 ],);
no encoding "utf8";
###_________________________________________________________________________
kysy();
my @gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
my @gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
my @gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
my @gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};
my @gROWfoil_side =@{info("matrix","$JOB/matrix","row")->{gROWfoil_side}};
###$DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;';
$DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtltest;uid=sa;pwd=719799;';
$dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";
###____________________________________________________________________________________________________
my $mw=MainWindow->new;   $mw->title("Better and better QQ190170444");    $mw->geometry("+200+100");
foreach (0..$#title_cn) { $mw->Button(-text=>$title_cn[$_]->[0],-width=>$title_cn[$_]->[1],-command=>[\&set_all,$_] )->grid(-column=>$_,-row=>0,) };
my $t = $mw->Scrolled("Text",-width=>64, -height=>45, -wrap => 'none',-bg=>'#999999')->grid(-column=>0,-row=>1,-columnspan=>13,);

foreach  (0..$#gROWname ) {
	my $key=$gROWname[$_];
	next unless $key;
    $hash{$key}[0]=$JOB;
	my $w= $t->Entry(-width=>12, -textvariable=>\$hash{$key}[0]   );  ###[]  goodscode [0]
    $t->windowCreate('end', -window => $w);
    $hash{$key}[1]=$gROWname[$_];
	$wid{name}{$key}= $t->Button(-width=>12, -textvariable =>\$hash{$key}[1],-command=>[\&set_name,$key], -bg=>'#00d900'  );  ###film_name[1]
    $t->windowCreate('end', -window => $wid{name}{$key});
    foreach (1..4){
		my $color;
		($_ > 2)?($color='#999999'):($color='#666666');
	    $w=$t->Radiobutton(-variable => \$hash{$key}[2],-value => $_,-relief=>'g',-bg=>$color,-activebackground=>$color);  ##black [2]
	    $t->windowCreate('end',-window=>$w);
	};
	foreach (1..4) {
		my $color;
		($_ < 3)?($color='#606000'):($color='#999900');
        my $w=$t->Radiobutton(-variable => \$hash{$key}[3],-value => $_, -bg=>$color,-activebackground=>$color,-relief=>'g',);##browen [3]
	    $t->windowCreate('end', -window => $w);
	}
	my $w= $t->Checkbutton(-width=>5, -variable => \$hash{$key}[4]   );  ###chang [4]
    $t->windowCreate('end', -window => $w);
    $t->insert('end', "\n");
}
$t->configure(-state => 'disabled'); 
$mw->Label(-textvariable=>\$error_info,  -width=>70, -relief=>'g',)->grid(-column=>0,-row=>2,-columnspan=>12,);
$mw->Entry(-textvariable=>\$pass_code,  -width=>15, -relief=>'g',)->grid(-column=>0,-row=>3,-columnspan=>2,);
$mw->Button(-text=>'Brush', -width=>6, -relief=>'g',-command=>\&brush)->grid(-column=>6,-row=>3,-columnspan=>2,);
$mw->Button(-text=>'Defualt', -width=>6, -relief=>'g',-command=>\&defualt)->grid(-column=>8,-row=>3,-columnspan=>2,);
$mw->Button(-text=>'Apply', -width=>10, -relief=>'g',-command=>\&apply)->grid(-column=>10,-row=>3,-columnspan=>2,);
defualt();
MainLoop;
sub set_name{
	my $key=shift;
	if ($wid{name}{$key}->cget(-bg) eq  '#00d900' ) {
		$wid{name}{$key}->configure(-bg=>'#777777');
		$hash{$key}[2]=0;
		$hash{$key}[3]=0;
	}else{
	    $wid{name}{$key}->configure(-bg=>'#00d900')
	};
}

sub set_all{
	my $id=shift;
	$count_button = not $count_button;
	if ($id == 11) {  foreach (0..$#gROWname){ $hash{$gROWname[$_]}[4] =$count_button};  }
}

sub apply {
    if ( $error_info=M_SQL::usr_pass($pass_code,$dbh) ){ $error_info=decode('gbk',$error_info);  return;} ;
    if ( $error_info=check_error() ){ return; };
    if ( $error_info=del_old() ) {return; };

foreach  (0..$#gROWname ){
	my $key=$gROWname[$_];
	next unless $key;
	next if $wid{name}{$key}->cget(-bg) ne  '#00d900';  
	my $GoodsCode=$hash{$key}[0];
    my $FilmName=$hash{$key}[1];
    $hash{$key}[2]=$hash{$key}[2]||0;
	$hash{$key}[3]=$hash{$key}[3]||0;
	my $grounp={  0=>[0,0,0,0],  1=>[1,0,0,0], 2=>[0,1,0,0], 3=>[0,0,1,0], 4=>[0,0,0,1],  };
	my ($BFilmPlusUp,$BFilmPlusDown,$BFilmToteUp,$BFilmToteDown)= @{ $grounp->{$hash{$key}[2]} };
	my ($PFilmPlusUp,$PFilmPlusDown,$PFilmToteUp,$PFilmToteDown)= @{ $grounp->{$hash{$key}[3]} };
	my $IsChange= $hash{$key}[4]||0;

	my $sql=qq\insert into TBFilmS 
(GoodsCode,FilmName,BFilmPlusUp,BFilmPlusDown,BFilmToteUp,BFilmToteDown,PFilmPlusUp,PFilmPlusDown,PFilmToteUp,PFilmToteDown,IsChange) values 
('$GoodsCode','$FilmName',$BFilmPlusUp,$BFilmPlusDown,$BFilmToteUp,$BFilmToteDown,$PFilmPlusUp,$PFilmPlusDown,$PFilmToteUp,$PFilmToteDown,$IsChange)\; 
    M_SQL::sql_process($sql,$pass_code,$dbh);
	#print ($sql,"\n");
}
exit;
}###end apply

sub check_error {
	foreach  (0..$#gROWname ){
	    my $key=$gROWname[$_];
		next unless $key;
		unless ( $hash{$key}[0] =~ m{$JOB}i ) { return "$key F/N error" }   ##chck the 
		if ($wid{name}{$key}->cget(-bg) ne  '#00d900'){ next; }
		unless ( $hash{$key}[2] ) { return "$key error" }
	}
}
sub brush{
	foreach  (0..$#gROWname ){
		my $key=$gROWname[$_];
		next unless $key;
		$wid{name}{$key}->configure(-bg=>'#00d900');
		$hash{$key}[0]=$JOB;
		$hash{$key}[2]=0;
		$hash{$key}[3]=0;
		$hash{$key}[4]=0;
	}
}

sub defualt {
foreach  (0..$#gROWname) {
	my $key=$gROWname[$_];
	next unless $key;
	if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] ne 'solder_paste' and $gROWlayer_type[$_] ne 'rout' and $gROWlayer_type[$_] ne 'drill'){
		$wid{name}{$key}->configure(-bg=>'#00d900');
		if ($gROWside[$_] ne 'inner') {###outer
			if ($gROWlayer_type[$_] eq 'silk_screen') {
				if ($key =~ m{^gt}i) {
			    	$hash{$key}[2]=1;
		    	}elsif ($key =~ m{^gb}i){
			    	$hash{$key}[2]=2;
			    }else{
				    $hash{$key}[2]=1;
			    }
			}else{
				if ($key =~ m{^gt}i) {
			    	$hash{$key}[2]=1; $hash{$key}[3]=2;
		    	}elsif ($key =~ m{^gb}i){
			    	$hash{$key}[2]=2; $hash{$key}[3]=1;
			    }else{
				    $hash{$key}[2]=1;   ##$hash{$key}[3]=2;
			   }
			}
		}else{###inner
			if ($key =~ m{^l\d\d?t}i) {
				$hash{$key}[2]=3;  $hash{$key}[3]=4;
			}elsif($key =~ m{^l\d\d?b}i){
				$hash{$key}[2]=4;  $hash{$key}[3]=3;
			}else{
				if ($gROWfoil_side[$_] eq 'top') {
					$hash{$key}[2]=3;  $hash{$key}[3]=4;
				}else{
					$hash{$key}[2]=4;  $hash{$key}[3]=3;
				}
			}
		}
			
	}else{  ##no film
	    $hash{$key}[0]=$JOB;
		$wid{name}{$key}->configure(-bg=>'#777777');
		$hash{$key}[2]=0;
		$hash{$key}[3]=0;
		$hash{$key}[4]=0;
	}
}
}##end defualt

sub del_old{
	my %del_goodsname;
	my @del_goodsname;
    foreach  (0..$#gROWname ){
    	my $key=$gROWname[$_];
    	next unless $key;
		$del_goodsname{ $hash{$key}[0] }=undef;	
	}
    map {  unless ( $_ =~ m{$JOB}i ){ return "del F/N error" }  }(keys %del_goodsname);
	foreach  (keys %del_goodsname) {
		 
		my $sql_del = qq{delete from TBFilmS  where goodscode='$_' }; 
        M_SQL::sql_process($sql_del,$pass_code,$dbh);
	}
}

=head


###___________


