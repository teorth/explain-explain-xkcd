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
	my $num = shift;
	
	$hashref->{'b'} = $num;
	
	print "Inner dump of hashref\n";
	
	print Dumper $hashref;
}



my %hashVal = ('a', 1);

insert(\%hashVal, 5);

print "Outer dump of hashval \n";

print Dumper %hashVal;

print "Outer dump of hashval passed by reference \n";

print Dumper \%hashVal;
