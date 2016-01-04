#!/usr/bin/perl
use strict;
use Tk;
use DBD::ODBC;
use M_SQL;
use Genesis;
use Win32;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$error_info,$pass_code,@cu_layer,%hash)=(0,0);
#####_____________________________________
kysy();
my @gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
my @gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
my @gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
my @gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};
my @gROWfoil_side =@{info("matrix","$JOB/matrix","row")->{gROWfoil_side}};

foreach  my $id (0..$#gROWname) {
	if ($gROWcontext[$id] eq 'board' and $gROWlayer_type[$id] =~ m{(^signal$)|(^mixed$)|(^power_ground$)}i ) {
		push @cu_layer,$gROWname[$id];
	}
}
###

my $mw=MainWindow->new;   $mw->title("Better and better QQ190170444");    $mw->geometry("+200+100");
    foreach  my $id (@cu_layer ) {
		$mw->Label(-text=>$id,-width=>10, -relief=>'sun')->grid(-column=>$column,-row=>$row++,) ;
		$mw->Entry(-textvariable=>\$hash{ent}{$id},-width=>10, )->grid(-column=>$column+1,-row=>$row-1,) ;
		$mw->Entry(-textvariable=>\$hash{ent_oz}{$id},-width=>10, )->grid(-column=>$column+2,-row=>$row-1,) ;
    }
$mw->Label(-textvariable=>\$error_info,  -width=>70, -relief=>'g',)->grid(-column=>0,-row=>$row++,-columnspan=>12,);
$mw->Entry(-textvariable=>\$pass_code,  -width=>15, -relief=>'g',)->grid(-column=>0,-row=>$row,);
$mw->Button(-text=>'Brush', -width=>6, -relief=>'g',-command=>\&brush)->grid(-column=>6,-row=>$row,);
##$mw->Button(-text=>'Defualt', -width=>6, -relief=>'g',-command=>\&defualt)->grid(-column=>8,-row=>$row,);
$mw->Button(-text=>'Apply', -width=>10, -relief=>'g',-command=>\&apply)->grid(-column=>10,-row=>$row,);

defualt();
MainLoop;



sub copper_area ($) {
	my $layer=shift;
	my $thickness=shift||0;
    $f->COM ('copper_area',
        layer1=>$layer,
		layer2=>'',
		drills=>'yes',
		consider_rout=>'no',
		drills_source=>'matrix',
		thickness=>$thickness,
		resolution_value=>1,
		x_boxes=>3,
		y_boxes=>3,
		area=>'no',
		dist_map=>'yes');
    my $result= $f->{COMANS};
    $result=(split m/ /,$result)[1];
}

sub brush {
	foreach  my $id (@cu_layer ) {
		$hash{ent}{$id}=undef;
	}
	($error_info,$pass_code)=(undef,undef);
}

sub defualt {
	foreach  my $id (@cu_layer ) {
		$hash{ent}{$id}=copper_area($id);
	}

}

sub apply {



}








=head
##$DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;';
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
	$count_button ? ($count_button=0):($count_button=1);
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
