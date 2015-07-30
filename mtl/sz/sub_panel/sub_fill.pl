use strict;
no strict "vars";

###________________________________________
my ($sr_margin_x,$sr_margin_y)=(0.016,0.016);
if ($joint) {
	$sr_margin_x=$joint+0.016;
	$sr_margin_y=$joint+0.016;
}

foreach  (  @{$layer_class{inner}}  ){
	clear($_);
	fill_params('','ljj',0.11811,0.11811); 
	$f->COM ('sr_fill',
		polarity        =>'positive',
		step_margin_x   =>0.016,
		step_margin_y   =>0.016,
		step_max_dist_x =>30,
		step_max_dist_y =>30,
		sr_margin_x     =>$sr_margin_x,
		sr_margin_y     =>$sr_margin_y,
		sr_max_dist_x   =>0,
		sr_max_dist_y   =>0,
		nest_sr         =>'no',
		consider_feat   =>'yes',
		feat_margin     =>0.01,
		consider_drill  =>'yes',
		drill_margin    =>0.01,
		dest            =>'layer_name',
		layer           =>$_,
		attributes      =>'no');

	foreach  (  @{$layer_class{outer}}   ) {
	    $f->COM ('sel_ref_feat',
		    layers       =>$_,
		    use          =>'filter',
		    mode         =>'touch',
		    pads_as      =>'shape',
		    f_types      =>'line\;pad\;surface\;arc\;text',
		    polarity     =>'positive\;negative',
		    include_syms =>'',
		    exclude_syms =>'');
	}
	$f->COM ('sel_delete',) if get_select_count(); 
}



foreach  (  @{$layer_class{outer}}   ) {
	clear($_);
	fill_params('solid'); 
	$f->COM ('sr_fill',
		polarity        =>'positive',
		step_margin_x   =>0.016,
		step_margin_y   =>0.016,
		step_max_dist_x =>30,
		step_max_dist_y =>30,
		sr_margin_x     =>$sr_margin_x,
		sr_margin_y     =>$sr_margin_y,
		sr_max_dist_x   =>0,
		sr_max_dist_y   =>0,
		nest_sr         =>'no',
		consider_feat   =>'yes',
		feat_margin     =>0.02,
		consider_drill  =>'yes',
		drill_margin    =>0.02,
		dest            =>'layer_name',
		layer           =>$_,
		attributes      =>'no');
	}

1;


=head
