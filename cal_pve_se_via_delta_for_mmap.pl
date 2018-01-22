# 
# A function to use delta method to calculate PVE and standard error
# Input: MMAP output file for variance component estimation
# Output: PVE and corresponding standard error
#
use strict;
use warnings;
use List::Util qw(sum);


# B = (p0 p1 p2 p3 p4)
# fi(B) = pi/sum(B)

# pder(pi) = (sum(B)-pi)/sum(B)**2
# else pder() = -pi/sum(B)**2

our $err_msg = qq{
At least 3 arguments needed:
  MMAP .variance.components.T.csv file
  >=2 VarComp names
Example:
  perl cal_pve_se_via_delta_for_mmap.pl test.variance.components.T.csv G D I ERROR
};

@ARGV > 2 or die $err_msg;

my ($infile, @p) = @ARGV;

# co-variance matrix of variance component estimates
my $var;

# variance component estimates
my %est;

open (IN,$infile) or die "Cannot open $infile: $!\n";
while(my $line = <IN>)
{
	if($line =~ /^COV/)
	{
		chomp $line;
		my @c = split /\,/,$line;
		my ($p1,$p2) = (split /_/,$c[0])[1,2];
		$var ->{$p1}->{$p2} = $c[1];
	}
	
	for my $comp (@p)
	{
		if($line =~ /$comp\_VAR\,/)
		{
			chomp $line;
			my @c = split /\,/,$line;
			$est{$comp} = $c[1];
		}
	}
}
close IN;

@p == (keys %est) or die "Check VarComp names; some are not in MMAP file.\n";

for my $p1 (@p)
{
	for my $p2 (@p)
	{
		(defined $var ->{$p1}->{$p2}) or $var ->{$p1}->{$p2} = $var ->{$p2}->{$p1};
	}
}

my $sum_est = sum(map {$est{$_}} @p);


print "VarComp\tPVE\tVar(PVE)\tStdErr(PVE)\n";

for my $comp (@p)
{
# derivatives
	my %der;
	for(@p)
	{
		if($_ eq $comp)
		{
			$der{$_} = ($sum_est - $est{$comp})/$sum_est**2;
		}
		else
		{
			$der{$_} = -$est{$comp}/$sum_est**2;
		}
	}
	
	my %tmp;
	for my $p1 (@p)
	{
		for my $p2 (@p)
		{
			$tmp{$p1} += $der{$p2} * $var->{$p2}->{$p1};
		}
	}
	
	my $var_f = 0;
	for(@p)
	{
		$var_f += $tmp{$_} * $der{$_};
	}
	
	print $comp,"\t",$est{$comp}/$sum_est,"\t",$var_f,"\t",sqrt($var_f),"\n";
}




