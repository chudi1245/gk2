###############################把BB替换为BBI。
if ( exists_layer('gtl-ir') ) { 
	clear('gtl-ir')
$f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=bbi");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");
$f->COM("sel_change_sym,symbol=bb,reset_angle=no");
}

if ( exists_layer('gbl-ir') ) { 
	clear('gbl-ir')
$f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=bbi");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no,lines_only=no,ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");
$f->COM("sel_change_sym,symbol=bb,reset_angle=no");
}
###############################



open IN,"<","E:\\中药\\drugBank\\DB_name_cas_2324.txt"or die "$!";
open IN_2,"<","E:\\中药\\drugBank\\a.txt"or die "$!";
my $text = do{$/=undef;open IN_2,"<","E:\\中药\\drugBank\\a.txt";<IN_2>};
open OUT,">","E:\\中药\\drugBank\\cas_cas.txt"or die "$!";
	while (<IN>) {
		chomp;
		my @a = split /;/,$_;
		print "$a[1]\->$a[2]\n";
		$text =~ s/$a[1]/$a[2]/gi;
	}
print OUT $text;
close IN;
close IN_2;
close OUT;
你们可以试一下
这样写就不行了
1;


