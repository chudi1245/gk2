#!/usr/bin/perl
use strict;
use Tk;
use Genesis;
use FBI;

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};;

kysy();

clear('gts');

$f->COM('filter_set', filter_name  => 'popup',
                    update_popup => 'no',
                    polarity     => 'positive');

$f->COM('filter_area_strt');

$f->COM('filter_area_end', layer          => '',
                         filter_name    => 'popup',
                         operation      => 'select',
                         area_type      => 'none',
                         inside_area    => 'no',
                         intersect_area => 'no');
$f->COM('filter_reset', filter_name => 'popup');

$f->COM('sel_copy_other', dest         => 'layer_name',
                        target_layer => 'gto',
                        invert       => 'yes',
                        dx           => 0,
                        dy           => 0,
                        size         => 8,
                        x_anchor     => 0,
                        y_anchor     => 0,
                        rotation     => 0,
                        mirror       => 'none');
