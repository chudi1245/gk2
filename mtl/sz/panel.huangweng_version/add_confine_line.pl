use strict;
use warnings;

my $class=\%main::layer_class;
my $length=0.3;
my @confine_line=(
 {x=>$main::SR_xmax+0.02,  y=>$main::SR_ymax+0.02,},
 {x=>$main::SR_xmin-0.02,  y=>$main::SR_ymax+0.02,},
 {x=>$main::SR_xmin-0.02,  y=>$main::SR_ymin-0.02,},
 {x=>$main::SR_xmax+0.02,  y=>$main::SR_ymin-0.02,},
);


clear();
    affected_layer('yes', 'single', @{$main::layer_class{line}} );
	creat_line($confine_line[0]{x},$confine_line[0]{y},'bot',$length,'r10'); 
	creat_line($confine_line[0]{x},$confine_line[0]{y},'lef',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'bot',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'rig',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'top',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'rig',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'top',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'lef',$length,'r10'); 
 clear();

if ( exists $class->{solder_mask}  ){
    affected_layer('yes', 'single', @{$class->{solder_mask}}, );
	creat_line($confine_line[0]{x},$confine_line[0]{y},'bot',$length,'r10'); 
	creat_line($confine_line[0]{x},$confine_line[0]{y},'lef',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'bot',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'rig',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'top',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'rig',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'top',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'lef',$length,'r10');
 clear();
}

if ( exists $class->{silk_screen}  ){
    affected_layer('yes', 'single', @{$class->{silk_screen}}, );
	creat_line($confine_line[0]{x},$confine_line[0]{y},'bot',$length,'r10'); 
	creat_line($confine_line[0]{x},$confine_line[0]{y},'lef',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'bot',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'rig',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'top',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'rig',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'top',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'lef',$length,'r10');
 clear();
}


#p__("confine line ok");
1;

=h
my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\line solder_mask silk_screen drill\);

clear();
affected_layer('yes','single',@add_layer);
map { add_pad($sypad[$_]{x},$sypad[$_]{y},'r125') }(0..$#sypad);
clear();


if ( exists $class->{solder_mask}  ){
    
    affected_layer('yes', 'single', @{$class->{solder_mask}}, );
	creat_line($confine_line[0]{x},$confine_line[0]{y},'bot',$length,'r10'); 
	creat_line($confine_line[0]{x},$confine_line[0]{y},'lef',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'bot',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'rig',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'top',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'rig',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'top',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'lef',$length,'r10');
    clear();
}


affected_layer('yes', 'single', @{$main::layer_class{line}} );
	creat_line($confine_line[0]{x},$confine_line[0]{y},'bot',$length,'r10'); 
	creat_line($confine_line[0]{x},$confine_line[0]{y},'lef',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'bot',$length,'r10'); 
	creat_line($confine_line[1]{x},$confine_line[1]{y},'rig',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'top',$length,'r10'); 
	creat_line($confine_line[2]{x},$confine_line[2]{y},'rig',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'top',$length,'r10'); 
	creat_line($confine_line[3]{x},$confine_line[3]{y},'lef',$length,'r10'); 
clear();

