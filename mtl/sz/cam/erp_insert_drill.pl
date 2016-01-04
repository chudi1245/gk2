#!/usr/bin/perl
use strict;
use Tk;
use warnings;
use DBD::ODBC;
use Encode;
use Genesis;
use Win32;
use Tk::BrowseEntry;
use Tk::Pane;
use File::Basename;
use FBI;

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

###____________________________
my ($mw,$column,$row,$select_file,$error_info,@text,$sum_drill_number,$pass_code, $wid)=(undef,0,0);
##$pass_code=407000;
my ($GoodsCode,$WorkCenterCode,@ParaType,@ParaQty1,@Tolerance,@CutleDia,@CutleDiaf,@ParaQty,@Unthread,@NPTH,@Memo)=(undef,undef,);
use encoding "utf8";
my @label=qw{档案号 钻孔类型 刀具号 成品孔径 公差 刀具孔径 孔数 钻槽 NPTH 备注};
my $hackneyed='Ctrl+C复制   钻槽   连孔   压接孔  引孔  喷锡孔  定位孔  切片孔  靶孔';
my @tol_list=qw(±  ±0.05  ±0.05  ±0.08  ±0.1  ±0.15  ±0.2) ;
no encoding "utf8";


my ($datebase, $Server);
$Server='192.168.10.2';
$datebase='mtlerp-running';

my $DSN = qq{driver={SQL Server};Server=$Server; database=$datebase;uid=sa;pwd=719799;};
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";


####____________________________tk主界面。
kysy();

my $frame=MainWindow->new; $frame->title("Better and better!"); $frame->geometry("+200+100"); $frame->withdraw;
$select_file =$frame->getOpenFile(-initialdir=>"D:/work/output",-filetypes=> [['GIF Files', '.drl',],['All Files', '*',]] );
$select_file=encode('gbk',$select_file);

