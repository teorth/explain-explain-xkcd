#!/usr/bin/perl 
  
# Modules used 
use MediaWiki::API;
 
my $mw = MediaWiki::API->new();
$mw->{config}->{api_url} = 'https://www.explainxkcd.com/wiki/api.php';
 

print "Printing contents\n";

# get some page contents
my $page = $mw->get_page( { title => 'List of all comics' } );

# weird issue: can't scrape the list of all comics (full) page, it is too large

# print page contents
# print $page->{'*'};

my $text = $page->{'*'};

for my $line (split /\n/, $text){
	print ("$1:$2:$3\n") if ($line =~ /comicsrow\|(.*)\|(.*)\|(.*)\|/);
}

 


