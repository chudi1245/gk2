use strict;
use warnings;
goto LABEL_INNER_BOOK_END if ($main::layer_number < 2);
my %grid=%main::grid;
my $laynum = $main::layer_number;
my @layer_line=@{$main::layer_class{line}};
my ($box_origx,$box_origy,) = ($main::SR_xmax+0.18,$grid{y}[5] -0.4);
my ($text_origx,$text_origy,) =($box_origx-0.062,$box_origy+0.049,);

foreach  (1..$laynum) {		
		affected_layer('yes', 'single', @layer_line );
		add_pad($box_origx, $box_origy, 'donut_s160x140', 'no', 0, 'yes' );
		$box_origy = $box_origy -0.15;

}

my $sizex;
foreach  (1..$laynum) {	
	if ($_ < 10) {
		$sizex = 0.14;
		clear($layer_line[$_-1]);
		add_layer_text($text_origx, $text_origy, $_,$sizex,);

	} else {
		$sizex = 0.07;
		clear($layer_line[$_-1]);
		add_layer_text($text_origx, $text_origy+0.017, $_,$sizex,);
			
		}	
		$text_origy = $text_origy -0.15;
		
}
clear();
sub add_layer_text  {
       my $x=shift||0;
       my $y=shift||0;
       my $text=shift||'nothing';
	   my $xsize=shift;
	   $main::f->COM ('add_text',
       attributes         =>'no',
       type               =>'string',
       x                  =>$x,
       y                  =>$y,
       text               =>$text,
       x_size             =>$xsize,
       y_size             =>0.12,
       w_factor           =>1.25,
       polarity           =>'positive',
       angle              =>90 ,
       mirror             =>'no',
       fontname           =>'standard',
       bar_type           =>'UPC39',
       bar_char_set       =>'full_ascii',
       bar128_code        =>'none',
       bar_checksum       =>'no',
       bar_background     =>'yes',
       bar_add_string     =>'yes',
       bar_add_string_pos =>'top',
       bar_width          =>0.001,
       bar_height         =>0.2,
       ver               =>1);
}

LABEL_INNER_BOOK_END:  ;
###p__("add layer number ok");

1;



=head

add_layer_text
#!/usr/bin/csh
COM units,type=inch
######################add box in every layer 2010 7-23  mzb

####################
COM cur_atr_set,attribute=.out_scale
foreach i ($gROWrow)
if ( $gROWcontext[$i] == 'board' && $gROWlayer_type[$i] == 'silk_screen' | $gROWlayer_type[$i] == 'solder_mask' | $gROWlayer_type[$i] == 'signal' | $gROWlayer_type[$i] == 'power_ground' | $gROWlayer_type[$i] == 'mixed' && $gROWside[$i] != 'inner') then
COM affected_layer,name=$gROWname[$i],mode=single,affected=yes
COM add_polyline_strt
COM add_polyline_xy,x=$blx1,y=$bly1
COM add_polyline_xy,x=$blx2,y=$bly2
COM add_polyline_xy,x=$blx3,y=$bly3
COM add_polyline_xy,x=$blx4,y=$bly4
COM add_polyline_xy,x=$blx1,y=$bly1
COM add_polyline_end,attributes=no,symbol=r15,polarity=positive
clear
endif
end
COM cur_atr_reset

###################
COM cur_atr_set,attribute=.out_scale
foreach i ($gROWrow)

##if ( $gROWcontext[$i] == 'board' && $gROWlayer_type[$i] != 'drill' && $gROWlayer_type[$i] != 'rout' && $gROWlayer_type[$i] != 'solder_paste' && $gROWlayer_type[$i] != 'silk_screen' ) then
set layer_bytes = `echo $gROWname[$i] | wc -c`
switch ($gROWside[$i])
#############################
case top:
set cname = 1
set cny = `echo "scale=10;$cty - 0.153" | bc`

breaksw
#############################
case bottom:
set cname = $numblay
set cny = `echo "scale=10;$cty - ($numblay - 0)*0.153" | bc`
breaksw
#############################
case inner:
   

                if ( $layer_bytes <= 4 ) then
                 set surfix_layer = `echo $gROWname[$i] | cut -c2`     #under 10 layer
                else
                 set surfix_layer = `echo $gROWname[$i] | cut -c2-3`    #above 10 layer
                endif     
                set cname = $surfix_layer
                set cny = `echo "scale=10;$cty - $surfix_layer*0.153" | bc`
breaksw
endsw
#############################
if ( $gROWcontext[$i] == 'board' &&  $gROWlayer_type[$i] == 'signal' | $gROWlayer_type[$i] == 'power_ground' | $gROWlayer_type[$i] == 'mixed' ) then
COM affected_layer,name=$gROWname[$i],mode=single,affected=yes
if ( $layer_bytes <= 4 ) then
COM add_text,attributes=no,type=string,x=$cnx,y=$cny,\
text=$cname,x_size=0.14,y_size=0.12,w_factor=1.25,\
polarity=positive,angle=90,mirror=no,fontname=standard,bar_type=UPC39,\
bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=yes,\
bar_add_string_pos=top,bar_width=0.008,bar_height=0.2,ver=1clear
else
COM add_text,attributes=no,type=string,x=$cnx,y=$cny,\
text=$cname,x_size=0.07,y_size=0.12,w_factor=1.25,\
polarity=positive,angle=90,mirror=no,fontname=standard,bar_type=UPC39,\
bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=yes,\
bar_add_string_pos=top,bar_width=0.008,bar_height=0.2,ver=1clear
 endif     
COM affected_layer,name=$gROWname[$i],mode=single,affected=no
endif
end
COM cur_atr_reset