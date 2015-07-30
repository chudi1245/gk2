#!/usr/bin/perl
use strict;
use Net::FTP;
use encoding "utf8";
use Win32;

kysy();

###_________________________________
####check_version();
my ($path,$mw,$i,$ii,%wid)=("d:/xxx/camp/exe/",);
my %hash =(
    new_rename           =>[0, 0,'层重命名'],
	register_layers      =>[1, 0,'自动层对齐'],
	creat_profile        =>[2, 0,'创建虚拟框'],
	move_zero            =>[3, 0,'归零点'],
	d_size               =>[4, 0,'导入刀具信息'],
	auto_rows            =>[5, 0,'自动层排序'],
	add_attribute        =>[6, 0,'增加孔属性'],
	del_duplicate_drill  =>[7, 0,'去重孔'],
	del_nfp              =>[8, 0,'去无用pad'],


	creat_pcb            =>[0, 1,'建立工作稿'],
	del_outprof          =>[1, 1,'删除虚拟框外物'],
	del_out_by_box       =>[2, 1,'选择外形线'],
	out_to_drill         =>[3, 1,'外形圈转孔'],
	circuitry_repair     =>[4, 1,'线路补偿'],
	add_lead_drill       =>[5, 1,'加引孔'],
	cop_orig             =>[6, 1,'复制原稿'],
	compair              =>[7, 1,'比对原稿'],
	scal                 =>[8, 1,'字符缩放'],

	
	sub_panel            =>[0, 2,'工艺边拼版'],
    impedance            =>[1, 2,'制作阻抗条'],
    creat_dd_map         =>[2, 2,'制作分孔图'],
    size_label           =>[3, 2,'标注尺寸'],
	add_chinese          =>[4, 2,'添加中文'],
	panel_new            =>[5, 2,'正式拼板'],
	mark_line_width      =>[6, 2,'标记最小线宽'],
	optimize_levels      =>[7, 2,'叠层优化'],
    calcu_gold_area      =>[8, 2,'算沉金面积'],



	ADM                  =>[0, 3,'钻孔输出'],
	output               =>[1, 3,'菲林输出'],
	write_me             =>[2, 3,'写ME文件'],
	new_print_ss         =>[3, 3,'新打印机文件'],
	erp_insert_drill     =>[4, 3,'ERP钻孔指示'],
	erp_insert_film      =>[5, 3,'ERP菲林指示'],
##  erp_cut_material     =>[6, 3,'ERP开料尺寸'],
	erp_base_info        =>[6, 3,'ERP基础信息'],
	acount_slot          =>[7, 3,'槽孔统计'],
	areatk               =>[8, 3,'计算残铜率'],	

	copy_net_orig        =>[0, 4,'复制orig-net'],
	copy_net_pcb         =>[1, 4,'复制pcb-net'],
    negative_tidy        =>[2, 4,'整理内层负片'],
	negative_to_positive =>[3, 4,'负片转正片'],
	net_analyzer         =>[5, 4,'网络分析'],
##	creat_print_ss       =>[7, 4,'旧打印机文件'],
	panel                =>[7, 4,'旧拼板'],          

    panle_calculate      =>[13,1,'拼版计算'],
	ftp_get_engbak       =>[13,2,'下载资料'],
	ftp_put_engbak       =>[13,3,'上传资料'],

	input_pcb            =>[0,5,'QAE导工作稿'],
	line_2_pad           =>[1,5,'线转pad'],
	checklists           =>[2,5,'分析列表'],  
    select_drawn         =>[3,5,'选择铜皮'],
	film_online          =>[5, 5,'ERP菲林审批'],

	display_week         =>[11,5,'查看周期'],
	del_tmp_layer        =>[12,5,'删除临时层'],
	save                 =>[13,5,'保存'],	


);
###______________________________________________
$mw=MainWindow->new; $mw->title("Better and better 牧泰莱工程部  V1.85"); $mw->geometry("+200+100");


map{$mw->gridColumnconfigure($_,-minsize=>125)}(0..5); ##col

foreach  (keys %hash) {
	my $text=$hash{$_}[2];
	$wid{$_}=$mw->Button(-text=>$text,-width=>12,-height=>1,-command=>[\&camp,$_],-font=>"courier 11" )->grid(-column=>$hash{$_}[1], -row=>$hash{$_}[0],);
}


MainLoop;
###————————————————————————————————————————————————————————————————————————————————————
sub camp {
	my $name=shift; 
	if ($name eq 'panel') {
		my $path1=$main::ENV{GENESIS_EDIR};
		my $path2=$main::ENV{GENESIS_DIR};
        $mw->destroy();
		my $ret=system('csh',"$path1/all/scr_start.csh", "$path2/sys/scripts/program/panel/mtlpn");
		print $ret;
		exit;
	}  elsif	($name eq 'acount_slot') {
		my $path1=$main::ENV{GENESIS_EDIR};
		my $path2=$main::ENV{GENESIS_DIR};
        $mw->destroy();
		my $ret=system('csh',"$path1/all/scr_start.csh", "$path/acount_slot");
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





=head

acount_slot
sub check_version{
	my $version=1.0;
	my $get_path="c:/tmp";
	chdir $get_path;

	my $ftp = Net::FTP->new("mtlfile", Debug => 0)or die "$@" ;
    $ftp->login("zq","12358")                     or die "$@", $ftp->message;
	$ftp->binary();
	$ftp->get("/engscript/exe/cam_script_version")or die "$@", $ftp->message;

	open (FH, "$get_path/cam_script_version") or die $!;
	chomp (my $sever_version=<FH>);
	print "$sever_version\n";
	if ( $sever_version > $version) {
		my $mw=MainWindow->new;
		$mw->Label(-text=>"使用版本为 $version ，请更新至 $sever_version，更新地址 \\\\192.168.0.8\\工程部\\camp ")->pack();
		MainLoop;
		exit;
	}
}



