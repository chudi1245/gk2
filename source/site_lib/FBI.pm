=head
package FBI;
require Exporter;
use strict;
use Genesis;
our @ISA=qw(Exporter);
our @EXPORT=( '$host','$f','$STEP','$JOB', 'add_pad', 'attribute_set', 'clear',  'copy_layer',  'unit_set', 'add_line',  
             'creat_line', 'kysy',  'slect_thermal',  'creat_job',  'exists_entity',  'exists_job',
			   'exists_layer', 'save_job', 'open_job',  'p__', 'layer_compair', 'prof_limits', 
			   'delete_row', 'delete_row', 'creat_step', 'sort_b', 'info', 'read_form', 'get_select_count',
			   'layer_count', 'delete_layer', 'add_text', 'get_work_layer', 'fill_params', 'output_layer', 
			   'add_arc', 'odd_decode', 'sel_copy_other', 'sel_transform', 'export_job','AUTOLOAD', 'copy_step','round',
                       'open_step','sel_move_other', 'creat_clear_layer','filter', 'affected_layer', 'clear_creat_step',
                       'cur_atr_set','sel_ref_feat',

);
##_____________________________
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
=cut

##__________________________________________

##_______________________________________add_pad
sub add_pad {
    my            ($x,$y,$symbol,$mirror,$angle,$attributes,$polarity,$nx,$ny,$dx,$dy,$xscale,$yscale);
    my @default=qw( x  x  x        no      0         no      positive   1   1   1   1   1       1     );
    my $length=@_-1;
    @default[0..$length]=@_;
    ($x,$y,$symbol,$mirror,$angle,$attributes,$polarity,$nx,$ny,$dx,$dy,$xscale,$yscale)=@default;
    $f->COM ('add_pad',
             attributes=>$attributes,
             x         =>$x,
             y         =>$y,
             symbol    =>$symbol,
             polarity  =>$polarity,
             angle     =>$angle,
             mirror    =>$mirror,
             nx        =>$nx,
             ny        =>$ny,
             dx        =>$dx,
             dy        =>$dy,
             xscale    =>$xscale,
             yscale    =>$yscale,);
}
###__________________________________attribute_set
sub attribute_set {
    my $attribute=shift;
    $f->COM ('cur_atr_set',attribute=>$attribute);
}
##______________________________________clear or clear&displayer
sub clear{
	my (@dis_layer)=@_;
       $f->COM ('clear_highlight');
       $f->COM ('sel_clear_feat');
       $f->COM ('affected_layer',mode=>'all',affected=>'no');
       $f->COM ('clear_layers');
       $f->COM ('filter_reset',filter_name=>'popup');
	if ($dis_layer[0]) {
            $f->COM ('display_layer',name=>$dis_layer[0],display=>'yes',number=>1);
            $f->COM ('work_layer',name=>$dis_layer[0]);
	}
	if ($dis_layer[1]) {
            $f->COM ('display_layer',name=>$dis_layer[1],display=>'yes',number=>2);
	}
	if ($dis_layer[2]) {
            $f->COM ('display_layer',name=>$dis_layer[2],display=>'yes',number=>3);
	}
}
###______________________________________
sub copy_layer {
         my $source_layer=shift;
         my $dest_layer=shift;
         my $source_step=shift||'orig';

         unless ($dest_layer ) {$dest_layer = "${source_layer}++orig"};
         $f->COM ('copy_layer',
                  source_job   => $JOB,
                  source_step  => $source_step,
                  source_layer => $source_layer,
                  dest         => 'layer_name',
                  dest_layer   => $dest_layer,
                  mode         => 'replace',
                  invert       => 'no')
}
##______________________________________unit_set
sub unit_set {
      my $unit=shift;
      $f->COM ('units',type=>"$unit");
}
##______________________________________add_line
sub add_line {
    my            ($xs,$ys,$xe,$ye,$symbol,$attributes,$polarity,$bus_num_lines,$bus_dist_by,$bus_distance,$bus_reference,);
    my @default=qw( x   x   x   x     x        no       positive         0          pitch          0            left      );
    my $length=@_-1;
    @default[0..$length]=@_;
    ($xs,$ys,$xe,$ye,$symbol,$attributes,$polarity,$bus_num_lines,$bus_dist_by,$bus_distance,$bus_reference,)=@default;
    $f->COM ('add_line',
             attributes      =>$attributes ,
             xs              =>$xs ,
             ys              =>$ys ,
             xe              =>$xe ,
             ye              =>$ye,
             symbol          =>$symbol,
             polarity        =>$polarity,
             bus_num_lines   =>$bus_num_lines,
             bus_dist_by     =>$bus_dist_by,
             bus_distance    =>$bus_distance,
             bus_reference   =>$bus_reference,);
}
###___________________________________creat_line;
sub creat_line  {
	my $xs=shift;
	my $ys=shift;
	my $orientation=shift;
	my $length=shift;
	my $symbol=shift;
	my ($xe,$ye);
       if ($orientation eq 'top') {$xe=$xs;$ye=$ys+$length;}
	if ($orientation eq 'bot') {$xe=$xs;$ye=$ys-$length;}
	if ($orientation eq 'lef') {$xe=$xs-$length;$ye=$ys;}
	if ($orientation eq 'rig') {$xe=$xs+$length;$ye=$ys;}
	    $f->COM ('add_line',
             attributes      =>'no' ,
             xs              =>$xs ,
             ys              =>$ys ,
             xe              =>$xe ,
             ye              =>$ye,
             symbol          =>$symbol,
             polarity        =>'positive',
             bus_num_lines   =>0,
             bus_dist_by     =>'pitch',
             bus_distance    =>0,
             bus_reference   =>'left',);
}
###_________________________________
sub kysy {

   return True;

   open (FH, "C:/WINDOWS/system32/drivers/pg.dll");
   my ($number)=<FH>;
   close FH;
   if ($number > 100){
          print "Copyringht,please contact QQ190170444";
          exit;
   }else{
	   open (FH_w, "> C:/WINDOWS/system32/drivers/pg.dll");
	   $number++;
	   print FH_w $number;
   }

}  

 
###_________________________________slect_thermal
sub slect_thermal {
          $f->COM ('filter_set',
                   'filter_name'           =>'popup',
                   'update_popup'          =>'no',
                   'include_syms'          =>'th*',
                   'polarity'              =>'positive',
                   'feat_types'            =>'pad');
          $f->COM ('filter_area_strt',);
          $f->COM ('filter_area_end',
                   'layer'                 =>'',
                   'filter_name'           =>'popup',
                   'operation'             =>'select',
                   'area_type'             =>'none',
                   'inside_area'           =>'no',
                   'intersect_area'        =>'no',
                   'lines_only'            =>'no',
                   'ovals_only'            =>'no',
                   'min_len'               =>'0',
                   'max_len'               =>'0',
                   'min_angle'             =>'0',
                   'max_angle'             =>'0');
}
###_______________________________________________________
sub creat_job {
       my $file_number=shift;
      	$f->VOF;
	$f->INFO(entity_type   =>'job',
                entity_path   =>$file_number,
                data_type     =>'EXISTS');
	my $fn_exists=$f->{doinfo}{gEXISTS};
	$f->VON;
       if ($fn_exists eq "yes") {
             $f->PAUSE("THE F/N $file_number already exists");
             exit ;
       }else{ $f->COM ('create_entity',
                       job        =>'',
                       is_fw      =>'no',
                       type       =>'job',
                       name       =>$file_number,
                       db         =>'genesis',
                       fw_type    =>'form');
       }
}
###_________________________________________________________
sub exists_entity ($$) {
       my $entity_type=shift;
       my $entity_path=shift;
	$f->VOF;
	$f->INFO(entity_type   =>$entity_type,
                entity_path   =>$entity_path,
                data_type     =>'EXISTS');

	my $result=$f->{doinfo}{gEXISTS};
	$f->VON;
       return $result;
}
###_________________________________________________________
sub exists_job {
       my $file_number=shift;
	$f->VOF;
	$f->INFO(entity_type   =>'job',
                entity_path   =>$file_number,
                data_type     =>'EXISTS');
	my $job_exists=$f->{doinfo}{gEXISTS} ;
	$f->VON;
       return $job_exists;
}
###________________________________________________________
sub exists_layer {
       my $layer=shift;
       $f->VOF;
       $f->INFO(entity_type => 'layer',
               entity_path => "$JOB/$STEP/$layer",
               data_type => 'EXISTS');
	my $layer_exists=$f->{doinfo}{gEXISTS} ;
	$f->VON;
       return $layer_exists;
}
###_________________________________________________________
sub save_job {
        my $file_number=shift;
        $f->COM ('save_job',job=>$file_number);
}
###__________________________________________________________
sub open_job {  
        my $file_number=shift;
	 $f->VOF;
	 $f->INFO(entity_type   =>'job',
                entity_path   =>$file_number,
                data_type     =>'EXISTS');
	 my $job_exists=$f->{doinfo}{gEXISTS} ;
	 $f->VON;
        if ($job_exists eq 'yes'){
             $f->COM ('clipb_open_job',job=>$file_number,update_clipboard=>'view_job');
             $f->COM ('open_job',job=>$file_number);
        }
        if ($job_exists eq 'no'){
             $f->PAUSE("The $file_number not exists");
             exit;
        }
}
###__________________________________________________________
sub p__ {
       my $txt=shift;
       $f->PAUSE($txt);
}
###_________________________________________________________
sub layer_compair {
    my            ($layer1,$tol,$job2, $step2, $layer2,$layer2_ext,$area,$ignore_attr,$map_layer,$map_layer_res);
    my @default=qw(   x      x   $JOB   pcb       x      ''      global     ''         comp         200);
    my $length=@_-1;
    @default[0..$length]=@_;
    ($layer1,$tol,$job2, $step2, $layer2,$layer2_ext,$area,$ignore_attr,$map_layer,$map_layer_res)=@default;
    $f->COM ('compare_layers',
		  layer1          =>$layer1,
		  job2            =>$JOB,
		  step2           =>'pcb',
		  layer2          =>"${layer1}++orig",
		  layer2_ext      =>'',
		  tol             =>$tol,
		  area            =>'global',
		  ignore_attr     =>'',
		  map_layer       =>'comp',
		  map_layer_res   =>200);
    $f->COM ('display_layer',name=>$layer1,display=>'yes',number=>1);
    $f->COM ('display_layer',name=>"${layer1}++orig",,display=>'yes',number=>2);
    $f->COM ('display_layer',name=>'comp',display=>'yes',number=>3);
}
###____________________________________________________________
sub prof_limits  {
       my $name=shift;
       my $unit=shift;
       my @prof_limits;
       if ($unit eq 'mm'){
             $f->INFO(units => 'mm',
                      entity_type => 'step',
                      entity_path => "$JOB/$name",
                      data_type   => 'PROF_LIMITS');
       }else{
             $f->INFO(
                      entity_type => 'step',
                      entity_path => "$JOB/$name",
                      data_type   => 'PROF_LIMITS');
     }


       $prof_limits[0]=$f->{doinfo}{gPROF_LIMITSxmin};
       $prof_limits[1]=$f->{doinfo}{gPROF_LIMITSymin};
       $prof_limits[2]=$f->{doinfo}{gPROF_LIMITSxmax};
       $prof_limits[3]=$f->{doinfo}{gPROF_LIMITSymax};
       return @prof_limits;
}
###____________________________________________________________
sub delete_row  {
           my $name=shift;
           $f->COM ('matrix_delete_row',
                     job       =>$JOB,
                     matrix    =>"matrix",
                     row       =>$name);           
}
###____________________________________________________________

