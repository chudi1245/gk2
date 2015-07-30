use strict;
use warnings;
goto LABEL_INNER_BOOK_END if ($main::layer_number < 3);

my @layer_line=@{$main::layer_class{line}};
my @inner=@{$main::layer_class{inner}};

my $book=[
    { x=>$main::px-0.18,  y=>$main::py-0.18 },
	{ x=>0.18,			  y=>$main::py-0.18 },
	{ x=>0.18,            y=>0.5      },
	{ x=>$main::px-0.18,  y=>0.18     },
];

my $symbol_book;

cur_atr_set('.out_scale');
foreach  (1..$#layer_line-1 ) {
	($_ % 2) ? ($symbol_book='booki') : ($symbol_book='booko');
	if ( $main::polarity[$_] ne '+') {	
		clear($layer_line[$_]);
		add_pad($book->[0]{x} - 0.35, $book->[0]{y}, $symbol_book, 'no', 0, 'yes' );
		add_pad($book->[1]{x} + 0.35, $book->[1]{y}, $symbol_book, 'no', 0, 'yes' ); ##左上角的，往右移0.18‘
		add_pad($book->[2]{x}, $book->[2]{y} + 0.3, $symbol_book, 'no', 0, 'yes' );
		add_pad($book->[3]{x} - 0.35, $book->[3]{y}, $symbol_book, 'no', 0, 'yes' ); ##右下角的，往左移0.18‘
	}
}
cur_atr_set();
clear();

###p__("@layer_line");  "gtl l2t l3b gbl"  线路层
###p__("@inner");     "l2t l3b"  内层

LABEL_INNER_BOOK_END:  ;
#p__("add inner book ok");
1;



