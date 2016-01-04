#!/usr/bin/perl
use strict;
use Tk;
use DBD::ODBC;
use Encode;
use Win32;
use Genesis;
use FBI;
use M_SQL;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($cut_size,$cut_size_w,$tolerance,$boardqty,$userate,$pqty,$boardsize_x,$boardsize_y,$page_now,$page_all,$use_pass,$info,$submemo);
my ($column,$row,)=(0,0);
###_________________________________
##my $DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtlerp-running;uid=sa;pwd=719799;';
my $DSN = 'driver={SQL Server};Server=192.168.0.2; database=mtltest;uid=sa;pwd=719799;';
my $dbh  = DBI->connect("dbi:ODBC:$DSN",RaiseError => 1, ) or die "$DBI::errstr\n";

kysy();

use  encoding "utf8";
my %hash_tk=(
GoodsCode_lab=>  ['Label',   0,   0,  10, '-text',          '档案号：',       ],
GoodsCode_ent=>  ['Label',   1,   0,  10, '-text',           $JOB,            ],
#CutSize_lab=>    ['Label',   2,   0,  20, '-text',          '开料尺寸INCH：经 x 纬',],
#CutSize_x_ent=>  ['Entry',   3,   0,  10, '-textvariable',  \$cut_size,       ],
#CutSize_y_ent=>  ['Entry',   4,   0,  10, '-textvariable',  \$cut_size_w,     ],
Tolerance_lab=>  ['Label',   5,   0,  10, '-text',          '公差：',         ],
Tolerance_ent=>  ['Entry',   6,   0,  10, '-textvariable',  \$tolerance,      ],

BoardQty_lab=>   ['Label',   0,   1,  10, '-text',          '大料件数：',     ],
BoardQty_ent=>   ['Entry',   1,   1,  10, '-textvariable',  \$boardqty,       ],
UseRate_lab=>    ['Label',   2,   1,  20, '-text',          '材料利用率:0.00', ],
UseRate_ent=>    ['Entry',   3,   1,  10, '-textvariable',  \$userate,        ],
PQty_lab=>       ['Label',   0,   2,  10, '-text',          '大件排版数：',   ],
PQty_ent=>       ['Entry',   1,   2,  10, '-textvariable',  \$pqty,           ],
BoardSize_lab=>  ['Label',   2,   2,  20, '-text',          '大料尺寸INCH：', ],
BoardSize_x_ent=>['Entry',   3,   2,  10, '-textvariable',  \$boardsize_x,    ],
BoardSize_y_ent=>['Entry',   4,   2,  10, '-textvariable',  \$boardsize_y,    ],
SubMemo_lab    =>['Label',   2,   3,  20, '-text',          '备注信息',       ],
SubMemo_ent    =>['Entry',   3,   3,  10, '-textvariable',  \$submemo,        ],
Page_now_lab=>   ['Label',   0,   3,  10, '-text',          '第 页',          ],
Page_now_ent=>   ['Entry',   1,   3,  10, '-textvariable',  \$page_now,       ],
Page_all_lab=>   ['Label',   0,   4,  10, '-text',          '共 页',          ],
Page_all_ent=>   ['Entry',   1,   4,  10, '-textvariable',  \$page_all,       ],
Use_pass_lab=>   ['Label',   0,   5,  10, '-text',          '用户口令',       ],
Use_pass_ent=>   ['Entry',   1,   5,  10, '-textvariable',  \$use_pass,       ],
);
no encoding "utf8";
####_______________________________________________________________________
kysy();
if ($STEP ne 'pnl') {p__("Not pnl STEP "); exit}
###________________________________________________________________________
my $mw=MainWindow->new;   $mw->title("Better and better");    $mw->geometry("+200+100");
foreach  (keys %hash_tk) { 
	my ($wid_type, $text_type,$width)=($hash_tk{$_}[0], $hash_tk{$_}[4],$hash_tk{$_}[3]);
	$mw->$wid_type($text_type=>$hash_tk{$_}[5],-width=>$width,-relief=>'sun',-font=>"courier 10" )->grid(-column=>$hash_tk{$_}[1], -row=>$hash_tk{$_}[2]);
};


$mw->Label(-textvariable=>\$info,-relief=>'g',-width=>120)->grid(-column=>0, -row=>9,-columnspan=>10);
$mw->Button(-text=>'Defualt',-width=>10,-command=>\&defualt)->grid(-column=>4, -row=>10,);
$mw->Button(-text=>'Brush',-width=>10,-command=>\&brush)->grid(-column=>5, -row=>10,);
$mw->Button(-text=>'Apply',-width=>10,-command=>\&apply)->grid(-column=>6, -row=>10,);
defualt();
MainLoop;

sub apply {
	if ($info=check_error() ) {return;}else{$info='check ok'};
	if ( $info=M_SQL::usr_pass($use_pass,$dbh) ){ $info=decode('gbk',$info);  return;}else{$info='use pass ok'} ;
	creat_cut_layer();

	my $sql_del=qq\delete  from  TBGoodsCutMaterial where GoodsCode='$JOB'\;
	M_SQL::sql_process($sql_del,$use_pass,$dbh);

	my $sql=qq\insert into TBGoodsCutMaterial
           (GoodsCode,Tolerance,  BoardQty,  UseRate, PQty, BoardLength, BoardWide,   SubMemo) values 
           ('$JOB', '$tolerance','$boardqty',$userate,$pqty,$boardsize_x,$boardsize_y,'$submemo')\; 
	$sql=encode('gb2312',$sql);
    M_SQL::sql_process($sql,$use_pass,$dbh);
	
    exit;
}

