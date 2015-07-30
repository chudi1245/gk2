#!/usr/bin/perl
use File::Copy;

my @plexe = qw(
	size_label
	tk_cam
	new_rename    
	creat_profile
	move_zero      
	register_layers  
	auto_rows      
	d_size     
	add_attribute    
	del_out_by_box     
	creat_pcb         
    auto_inport_job		
	Shave_copper      
    close_and_exit 
	
    change_unit.pl
	open_pcb        
	out_to_drill     
	slot_to_box       
	rev_drill          
	check_drill         
	add_lead_drill      
    select_drawn    
    del_nfp           
	del_outprof       
	scal             
	display_week      
	add_mark            
	
	open_orig             
    impedance        
	creat_dd_map        
	size_label          	      
	panle_calculate            
	mark_line_width     
	mdgj_no_scale       
	add_Corner_drl      
	add_vut_hole        
	jspanel            

	open_panel          
	write_me           
	output             
	ADM                  
    new_print_ss         
	new_print_old       
	calcu_gold_area     
	areatk                       
    output_film         
	add_qiepian        
	auto_rout          
	del_tmp_layer       
	 
	open_pcs            
	erp_base_info        
	erp_insert_drill     
	erp_insert_film     
	input_pcb           
	copy_net_orig 	    
    copy_net_pcb         
   	negative_to_positive 		
	negative_tidy      
	Auto_shrink_cu		
	net_analyzer        
	output_vut           

	cop_orig            
	compair             
	auto_to__surface     
	line_2_pad           
	checklists           
    vut					
	gold_finger			 
    message				
    Delete_ff_file	     			 
	save                
	ftp_put_engbak       

	erp_cut_material    
	jspanel             
	circuitry_repair    
	optimize_levels     

	contourize                
	checklists           
	auto_surface         
	input_pcb           
    film_online                   
	jssheet  
	tk_cam.pl
);

my @nopl = qw(
	add_chinese
	panel_new
	acount_slot
	test_job
	close_tk
	add_ypad
);

=head
##找脚本，找到了，就拷过来。
my $pl_path = "h:/myscript/cs/qae";
foreach  my $file (@nopl) {
	my $plfile = $file.'.pl';
	 if ( -f "$pl_path/$plfile") { 
		 copy("$pl_path/$plfile","h:/myscript/sz/cam") or die "not copy $file";
		 print "$plfile\n";
	};
	
}

=cut

my $ex_comand = "perlapp -add Socket -add shellwords.pl -add Encode::CN ";
my $week_cmd  = "perlapp -add Socket -add shellwords.pl -add DateTime -add DateTime::Locale::en_US -add Encode::CN ";

my $pl_path = "h:/myscript/sz/cam";
my $dest_path = "h:/xxx/camp/exe";

#my $dest_path = "h:/xxx/nexe";


#=head
##1.编译cam下的脚本：
#my $suma = 0;
#my $sumb = 0;

chdir($pl_path);
foreach  my $file (@plexe) {
	my $plfile = $file.'.pl';
	my $exefil = $file.'.exe';
	
	if(-f $plfile) {
		#删除exe文件 ，再执行编译。
		unlink $exefil if -f $exefil;

		if ($file eq 'display_week') {
			system("$week_cmd $plfile");
		}else{
			system("$ex_comand $plfile");
		}

		move($exefil,$dest_path);
		#move($exefil,"h:/xxx/camp/exe");

		#exit;

		#$suma++;
	}
	#	else{
	#		open(RF,">>result.txt");
	#		print RF "$file\n";
	#		close(RF);
	#		#$sumb++;
	#	}	

}

#print "a = $suma : b = $sumb";

#=cut



##2.编译拼板程序：

if(-f "h:/myscript/sz/panel/panel_new.pl") {
	chdir("h:/myscript/sz/panel/");
	unlink "panel_new.exe" if -f "panel_new.exe";
	system("$ex_comand panel_new.pl");
	move("panel_new.exe",$dest_path);

}


##3.编译拼pcs程序：

if(-f "h:/myscript/sz/sub_panel/sub_panel.pl") {
	chdir("h:/myscript/sz/sub_panel/");
	unlink "sub_panel.exe" if -f "sub_panel.exe";
	system("$ex_comand sub_panel.pl");
	move("sub_panel.exe",$dest_path);
}


#=cut








