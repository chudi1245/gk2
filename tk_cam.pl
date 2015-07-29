#!/usr/bin/perl
use strict;
use encoding "utf8";
use Tk;
###_________________________________

my ($path,$mw,$i,$ii,%wid)=("d:/pcam/",);
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
    net_analyzer         =>[8, 1,'网络分析'],
	optimize_levels      =>[9, 1,'叠层优化'],

	sub_panel            =>[0, 2,'工艺边拼版'],
	panel                =>[1, 2,'拼版'],
	mark_line_width      =>[2, 2,'标记最小线宽'],
    creat_dd_map         =>[3, 2,'制作分孔图'],
    size_label           =>[4, 2,'标注尺寸'],
	creat_print_ss       =>[5, 2,'制作打印文件'],

    impedance             =>[0, 3,'制作阻抗条'],
	ADM                  =>[1, 3,'钻孔输出'],
	output               =>[2, 3,'菲林输出'],
	write_me             =>[3, 3,'写ME文件'],
	del_tmp_layer        =>[4, 3,'删除临时层'],
	display_week         =>[8,3,'查看周期'],
	tmp                  =>[10,3,'tmp'],

	erp_insert_drill     =>[1,4,'ERP钻孔指示'],



);
###______________________________________________
$mw=MainWindow->new; $mw->title("Better and better QQ_190170444"); $mw->geometry("+200+100");
map{$mw->gridColumnconfigure($_,-minsize=>140)}(0..3); ##col
map{$mw->gridRowconfigure($_,-minsize=>34);}(0..10);   ##row
foreach  (keys %hash) {
	my $text=$hash{$_}[2];
	$wid{$_}=$mw->Button(-text=>$text,-width=>12,-height=>1,-command=>[\&camp,$_],-font=>"courier 11" )->grid(-column=>$hash{$_}[1], -row=>$hash{$_}[0],);
}
#$mw->Button(-text=>'帮助',-width=>14,-height=>1,-command=>[\&camp,$_],-font=>"courier 11" )->grid(-column=>3, -row=>8,);
MainLoop;
###————————————————————————————————————————————————————————————————————————————————————
sub camp {
	my $name=shift; 
	if ($name ne 'panel') {
	    $mw->destroy();
		if (-e "$path/$name.exe") {
	        my $ret=system "$path/$name.exe";
		    print $ret;
	        
		}else{
			print "$path/$name.exe  not exsist";
		}
		exit;	


	}else{
		my $path1=$main::ENV{GENESIS_EDIR};
		my $path2=$main::ENV{GENESIS_DIR};
        $mw->destroy();
		my $ret=system('csh',"$path1/all/scr_start.csh", "$path2/sys/scripts/program/panel/mtlpn");
		print $ret;
		exit;
	}
}




