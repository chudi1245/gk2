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
my $addbook=0;
if ($main::g_moudel eq "Steel" ){$addbook = 0.65;}
my $symbol_book;

cur_atr_set('.out_scale');
foreach  (1..$#layer_line-1 ) {
	($_ % 2) ? ($symbol_book='booki') : ($symbol_book='booko');
	if ( $main::polarity[$_] ne '+') {	
		clear($layer_line[$_]);
		add_pad($book->[0]{x}, $book->[0]{y}, $symbol_book, 'no', 0, 'yes' );
		add_pad($book->[1]{x}, $book->[1]{y}-0.32-$addbook, $symbol_book, 'no', 0, 'yes' );
		add_pad($book->[2]{x}, $book->[2]{y}+$addbook, $symbol_book, 'no', 0, 'yes' );
		add_pad($book->[3]{x}, $book->[3]{y}+0.32+$addbook, $symbol_book, 'no', 0, 'yes' );
	}
}
cur_atr_set();
clear();


LABEL_INNER_BOOK_END:  ;
#p__("add inner book ok");
1;



