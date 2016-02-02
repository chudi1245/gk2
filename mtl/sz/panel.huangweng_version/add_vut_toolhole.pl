use strict;
use warnings;

goto LABEL_VUT_TOOL_HOLE if ($main::vcut eq 'no');

#p__("$main::vcut  is ok"); 

my $class=\%main::layer_class;

my $res_x= ($main::px-$main::SR_xmax)*$main::I_M;
my $res_y= ($main::py-$main::SR_ymax)*$main::I_M;

my ($origx,$origy,);
if ($res_x < 10) { $origx = $main::SR_xmin - 0.19685;  } else { $origx = $main::SR_xmin - 0.27559;}
if ($res_y < 10) { $origy = $main::SR_ymin - 0.19685;  } else { $origy = $main::SR_ymin - 0.27559;}


#######our ($Prof_xmin,$Prof_ymin,$Prof_xmax,$Prof_ymax,);

my ($vut_holex,$vut_holey);

if ($main::px<22) {
	
	$vut_holex = $main::Prof_xmin + 1.7;
	
	
	} else {
		if ($main::layer_number <=2){
			$vut_holex = $main::Prof_xmin + 0.188976;
		}
		else{
			$vut_holex = $main::Prof_xmin + 4.125984252;  
		}
	}
if ($main::py<22) {
	$vut_holey = $main::Prof_ymin + 1.9;
	
	} else {
        if ($main::layer_number <=2){
			$vut_holey = $main::Prof_ymin + 0.188976;
		}else{
			$vut_holey = $main::Prof_ymin + 4.125984252;
		}
	}

#p__("$main::cy_area->{bot}, $main::cy_area->{lef}"); 
my $vut_x_length = $main::cy_area->{rig}-$main::cy_area->{lef}-$vut_holex + $main::cy_area->{lef};

my $vut_y_length = $main::cy_area->{top}-$main::cy_area->{bot}-$vut_holey + $main::cy_area->{bot};



my $vut_holeNunberx = int(($vut_x_length )/3.9370078740 );
my $vut_holeNunbery = int(($vut_y_length )/3.9370078740 );

##p__("$vut_holeNunberx, $vut_holeNunbery"); 
## 126.14173228346
if ($main::vcut eq 'Vert') {
 
  foreach  (1..$vut_holeNunbery+1 ) {
	
	clear('drl'); 
	add_pad($origx,$vut_holey,'r126.14173228346'); clear();

	if (  exists $class->{outer}       ){
		clear();
		affected_layer('yes', 'single', @{$class->{outer}}, );
		add_pad($origx,$vut_holey,'r126');clear();}

	if ( exists $class->{solder_mask}  ){
		clear();
		affected_layer('yes', 'single', @{$class->{solder_mask}}, );
		add_pad($origx,$vut_holey,'r141');
	} 
	
	$vut_holey+=3.9370078740; 
	
    }
}


if ($main::vcut eq 'Horiz') {
 foreach  (1..$vut_holeNunberx+1 ) {
	clear('drl'); 
	add_pad($vut_holex,$origy,'r126.14173228346'); 
	clear();

	if (  exists $class->{outer}       ){
		clear();
		affected_layer('yes', 'single', @{$class->{outer}}, );
		add_pad($vut_holex,$origy,'r126',);clear();
	}

	if ( exists $class->{solder_mask}  ){
		clear();
		affected_layer('yes', 'single', @{$class->{solder_mask}}, );
		add_pad($vut_holex,$origy,'r141');
	}
    $vut_holex+=3.9370078740;  
	}
}


