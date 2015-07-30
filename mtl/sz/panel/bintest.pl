#!c:/bin/perl
use FBI;
use Win32;
use Genesis;

$host = shift;
$f = new Genesis;
$JOB  = $ENV{JOB};;
$STEP = $ENV{STEP};;
$f->COM('affected_layer', name => 'gts', mode => 'single', affected => 'yes');
$f->COM('affected_layer', name => 'gbs', mode => 'single', affected => 'yes');
$f->COM('sel_copy_other', dest         => 'affected_layers',
                        target_layer => '.affected',
                        invert       => 'no',
                        dx           => 0,
                        dy           => 0,
                        size         => 12,
                        x_anchor     => 0,
                        y_anchor     => 0,
                        rotation     => 0,
                        mirror       => 'none');
$f->COM('affected_layer', name => 'gts', mode => 'single', affected => 'no');
$f->COM('affected_layer', name => 'gbs', mode => 'single', affected => 'no');
$f->COM('affected_layer', name => 'gbl', mode => 'single', affected => 'yes');
$f->COM('affected_layer', name => 'gtl', mode => 'single', affected => 'yes');
$f->COM('sel_copy_other', dest         => 'affected_layers',
                        target_layer => '.affected',
                        invert       => 'yes',
                        dx           => 0,
                        dy           => 0,
                        size         => 20,
                        x_anchor     => 0,
                        y_anchor     => 0,
                        rotation     => 0,
                        mirror       => 'none');
$f->COM('affected_layer', name => 'gtl', mode => 'all', affected => 'no');
