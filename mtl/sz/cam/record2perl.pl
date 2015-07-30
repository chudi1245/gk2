#!/sw/bin/perl -w
=head

This perl program translates the output of a Genesis/Enterprise "record"
session to perl.

Usage:
  record2perl.pl [input_file [output_file]]

Ben Michelson -- 3 July 97

Copyright 1997  Valor Computerized Systems Ltd.

Known Bugs:
   The program will not function correctly if there are
   parameters with commas in them.

=cut

# The following variables are defined here 
# to make it easy to change them
#######################################
$perl_path = "/sw/bin/perl";          # The path of perl

$genesis_perl_lib_name = "Genesis";   # The name of the perl library required
                                      # to run genesis scripts

$max_line_len = 80;                   # Maximal line length of generated script
                                      # Note - the calculation is approximate
#######################################


if (@ARGV > 2) {
   die "Usage: $0 [input_file [output_file]]\n";
}

if (@ARGV == 2) {
   open(OUTFILE, ">$ARGV[1]") or 
      die "$0: Cannot open output file ``$ARGV[1]''\n";
   select(OUTFILE);
}

undef $/;
if (@ARGV > 0) {
   open(INFILE, "<$ARGV[0]") or 
      die "$0: Cannot open input file ``$ARGV[0]''\n";
   $file = <INFILE>;
   close(INFILE);
} else {
   $file = <STDIN>;
}

$file =~ s/\\\n//g;
$file =~ s/\\//g;

print "#!$perl_path\n";
print "use $genesis_perl_lib_name;\n\n";
print "\$f = new $genesis_perl_lib_name;\n\n";

foreach (split(/\n/, $file)) {
   if (/^(COM|AUX) /) {
      $prefix = $1;
      @param = split(/,/);
      $op = $param[0];
      $op =~ s/^$prefix //;
      $op_len = length($op);
      $name_len = 0;
      for ($i = 1; $i < @param; $i++) {
         ($name[$i], $value[$i]) = split(/=/, $param[$i], 2);
         if (length($name[$i]) > $name_len) {
	    $name_len = length($name[$i]);
	 }
      }
      
      if (length($_) + 6 * $i > $max_line_len) {
         $comma_format = ",\n          %${op_len}s";
	 $param_format = "%-${name_len}s => %s",
      } else {
         $comma_format = ", ";
	 $param_format = "%s => %s",
      }
      
      print "\$f->$prefix('$op'";
      if (@param > 1) { print ", "; }
         
      for ($i = 1; $i < @param; $i++) {
         if ($i > 1) { printf $comma_format, ""; }
	 $val = $value[$i];
	 if ($val !~ /^[-0-9]+$/) { $val = "'$val'"; }
         printf $param_format, $name[$i], $val;
      }
      print ");\n";
   } else {
      print "$_\n";
   }
}