my ($jobfile,$drl_file,@filepath);
$jobfile = $select_file;
$jobfile =~ s/[\/\\]/ /ig; 
@filepath=split m{ },$jobfile;
$drl_file = $filepath[$#filepath];
$drl_file =~ s/(.drl)$//ig;
##$f->PAUSE($drl_file);
if ( not($drl_file =~ m/$JOB/ig)) {
	p__("The job is error");
	exit;
}
$drl_file =~ s/$JOB/drl/ig;

$f->INFO(units => 'mm',entity_type => 'layer',entity_path => "$JOB/pcb/$drl_file");
my @drill_size   = @{$f->{doinfo}{gTOOLdrill_size}};
my @finish_size  = @{$f->{doinfo}{gTOOLfinish_size}};
my @drill_type   = @{$f->{doinfo}{gTOOLtype}};
my @drill_shape  = @{$f->{doinfo}{gTOOLshape}};

my %finish;

foreach  (0..$#drill_size) {	
	$finish{$drill_size[$_]}[0] = $finish_size[$_];
	$finish{$drill_size[$_]}[1] = $drill_type[$_];
	$finish{$drill_size[$_]}[2] = $drill_shape[$_];
}

@text=distill_head($select_file);
($GoodsCode,$WorkCenterCode)=distill_goodscode_workcentercode($select_file);
$frame->deiconify;
my $height=($#text+2)*22;  
$height=600 if $height > 600;
$mw=$frame->Scrolled("Frame", -scrollbars => 'w',-height=>$height )->grid(-column=>0, -row=>0,-columnspan=>20);

foreach  (0..$#label) {  
	if ($_ == 4) {
		$mw->Button(-text=>$label[$_],-width=>10,-command=>\&count_tol,)->grid(-column=>$column++, -row=>$row) 
	}else{
	    $mw->Label(-text=>$label[$_],-width=>10,-relief=>'g',)->grid(-column=>$column++, -row=>$row) ;
	}
}

foreach  (0..$#text) {
	next unless $text[$_];
	$text[$_] =~ s/[\\\/c]/ /ig;   
	my @word=split m{ },$text[$_];
	$word[1]/=1000;
	$mw->Label(-text=>$GoodsCode,-width=>10,-relief=>'g',)->grid(-column=>0, -row=>$_+1);      ##job
	$mw->Label(-text=>$WorkCenterCode,-width=>10,-relief=>'g',)->grid(-column=>1, -row=>$_+1); ##drill_1 or drill_2
	$ParaType[$_]=$word[0];
	$mw->Label(-textvariable=>\$ParaType[$_],-width=>10,-relief=>'g',)->grid(-column=>2, -row=>$_+1);   ## T01 T02
	$wid->[3][$_+1]=$mw->Entry(-textvariable=>\$ParaQty1[$_],-width=>10,-relief=>'g',)->grid(-column=>3, -row=>$_+1);   ##finish size
	$Tolerance[$_]=$tol_list[0];
	$wid->[4][$_+1]=$mw->BrowseEntry(-textvariable=>\$Tolerance[$_],-width=>8,-choices=>\@tol_list,)->grid(-column=>4, -row=>$_+1);   ##Tolerance
	##钻孔尺寸。
	$CutleDia[$_]=$word[1];
	if ($CutleDia[$_] ==3.175 or $CutleDia[$_] ==3.176  ) {
		$CutleDia[$_]=3.175;

		$CutleDiaf[$_]=3.175;

	}else{
		$CutleDiaf[$_] = $CutleDia[$_];
		$CutleDia[$_] = sprintf"%.2f",$CutleDia[$_];
		$CutleDia[$_] =~ s!(\.\d\d)[123]!$1!;
		$CutleDia[$_] =~ s!(\.\d)[123]!${1}0!;
		$CutleDia[$_] =~ s!(\.\d)[678]!${1}5!;	
	}

	$mw->Label(-textvariable=>\$CutleDia[$_],-width=>10,-relief=>'g',)->grid(-column=>5, -row=>$_+1);    ##tool size
	$ParaQty[$_]=$word[2];
	$wid->[6][$_+1]=$mw->Entry(-textvariable=>\$ParaQty[$_],-width=>10,-relief=>'g',)->grid(-column=>6, -row=>$_+1);     ##number of drill
	$mw->Checkbutton(-variable=>\$Unthread[$_],-width=>6,-relief=>'g',)->grid(-column=>7, -row=>$_+1);   ##slot
	$mw->Checkbutton(-variable=>\$NPTH[$_],-width=>6,-relief=>'g',)->grid(-column=>8, -row=>$_+1);       ##npth
	$wid->[9][$_+1]=$mw->Entry(-textvariable=>\$Memo[$_],-width=>25,-relief=>'g',)->grid(-column=>9, -row=>$_+1);        ##Memo
}
$frame->Entry(-text=>$hackneyed,-relief=>'g',)->grid(-column=>0, -row=>1,-columnspan=>20,-sticky=>'we'); 

$frame->Label(-textvariable=>\$error_info,-relief=>'g',)->grid(-column=>0,-columnspan=>20, -row=>2,-sticky=>'we'); 
$frame->Button(-textvariable=>\$sum_drill_number,-width=>10,-relief=>'g',-command=>\&sum_drill_number)->grid(-column=>0, -row=>3);
$frame->Label(-text=>"USR CODE",-width=>10,)->grid(-column=>1, -row=>3,-sticky=>'w');
$frame->Entry(-text=>\$pass_code,-width=>10,)->grid(-column=>2, -row=>3,-sticky=>'w');
$frame->Button(-text=>'Same_Tol',-width=>15,-command=>\&drl_def_tol)->grid(-column=>4, -row=>3,-sticky=>'e');
$frame->Button(-text=>'Finish_Size',-width=>15,-command=>\&drl_finish)->grid(-column=>5, -row=>3,-sticky=>'e');
$frame->Button(-text=>'Slot_INFO', -width=>15,-command=>\&slot_info  )->grid(-column=>6, -row=>3,-sticky=>'e');
$frame->Button(-text=>'OK',-width=>15,-command=>\&apply)->grid(-column=>19, -row=>3,-sticky=>'e');

sum_drill_number();
$frame->bind('<Down>'=>[\&focus, 'down'] );
$frame->bind('<Up>'=>[\&focus, 'up']);

MainLoop;
####______________________________________

sub drl_def_tol{

foreach  (0..$#ParaType){
	my ($size,$npth,$slot)=($ParaQty1[$_],  $NPTH[$_],$Unthread[$_]);
	if ($CutleDia[$_] == 3.175) {
		$Tolerance[$_]=$tol_list[5]; 
	}elsif($slot) {
		$Tolerance[$_]=$tol_list[4]; 
	}elsif(!$slot and $npth ){
		$Tolerance[$_]=$tol_list[2];
	}else{
        $Tolerance[$_]= $tol_list[3];
	}
}

}

######___________________###$f->PAUSE($str);
sub drl_finish{

	#foreach  (0..$#CutleDiaf){
	#	p__($CutleDiaf[$_]);
	#}

	foreach  (0..$#CutleDia){
		if ($CutleDia[$_] == 3.175) {
			$ParaQty1[$_] =3.15;
		}else{
			my $size =  $CutleDiaf[$_] * 1000 ;	
			if ($finish{$size}) {
				$ParaQty1[$_] = sprintf "%.2f", ($finish{$size}[0]/1000);
			
				if ($finish{$size}[1] eq "non_plated") {
					$NPTH[$_] = 1;
				}	
				if ($finish{$size}[2] eq "slot") {
					$Unthread[$_] = 1;
					#	$ParaQty[$_] = 1 ;
				}
			}else{
			    $ParaQty1[$_] = sprintf "%.2f", ($CutleDia[$_]); 
			}		
   }
 #  p__($CutleDia[$_],$ParaQty1[$_]);
}
}

sub apply { 
	if ( usr_pass($pass_code) ){return};
	if ( check_error() ){return};
	del_old_data($GoodsCode,$WorkCenterCode);
	
	foreach  (0..$#ParaType) {
		my $ParaType=$ParaType[$_];
		my $ParaQty1=$ParaQty1[$_]||0;
		my $Tolerance=$Tolerance[$_];  
		my $CutleDia=$CutleDia[$_];
		my $ParaQty=$ParaQty[$_];
		my $Unthread=$Unthread[$_]||0;
		my $NPTH=$NPTH[$_]||0;
		my $Memo=$Memo[$_]||'';
	
		my $sql=qq\insert into TBGoodsPara 
		  (GoodsCode,WorkCenterCode,ParaType,ParaQty1,Tolerance,CutleDia,ParaQty,Unthread,NPTH,Memo) values 
		  ('$GoodsCode','$WorkCenterCode','$ParaType',$ParaQty1,'$Tolerance',$CutleDia,$ParaQty,$Unthread,$NPTH,'$Memo')\; 
		$sql=encode('gb2312',$sql);
		dbi_course($sql,$pass_code);
	}
	
	$dbh->disconnect;
	exit 1;
}####

sub del_old_data {
	my $name=shift;
	my $wxx=shift;
	exit unless $name;
	if ($name) {
        my $sql=qq{delete from TBGoodsPara where goodscode='$name' and WorkCenterCode='$wxx'};  ##删除
		dbi_course($sql,$pass_code);
	}
}###

sub distill_head {
	my ($file,@line)=shift;
	exit unless $file;
	open (FH,$file) or die $!;
	while (<FH>) {   chomp $_;     last if m{^\%$};	  if ( m{^T\d\dC}i ) { push @line,$_; };      }
	close FH;
	return @line;
}

sub distill_goodscode_workcentercode {
	my ($name,$goodscode,$workcentercode)=shift;
	fileparse_set_fstype('MSWin32');
	$name=fileparse($name,'.drl');

	if    ( $name =~ m{[-_]2$} ){ $workcentercode='W36';
	}elsif( $name =~ m{[-_]d}i ){ $workcentercode='W15';
	}elsif( $name =~ m{[-_]g}i ){ $workcentercode='W03';
	}else                       { $workcentercode='W22';
	}

	$goodscode=$name;
	$goodscode =~ s/\.drl//i;
	$goodscode =~ s/[-_][d2]$//;

	unless ( $goodscode =~ m/^[msd]\d{3,5}[-_]*[\dg]*$/i  ) {print "$goodscode cant regex goodscode"; exit };
	return ($goodscode,$workcentercode);
}###

sub check_error {
	foreach  (0..$#ParaQty1) {
		my $result=check_finish_drill_size($ParaQty1[$_],$CutleDia[$_],$Tolerance[$_],$_);
		if ($result) {$error_info=$result; return 1};
		unless ( $ParaQty1[$_]) { $error_info="$_ finish_size error " ; return 1};
		unless ( $ParaQty1[$_] =~ m{^[\.0123456789]+$}  ) { $error_info="$_ finish_size only numeral " ; return 1};
		if ($Tolerance[$_] eq $tol_list[0] or ! $Tolerance[$_]) { $error_info="$_ tolence error " ; return 1};
		if ($ParaQty[$_] <= 0) { $error_info="$_  drill number error " ; return 1};
	}
	return 0;
}

sub sum_drill_number{
	my $all;
	map {$all+=$_}@ParaQty;
	$sum_drill_number=$all;
}

sub usr_pass {
	my $code = shift;
	my ($v1, $v2, $v3, $v4, $v5, $v6);
	my ($output,$creturn);
	my $sth1 = $dbh->prepare ("{? = call PCheckEmployeeCodeValidate(?,?,?,?,?,?) }");
	
	$sth1->bind_param_inout(1, \$output, 1);
	$sth1->bind_param(2, $code);
	$sth1->bind_param_inout(3, \$v1, 1);
	$sth1->bind_param_inout(4, \$v2, 1);
	$sth1->bind_param_inout(5, \$v3, 1);
	$sth1->bind_param_inout(6, \$v4, 1);
	$sth1->bind_param_inout(7, \$creturn, 500);
	$sth1->execute();
	$error_info=decode('gbk',$creturn);
}

sub dbi_course {
	my $sql =shift;
	my $code=shift;
        my $output;
        my $creturn;
	
	my $sth = $dbh->prepare ("{? = call PCheckGnsUpdateSql(?,?,?) }");
	$sth->bind_param_inout(1, \$output, 1);
	$sth->bind_param(2, $code);
	$sth->bind_param(3, $sql);
	$sth->bind_param_inout(4, \$creturn, 100);
	$sth->execute();

	return $creturn;
}

sub focus {
	shift;
	my $id=shift;
	my $who=$frame->focusCurrent;
	my %info=$who->gridInfo();
	my $column=$info{-column};
	my $row=$info{-row};
	if ($id eq 'down') {
		if (  $wid->[$column][$row+1] ) {  $wid->[$column][$row+1] -> focus; print "ok"}
	}elsif($id eq 'up') {
		if (  $wid->[$column][$row-1] ) {  $wid->[$column][$row-1] -> focus; print "ok"}
	}
	return;
}

sub count_tol {
	foreach  (0..$#ParaType){
		my ($size,$npth)=($ParaQty1[$_],  $NPTH[$_]);
		if ($npth) {
			($size > 1.6)                 ? ( $Tolerance[$_]=$tol_list[4] ) :
			($size > 0.8 and $size <=1.6) ? ( $Tolerance[$_]=$tol_list[3] ) :
			($size > 0   and $size <=0.8) ? ( $Tolerance[$_]=$tol_list[2] ) :
		( $Tolerance[$_]=$tol_list[0] );
			
		}else{
			($size > 1.6)                 ? ( $Tolerance[$_]=$tol_list[5] ) :
			($size > 0.8 and $size <=1.6) ? ( $Tolerance[$_]=$tol_list[4] ) :
			($size > 0   and $size <=0.8) ? ( $Tolerance[$_]=$tol_list[3] ) :
		($Tolerance[$_]=$tol_list[0] );	
		}
	}
}
##end sub

sub check_finish_drill_size{
	my ($finish,$tool,$tolence,$flage)=@_;
	#$tolence=encode('cp936', $tolence);
	#my $match=encode('cp936',$tol_list[0]);  ##  ±
	if ($finish > $tool or $finish < $tool-0.2) {
		return "$flage finish size error";
	}
}

##统计槽孔信息
sub slot_info{
	##反转钻孔层到drlslot
	$f->COM('units', type => 'mm');
	$f->COM('display_layer', name => 'drl', display => 'yes', number => 1);
	$f->COM('work_layer', name => 'drl');
	$f->COM('flatten_layer', source_layer => 'drl', target_layer => 'drlslot');
	$f->COM('display_layer', name => 'drl', display => 'no', number => 1);
	$f->COM('display_layer', name => 'drlslot', display => 'yes', number => 1);
	$f->COM('work_layer', name => 'drlslot');
	
	##删除普通孔，保留slot孔（线条）
	$f->COM('filter_set', filter_name  => 'popup', update_popup => 'no',feat_types   => 'pad;surface;arc;text');
	$f->COM('filter_area_strt');
	$f->COM('filter_area_end', layer=> '',
                         filter_name    => 'popup',
                         operation      => 'select',
                         area_type      => 'none',
                         inside_area    => 'no',
                         intersect_area => 'no',
                         lines_only     => 'no',
                         ovals_only     => 'no',
                         min_len        => 0,
                         max_len        => 0,
                         min_angle      => 0,
                         max_angle      => 0);

	$f->COM('filter_reset', filter_name => 'popup');

	#p__("Hi,How are you!,i'm first");
	if (get_select_count) {
		$f->COM('sel_delete');
	}
	##删除档案号孔。
	$f->COM('filter_set', filter_name  => 'popup',update_popup => 'no',include_syms => 'r702');
	$f->COM('filter_area_strt');
	$f->COM('filter_area_end', layer          => '',
                         filter_name    => 'popup',
                         operation      => 'select',
                         area_type      => 'none',
                         inside_area    => 'no',
                         intersect_area => 'no',
                         lines_only     => 'no',
                         ovals_only     => 'no',
                         min_len        => 0,
                         max_len        => 0,
                         min_angle      => 0,
                         max_angle      => 0);
	$f->COM('filter_reset', filter_name => 'popup');

	#p__("Hi,How are you!i'm second");
	if (get_select_count) {
		$f->COM('sel_delete');
	}

	#输出槽孔info信息
	$f->COM('info',  out_file => 'C:/tmp/slot_info',units=> 'mm',args => " -t layer -e $JOB/pnl/drlslot -m display -d SLOT_HIST",);

	my %slot_info;
	my ($width,$b,$long,$size,$str,$key,$value,$count);
	open (FILES, "C://tmp//slot_info");
	my @slotlist=<FILES>;
	close(FILES);

	foreach my $slot (@slotlist){
		($width,$b,undef,$count) = split(' ',$slot);	
		$width =~ s/r//; $width=sprintf "%4.2f",$width/1000;  
		$long=sprintf "%4.2f" ,($width + $b);
		$size = "$width"."x"."$long";
		
		if ( exists $slot_info{$size} ) { 
			$slot_info{$size} = $slot_info{$size} + $count; 
		}else{
			$slot_info{$size}=$count;
		}
	}

	foreach my $key (sort keys %slot_info) { 
		$str="$str"."$key->$slot_info{$key}: " 
	}
	##显示槽孔信息
	$frame->Entry(-text=>$str,-relief=>'g',-width=>15,-font => [-size => 12],)->grid(-column=>0, -row=>4,-columnspan=>20,-sticky=>'we');
	return;
}


