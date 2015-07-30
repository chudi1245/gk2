use strict;
package DATA_NAME;
our %data_name =(
    ##name                numb    cn_naeme,         state   use  str_  end_time  rsult
    new_rename           =>[1,  '层重命名',          1,     undef, undef, undef, undef, '#009900',],
	register_layers      =>[2,  '层对齐',            1,     undef, undef, undef, undef, '#009900',],
	creat_profile        =>[3,  '创建虚拟框',        1,     undef, undef, undef, undef, '#009900',],
	move_zero            =>[4,  '归零点',            1,     undef, undef, undef, undef, '#009900',],
	d_size               =>[5,  '导入孔信心',        1,     undef, undef, undef, undef, '#009900',],
	auto_rows            =>[6,  '层排序',            1,     undef, undef, undef, undef, '#009900',],
	add_attribute        =>[7,  '添加孔孔属性',      1,     undef, undef, undef, undef, '#009900',],
	del_duplicate_drill  =>[8,  '去重孔',            1,     undef, undef, undef, undef, '#009900',],
	del_nfp              =>[9,  '去无用pad',         1,     undef, undef, undef, undef, '#009900',],
	creat_pcb            =>[10, '创建PCB-STEP',      1,     undef, undef, undef, undef, '#009900',],
	del_outprof          =>[11, '删除虚拟框外物',    1,     undef, undef, undef, undef, '#009900',],
	del_out_by_box       =>[12, '选择外形线',        1,     undef, undef, undef, undef, '#009900',],
	out_to_drill         =>[13, '外形圈转孔',        1,     undef, undef, undef, undef, '#009900',],
	circuitry_repair     =>[14, '线路补偿',          1,     undef, undef, undef, undef, '#009900',],
	add_lead_drill       =>[15, '槽加引孔',          1,     undef, undef, undef, undef, '#009900',],
	cop_orig             =>[16, '复制ORIG-STEP',     1,     undef, undef, undef, undef, '#009900',],
	compair              =>[17, '层比对',            1,     undef, undef, undef, undef, '#009900',],
    net_analyzer         =>[18, '网络比对',          1,     undef, undef, undef, undef, '#009900',],
	optimize_levels      =>[19, '叠层优化',          1,     undef, undef, undef, undef, '#009900',],
	sub_panel            =>[20, '工艺边拼版',        1,     undef, undef, undef, undef, '#009900',],
	panel                =>[21, '拼版',              1,     undef, undef, undef, undef, '#009900',],
	mark_line_width      =>[22, '标记最小线宽',      1,     undef, undef, undef, undef, '#009900',],
    creat_dd_map         =>[23, '创建分孔图',        1,     undef, undef, undef, undef, '#009900',],
	creat_print_ss       =>[24, '制作字符打印文件',  1,     undef, undef, undef, undef, '#009900',],
    impedance            =>[25, '阻抗条制作',        1,     undef, undef, undef, undef, '#009900',],
	ADM                  =>[26, '钻带输出',          1,     undef, undef, undef, undef, '#009900',],
	output               =>[27, '菲林输出',          1,     undef, undef, undef, undef, '#009900',],
	write_me             =>[28, '写ME文件',          1,     undef, undef, undef, undef, '#009900',],
	del_tmp_layer        =>[29, '删除临时层',        1,     undef, undef, undef, undef, '#009900',],
	display_week         =>[30, '查看周期表',        1,     undef, undef, undef, undef, '#009900',],
	erp_insert_drill     =>[31, 'ERP钻孔',           1,     undef, undef, undef, undef, '#009900',],
);

1;



