use strict;
use warnings;
my $class=\%main::layer_class;
my @sypad=@main::sypad;
my $text;

my @end_drill = @main::end_drill;
my @cha_drill = map { abs($end_drill[$_] - 31.811)  }(0..$#end_drill);

my %drill_sizes = map { ($cha_drill[$_],$end_drill[$_]) } (0..$#end_drill);
@cha_drill=sort{$a<=>$b}@cha_drill;
#p__("$drill_sizes{$cha_drill[0]}");

my $min_drill = $drill_sizes{$cha_drill[0]};

if ($min_drill <23.622 || $min_drill > 33.465) {
    $min_drill = 27.638;
}
my $min_job = "r$min_drill" ;


##2014-6-10 修改.
my @add_drll = @{$class->{drill}};
push (@add_drll,'drlp');

foreach  ( @add_drll ) {
	$text=$_;
	next if ($text eq 'drl-2' or $text eq 'drl_2');
	$text = $main::JOB;   ##$text =~ s/drl/$main::JOB/;  2014-6-10修改.
	clear($_);  
    add_drill_fn($text);
    $main::f->COM('sel_break');
	$main::f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=r31.811");
	$main::f->COM("filter_area_strt");
	$main::f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no");
	$main::f->COM("filter_reset,filter_name=popup");
    if ( get_select_count() > 0) {
		$main::f->COM("sel_change_sym,symbol=$min_job,reset_angle=no");
    }

}

my $drl_pp = "$main::JOB"."-"."pp";
if ( exists_layer($drl_pp) eq 'yes' ) {
	clear($drl_pp);
	$text = "$main::JOB"."$main::drl_Version";
	add_drill_fn($text);
	##2014-6-10  注释, 钻pp不需要加丝印定位孔.
	##map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r125') }(0..$#sypad);
	##add_second_pad('r125');
	
}

if ( exists_layer('lp') eq 'yes' ) {
	clear('lp');
	$text = "$main::JOB"."$main::drl_Version";
	add_drill_fn($text);
	map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r125') }(0..$#sypad);
	add_second_pad('r125');
	
}

clear();

1;


sub add_drill_fn{
$main::f->COM ('add_text',
		attributes=>'no',
		type=>'canned_text',
	    ####x=>$main::SR_xmin+0.38,
		x=>$main::SR_xmin+1.30,   ##2013.7.01修改
		y=>$sypad[2]{y} - 0.1 ,   ##y=>$main::SR_ymax+0.18, 2014-6-10修改.
		text=>$text,
		x_size=>0.227,
		y_size=>0.265,

		w_factor=> 2.6509187222,
		polarity=>'positive',
		angle=>0,
		mirror=>'no',
		fontname=>'canned_57',
		bar_type=>'UPC39',
		bar_char_set=>'full_ascii',
		bar128_code=>'none',
		bar_checksum=>'no',
		bar_background=>'yes',
		bar_add_string=>'no',
		bar_add_string_pos=>'top',
		bar_width=>0.008,
		bar_height=>0.175,
		ver=>1);

};



###$main::f->COM ('sel_break');   ##breake the drill fn
	


=head

31.811

COM display_layer,name=drl,display=yes,number=1
COM work_layer,name=drl
COM sel_single_feat,operation=select,x=72.4896125,y=361.73632,tol=1044.9275,cyclic=no
COM sel_single_feat,operation=unselect,x=72.280625,y=355.8847275,tol=1044.9275,cyclic=yes
COM undo
COM sel_single_feat,operation=select,x=75.8333775,y=367.58791,tol=1044.9275,cyclic=no
COM sel_single_feat,operation=select,x=76.878305,y=360.064435,tol=1044.9275,cyclic=no
COM sel_clear_feat
COM sel_multi_feat,operation=select,feat_types=text,include_syms=
COM sel_change_sym,symbol=r501,reset_angle=no
COM sel_single_feat,operation=unselect,x=48.247305,y=357.55661,tol=1044.9275,cyclic=yes
COM add_text,attributes=no,type=canned_text,x=180.53506,y=366.5429825,text=$$LAYER,x_size=6.0198,y_size=8.4074,w_factor=3.28083992,polarity=positive,angle=0,mirror=no,fontname=canned_57,bar_type=UPC39,bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=no,bar_add_string_pos=top,bar_width=0.2032,bar_height=4.445,ver=1
COM add_text,attributes=no,type=canned_text,x=199.9707,y=367.16994,text=$$LAYER,x_size=7.2136,y_size=8.4074,w_factor=3.28083992,polarity=positive,angle=0,mirror=no,fontname=canned_67,bar_type=UPC39,bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=no,bar_add_string_pos=top,bar_width=0.2032,bar_height=4.445,ver=1
COM zoom_area,x1=163.3982575,y1=383.88877,x2=228.392715,y2=354.630815
COM display_layer,name=rou,display=yes,number=2
COM display_layer,name=drl,display=no,number=1
COM work_layer,name=rou
COM display_layer,name=rou,display=no,number=2
COM display_layer,name=drl,display=yes,number=1
COM work_layer,name=drl
COM sel_single_feat,operation=select,x=216.57119,y=371.0784875,tol=239.3025,cyclic=no
COM sel_single_feat,operation=select,x=214.848215,y=370.16914,tol=239.3025,cyclic=no
COM sel_single_feat,operation=unselect,x=215.1353775,y=369.546955,tol=239.3025,cyclic=yes
COM sel_single_feat,operation=select,x=181.58522,y=372.897185,tol=239.3025,cyclic=no
COM sel_break
COM sel_multi_feat,operation=select,feat_types=line,include_syms=r1000
COM clear_highlight
COM sel_clear_feat
COM zoom_out
COM zoom_out
COM sel_single_feat,operation=select,x=127.167915,y=361.79356,tol=957.2075,cyclic=no
COM sel_multi_feat,operation=select,feat_types=text,include_syms=

COM sel_break
COM filter_set,filter_name=popup,update_popup=no,include_syms=r31.811
COM filter_area_strt
COM filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no
COM filter_reset,filter_name=popup

COM sel_change_sym,symbol=r505,reset_angle=no
COM filter_reset,filter_name=popup



COM add_text,attributes=no,type=canned_text,x=77.7169525,y=396.541075,text=$$job,x_size=4.8768,y_size=6.8072,w_factor=2.6556758881,polarity=positive,angle=0,mirror=no,fontname=canned_57,ver=1
COM add_text,attributes=no,type=canned_text,x=19.7088825,y=409.1364525,text=$$job,x_size=6.0198,y_size=8.4328,w_factor=3.2841207981,polarity=positive,angle=0,mirror=no,fontname=canned_57,ver=1
COM add_text,attributes=no,type=canned_text,x=57.2639075,y=407.0564825,text=$$job,x_size=4.8768,y_size=6.8072,w_factor=2.6556758881,polarity=positive,angle=0,mirror=no,fontname=canned_57,ver=1
COM add_text,attributes=no,type=canned_text,x=34.0375675,y=360.0260325,text=$$job,x_size=4.8514,y_size=6.8072,w_factor=2.6509187222,polarity=positive,angle=0,mirror=no,fontname=canned_57,ver=1

COM add_text,attributes=no,type=canned_text,x=3.2847064961,y=14.5914990157,text=$$LAYER,x_size=0.12,y_size=0.168,w_factor=1.6666666269,polarity=positive,angle=0,mirror=no,fontname=canned_57,bar_type=UPC39,bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=no,bar_add_string_pos=top,bar_width=0.008,bar_height=0.175,ver=1
COM add_text,attributes=no,type=canned_text,x=4.0576080709,y=14.708408563,text=$$LAYER,x_size=0.12,y_size=0.168,w_factor=1.6666666269,polarity=positive,angle=0,mirror=no,fontname=canned_57,bar_type=UPC39,bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=no,bar_add_string_pos=top,bar_width=0.008,bar_height=0.175,ver=1

