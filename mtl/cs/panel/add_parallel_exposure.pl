use strict;
use warnings;
goto LABEL_PARALLEL_EXPOSURE_END if ($main::layer_number < 3);

my @layer_line=@{$main::layer_class{line}};
my @inner=@{$main::layer_class{inner}};

my $mark_bg=[
    { x=>$main::px / 2  + 0.24803149606299212,  y=>$main::py / 2  + 12.598425196850 },		## 上边
	{ x=>$main::px / 2  + 0.24803149606299212,	y=>$main::py / 2  - 12.598425196850	},		## 下边
    { x=>$main::px / 2  + 0.24803149606299212,  y=>$main::py / 2  + 12.598425196850 - 0.1968 },		 ## 上边
	{ x=>$main::px / 2  + 0.24803149606299212,	y=>$main::py / 2  - 12.598425196850 + 0.1968 },		 ## 下边
];
my $frame_bg=[
    { x=>$main::px / 2 - 10.881889763779527,  y=>$main::py / 2  - 12.881889763779527 },
	{ x=>$main::px / 2 + 10.881889763779527,  y=>$main::py / 2  - 12.881889763779527 },
	{ x=>$main::px / 2 + 10.881889763779527,  y=>$main::py / 2  + 12.881889763779527 },
	{ x=>$main::px / 2 - 10.881889763779527,  y=>$main::py / 2  + 12.881889763779527 },
]; 
my ($flcx, $flcy,$symbol_gb,$symbol_bg,$symbol_bgx) = (-0.4967,$main::py - 2.75725,'rect590.6x5905.5');

if ($main::px > $main::py) {

	 $mark_bg=[
		{ x=>$main::px / 2  - 12.598425196850,				y=>$main::py / 2  + 0.24803149606299212 },
		{ x=>$main::px / 2  + 12.598425196850,				y=>$main::py / 2  + 0.24803149606299212 },	
		{ x=>$main::px / 2  - 12.598425196850 - 0.1968,		y=>$main::py / 2  + 0.24803149606299212 },		 ## 上边
	    { x=>$main::px / 2  + 12.598425196850 + 0.1968,		y=>$main::py / 2  + 0.24803149606299212 },		 ## 下边
	];

     $frame_bg=[
		{ x=>$main::px / 2 - 12.881889763779527,  y=>$main::py / 2  - 10.881889763779527 },
		{ x=>$main::px / 2 + 12.881889763779527,  y=>$main::py / 2  - 10.881889763779527 },
		{ x=>$main::px / 2 + 12.881889763779527,  y=>$main::py / 2  + 10.881889763779527 },
		{ x=>$main::px / 2 - 12.881889763779527,  y=>$main::py / 2  + 10.881889763779527 },
	]; 

	($flcx, $flcy,$symbol_gb,) = (2.75725,-0.4967,'rect5905.5x590.6');
}

cur_atr_set('.out_scale');
foreach (@inner ) {

	if ($_ =~ m/t/i ) {$symbol_bg='bgt';$symbol_bgx='bgtx';} else {$symbol_bg='bgb';$symbol_bgx='bgbx';}
	
		clear($_);
		add_pad($mark_bg->[0]{x}, $mark_bg->[0]{y}, $symbol_bg, 'no', 0, 'yes' );
		add_pad($mark_bg->[1]{x}, $mark_bg->[1]{y}, $symbol_bg, 'no', 0, 'yes' );
		add_pad($mark_bg->[2]{x}, $mark_bg->[2]{y}, $symbol_bgx, 'no', 0, 'yes' );
		add_pad($mark_bg->[3]{x}, $mark_bg->[3]{y}, $symbol_bgx, 'no', 0, 'yes' );
		if ($main::px <= $main::py) {
			add_pad($mark_bg->[2]{x} - 8.2677, $mark_bg->[2]{y}, $symbol_bg, 'no', 0, 'yes' ); #左上
			add_pad($mark_bg->[2]{x} + 8.2677, $mark_bg->[2]{y}, $symbol_bg, 'no', 0, 'yes' ); #右上
			add_pad($mark_bg->[3]{x} - 8.2677, $mark_bg->[3]{y}, $symbol_bg, 'no', 0, 'yes' ); #左下
			add_pad($mark_bg->[3]{x} + 8.2677, $mark_bg->[3]{y}, $symbol_bg, 'no', 0, 'yes' ); #右下
		}else{
			add_pad($mark_bg->[2]{x} , $mark_bg->[2]{y} - 8.2677, $symbol_bg, 'no', 0, 'yes' ); #左上
			add_pad($mark_bg->[2]{x} , $mark_bg->[2]{y} + 8.2677, $symbol_bg, 'no', 0, 'yes' ); #右上
			add_pad($mark_bg->[3]{x} , $mark_bg->[3]{y} - 8.2677, $symbol_bg, 'no', 0, 'yes' ); #左下
			add_pad($mark_bg->[3]{x} , $mark_bg->[3]{y} + 8.2677, $symbol_bg, 'no', 0, 'yes' ); #右下
		
		}
		add_pad($flcx, $flcy, $symbol_gb, 'no', 0, 'yes' );
		}