sub check_error {
	if ( $cut_size < 9 or  $cut_size > 24 ) { return "cut_size error" };
	if ( $cut_size_w < 9 or  $cut_size_w > 24 ) { return "cut_size_w error" };
	if (! $tolerance) {return "tolence error"};
    if (! $boardqty)  {return "boardqty error"};
	if ( $userate < 65 ) {return "userate error"  };
	if ( $boardsize_x !~ m{(^36$)|(^37$)|(^40$)|(^41$)} ) {return "boardsize_x error"};
	if ( $boardsize_y !~ m{(^48$)|(^49$)|(^50$)}) {return "boardsize_y error"};
}

sub brush {
	map{$_=undef}($cut_size,$cut_size_w,$tolerance,$boardqty,$userate,$pqty,$boardsize_x,$boardsize_y, $page_now,$page_all);
}

sub defualt {
	$tolerance='+/-2mm';
    ($page_now,$page_all)=(5,6);
	my $ref=info('STEP',"$JOB/$STEP");
    ($cut_size,$cut_size_w)=dist_woof( $ref->{gPROF_LIMITSxmax}-$ref->{gPROF_LIMITSxmin},  $ref->{gPROF_LIMITSymax}-$ref->{gPROF_LIMITSymin}, );
    if (int $cut_size =~ m{9|12|18} ){ 
	    ($boardsize_x,$boardsize_y)=(37,49)  ;
    }
    else{
	    ($boardsize_x,$boardsize_y)=(41,49)  ;
    }
    ##my ($gr_step)=@{$ref->{gSRstep}};
    $pqty= int($boardsize_x / $cut_size) * int($boardsize_y / $cut_size_w);
	$boardqty=1;
}

sub dist_woof ($$) { 
	my ($v1,$v2)=@_;
	map{$_=int $_}($v1,$v2);
	if (not 48 % $v1 and not 48 % $v2  ) {
		return sort{$a<=>$b}@_;
	}
	elsif(not 48 % $v1 and  48 % $v2 ){
		return reverse @_;
	}
	elsif( 48 % $v1 and not 48 % $v2 ){
		return  @_;
	}
	else{
		return  @_;
	}
}


sub  add_if_text {
	my $text=shift;
    my $x=shift;
	my $y=shift;
	my $x_size=shift||0.12;
	my $y_size=shift||0.13;
if ($text) {
	$f->COM ('add_text',
    attributes         =>'no',
	type               =>'string',
	x                  =>$x,
	y                  =>$y,
	text               =>$text,
	x_size             =>$x_size,
	y_size             =>$y_size,
	w_factor           =>1,
	polarity           =>'positive',
	angle              =>0,
	mirror             =>'no',
	fontname           =>'standard',
	bar_type           =>'UPC39',
	bar_char_set       =>'full_ascii',
	bar128_code        =>'none',
	bar_checksum       =>'no',
	bar_background     =>'yes',
	bar_add_string     =>'yes',
	bar_add_string_pos =>'top',
	bar_width          =>0.008,
	bar_height         =>0.2,
	ver                =>1);
}else{
	return;
}
};###end add_if_text;

sub creat_cut_layer {
	unit_set('inch');
	creat_clear_layer('cut_material');
	add_pad(0,0,'cut_material');
	add_if_text( uc($JOB), 0.8,5.9);
	add_if_text( $cut_size, 2.7 ,5.9);
	add_if_text( $cut_size_w, 3.2 ,5.9);
	add_if_text( $tolerance, 4.2 ,5.9);
	add_if_text( $boardsize_x, 2.7 ,5.45);
	add_if_text( $boardsize_y, 3.2 ,5.45);
	add_if_text( $boardsize_x, 1.9 ,4.75);
	add_if_text( $boardsize_y, 4.29 ,3.35);
	add_if_text( $page_now, 4.34 ,6.5);
	add_if_text( $page_all, 4.96 ,6.5);
	add_if_text( $pqty, 0.85, 5.45);
	add_if_text( "${userate}%", 2.7 ,5.68);
	add_if_text( $boardqty, 0.81 ,5.68);

	my @pix=(0.9095, 1.3229,  3.7846,   4.4688);
	my ($pace_x,$pace_y)=( ($pix[2]-$pix[0])/$boardsize_x,   ($pix[3]-$pix[1])/$boardsize_y);
	for (my $x=$pix[0]+$pace_x*$cut_size; $x<=$pix[2];  $x+=$pace_x*$cut_size) {
		add_line($x,  $pix[1]-0.05,  $x, $pix[3]+0.05, 'r9');
		add_if_text("$cut_size", $x-$pace_x*$cut_size/2, $pix[1]-0.15 );
	}
	for (my $y=$pix[1]+$pace_y*$cut_size_w; $y<=$pix[3];  $y+=$pace_y*$cut_size_w) {
		add_line($pix[0]-0.05,$y,  $pix[2]+0.05,  $y,  'r9');
		add_if_text("$cut_size_w", $pix[0]-0.22, $y-$pace_y*$cut_size_w/2,  );
	}

}


=head

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




BoardLength



BoardWide

SubMemo
SubMemo