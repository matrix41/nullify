#! /usr/bin/perl 

use strict;
use warnings;
use feature qw(switch say); # need this for GIVEN-WHEN block

# Define
my $superstring;
my $parameter;
my $value;

# Get filename from command line argument 
my $inputfile = $ARGV[0];

# Get parameter field to nullify
my $parameterfield = $ARGV[1];

# Declare new filehandle and associate it with filename 
open (my $fh, '<', $inputfile) or die "\nCould not open file '$inputfile' $!\n";

# Point array to filehandle.  
my @array = <$fh>;

# Close filehandle after filling array 
close ($fh);

# Array element 9 (ie the 10th row) is where the data starts.  
# my @split_parameters = split(/\|/, $array[9]);

my $j = 0;
foreach my $element (@array)
{
	my @split_parameters = split(/\|/, $element);
	if ( $split_parameters[0] =~ /^EDMT$/ )
	{
		for ( my $i = 0 ; $i < $#split_parameters ; $i++ )
		{
          ( $parameter, $value ) = split(/\s+/, $split_parameters[$i]);

          # i am checking for a defined $value because some of the 
          # fields have only a parameter (ie not corresponding value)
	      if ( defined($value) && ( $parameter =~ /^$parameterfield$/ ) )
	      {
	        $value = "null";
	      } 

          # i am checking for defined $value because if I print an 
          # undefined value then I will see a warning message on screen 
          if ( defined($value) )
          {
            # now put the parameter/value pair back together 
            $split_parameters[$i] = "$parameter" . " " . "$value";
          } else {
            # now put the parameter back 
            $split_parameters[$i] = "$parameter";
          }

		}

	    # now pack the parameters back up again
	    for ( my $k = 0 ; $k < $#split_parameters ; $k++ )
	    {
	      $superstring .= $split_parameters[$k]."|";
	    }
        $array[$j] = $superstring;
	} # end of IF statement 
	$j += 1;
}

open (my $fh2, '>', $inputfile) or die "\nCould not open file '$inputfile' $!\n";
for ( my $m = 0 ; $m <= $#array ; $m++ )
{
  print $fh2 $array[$m];
}
print $fh2 "\n";
close ($fh2);
