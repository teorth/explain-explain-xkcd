#!/usr/bin/perl 
  
# Modules used 
use strict; 
use warnings; 
use Data::Dumper;
  
# Print function  

sub insert {
	
	print "Argument dump\n";
	
	print Dumper @_;
	
	my $hashref = shift;
	my $key = shift;
	my $num = shift;
	
	$hashref->{$key} = $num;
	
	my $length = keys %{$hashref};
	print "hashref length: $length\n";

	
	print "Inner dump of hashref\n";
	print Dumper $hashref;
	
	print "Inner dump of hashref converted to hash\n";
	print Dumper %{$hashref};
}



my %hashVal = ('a', 1);

insert(\%hashVal, 'b', 5);
insert(\%hashVal, 'c', 3);

my $length = keys %hashVal;
print "hashVal length: $length\n";
	
print "Outer dump of hashval \n";

print Dumper %hashVal;

print "Outer dump of hashval passed by reference \n";

print Dumper \%hashVal;