cur_atr_set();
clear(); 

##加框线。
 affected_layer('yes', 'single', @inner );	
 add_line($frame_bg->[0]{x},$frame_bg->[0]{y},$frame_bg->[1]{x},$frame_bg->[1]{y},'r10');
 add_line($frame_bg->[1]{x},$frame_bg->[1]{y},$frame_bg->[2]{x},$frame_bg->[2]{y},'r10');
 add_line($frame_bg->[2]{x},$frame_bg->[2]{y},$frame_bg->[3]{x},$frame_bg->[3]{y},'r10');
 add_line($frame_bg->[3]{x},$frame_bg->[3]{y},$frame_bg->[0]{x},$frame_bg->[0]{y},'r10');

 clear();

LABEL_PARALLEL_EXPOSURE_END:  ;

#p__("add inner book ok");

1;


=head

#!/usr/bin/csh
#######################2011-3-15 自动曝光机加光学点！！
COM units,type=inch
set bgx1 = `echo "scale=10;$px / 2  + 0.24803149606299212" | bc`
set bgy1 = `echo "scale=10;$py / 2  + 12.598425196850" | bc`

set bgx2 = $bgx1
set bgy2 = `echo "scale=10;$py / 2  - 12.598425196850" | bc`

######################    2010 3-15 

set bgjx1 = `echo "scale=10;$px / 2 - 11.881889763779527" | bc`
set bgjy1 = `echo "scale=10;$py / 2 - 12.881889763779527" | bc`

set bgjx2 = `echo "scale=10;$px / 2 + 11.881889763779527" | bc`
set bgjy2 = `echo "scale=10;$py / 2 - 12.881889763779527" | bc`

set bgjx3 = `echo "scale=10;$px / 2 + 11.881889763779527" | bc`
set bgjy3 = `echo "scale=10;$py / 2 + 12.881889763779527" | bc`

set bgjx4 = `echo "scale=10;$px / 2 - 11.881889763779527" | bc`
set bgjy4 = `echo "scale=10;$py / 2 + 12.881889763779527" | bc`

set flcx = -1.1811
set flcy = `echo "scale=10;$py - 3.1496" | bc`
######################
foreach i ($gROWrow)
set layer_bytes = `echo $gROWname[$i] | wc -c`      

                if ( $layer_bytes <= 4 ) then
                 set surfix_layer = `echo $gROWname[$i] | cut -c3`     #under 10 layer
                else
                 set surfix_layer = `echo $gROWname[$i] | cut -c4`     #above 10 layer
                endif     

if ( $surfix_layer == "b" )  then
               set bg = bgb
else
               set bg = bgt
endif
if ($gROWcontext[$i] == 'board' && $gROWside[$i] == 'inner') then
  COM affected_layer,name=$gROWname[$i],mode=single,affected=yes
###################### 加对位点
  COM add_pad,attributes=no,x=$bgx1,y=$bgy1,symbol=$bg,\
  polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
  COM add_pad,attributes=no,x=$bgx2,y=$bgy2,symbol=$bg,\
  polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
  COM add_pad,attributes=no,x=$flcx,y=$flcy,symbol=rect1574.803x5905.512,\
  polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
