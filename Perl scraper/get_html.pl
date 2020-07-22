#!/usr/bin/perl 
  
# Modules used 
use MediaWiki::API;


# activate the explainxkcd API 
my $mw = MediaWiki::API->new();
$mw->{config}->{api_url} = 'https://www.explainxkcd.com/wiki/api.php';
 

# get some page contents
# weird issue: can't scrape the list of all comics (full) page, it is too large, so we have to scrape the subpages
my $page = $mw->get_page( { title => 'List of all comics' } );

# grab the main text of $page
my $text = $page->{'*'};

for my $line (split /\n/, $text){
	# check each line of $text to see if it contains the string "comicsrow|$1|$2|$3|"
	if ($line =~ /comicsrow\|(.*)\|(.*)\|(.*)\|/)
	{
		# $1 is comic number; $2 is date published; $3 is comic title
		print ("$1:$2:$3\n") 
	}
}

 


