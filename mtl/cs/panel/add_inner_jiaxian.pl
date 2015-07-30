use strict;
use warnings;
my $class=\%main::layer_class;

###________________________________________ 
my %inner_jiaxian=(
  xmin=>0,               #-(5/$main::I_M),
  ymin=>0,               #-(5/$main::I_M),
  xmax=>$main::px,       #$main::px+(5/$main::I_M),
  ymax=>$main::py,       #$main::py+(5/$main::I_M),
);

if ($main::layer_number > 2) {
    clear();
    affected_layer('yes', 'single', @{$class->{inner}} );
	
	add_pad($inner_jiaxian{xmin},$inner_jiaxian{ymin},'mtljx','no',0,  );
	add_pad($inner_jiaxian{xmin},$inner_jiaxian{ymax},'mtljx','no',90, );
	add_pad($inner_jiaxian{xmax},$inner_jiaxian{ymax},'mtljx','no',180,);
	add_pad($inner_jiaxian{xmax},$inner_jiaxian{ymin},'mtljx','no',270,);

    #add_line($inner_jiaxian{xmax},$inner_jiaxian{ymax},$inner_jiaxian{xmax},$inner_jiaxian{ymin},'r10');
    #add_line($inner_jiaxian{xmax},$inner_jiaxian{ymin},$inner_jiaxian{xmin},$inner_jiaxian{ymin},'r10');
    #add_line($inner_jiaxian{xmin},$inner_jiaxian{ymin},$inner_jiaxian{xmin},$inner_jiaxian{ymax},'r10');
    #add_line($inner_jiaxian{xmin},$inner_jiaxian{ymax},$inner_jiaxian{xmax},$inner_jiaxian{ymax},'r10');
}

clear();
###p__('line frame ok');

1;

