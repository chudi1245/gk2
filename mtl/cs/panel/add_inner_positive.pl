use strict;
use warnings;

goto LABEL_INNER_POSITIVE_END if ($main::layer_number < 3);

my @layer_line=@{$main::layer_class{line}};




foreach  (1..$#layer_line-1 ) {
	if ( $main::polarity[$_] eq '+') {	
		clear($layer_line[$_]);





	}
}







LABEL_INNER_POSITIVE_END:  ;
1;








