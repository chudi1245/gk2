use strict;
use warnings;

goto LABEL_TARGET_RIVET_TOOL if ($main::layer_number < 3  );

my @add_layer=@{$main::layer_class{inner}};
my %grid=%main::grid;
my $class=\%main::layer_class;

my $target_tool=$main::target_tool;
my $start_point=$main::start_point; 


if ($main::layer_number > 4  
        or ($main::layer_number == 4 and @{$main::layer_class{inner}}[0] =~ m/l2b/i ) ){

	
	clear();
    ##加热熔pad 
	affected_layer('yes','single',@add_layer);
	cur_atr_set('.out_scale');
	add_target_rpad('rpad');
	cur_atr_set();

	if ( exists $class->{solder_mask}  ){
			clear();
			affected_layer('yes', 'single', @{$class->{solder_mask}}, );
			add_target_rpad_solder();
		}

	if ( exists_layer('drl')  eq  'yes' ) {
			clear('drl');
			add_target_rpad_drl();
	}

	clear();

}

##加工具孔
goto LABEL_TARGET_RIVET_TOOL if ($main::layer_number < 6  );

clear();
affected_layer('yes','single',@add_layer);
cur_atr_set('.out_scale');
add_target_tool('gj');
cur_atr_set();
clear();

########################  子程序  ##############
sub add_target_rpad{
	my $symbol=shift;
	##Y方向为长方向
	if ($main::px <= $main::py) {
		if ($main::py>= 12) {
		
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} + 5.9842992,$symbol, 'no', 0, 'yes');
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} + 2.4409016,$symbol, 'no', 0, 'yes');
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} - 3.3857992,$symbol, 'no', 0, 'yes');
		
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} + 5.9842992,$symbol, 'no', 0, 'yes');
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} + 2.4409016,$symbol, 'no', 0, 'yes');
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} - 3.3857992,$symbol, 'no', 0, 'yes');
		}
		if ($main::py>= 16) {
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} - 6.9290984,$symbol, 'no', 0, 'yes');
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} - 6.9290984,$symbol, 'no', 0, 'yes');
		}
		if ($main::py>= 21) {
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} + 9.5276968,$symbol, 'no', 0, 'yes');
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} + 9.5276968,$symbol, 'no', 0, 'yes');
		}

		if ($main::py>= 25 and  $main::py<= 26) {
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} - 10.472496,$symbol, 'no', 0, 'yes');
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} - 10.472496,$symbol, 'no', 0, 'yes');
		}

	}else{
		##X方向为长方向
		if ($main::px >=12) {
			add_pad($target_tool->[2]{x} - 5.9842992,$target_tool->[2]{y} ,$symbol, 'no', 90, 'yes');
			add_pad($target_tool->[2]{x} - 2.4409016,$target_tool->[2]{y} ,$symbol, 'no', 90, 'yes');
			add_pad($target_tool->[2]{x} + 3.3857992,$target_tool->[2]{y} ,$symbol, 'no', 90, 'yes');
	
			add_pad($target_tool->[2]{x} - 5.9842992,$target_tool->[3]{y} ,$symbol, 'no', 90, 'yes');
			add_pad($target_tool->[2]{x} - 2.4409016,$target_tool->[3]{y} ,$symbol, 'no', 90, 'yes');
			add_pad($target_tool->[2]{x} + 3.3857992,$target_tool->[3]{y} ,$symbol, 'no', 90, 'yes');
	
		}
		if ($main::px >=16) {
			add_pad($target_tool->[2]{x} + 6.9290984,$target_tool->[2]{y} ,$symbol, 'no', 90, 'yes');
			add_pad($target_tool->[2]{x} + 6.9290984,$target_tool->[3]{y} ,$symbol, 'no', 90, 'yes');
  	    }
		if ($main::px >=21) {
						add_pad($target_tool->[2]{x} - 9.5276968,$target_tool->[2]{y} ,$symbol, 'no', 90, 'yes');
			add_pad($target_tool->[2]{x} - 9.5276968,$target_tool->[3]{y} ,$symbol, 'no', 90, 'yes');
  	    }
	
		if ($main::px >=25 and $main::px <=26) {
			add_pad($target_tool->[2]{x} - 10.472496,$target_tool->[2]{y} ,$symbol, 'no', 90, 'yes');
			add_pad($target_tool->[2]{x} - 10.472496,$target_tool->[3]{y} ,$symbol, 'no', 90, 'yes');
  	    }

	}
}


sub add_target_tool{
	my $symbol=shift;
	add_pad($target_tool->[0]{x},$target_tool->[0]{y},$symbol, 'no', 0, 'yes');
	add_pad($target_tool->[1]{x},$target_tool->[1]{y},$symbol, 'no', 0, 'yes');
	add_pad($target_tool->[2]{x},$target_tool->[2]{y},$symbol, 'no', 0, 'yes');
	add_pad($target_tool->[3]{x},$target_tool->[3]{y},$symbol, 'no', 0, 'yes');

}


