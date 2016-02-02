#!/sw/bin/perl -w

#######################################
$perl_path = "c:/bin/perl";          # The path of perl

$genesis_perl_lib_name = "Genesis";   # The name of the perl library required
                                      # to run genesis scripts

$max_line_len = 80;                   # Maximal line length of generated script
                                      # Note - the calculation is approximate
#######################################

@ARGV = qw{test bintest.pl};

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
print "use FBI;\n";
print "use Win32;\n";
print "use $genesis_perl_lib_name;\n\n";

print "\$host = shift;\n";
print "\$f = new Genesis;\n";
print "\$JOB  = \$ENV{JOB};;\n";
print "\$STEP = \$ENV{STEP};;\n";




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
