#!/usr/bin/perl

my %hash =(
   	new_rename           =>[1, 0,'��������'],
	creat_profile        =>[2, 0,'��profile'],
	move_zero            =>[3, 0,'�����'],
	register_layers      =>[4, 0,'�Զ������'],
	auto_rows            =>[5, 0,'�Զ�������'],
	d_size               =>[6, 0,'���������Ϣ'],
	add_attribute        =>[7, 0,'��������'],
	del_out_by_box       =>[8, 0,'ѡ��������'],	
	creat_pcb            =>[9, 0,'����pcb'],
    auto_inport_job		 =>[10,0,'�Զ���tgz'],
	Shave_copper         =>[11,0,'�Զ���ͭ'],
    close_and_exit       =>[12,0,'�ر��˳�'],

	open_pcb             =>[1, 1,'open_pcb'],
	out_to_drill         =>[2, 1,'����Ȧת��'],
	slot_to_box          =>[3, 1,'��/��ת����'],
	rev_drill            =>[4, 1,'У����ƫ'],
	check_drill          =>[5, 1,'��׼��'],
	add_lead_drill       =>[6, 1,'������'],
    select_drawn         =>[7, 1,'ѡ��ͭƤ'],
    del_nfp              =>[8, 1,'ȥ����pad'],
	del_outprof          =>[9, 1,'ɾout_prof'],	
	scal                 =>[10,1,'�ַ�����'],
	display_week         =>[11,1,'�鿴����'],
	add_mark             =>[12,1,'�ӱ��'],

	open_orig            =>[1, 2,'open_orig'],			
	sub_panel            =>[2, 2,'pcsƴ��'],	
    impedance            =>[3, 2,'���迹��'],
	creat_dd_map         =>[4, 2,'�ֿ�ͼ����'],    
	size_label           =>[5, 2,'��ע�ߴ�'],	
	add_chinese          =>[6, 2,'�������'],
	panle_calculate      =>[7, 2,'����������'],
	panel_new            =>[8, 2,'��ʽƴ��'], 		
	mark_line_width      =>[9, 2,'����С�߿�'],
	mdgj_no_scale        =>[10,2,'md_gj������'],
	add_Corner_drl       =>[11,2,'�Ӱ�ǿ�'],
	add_vut_hole         =>[12,2,'��VUT��'],

	open_panel           =>[1, 3,'open_pnl'],		
	write_me             =>[1, 3,'дME�ļ�'],	
	output               =>[2, 3,'�������'],
	ADM                  =>[3, 3,'������'],	
    new_print_ss         =>[4, 3,'�´�ӡ�ַ�'],
	new_print_old        =>[5, 3,'�ɴ�ӡ�ַ�'],
	calcu_gold_area      =>[6, 3,'�������'],
	areatk               =>[7, 3,'���ͭ��'],
#	acount_slot          =>[8, 3,'�ۿ�ͳ��'],
    output_film          =>[9, 3,'��������'],  	
	add_qiepian          =>[11,3,'����Ƭ��'],
	auto_rout            =>[12,3,'��cy���'],
	del_tmp_layer        =>[10,3,'ɾ��++orig'],
	 

	open_pcs             =>[1, 4,'open_pcs'],	
	erp_base_info        =>[2, 4,'erp������Ϣ'],
	erp_insert_drill     =>[3, 4,'erp���ָʾ'],
	erp_insert_film      =>[4, 4,'erp����ָʾ'],
	input_pcb            =>[5, 4,'input_pcb'],
	copy_net_orig 	     =>[6, 4,'����ori_net'],
    copy_net_pcb         =>[7, 4,'����pcb-net'],	
   	negative_to_positive =>[8, 4,'��Ƭת��Ƭ'],		
	negative_tidy        =>[9, 4,'��Ƭ����'],	
	Auto_shrink_cu		 =>[10,4,'�Զ���ͭ'],
	net_analyzer         =>[11,4,'�������'],
	output_vut           =>[12,4,'���vut'],
	
	cop_orig             =>[1, 5,'����orig'],
	compair              =>[2, 5,'�ȶ�ԭ��'],	
	auto_to__surface     =>[3, 5,'�Զ�תͭƤ'],	
	line_2_pad           =>[4, 5,'��תpad'],
	checklists           =>[5, 5,'����б�'],	
    vut					 =>[6, 5,'VUT��ͭ'],	
	gold_finger			 =>[7, 5,'����ָб��'],	
    message				 =>[8, 5,'���õ绰'],
    Delete_ff_file	     =>[9, 5,'ɾ��������'],
    test_job			 =>[10,5,'����JOB'],
	save                 =>[11,5,'�����ļ�'],	
	ftp_put_engbak       =>[12,5,'�ϴ�����'],

);


my @keys = keys %hash;
my $plPath = "C:/genesis/sys/scripts/g2k/mtl/sz/cam/";

foreach  my $file (@keys) {
	my $plFile = $plPath.$file.".pl";
	my $exeFile = $plPath.$file.".exe";
	system("perlapp -add Socket -add shellwords.pl -add Encode::CN $plFile");
	#system("mv $exeFile D:/exe/");

	print "$plFile to $exeFile is ok!\n";
}





















