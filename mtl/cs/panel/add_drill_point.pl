use strict;
use warnings;

open_step('pcb');

if ( exists_layer('drlp') eq 'yes' ) {
	$main::f->COM("delete_layer,layer=drlp");
}

clear('drl');
sel_copy_other('drlp','no','4');
sel_copy_other('drlp','yes',0);
clear();

##open_step('pnl');


1;