sub add_target_rpad_drl{
##6.24修改 钻孔放三分之一处。mozhibing
if ($main::px <= $main::py) {
		if ($main::py>= 12) {	
			add_pad($target_tool->[0]{x} - 0.07874 ,$target_tool->[0]{y} + 5.9842992 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[0]{x} - 0.07874 ,$target_tool->[0]{y} + 2.4409016 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[0]{x} - 0.07874 ,$target_tool->[0]{y} - 3.3857992 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		
			add_pad($target_tool->[1]{x} + 0.07874 ,$target_tool->[0]{y} + 5.9842992 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x} + 0.07874 ,$target_tool->[0]{y} + 2.4409016 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x} + 0.07874 ,$target_tool->[0]{y} - 3.3857992 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}
		if ($main::py>= 16) {
			add_pad($target_tool->[0]{x} - 0.07874,$target_tool->[0]{y} - 6.9290984 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x} + 0.07874,$target_tool->[0]{y} - 6.9290984 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}
		if ($main::py>= 21) {
			add_pad($target_tool->[0]{x} - 0.07874,$target_tool->[0]{y} + 9.5276968 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x} + 0.07874,$target_tool->[0]{y} + 9.5276968 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}

		if ($main::py>= 25 and  $main::py<= 26) {
			add_pad($target_tool->[0]{x} - 0.07874,$target_tool->[0]{y} - 10.472496 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x} + 0.07874,$target_tool->[0]{y} - 10.472496 - 0.2362205,'r79.18','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}

	}else{
		##X方向为长方向
		if ($main::px >=12) {
			add_pad($target_tool->[2]{x} - 5.9842992 - 0.2362205,$target_tool->[2]{y} - 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 2.4409016 - 0.2362205,$target_tool->[2]{y} - 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 3.3857992 - 0.2362205,$target_tool->[2]{y} - 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
	
			add_pad($target_tool->[2]{x} - 5.9842992 - 0.2362205,$target_tool->[3]{y} + 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 2.4409016 - 0.2362205,$target_tool->[3]{y} + 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 3.3857992 - 0.2362205,$target_tool->[3]{y} + 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
	
		}
		if ($main::px >=16) {
			add_pad($target_tool->[2]{x} + 6.9290984 - 0.2362205,$target_tool->[2]{y} - 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 6.9290984 - 0.2362205,$target_tool->[3]{y} + 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }
		if ($main::px >=21) {
						add_pad($target_tool->[2]{x} - 9.5276968,$target_tool->[2]{y} - 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 9.5276968 - 0.2362205,$target_tool->[3]{y} + 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }
	
		if ($main::px >=25 and $main::px <=26) {
			add_pad($target_tool->[2]{x} - 10.472496 - 0.2362205,$target_tool->[2]{y} - 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 10.472496 - 0.2362205,$target_tool->[3]{y} + 0.07874 ,'r79.18','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }
	}
}


###  6.23修改---- 钻热熔PAD的孔需加到热熔PAD中间
sub add_target_rpad_solder{

if ($main::px <= $main::py) {
		if ($main::py>= 12) {	
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} + 5.9842992 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} + 2.4409016 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} - 3.3857992 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} + 5.9842992 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} + 2.4409016 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} - 3.3857992 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}
		if ($main::py>= 16) {
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} - 6.9290984 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} - 6.9290984 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}
		if ($main::py>= 21) {
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} + 9.5276968 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} + 9.5276968 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}

		if ($main::py>= 25 and  $main::py<= 26) {
			add_pad($target_tool->[0]{x},$target_tool->[0]{y} - 10.472496 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x},$target_tool->[0]{y} - 10.472496 - 0.2362205,'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}

	}else{
		##X方向为长方向
		if ($main::px >=12) {
			add_pad($target_tool->[2]{x} - 5.9842992 - 0.2362205,$target_tool->[2]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 2.4409016 - 0.2362205,$target_tool->[2]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 3.3857992 - 0.2362205,$target_tool->[2]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
	
			add_pad($target_tool->[2]{x} - 5.9842992 - 0.2362205,$target_tool->[3]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 2.4409016 - 0.2362205,$target_tool->[3]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 3.3857992 - 0.2362205,$target_tool->[3]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
	
		}
		if ($main::px >=16) {
			add_pad($target_tool->[2]{x} + 6.9290984 - 0.2362205,$target_tool->[2]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 6.9290984 - 0.2362205,$target_tool->[3]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }
		if ($main::px >=21) {
						add_pad($target_tool->[2]{x} - 9.5276968,$target_tool->[2]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 9.5276968 - 0.2362205,$target_tool->[3]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }
	
		if ($main::px >=25 and $main::px <=26) {
			add_pad($target_tool->[2]{x} - 10.472496 - 0.2362205,$target_tool->[2]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 10.472496 - 0.2362205,$target_tool->[3]{y},'r90.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }

	}


}

LABEL_TARGET_RIVET_TOOL:  ;

1;




=head


my %target_tool=(
  top=>$main::SR_ymax+0.65,
  bot=>$main::SR_ymin-0.65,
  rig=>$main::SR_xmax+0.65,
  lef=>$main::SR_xmin-0.65,
);


if ($main::px =~ m/12/ and  $main::py =~ m/16/) {
    $target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>15.5}, {x=>11.5,y=>14  }, {x=>11.5,y=>0.5 }, ];
}elsif ($main::px =~ m/12/ and  $main::py =~ m/18/){
	$target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>17.5}, {x=>11.5,y=>16  }, {x=>11.5,y=>0.5 }, ];
}else{
	$target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>$main::py-0.5}, {x=>$main::px-0.5,y=>$main::py-0.5  }, {x=>$main::px-0.5,y=>0.5 }, ];
}