##################### 加边框
  COM add_polyline_strt
  COM add_polyline_xy,x=$bgjx1,y=$bgjy1
  COM add_polyline_xy,x=$bgjx2,y=$bgjy2
  COM add_polyline_xy,x=$bgjx3,y=$bgjy3
  COM add_polyline_xy,x=$bgjx4,y=$bgjy4
  COM add_polyline_xy,x=$bgjx1,y=$bgjy1
  COM add_polyline_end,attributes=no,symbol=r10,polarity=positive
  clear
endif                
end
######################


##########2014-01-01 备份

use strict;
use warnings;
goto LABEL_PARALLEL_EXPOSURE_END if ($main::layer_number < 3);

my @layer_line=@{$main::layer_class{line}};
my @inner=@{$main::layer_class{inner}};

my $mark_bg=[
    { x=>$main::px / 2  + 0.24803149606299212,  y=>$main::py / 2  + 12.598425196850 },
	{ x=>$main::px / 2  + 0.24803149606299212,	y=>$main::py / 2  - 12.598425196850	},	
];
my $frame_bg=[
    { x=>$main::px / 2 - 11.881889763779527,  y=>$main::py / 2  - 12.881889763779527 },
	{ x=>$main::px / 2 + 11.881889763779527,  y=>$main::py / 2  - 12.881889763779527 },
	{ x=>$main::px / 2 + 11.881889763779527,  y=>$main::py / 2  + 12.881889763779527 },
	{ x=>$main::px / 2 - 11.881889763779527,  y=>$main::py / 2  + 12.881889763779527 },
]; 
my ($flcx, $flcy,$symbol_gb,$symbol_bg) = (-1.1811,$main::py - 3.1496,'rect1574.803x5905.512');

if ($main::px > $main::py) {
	 $mark_bg=[
    { x=>$main::px / 2  - 12.598425196850,      y=>$main::py / 2  + 0.24803149606299212 },
	{ x=>$main::px / 2  + 12.598425196850	,	y=>$main::py / 2  + 0.24803149606299212 },	
];
     $frame_bg=[
    { x=>$main::px / 2 - 12.881889763779527,  y=>$main::py / 2  - 11.881889763779527 },
	{ x=>$main::px / 2 + 12.881889763779527,  y=>$main::py / 2  - 11.881889763779527 },
	{ x=>$main::px / 2 + 12.881889763779527,  y=>$main::py / 2  + 11.881889763779527 },
	{ x=>$main::px / 2 - 12.881889763779527,  y=>$main::py / 2  + 11.881889763779527 },
]; 
($flcx, $flcy,$symbol_gb,) = (3.1496,-1.1811,'rect5905.512x1574.803');
}

cur_atr_set('.out_scale');
foreach (@inner ) {

	if ($_ =~ m/t/i ) {$symbol_bg='bgt';} else {$symbol_bg='bgb';}
	
		clear($_);
		add_pad($mark_bg->[0]{x}, $mark_bg->[0]{y}, $symbol_bg, 'no', 0, 'yes' );
		add_pad($mark_bg->[1]{x}, $mark_bg->[1]{y}, $symbol_bg, 'no', 0, 'yes' );
		add_pad($flcx, $flcy, $symbol_gb, 'no', 0, 'yes' );
		}
cur_atr_set();
clear(); 
 affected_layer('yes', 'single', @inner );	
 add_line($frame_bg->[0]{x},$frame_bg->[0]{y},$frame_bg->[1]{x},$frame_bg->[1]{y},'r10');
 add_line($frame_bg->[1]{x},$frame_bg->[1]{y},$frame_bg->[2]{x},$frame_bg->[2]{y},'r10');
 add_line($frame_bg->[2]{x},$frame_bg->[2]{y},$frame_bg->[3]{x},$frame_bg->[3]{y},'r10');
 add_line($frame_bg->[3]{x},$frame_bg->[3]{y},$frame_bg->[0]{x},$frame_bg->[0]{y},'r10');
 clear();

LABEL_PARALLEL_EXPOSURE_END:  ;
#p__("add inner book ok");

1;
