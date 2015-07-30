#!/usr/bin/perl
use strict;
use FBI;
use Win32::API;
use Net::FTP;
use encoding "utf8";
use Win32;
use Tk;

kysy();


###_________________________________
####check_version();
my ($path,$mw,$i,$ii,%wid)=($ENV{'PWD'},);    
my %hash =(
   	new_rename           =>[1, 0,'层重命名'],
	creat_profile        =>[2, 0,'建profile'],
	move_zero            =>[3, 0,'归零点'],
	register_layers      =>[4, 0,'自动层对齐'],
	auto_rows            =>[5, 0,'自动层排序'],
	d_size               =>[6, 0,'导入钻孔信息'],
	add_attribute        =>[7, 0,'定孔属性'],
	del_out_by_box       =>[8, 0,'选择外形线'],	
	creat_pcb            =>[9, 0,'创建pcb'],
    auto_inport_job		 =>[10,0,'自动调tgz'],
	Shave_copper         =>[11,0,'自动掏铜'],
    close_and_exit       =>[12,0,'关闭退出'],




	open_pcb             =>[1, 1,'open_pcb'],
	out_to_drill         =>[2, 1,'外形圈转孔'],
	slot_to_box          =>[3, 1,'槽/孔转外形'],
	rev_drill            =>[4, 1,'校正孔偏'],
	check_drill          =>[5, 1,'钻孔检测'],
	add_lead_drill       =>[6, 1,'加引孔'],
    select_drawn         =>[7, 1,'选择铜皮'],
    del_nfp              =>[8, 1,'去无用pad'],
	del_outprof          =>[9, 1,'删out_prof'],	
	scal                 =>[10,1,'字符缩放'],
	display_week         =>[11,1,'查看周期'],
	add_mark             =>[12,1,'加标记'],
	



	open_orig            =>[1, 2,'open_orig'],			
	sub_panel            =>[2, 2,'pcs拼版'],	
    impedance            =>[3, 2,'画阻抗条'],
	creat_dd_map         =>[4, 2,'分孔图制作'],    
	size_label           =>[5, 2,'标注尺寸'],	
	add_chinese          =>[6, 2,'添加中文'],
	panle_calculate      =>[7, 2,'计算利用率'],
	panel_new            =>[8, 2,'正式拼版'], 		
	mark_line_width      =>[9, 2,'标最小线宽'],
	mdgj_no_scale        =>[10,2,'md_gj不缩放'],
	add_Corner_drl       =>[11,2,'加板角孔'],
	add_vut_hole         =>[12,2,'加VUT孔'],

##	jspanel              =>[12,2,'拼板软件'],	
	


#	open_panel           =>[1, 3,'open_pnl'],		
	write_me             =>[1, 3,'写ME文件'],	
	output               =>[2, 3,'菲林输出'],
	ADM                  =>[3, 3,'钻孔输出'],	
    new_print_ss         =>[4, 3,'新打印字符'],
	new_print_old        =>[5, 3,'旧打印字符'],
	calcu_gold_area      =>[6, 3,'沉金计算'],
	areatk               =>[7, 3,'算残铜率'],
	acount_slot          =>[8, 3,'槽孔统计'],
    output_film          =>[9, 3,'光绘输菲林'],  	
	add_qiepian          =>[11,3,'加切片孔'],
	auto_rout            =>[12,3,'输cy锣带'],
	del_tmp_layer        =>[10,3,'删除++orig'],
	 


	open_pcs             =>[1, 4,'open_pcs'],	
	erp_base_info        =>[2, 4,'erp基础信息'],
	erp_insert_drill     =>[3, 4,'erp钻孔指示'],
	erp_insert_film      =>[4, 4,'erp菲林指示'],
	input_pcb            =>[5, 4,'input_pcb'],
	copy_net_orig 	     =>[6, 4,'复制ori_net'],
    copy_net_pcb         =>[7, 4,'复制pcb-net'],	
   	negative_to_positive =>[8, 4,'负片转正片'],		
	negative_tidy        =>[9, 4,'负片整理'],	
	Auto_shrink_cu		 =>[10,4,'自动缩铜'],
	net_analyzer         =>[11,4,'网络分析'],
	output_vut           =>[12,4,'输出vut'],


	
	cop_orig             =>[1, 5,'复制orig'],
	compair              =>[2, 5,'比对原稿'],	
	auto_to__surface     =>[3, 5,'自动转铜皮'],	
	line_2_pad           =>[4, 5,'线转pad'],
	checklists           =>[5, 5,'检测列表'],	
    vut					 =>[6, 5,'VUT叠铜'],	
	gold_finger			 =>[7, 5,'金手指斜边'],	
    message				 =>[8, 5,'常用电话'],
    Delete_ff_file	     =>[9, 5,'删发放资料'],
    test_job			 =>[10,5,'查找JOB'],
	save                 =>[11,5,'保存文件'],	
	ftp_put_engbak       =>[12,5,'上传资料'],


#Shave_copper
#add_chinese
#panel_new
#acount_slot
#output_film
#test_job
#close_tk
#add_ypad

#	erp_cut_material     =>[4, 4,'开料尺寸'],
#	jspanel              =>[6, 2,'拼板软件'],	
#	circuitry_repair     =>[7, 1,'线路补偿'],
#	optimize_levels      =>[7, 3,'叠层优化'],   

#	contourize           =>[7, 1,'转铜皮'],
#	close_tk             =>[11,5,'关闭退出'], 
#	checklists           =>[8, 5,'检测列表'],	
#	auto_surface         =>[3, 5,'Auto转铜皮'],	
#	input_pcb            =>[1, 5,'导入工作稿'],	
#    film_online          =>[6, 4,'菲林审批'],
#   add_ypad             =>[10,2,'加多丝印孔'],	
#	jssheet              =>[8, 3,'计算预投'],

);