if ($main::px =~ m/12/ and  $main::py =~ m/16/) {
    $target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>15.5}, {x=>11.5,y=>14  }, {x=>11.5,y=>0.5 }, ];
}elsif ($main::px =~ m/12/ and  $main::py =~ m/18/){
	$target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>17.5}, {x=>11.5,y=>16  }, {x=>11.5,y=>0.5 }, ];
}else{
	$target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>$main::py-0.5}, {x=>$main::px-0.5,y=>$main::py-0.5  }, {x=>$main::px-0.5,y=>0.5 }, ];
}

clear('drl');

    add_pad($off_setx+ 0.236220, $ope_lefy+5.9842992- 0.2362205, 'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy+2.4409016- 0.2362205, 'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy-3.3857992- 0.2362205, 'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy-6.9290984- 0.2362205, 'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy+5.9842992- 0.2362205, 'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy+2.4409016- 0.2362205, 'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy-3.3857992- 0.2362205, 'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy-6.9290984- 0.2362205, 'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
#*******************************************
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}}, );
    add_pad($off_setx+ 0.236220, $ope_lefy+5.9842992- 0.2362205, 'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy+2.4409016- 0.2362205, 'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy-3.3857992- 0.2362205, 'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy-6.9290984- 0.2362205, 'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);	
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy+5.9842992- 0.2362205, 'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy+2.4409016- 0.2362205, 'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy-3.3857992- 0.2362205, 'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy-6.9290984- 0.2362205, 'r90.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
}
###6.23修改。
sub add_target_rpad_drl{

if ($main::px <= $main::py) {
		if ($main::py>= 12) {
		
			add_pad($target_tool->[0]{x} - 0.236220,$target_tool->[0]{y} + 5.9842992 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[0]{x} - 0.236220,$target_tool->[0]{y} + 2.4409016 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[0]{x} - 0.236220,$target_tool->[0]{y} - 3.3857992 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		
			add_pad($target_tool->[1]{x} + 0.236220,$target_tool->[0]{y} + 5.9842992 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x} + 0.236220,$target_tool->[0]{y} + 2.4409016 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x} + 0.236220,$target_tool->[0]{y} - 3.3857992 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}
		if ($main::py>= 16) {
			add_pad($target_tool->[0]{x}- 0.236220,$target_tool->[0]{y} - 6.9290984 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x}+ 0.236220,$target_tool->[0]{y} - 6.9290984 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}
		if ($main::py>= 21) {
			add_pad($target_tool->[0]{x}- 0.236220,$target_tool->[0]{y} + 9.5276968 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x}+ 0.236220,$target_tool->[0]{y} + 9.5276968 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}

		if ($main::py>= 25 and  $main::py<= 26) {
			add_pad($target_tool->[0]{x}- 0.236220,$target_tool->[0]{y} - 10.472496 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
			add_pad($target_tool->[1]{x}+ 0.236220,$target_tool->[0]{y} - 10.472496 - 0.2362205,'r78.74','no',0,'no','positive',1,4,0,157.480019685,1,1,);
		}

	}else{
		##X方向为长方向
		if ($main::px >=12) {
			add_pad($target_tool->[2]{x} - 5.9842992 - 0.2362205,$target_tool->[2]{y}- 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 2.4409016 - 0.2362205,$target_tool->[2]{y}- 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 3.3857992 - 0.2362205,$target_tool->[2]{y}- 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
	
			add_pad($target_tool->[2]{x} - 5.9842992 - 0.2362205,$target_tool->[3]{y}+ 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 2.4409016 - 0.2362205,$target_tool->[3]{y}+ 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 3.3857992 - 0.2362205,$target_tool->[3]{y}+ 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
	
		}
		if ($main::px >=16) {
			add_pad($target_tool->[2]{x} + 6.9290984 - 0.2362205,$target_tool->[2]{y}- 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} + 6.9290984 - 0.2362205,$target_tool->[3]{y}+ 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }
		if ($main::px >=21) {
						add_pad($target_tool->[2]{x} - 9.5276968,$target_tool->[2]{y}- 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 9.5276968 - 0.2362205,$target_tool->[3]{y}+ 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }
	
		if ($main::px >=25 and $main::px <=26) {
			add_pad($target_tool->[2]{x} - 10.472496 - 0.2362205,$target_tool->[2]{y}- 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
			add_pad($target_tool->[2]{x} - 10.472496 - 0.2362205,$target_tool->[3]{y}+ 0.236220 ,'r78.74','no', 90,'no','positive',4,1,157.480019685,0,1,1,);
  	    }
	}
}