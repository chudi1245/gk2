use strict;
use warnings;
goto LABEL_INNER_BOOK_END if ($main::layer_number < 3);

my @layer_line=@{$main::layer_class{line}};

###my @inner=@{$main::layer_class{inner}};
###my @outer=@{$main::layer_class{outer}};

my $off=($main::layer_number*0.01) + 0.06;

my $same_dount=[
    {x=>$main::SR_xmax-$off,    y=>$main::SR_ymax+$off},
    {x=>$main::SR_xmax+$off,    y=>$main::SR_ymin+$off},
    {x=>$main::SR_xmin-$off,    y=>$main::SR_ymin+$off},
    {x=>$main::SR_xmin+$off,    y=>$main::SR_ymax+$off},
];

my $laynum = $main::layer_number;
my $same_heart = $main::same_heart;
my ($outd,$innd,$symbol_dount);
 ####   set txname = donut_r{$outd}x{$innd}
cur_atr_set('.out_scale');

foreach  (0..$#layer_line) {
	       
			$outd = ($_ + 1 )* 20; 
			$innd = $_ * 20 + 4; 
			$symbol_dount= "donut_r"."$outd"."x"."$innd";
			clear($layer_line[$_]);

		if ($layer_line[$_] eq 'gtl'|| $layer_line[$_] eq 'gbl') {
			
		    ##$outd = $laynum * 20;  $innd = ($laynum-1)*20 + 4;
			add_pad($same_dount->[0]{x}, $same_dount->[0]{y}, $same_heart, 'no', 0, 'yes' );
			add_pad($same_dount->[1]{x}, $same_dount->[1]{y}, $same_heart, 'no', 0, 'yes' );
			add_pad($same_dount->[2]{x}, $same_dount->[2]{y}, $same_heart, 'no', 0, 'yes' );
			add_pad($same_dount->[3]{x}, $same_dount->[3]{y}, $same_heart, 'no', 0, 'yes' );	 

		} else {
			
			add_pad($same_dount->[0]{x}, $same_dount->[0]{y}, $symbol_dount, 'no', 0, 'yes' );
			add_pad($same_dount->[1]{x}, $same_dount->[1]{y}, $symbol_dount, 'no', 0, 'yes' );
			add_pad($same_dount->[2]{x}, $same_dount->[2]{y}, $symbol_dount, 'no', 0, 'yes' );
			add_pad($same_dount->[3]{x}, $same_dount->[3]{y}, $symbol_dount, 'no', 0, 'yes' );
		
			add_pad($same_dount->[0]{x}, $same_dount->[0]{y}, $same_heart, 'no', 0, 'yes' );
			add_pad($same_dount->[1]{x}, $same_dount->[1]{y}, $same_heart, 'no', 0, 'yes' );
			add_pad($same_dount->[2]{x}, $same_dount->[2]{y}, $same_heart, 'no', 0, 'yes' );
			add_pad($same_dount->[3]{x}, $same_dount->[3]{y}, $same_heart, 'no', 0, 'yes' );
		}
}

cur_atr_set();

clear();

LABEL_INNER_BOOK_END:  ;
###p__("add inner book ok");
1;


=head

###############################2010-3-18Ìí¼ÓÍ¬ÐÄÔ²
COM units,type=inch
set tx1x = `echo "scale=10;$gSR_LIMITSxmax - 0.10" | bc`
set tx1y = `echo "scale=10;$gSR_LIMITSymax + 0.18" | bc`
 
set tx2x = `echo "scale=10;$gSR_LIMITSxmax + 0.18" | bc`                         
set tx2y = `echo "scale=10;$gSR_LIMITSymin + 0.18" | bc`

set tx3x = `echo "scale=10;$gSR_LIMITSxmin - 0.18" | bc`       
set tx3y = `echo "scale=10;$gSR_LIMITSymin + 0.18" | bc`

set tx4x = `echo "scale=10;$gSR_LIMITSxmin + 0.18" | bc`
set tx4y = `echo "scale=10;$gSR_LIMITSymax + 0.18" | bc`

#!/usr/bin/csh
###################
###################
COM cur_atr_set,attribute=.out_scale
foreach i ($gROWrow)
set layer_bytes = `echo $gROWname[$i] | wc -c`
switch ($gROWside[$i])
#############################
case top:
set  outd = `echo "scale=10;$numblay * 20" | bc`
set  innd = `echo "scale=10;($numblay - 1) * 20 + 4" | bc`
set txname = donut_r{$outd}x{$innd}
breaksw
#############################
case bottom:
set  outd = `echo "scale=10;$numblay * 20" | bc`
set  innd = `echo "scale=10;($numblay - 1) * 20 + 4" | bc`
set txname = donut_r{$outd}x{$innd}
breaksw
#############################
case inner:
                if ( $layer_bytes <= 4 ) then
                 set surfix_layer = `echo $gROWname[$i] | cut -c2`     #under 10 layer
                else
                 set surfix_layer = `echo $gROWname[$i] | cut -c2-3`    #above 10 layer
                endif 
	set  outd = `echo "scale=10;$surfix_layer * 20" | bc`
	set  innd = `echo "scale=10;($surfix_layer - 1) * 20 + 4" | bc`
	set txname = donut_r{$outd}x{$innd}              
breaksw
endsw
#############################
if ( $gROWcontext[$i] == 'board' &&  $gROWlayer_type[$i] == 'signal' | $gROWlayer_type[$i] == 'power_ground' | $gROWlayer_type[$i] == 'mixed' ) then
COM affected_layer,name=$gROWname[$i],mode=single,affected=yes
COM add_pad,attributes=no,x=$tx1x,y=$tx1y,symbol=$txname,polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
COM add_pad,attributes=no,x=$tx2x,y=$tx2y,symbol=$txname,polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
COM add_pad,attributes=no,x=$tx3x,y=$tx3y,symbol=$txname,polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
COM add_pad,attributes=no,x=$tx4x,y=$tx4y,symbol=$txname,polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1

COM add_pad,attributes=no,x=$tx1x,y=$tx1y,symbol=txmax,polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
COM add_pad,attributes=no,x=$tx2x,y=$tx2y,symbol=txmax,polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
COM add_pad,attributes=no,x=$tx3x,y=$tx3y,symbol=txmax,polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1
COM add_pad,attributes=no,x=$tx4x,y=$tx4y,symbol=txmax,polarity=positive,angle=0,mirror=no,nx=1,ny=1,dx=0,dy=0,xscale=1,yscale=1

COM affected_layer,name=$gROWname[$i],mode=single,affected=no
clear
endif   
end
COM cur_atr_reset