##################################
$mw=MainWindow->new;
$mw->title("Better and better Auto_cam_system Ver2.67");
$mw->geometry("+184+85");

$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);

map{$mw->gridColumnconfigure($_,-minsize=>125)}(0..5); ##col
#map{$mw->gridRowconfigure($_,-minsize=>34);}(1..10);  ##row

$mw->Label(-text => "原稿整理",-relief=>'flat',-width=>14,-bg => 'skyblue',-font => [-family=>'黑体',-size=>13],)->grid(-ipadx => 2,-row=>0,-column=>0);
$mw->Label(-text => "常用命令",-relief=>'flat',-width=>14,-bg => 'skyblue',-font => [-family=>'黑体',-size=>13],)->grid(-ipadx => 2,-row=>0,-column=>1);
$mw->Label(-text => "资料拼板",-relief=>'flat',-width=>14,-bg => 'skyblue',-font => [-family=>'黑体',-size=>13],)->grid(-ipadx => 2,-row=>0,-column=>2);
$mw->Label(-text => "输出检查",-relief=>'flat',-width=>14,-bg => 'skyblue',-font => [-family=>'黑体',-size=>13],)->grid(-ipadx => 2,-row=>0,-column=>3);
$mw->Label(-text => "ERP输入", -relief=>'flat',-width=>14,-bg => 'skyblue',-font => [-family=>'黑体',-size=>13],)->grid(-ipadx => 2,-row=>0,-column=>4);
$mw->Label(-text => "资料检查",-relief=>'flat',-width=>14,-bg => 'skyblue',-font => [-family=>'黑体',-size=>13],)->grid(-ipadx => 2,-row=>0,-column=>5);

##$mw->Button(-text => '大料计算',-relief=>'raised',-width=>12,-font=>[-family=>'黑体',-size=>16],-command =>\&Count_sheet)->grid(-row=>6,-column=>4);

foreach  (keys %hash) {
	my $text=$hash{$_}[2];
	
	$wid{$_}=$mw->Button(-text=>$text,-width=>12,-height=>1,
		-relief=>'raised',-bg => 'seashell',-command=>[\&camp,$_],
		-font=>"courier 13"  )->grid(-column=>$hash{$_}[1], -row=>$hash{$_}[0],-padx => 1,-pady =>2);
}

MainLoop;
##################################
sub camp {
	my $name=shift; 
	my $path1=$main::ENV{GENESIS_EDIR};
	my $path2=$main::ENV{GENESIS_DIR};	
	
	if	($name eq 'acount_slot') {
        $mw->destroy();
		my $ret=system('csh',"$path1/all/scr_start.csh", "$path/acount_slot");
		print $ret;
		exit;
	}	else{
	    $mw->destroy();
	    my $ret=system "$path/$name.exe";
		print $ret;
	    exit;	
	}
}


=head


sub camp {
	my $name=shift; 
	my $path1=$main::ENV{GENESIS_EDIR};
	my $path2=$main::ENV{GENESIS_DIR};
	if	($name eq 'acount_slot') {
		my $path1=$main::ENV{GENESIS_EDIR};
		my $path2=$main::ENV{GENESIS_DIR};
        $mw->destroy();
		my $ret=system('csh',"$path1/all/scr_start.csh", "$path/acount_slot");
		print $ret;
		exit;
	}
	elsif($name eq 'posit_negat') {
	     $mw->destroy();
		 my $ret=system('csh',"$path1/all/scr_start.csh", "$path/posit-to-negat.txt");
		 print $ret;
		 exit;
	
	}	
	else{
	    $mw->destroy();
	    my $ret=system "$path/$name.exe";
		print $ret;
	    exit;	
	}
}


