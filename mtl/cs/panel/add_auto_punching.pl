use strict;
use warnings;
my $class=\%main::layer_class;
if ( $main::layer_number > 4 or ($main::layer_number == 4 and @{$main::layer_class{inner}}[0] =~ m/l2b/i ) ){

  my ($px_decimals,$py_decimals, ) = ($main::px - int($main::px),$main::py - int($main::py),);
   
   my ($opex_decimals,$opey_decimals);   
	   
	   if ($px_decimals <0.2)      {$opex_decimals = 0;  }
       elsif ($px_decimals <=0.6)  {$opex_decimals = 0.5;}
                              else {$opex_decimals = 1;  }

       if ($py_decimals <0.2)      {$opey_decimals = 0;  }
       elsif ($py_decimals <=0.6)  {$opey_decimals = 0.5;}
       else                        {$opey_decimals = 1;  }


###p__("$opex_decimals,$opey_decimals");

my ($ope_px,$ope_py) = (int($main::px) + $opex_decimals,int($main::py) + $opey_decimals,);
###加ope 的尺寸。只能为整数，或小数部分为0.5

##p__("$ope_px,$ope_py");
my ($px_ope_jump,$py_ope_jump) =(($ope_px-int($ope_px))/2, ($ope_py-int($ope_py))/2, );
###为0，或者0.25

my ($px_ope_gapx,$py_ope_gapy) = (($ope_px-$main::px)/2,($ope_py-$main::py)/2,);
###chax,chay 加ope尺寸与拼板尺寸的单边差距。

 ($main::ope_lefx,$main::ope_lefy) = (0.375 - $px_ope_gapx,                $main::py/2 -$py_ope_jump,);

 ($main::ope_botx,$main::ope_boty) = ($main::px/2 -$px_ope_jump,                0.375 - $py_ope_gapy,);

 ($main::ope_rigx,$main::ope_rigy) = ($main::px - 0.375+$px_ope_gapx, $main::py/2-$py_ope_jump+0.188,);

 ($main::ope_topx,$main::ope_topy) = ($main::px/2-$px_ope_jump,       $main::py - 0.375+$py_ope_gapy,);

my ($ope_lefx, $ope_lefy,)=($main::ope_lefx,$main::ope_lefy);
my ($ope_botx, $ope_boty,)=($main::ope_botx,$main::ope_boty);
my ($ope_rigx, $ope_rigy,)=($main::ope_rigx,$main::ope_rigy);
my ($ope_topx, $ope_topy,)=($main::ope_topx,$main::ope_topy);

my ($off_setx,);
my $res_x= ($main::px-$main::SR_xmax)*$main::I_M;

if ($res_x < 18){
	$off_setx=0.078740;
}elsif($res_x >= 18 && $res_x <= 20) {
	$off_setx=0.157480;
}elsif($res_x > 20 && $res_x <= 22)  {
	$off_setx=0.236220;
}else  {$off_setx=0.314960;}

#######打开所有内层加ope。
my @inner=@{$main::layer_class{inner}};
cur_atr_set('.out_scale');
  foreach  (@inner) {
    my ($symbol_mark,);
#    $_=~ m/t/i ? $symbol_mark='markt':$symbol_mark='markb';	
	
	if ($_=~ m/t/i) { $symbol_mark='markt';
   } else {$symbol_mark='markb';}	

	clear($_);
    #################加OPE光学对位点。
	add_pad($ope_lefx, $ope_lefy+1.5, $symbol_mark,'no', 0, 'yes');
	add_pad($ope_botx+1.5, $ope_boty, $symbol_mark,'no', 0, 'yes');
	add_pad($ope_rigx, $ope_rigy+1.5, $symbol_mark,'no', 0, 'yes');
	add_pad($ope_topx+1.5, $ope_topy, $symbol_mark,'no', 0, 'yes');
    	clear();
  }

		clear();
	affected_layer('yes','single',  @inner);
	#################加圆形铆钉。
	add_pad($ope_lefx, $ope_lefy-0.53, 'mdn','no', 0, 'yes');
	add_pad($ope_botx-0.53, $ope_boty, 'mdn','no', 0, 'yes');
	add_pad($ope_rigx, $ope_rigy-0.53, 'mdn','no', 0, 'yes');
	add_pad($ope_topx-0.53, $ope_topy, 'mdn','no', 0, 'yes');

#############________________________________________________________给OPE加阻流条。	
#	add_pad($ope_lefx -0.2 , $ope_lefy,  'oval39.37x1600', 'no', 0,  'yes');
#	add_pad($ope_botx, $ope_boty -0.2,   'oval39.37x1600', 'no', 90, 'yes');
#	add_pad($ope_rigx + 0.2, $ope_rigy,  'oval39.37x1600', 'no', 0,  'yes');
#	add_pad($ope_topx, $ope_topy + 0.2,  'oval39.37x1600', 'no', 90, 'yes');
	
	#################加热熔pad。
	add_pad($off_setx, $ope_lefy+5.9842992, 'rpad','no', 0, 'yes');
	add_pad($off_setx, $ope_lefy+2.4409016, 'rpad','no', 0, 'yes');
	add_pad($off_setx, $ope_lefy-3.3857992, 'rpad','no', 0, 'yes');
	add_pad($off_setx, $ope_lefy-6.9290984, 'rpad','no', 0, 'yes');
		
	add_pad($main::px-$off_setx, $ope_lefy+5.9842992, 'rpad','no', 0, 'yes');
	add_pad($main::px-$off_setx, $ope_lefy+2.4409016, 'rpad','no', 0, 'yes');
	add_pad($main::px-$off_setx, $ope_lefy-3.3857992, 'rpad','no', 0, 'yes');
	add_pad($main::px-$off_setx, $ope_lefy-6.9290984, 'rpad','no', 0, 'yes');	
	###_add_rivet('md');　加OPE冲孔图形。
    add_pad($ope_lefx, $ope_lefy, 'gjlb', 'no', 0,   'yes');
	add_pad($ope_botx, $ope_boty, 'gjlb', 'no', 90,  'yes');
	add_pad($ope_rigx, $ope_rigy, 'gjrt', 'no', 90,  'yes');
	add_pad($ope_topx, $ope_topy, 'gjrt', 'no', 0,   'yes');		
    cur_atr_set( );	
	
	clear();
	affected_layer('yes','single',  @{$main::layer_class{outer}}   );
    
	add_pad($off_setx+ 0.236220, $ope_lefy+5.9842992- 0.2362205, 'r52','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy+2.4409016- 0.2362205, 'r52','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy-3.3857992- 0.2362205, 'r52','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($off_setx+ 0.236220, $ope_lefy-6.9290984- 0.2362205, 'r52','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	
	
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy+5.9842992- 0.2362205, 'r52','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy+2.4409016- 0.2362205, 'r52','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy-3.3857992- 0.2362205, 'r52','no',0,'no','positive',1,4,0,157.480019685,1,1,);
	add_pad($main::px-$off_setx- 0.236220, $ope_lefy-6.9290984- 0.2362205, 'r52','no',0,'no','positive',1,4,0,157.480019685,1,1,);


	clear();


clear('cy');

    add_pad($ope_lefx, $ope_lefy, 'r236.22',);
	add_pad($ope_botx, $ope_boty, 'r236.22',);
	add_pad($ope_rigx, $ope_rigy, 'r236.22',);
	add_pad($ope_topx, $ope_topy, 'r236.22',);

	add_pad($ope_lefx, $ope_lefy-0.53, 'r236.22',);
	add_pad($ope_botx-0.53, $ope_boty, 'r236.22',);
	add_pad($ope_rigx, $ope_rigy-0.53, 'r236.22',);
	add_pad($ope_topx-0.53, $ope_topy, 'r236.22',);


clear();

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

#*******************************************
my $drl_pp = "$main::JOB"."-"."pp";

if ( exists_layer($drl_pp) eq 'yes' ) {$main::f->COM("delete_layer,layer=$drl_pp");}
	creat_clear_layer($drl_pp);
    add_pad($ope_lefx, $ope_lefy, 'zkpt', 'no', 90,   'yes');
	add_pad($ope_botx, $ope_boty, 'zkpt', 'no', 0,  'yes');
	add_pad($ope_rigx, $ope_rigy, 'zkpt', 'no', 90,  'yes');
	add_pad($ope_topx, $ope_topy, 'zkpt', 'no', 0,   'yes');
  
	#################加圆形铆钉。
	add_pad($ope_lefx, $ope_lefy-0.53, 'r157.48',);
	add_pad($ope_botx-0.53, $ope_boty, 'r157.48',);
	add_pad($ope_rigx, $ope_rigy-0.53, 'r157.48',);
	add_pad($ope_topx-0.53, $ope_topy, 'r157.48',);

    add_pad(0.03937,                         0.03937, 'r39.37',);
	add_pad(0.03937,             $main::py - 0.03937, 'r39.37',);
	add_pad($main::px - 0.03937, $main::py - 0.03937, 'r39.37',);
	add_pad($main::px - 0.03937,             0.03937, 'r39.37',);
    clear();

###多层板，是否有光板
if ($main::g_board eq 'Bare') {
      if ( exists_layer('gb-rout') eq 'yes' ) {$main::f->COM("delete_layer,layer=gb-rout");}
       creat_clear_layer('gb-rout');
	   add_pad($ope_lefx, $ope_lefy, 'gbrou', 'no', 90,   'yes');
	   add_pad($ope_botx, $ope_boty, 'gbrou', 'no', 0,  'yes');
	   add_pad($ope_rigx, $ope_rigy, 'gbrou', 'no', 90,  'yes');
	   add_pad($ope_topx, $ope_topy, 'gbrou', 'no', 0,   'yes');

      if ( exists_layer('gb-drl') eq 'yes'  ) {$main::f->COM("delete_layer,layer=gb-drl");}

       creat_clear_layer('gb-drl');
       add_pad(0.03937,                          0.03937, 'r39.37',);
	   add_pad(0.03937,              $main::py - 0.03937, 'r39.37',);
	   add_pad($main::px - 0.03937,  $main::py - 0.03937, 'r39.37',);
	   add_pad($main::px - 0.03937,              0.03937, 'r39.37',);

       	add_pad($ope_lefx, $ope_lefy-0.53, 'r125.984',);
		add_pad($ope_botx-0.53, $ope_boty, 'r125.984',);
		add_pad($ope_rigx, $ope_rigy-0.53, 'r125.984',);
		add_pad($ope_topx-0.53, $ope_topy, 'r125.984',);

     }

}

1;

=head