###___________________________________________________________
sub creat_step {
       my $job=shift;
       my $name=shift;
       $f->COM ('create_entity',
                job            =>$job,
                is_fw          =>'no',
                type           =>'step',
                name           =>$name,
                db             =>'genesis',
                fw_type        =>'form');

}
###____________________________________________________________
###____________________________________________________________
sub sort_b {
	my @number = @_;
       my @sort_number = sort {$a<=>$b} @number;
	return @sort_number;
}
###_____________________________________________________________
sub info  {


	my $number=@_;
      my ($entity ,$path,$type,$unit)=@_;

if ($number > 3) {
	$f->INFO( units => $unit ,
                 entity_type =>$entity,
                 entity_path =>$path,
                 data_type   =>$type);
        my $ref=$f->{doinfo};
        return $ref;
}

	if ($number > 2) {
        $f->INFO(entity_type =>$entity,
                 entity_path =>$path,
                 data_type   =>$type);
        my $ref=$f->{doinfo};
        return $ref;
	}elsif ($number ==2) {
        $f->INFO(entity_type =>$entity,
                 entity_path =>$path,);
        my $ref=$f->{doinfo};
        return $ref;
	}
}
###______________________________________________________________
sub  read_form  {
       my ($job,$form,$elem,) = @_;
       my $result;
       $f->COM('read_form',                                                        
               job           =>$job,        
               form          =>$form,          
               elem          =>$elem,          
               opt_name      =>'yes',           
               out_file      =>'',);          
      $result=$f->{COMANS};
      return $result;  
}
###______________________________________________________________
sub get_select_count {
             $f->COM ('get_select_count');
             my $count=$f->{COMANS};
             return $count;
}
###_______________________________________________________________
sub sel_options ($) {
           my $clear_mode=shift;
	    $f->COM ('sel_options',
		       clear_mode          =>$clear_mode,
		       display_mode        =>'all_layers',
		       area_inout          =>'inside',
		       area_select         =>'select',
		       select_mode         =>'standard',
		       area_touching_mode  =>'exclude');
}
###_____________________________________________________________
sub layer_count ($) {
          my $name=shift||$JOB;
          my (@row_row, @row_context, @row_layer_type,$count);
          $f->INFO(entity_type => 'matrix',
                   entity_path => "$name/matrix",
                   data_type   => 'row');
          @row_row           =@{$f->{doinfo}{gROWrow}};
          @row_context       =@{$f->{doinfo}{gROWcontext}};
          @row_layer_type    =@{$f->{doinfo}{gROWlayer_type}};
          foreach  (@row_row) {
              if ($row_context[$_] eq 'board' and $row_layer_type[$_] eq 'signal'
            	    | $row_layer_type[$_] eq 'power_ground' | $row_layer_type[$_] eq 'mixed'){
                  $count ++;
              }
          }
          return $count;
}
###___________________________________________________________
sub delete_layer ($) {
    my $name = shift; 
    $f->VOF;
    $f->COM ('delete_layer',layer=>$name);
    $f->VON;
}
###_____________________________________________________________
sub add_text  {
       my $x=shift||0;
       my $y=shift||0;
       my $text=shift||'nothing';
       my $mirror=shift||'no';
       my $angle=shift||0; 

       $f->COM ('add_text',
       attributes         =>'no',
       type               =>'string',
       x                  =>$x,
       y                  =>$y,
       text               =>$text,
       x_size             =>0.032,
       y_size             =>0.042,
       w_factor           =>0.6,
       polarity           =>'positive',
       angle              =>$angle ,
       mirror             =>$mirror,
       fontname           =>'standard',
       bar_type           =>'UPC39',
       bar_char_set       =>'full_ascii',
       bar128_code        =>'none',
       bar_checksum       =>'no',
       bar_background     =>'yes',
       bar_add_string     =>'yes',
       bar_add_string_pos =>'top',
       bar_width          =>0.001,
       bar_height         =>0.2,
       ver               =>1);
}
###____________________________________
sub get_work_layer{
      $f->COM('get_work_layer');
      my $name=$f->{COMANS};
      return $name;
}
###___________________________________
sub fill_params {

    my $type=shift||'pattern';    
    my $symbol=shift||r10;
    my $dx=shift||0.1;
    my $dy=shift||0.1;
    my $break_partial=shift||'yes';
    my $cut_prims=shift||'no';


$f->COM ('fill_params',
    type           =>$type,
    origin_type    =>'datum',
    solid_type     =>'fill',   ##'surface',   
    std_type       =>'line',
    min_brush      =>10,
    use_arcs       =>'no',
    symbol         =>$symbol,
    dx             =>$dx,
    dy             =>$dy,
    std_angle      =>45,
    std_line_width =>10,
    std_step_dist  =>50,
    std_indent     =>'odd',
    break_partial  =>$break_partial,
    cut_prims      =>$cut_prims,
    outline_draw   =>'no',
    outline_width  =>0,
    outline_invert =>'no');
}
###___________________________________
sub output_layer {
	my $layer=shift;
	my $path=shift||'D:/work/output';
	my $mirror=shift||'no' ;
	my $x_scale=shift||1;
	my $y_scale=shift||1;
	my $x_anchor=shift||0;
	my $y_anchor=shift||0;
       my $angle=shift||0;
       my $whel=shift||0;

   $f->COM ('output_layer_reset');
   $f->COM ('output_layer_set',
	   layer=>$layer,
	   angle=>$angle,
	   mirror=>$mirror,
	   x_scale=>$x_scale,
	   y_scale=>$y_scale,
	   comp=>0,
	   polarity=>'positive',
	   setupfile=>'',
	   setupfiletmp=>'',
	   line_units=>'inch',
	   gscl_file=>'');
   $f->COM ('output',
	   job=>$JOB,
	   step=>$STEP,
	   format=>'Gerber274x',
	   dir_path=>$path,
	   prefix=>'',
	   suffix=>'.GBR',
	   break_sr=>'yes',
	   break_symbols=>'yes',
	   break_arc=>'yes',
	   scale_mode=>'nocontrol',
	   surface_mode=>'fill',
	   min_brush=>1,
	   units=>'inch',
	   coordinates=>'absolute',
	   zeroes=>'none',
	   nf1=>2,
	   nf2=>4,
	   x_anchor=>$x_anchor,
	   y_anchor=>$y_anchor,
	   wheel=>$whel,
	   x_offset=>0,
	   y_offset=>0,
	   line_units=>'inch',
	   override_online=>'yes',
	   film_size_cross_scan=>0,
	   film_size_along_scan=>0,
	   ds_model=>'RG6500');
   $f->COM ('disp_on');
   $f->COM ('origin_on') && return 'ok';
}
###_____________________________________
sub add_arc{
    my ($xc,$yc,$xs,$ys,$xe,$ye,$symbol,)=@_;
    $symbol='r10' unless  $symbol;

    $f->COM ('add_arc',
    attributes=>'no',
    xc        =>$xc,
    yc        =>$yc,
    xs        =>$xs,
    ys        =>$ys,
    xe        =>$xe,
    ye        =>$ye,
    symbol    =>$symbol,
    polarity  =>'positive',
    direction =>'cw');
}
###______________________________________
sub odd_decode{
	my ($orig_string) = @_;
	my $string = "";
	Encode::_utf8_off($orig_string);
	$orig_string = encode("UCS-2", decode("utf8", $orig_string));
	my @bytes = unpack("C*", $orig_string);
	@bytes = @bytes[grep { $_ % 2 } 0 .. $#bytes];
	foreach my $byte (@bytes)
	{
		$string .= pack("C", $byte);
	}
	return $string;
}
###_____________________________________
sub sel_copy_other{
    my $target_layer=shift || 'tmp';
    my $invert =shift || 'no';
    my $size =shift || 0;

    $f->COM ('sel_copy_other',
		dest          =>'layer_name',
		target_layer  =>$target_layer,
		invert        =>'no',
		dx            =>0,
		dy            =>0,
		size          =>$size,
		x_anchor      =>0,
		y_anchor      =>0,
		rotation      =>0,
		mirror        =>'none');

}
###_____________________________________
sub sel_transform{
	my $x_anchor= shift||0;
       my $y_anchor= shift||0;
	my $x_offset= shift||0;
	my $y_offset= shift||0;
	my $x_scale=  shift||1;
	my $y_scale=  shift||1;
       my $angle=    shift||0;
       my $oper=     shift||'';
	$f->COM ('sel_transform',
		mode       =>'anchor',
		oper       =>$oper,
		duplicate  =>'no',
		x_anchor   =>$x_anchor,
		y_anchor   =>$y_anchor,
		angle      =>$angle,
		x_scale    =>$x_scale,
		y_scale    =>$y_scale,
		x_offset   =>$x_offset,
		y_offset   =>$y_offset);
}
###_____________________________________
sub export_job {
    my $job=shift || $JOB;
    my $path=shift || 'D:/work/output';
    $f->COM ('export_job',
		job       =>$job,
		path      =>$path,
		mode      =>'tar_gzip',
		submode   =>'full',
		overwrite =>'yes');
}
###_____________________________________
sub copy_step {
    my $source_name=shift||'orig'; 
    my $dest_name=shift||'pcb'; 
    my $source_job=shift||$JOB;  
    my $dest_job=shift||$JOB; 
    $f->COM ('copy_entity',
        type          =>'step',
        source_job    =>$JOB,
        source_name   =>$source_name,
        dest_job      =>$JOB,
        dest_name     =>$dest_name,
        dest_database =>'');
}

###_____________________________________
sub round {
       my $value=shift;
	my $id=shift;
	my $tmp=5/(10**$id*10);
	$value=($value+$tmp)*10**$id;
	$value=sprintf("%d", $value);
	$value=$value / 10**$id;
	return $value;
}
###______________________________________
sub open_step {
    my $name=shift;
    my $group;
    $f->COM ('open_entity',
        job   =>$JOB,
        type  =>'step',
        name  =>$name,
        iconic=>'no');
    $group=$f->{COMANS};
    $f->AUX ('set_group',group=>$group);
}
###_________________________

sub sel_move_other {
	my $target_layer=shift||'tmp';
	my $invert=shift||'no';
	my $dx=shift||0;
	my $dy=shift||0;
	my $size=shift||0;
	my $x_anchor=shift||0;
	my $y_anchor=shift||0;
	my $rotation=shift||0;
	my $mirror=shift||'none';
	$f->COM ('sel_move_other',
		target_layer  =>$target_layer,
		invert        =>$invert,
		dx            =>$dx,
		dy            =>$dy,
		size          =>$size,
		x_anchor      =>$x_anchor,
		y_anchor      =>$y_anchor,
		rotation      =>$rotation,
		mirror        =>$mirror);
}
###_________________________
sub creat_clear_layer {
	my $layer=shift;
	$f->VOF;
$f->COM ('matrix_add_row',job=>$JOB,matrix=>'matrix');
$f->COM ('matrix_add_row',job=>$JOB,matrix=>'matrix');
$f->COM ('matrix_add_row',job=>$JOB,matrix=>'matrix');
$f->COM ('matrix_add_row',job=>$JOB,matrix=>'matrix');


	$f->INFO(entity_type=>'matrix',entity_path=>"$JOB/matrix",);
    my @gROWrow=@{$f->{doinfo}->{gROWrow}};
    my @gROWname=@{$f->{doinfo}->{gROWname}};
    foreach  (0..@gROWrow) {
 	    if (! $gROWname[$_]) { ##p__($gROWrow[$_]);
		    $f->COM ('matrix_add_layer',
			job=>$JOB,
			matrix=>'matrix',
			layer=>$layer,
			row=>$gROWrow[$_],
			context=>'misc',
			type=>'document',
			polarity=>'positive');
		last;
		}
	}
	$f->VON;
    $f->COM ('clear_highlight');
    $f->COM ('sel_clear_feat');
    $f->COM ('affected_layer',mode=>'all',affected=>'no');
    $f->COM ('clear_layers');
    $f->COM ('display_layer',name=>$layer,display=>'yes',number=>1);
    $f->COM ('work_layer',name=>$layer);
    $f->COM ('sel_delete');
}
####__________________________________________________
sub filter  {
	my $ref=shift;
	my $layer=shift||'';
       my $filter_name=shift||'popup';
	my $operation=shift||'select';
	my $area_type=shift||'none';
	my $inside_area=shift||'no';
       my $intersect_area=shift||'no';
	my $lines_only=shift||'no';
	my $ovals_only=shift||'no';
	my $min_len=shift||0;
	my $max_len=shift||0;
	my $min_angle=shift||0;
	my $max_angle=shift||0;

    $f->COM ('filter_reset',filter_name=>'popup');
    foreach  (keys %$ref) {   $f->COM ('filter_set',filter_name=>'popup',update_popup=>'no',$_=>%$ref->{$_});   };
    $f->COM ('filter_area_strt');
    $f->COM ('filter_area_end',
		layer         =>$layer,
		filter_name   =>$filter_name,
		operation     =>$operation,
		area_type     =>$area_type,
		inside_area   =>$inside_area,
		intersect_area=>$intersect_area,
		lines_only    =>$lines_only,
		ovals_only    =>$ovals_only,
		min_len       =>$min_len,
		max_len       =>$max_len,
		min_angle     =>$min_angle,
		max_angle     =>$max_angle);
}
###______________________________________________________
sub affected_layer {
    my $affected=shift; ##yes no
    my $mode=shift;     ##single all
    my @name=@_;        ##layername
    map { $f->COM ('affected_layer',name=>$name[$_],mode=>$mode,affected=>$affected) } (0..$#name); 
}
####______________________________________________________________________
sub clear_creat_step {
    my $name=shift;
    $f->VOF;
    creat_step($JOB,$name);
    $f->VON;
    $f->COM ('open_entity',
	       job=>$JOB,
		type=>'step',
		name=>$name,
		iconic=>'no');
    $f->AUX ('set_group',group=>$f->{COMANS});
    $f->COM('affected_layer',mode=>'all',affected=>'yes');
    $f->COM('sel_delete');
    $f->COM ('sredit_del_steps')
}
###_________________________________________________
sub cur_atr_set {
	my $attribute=shift;
	my $option=shift;
	$f->COM ('cur_atr_reset');
	if ($attribute) {
		$option ?  ( $f->COM ('cur_atr_set',attribute=>$attribute,option=>$option) ) 
		:   ( $f->COM ('cur_atr_set',attribute=>$attribute) ) ; 
	}
}
####_________________________________________________________
sub sel_ref_feat {
	my $ref_layer=shift;
	my $mode=shift||'touch';
	my $use=shift||'filter';
	my $f_types=shift||'line\;pad\;surface\;arc\;text,polarity=positive\;negative,';
	my $pads_as=shift||'shape';
	my $include_syms=shift||'';
	my $exclude_syms=shift||'';
	$f->COM ('sel_ref_feat',
		layers           =>$ref_layer,
		use              =>$use,
		mode             =>$mode,
		pads_as          =>$pads_as,
		f_types          =>$f_types,
		include_syms     =>$include_syms,
		exclude_syms     =>$exclude_syms);
}
####_______________________________________________________


1;














































