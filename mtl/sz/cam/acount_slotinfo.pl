#!/usr/bin/perl
#!/usr/bin/perl
use Tk;
use FBI;
use Genesis;
use Encode;
###______________
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();
$f->COM('units', type => 'mm');
$f->COM('display_layer', name => 'drl', display => 'yes', number => 1);
$f->COM('work_layer', name => 'drl');
$f->COM('flatten_layer', source_layer => 'drl', target_layer => 'drlslot');
$f->COM('display_layer', name => 'drl', display => 'no', number => 1);
$f->COM('display_layer', name => 'drlslot', display => 'yes', number => 1);
$f->COM('work_layer', name => 'drlslot');
$f->COM('filter_set', filter_name  => 'popup',
                    update_popup => 'no',
                    feat_types   => 'pad;surface;arc;text');
$f->COM('filter_area_strt');
$f->COM('filter_area_end', layer          => '',
                         filter_name    => 'popup',
                         operation      => 'select',
                         area_type      => 'none',
                         inside_area    => 'no',
                         intersect_area => 'no',
                         lines_only     => 'no',
                         ovals_only     => 'no',
                         min_len        => 0,
                         max_len        => 0,
                         min_angle      => 0,
                         max_angle      => 0);
$f->COM('filter_reset', filter_name => 'popup');
$f->COM('sel_delete');
$f->COM('filter_set', filter_name  => 'popup',
                    update_popup => 'no',
                    include_syms => 'r809.85');
$f->COM('filter_area_strt');
$f->COM('filter_area_end', layer          => '',
                         filter_name    => 'popup',
                         operation      => 'select',
                         area_type      => 'none',
                         inside_area    => 'no',
                         intersect_area => 'no',
                         lines_only     => 'no',
                         ovals_only     => 'no',
                         min_len        => 0,
                         max_len        => 0,
                         min_angle      => 0,
                         max_angle      => 0);
$f->COM('filter_reset', filter_name => 'popup');
$f->COM('sel_delete');


$f->COM('info',  out_file => 'C:/tmp/slot_info',
                units     => 'mm',
                args      => "  -t layer -e $JOB/pnl/drlslot -m display -d SLOT_HIST",);


my %slot_info;
open (FILES, "C://tmp//slot_info");
@slotlist=<FILES>;
close(FILES);

foreach $slot (@slotlist){
($width,$b,undef,$count) = split(' ',$slot);

$width =~ s/r//; $width=sprintf "%4.2f",$width/1000;  
$long=sprintf "%4.2f" ,($width + $b);

##print "$long\n";
$size = "$width"."x"."$long";

if ( exists $slot_info{$size} ) { 
     $slot_info{$size} = $slot_info{$size} + $count; 
}else{
	 $slot_info{$size}=$count;
 }


}

while (($key,$value) = each %slot_info) {$str="$str" . "$key->$value: "}

$f->PAUSE($str);



=head



=head
@tol_list=qw(¡À  ¡À0.05  ¡À0.05  ¡À0.08  ¡À0.1  ¡À0.15  ¡À0.2) ;
(GoodsCode, WorkCenterCode,ParaType, ParaQty1, Tolerance, CutleDia, ParaQty, Unthread, NPTH, Memo) 
µµ°¸ºÅ       W22,W36       µ¶¾ßºÅ    ³ÉÆ·¿×¾¶  ¹«²î       µ¶¾ß¿×¾¶  ¿×Êý     ×ê²Û      NPTH  ±¸×¢
#$dbh->do("default-character-set=gbk");
#$dbh->do("SET character_set_connection=gbk");
#$dbh->do("SET character_set_results='gbk'");
		(GoodsCode,WorkCenterCode,ParaType,Tolerance,CutleDia)   values 
		($GoodsCode,$WorkCenterCode,$ParaType,$Tolerance,$CutleDia)\; 

1;¡À
	(GoodsCode,WorkCenterCode,ParaType,ParaQty1,Tolerance,CutleDia,ParaQty,Unthread,NPTH,Memo) values 
	($GoodsCode,$WorkCenterCode,$ParaType,$ParaQty1,$Tolerance,$CutleDia,$ParaQty,$Unthread,$NPTH,$Memo)\;



###2012.10.10
#use encoding "utf8";
#foreach  (0..$#CutleDia) {

#	if ($CutleDia[$_] < 0.85) {
#       $Tolerance[$_] = "¡À0.076";
#		}elsif($CutleDia[$_] < 1.65) {
#		 $Tolerance[$_] = "¡À0.10";
#		}else{ $Tolerance[$_] = "¡À0.15";  
#	}
#}
#no encoding "utf8";

}

###_____________ @ParaQty1         else{$ParaQty1[$a] =' '}   #$f->PAUSE($CutleDia[$_]);
#foreach  (0..$#drill_size) {	
#	$finish{$drill_size[$_]}[0] = $finish_size[$_];
#	$finish{$drill_size[$_]}[1] = $drill_type[$_];
#}





=head

