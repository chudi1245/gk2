#!/usr/bin/perl
print "Hello, World...\n";

open (FH,"> c:/genesis/fw/jobs/m46889/output/cy.log") or die $!;
print FH "yes";
close FH;