if ($main::vcut eq 'Both') {
	foreach  (1..$vut_holeNunbery+1 ) {
	
		clear('drl'); 
		add_pad($origx,$vut_holey,'r126.14173228346'); clear();

		if (  exists $class->{outer}       ){
			clear();
			affected_layer('yes', 'single', @{$class->{outer}}, );
			add_pad($origx,$vut_holey,'r126');clear();}

		if ( exists $class->{solder_mask}  ){
			clear();
			affected_layer('yes', 'single', @{$class->{solder_mask}}, );
			add_pad($origx,$vut_holey,'r141');
		}   
		$vut_holey+=3.9370078740;  
	}

	foreach  (1..$vut_holeNunberx+1 ) {
		clear('drl'); 
		add_pad($vut_holex,$origy,'r126.14173228346'); 
		clear();

		if (  exists $class->{outer}       ){
			clear();
			affected_layer('yes', 'single', @{$class->{outer}}, );
			add_pad($vut_holex,$origy,'r126',);clear();
		}

		if ( exists $class->{solder_mask}  ){
			clear();
			affected_layer('yes', 'single', @{$class->{solder_mask}}, );
			add_pad($vut_holex,$origy,'r141');
		}
		$vut_holex+=3.9370078740;  
	}
}


LABEL_VUT_TOOL_HOLE:;
####p__("vut hole is  ok");

1;


=head

if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'solder_mask', @{$class->{solder_mask}}, );
    
	add_pad($origx,$vut_holey,'r142');
	clear();
}






####加层偏对位图形。
if ( exists $class->{inner}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{inner}}, );
    add_layer_warp('dwi');
}
if ( exists $class->{outer}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{outer}}, );
    add_layer_warp('dwo');
}
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}}, );
    add_layer_warp('dws');
}
#!/usr/bin/csh

######################################ＶＵＴ工具孔座标设置
if ( $vcut == 2 || $vcut == 3 || $vcut == 4 ) then

set vcmx = `echo "scale=6;$gPROF_LIMITSxmax - $gPROF_LIMITSxmin " | bc| awk -F' ' '{printf("%5.4f",$1)}'`

if ( `echo "if ($py < 22) 1" | bc`) then
set orgvy = `echo "scale=10;$gPROF_LIMITSymin - 1.188976" | bc` 
set vcmy = `echo "scale=6;$gPROF_LIMITSymax - $gPROF_LIMITSymin- 0.19685 " | bc| awk -F' ' '{printf("%5.4f",$1)}'`
else
set orgvy = `echo "scale=10;$gPROF_LIMITSymin + 0.188976" | bc` 
set vcmy = `echo "scale=6;$gPROF_LIMITSymax - $gPROF_LIMITSymin- 0.28748 " | bc| awk -F' ' '{printf("%5.4f",$1)}'`
endif


if ( `echo "if ($gzy < 10) 1" | bc`) then
set orgx = `echo "scale=10;$gSR_LIMITSxmin - 0.19685" | bc`
else
set orgx = `echo "scale=10;$gSR_LIMITSxmin - 0.27559" | bc`
endif

if ( `echo "if ($gsx < 10) 1" | bc`) then
set orgy = `echo "scale=10;$gSR_LIMITSymin - 0.19685" | bc` 
else
set orgy = `echo "scale=10;$gSR_LIMITSymin - 0.27559" | bc` 
endif

  ##X方向
  set vchax = `echo "scale=10; $orgx + 1.2 " | bc `
  set vchbx = `echo "scale=10; $orgx + 1.2 + 3.9370078740 * 1 " | bc `
  set vchcx = `echo "scale=10; $orgx + 1.2 + 3.9370078740 * 2 " | bc `
  set vchdx = `echo "scale=10; $orgx + 1.2 + 3.9370078740 * 3 " | bc `
  set vchex = `echo "scale=10; $orgx + 1.2 + 3.9370078740 * 4 " | bc `
  set vchfx = `echo "scale=10; $orgx + 1.2 + 3.9370078740 * 5 " | bc `
  ##Y方向
  set vchay = `echo "scale=10; $orgvy + 3.9370078740 * 1 " | bc `
  set vchby = `echo "scale=10; $orgvy + 3.9370078740 * 2 " | bc `
  set vchcy = `echo "scale=10; $orgvy + 3.9370078740 * 3 " | bc `
  set vchdy = `echo "scale=10; $orgvy + 3.9370078740 * 4 " | bc `
  set vchey = `echo "scale=10; $orgvy + 3.9370078740 * 5 " | bc `
  set vchfy = `echo "scale=10; $orgvy + 3.9370078740 * 6 " | bc `
endif