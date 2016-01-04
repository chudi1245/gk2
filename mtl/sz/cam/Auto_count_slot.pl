#!/usr/bin/perl -w
use Win32;
use Tk;
use Genesis;
use Encode;
use DBD::ODBC;
use Win32::API;
use encoding 'euc_cn';

###________________________________________
$host = shift;
$f = new Genesis;
$JOB  = $ENV{JOB};
$STEP = $ENV{STEP};
###________________________________________
kysy();

$f->INFO(entity_type => 'layer',
         entity_path => "$JOB/pnl/drlslot",
         data_type => 'EXISTS');

$slot_exists = $f->{doinfo}{gEXISTS};
if ($slot_exists eq 'yes') { $f->COM("delete_layer,layer=drlslot"); }
###_________________________________________


my $mw = MainWindow->new;
$mw->geometry("+200+150");
$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
$mw->title("槽孔统计");

$mw->Label(-text => "槽孔大小:",-relief=>'g',-width=>15,-font => [-size => 14],)->grid(-row=>0,-column=>0);
$mw->Label(-text => "槽孔数量:",-relief=>'g',-width=>15,-font => [-size => 14],)->grid(-row=>0,-column=>1);
$mw->Label(-text => "槽孔长度:",-relief=>'g',-width=>15,-font => [-size => 14],)->grid(-row=>0,-column=>2);
$mw->Label(-text => "槽孔数量:",-relief=>'g',-width=>15,-font => [-size => 14],)->grid(-row=>0,-column=>3);

###_________________________________________
$f->COM("units,type=mm");
$f->COM("display_layer,name=drl,display=yes,number=1");
$f->COM("work_layer,name=drl");
$f->COM("flatten_layer,source_layer=drl,target_layer=drlslot");
$f->COM("display_layer,name=drl,display=no,number=2");

$f->COM("display_layer,name=drlslot,display=yes,number=1");
$f->COM("work_layer,name=drlslot");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;surface\;arc\;text");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");
$f->COM("sel_delete");
$f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=r809.852");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");
$f->COM("sel_delete");

$f->COM("open_entity,job=$JOB,type=matrix,name=matrix,iconic=no");
$f->COM("matrix_layer_context,job=$JOB,matrix=matrix,layer=drlslot,context=board");
$f->COM("matrix_layer_type,job=$JOB,matrix=matrix,layer=drlslot,type=drill");
$f->COM("matrix_page_close,job=$JOB,matrix=matrix");


###_________________________________________先统计槽大小与数量
$f->INFO(units => 'mm', 
		 entity_type => 'layer',
         entity_path => "$JOB/pnl/drlslot",
		 );
@drill_list = @{$f->{doinfo}{gSYMS_HISTsymbol}};

my @drill_size;
my $c = 0;
foreach  (@drill_list) {
s/r//;

##$e, $f) = split(/x/,$_);

$_=$_/1000;

$drill_size[$c] = "$_"."mm";
$c++;
}


@drill_numb = @{$f->{doinfo}{gSYMS_HISTline}};
$a= 1;
foreach  (0..$#drill_size) {

$mw->Entry(-background => "white",-textvariable =>\$drill_size[$a-1],-width=>14,-font => [-size => 14],-foreground =>'black')->grid(-row=>$a,-column=>0);
$mw->Entry(-background => "white",-textvariable =>\$drill_numb[$a-1],-width=>14,-font => [-size => 14],-foreground =>'black')->grid(-row=>$a,-column=>1);
	
	$a++;
}
###________________________________________将槽由线转pad.

$f->COM("display_layer,name=drlslot,display=yes,number=1");
$f->COM("work_layer,name=drlslot");
$f->COM("sel_reverse");
$f->COM("chklist_single,action=valor_cleanup_ref_subst,show=yes");
$f->COM("chklist_cupd,chklist=valor_cleanup_ref_subst,nact=1,params=((pp_layer=.affected)(pp_in_selected=All)(pp_tol=0)(pp_rot_mode=One)(pp_connected=Yes)(pp_work=Features)),mode=regular");
$f->COM("chklist_run,chklist=valor_cleanup_ref_subst,nact=1,area=profile");
$f->COM("chklist_close,chklist=valor_cleanup_ref_subst,mode=hide");

###_________________________________________改变槽孔方向。

$f->INFO(units => 'mm', 
		 entity_type => 'layer',
         entity_path => "$JOB/pnl/drlslot",
		 );
@slot_sym = @{$f->{doinfo}{gSYMS_HISTsymbol}};
	foreach  (@slot_sym) {
s/oval//;
($db, $cb) = split(/x/,$_);

if ($db > $cb) {
	$symb = "oval"."$db"."x"."$cb";
$f->COM("feat_hist_open,layer=drlslot,type=features");
$f->COM("filter_set,filter_name=histogram,update_popup=no,active=yes,feat_types=pad,polarity=positive,include_syms=$symb,exclude_syms=,profile=all,dcode=");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=drlslot,filter_name=histogram,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("feat_hist_close,layer=drlslot,type=features");
	($db,$cb)=($cb,$db);
	$symb2 = "oval"."$db"."x"."$cb";
$f->COM("sel_change_sym,symbol=$symb2,reset_angle=no");
   }
   }

###_____________________________________________分别统计槽大小与数量
$f->INFO(units => 'mm', 
		 entity_type => 'layer',
         entity_path => "$JOB/pnl/drlslot",
		 );
@slot_daxiao = @{$f->{doinfo}{gSYMS_HISTsymbol}};

@slot_numb = @{$f->{doinfo}{gSYMS_HISTpad}};
my @slot_size;
my $c = 0;
foreach  (@slot_daxiao) {
s/oval//;
($e, $f) = split(/x/,$_);
$e=$e/1000;
$f=$f/1000;
$slot_size[$c] = "$e"."x"."$f"."mm";
$c++;
}
####______________________________________显示结果
$i= 1;
foreach  (0..$#slot_size){
$mw->Entry(-background => "white",-textvariable =>\$slot_size[$i-1],-width=>14,-font => [-size => 14],-foreground =>'black')->grid(-row=>$i,-column=>2);
$mw->Entry(-background => "white",-textvariable =>\$slot_numb[$i-1],-width=>14,-font => [-size => 14],-foreground =>'black')->grid(-row=>$i,-column=>3);
$i++;}

MainLoop;


=head
####_____________________________________________















