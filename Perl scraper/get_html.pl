#!/usr/bin/perl 
  
# Modules used 
use MediaWiki::API;
use JSON::PP;

# activate the explainxkcd API 
my $mw = MediaWiki::API->new();
$mw->{config}->{api_url} = 'https://www.explainxkcd.com/wiki/api.php';
 

# get some page contents
# weird issue: can't scrape the list of all comics (full) page, it is too large, so we have to scrape the subpages
my $page = $mw->get_page( { title => 'List of all comics' } );

# grab the main text of $page
my $text = $page->{'*'};

# create a key/value hash of hashes for the comic numbers and titles
my %title_db = ();

for my $line (split /\n/, $text){
	# check each line of $text to see if it contains the string "comicsrow|$1|$2|$3|"
	# $1 is comic number; $2 is date published; $3 is comic title
	if ($line =~ /comicsrow\|(.*)\|(.*)\|(.*)\|/)
	{
		my $comicnum = $1;
		
		# create a hash of various attributes of comic $1 and add it to the %title_db hash
		my %key = ();
		$key{"date"} = $2;
		
		my $title = $3;
		$key{"title"} = $title;

		#search and replace, spaces to underscores
		$title =~ s/ /_/g;
		
		print("$title\n");
		
		$key{"URL"} = "https://www.explainxkcd.com/wiki/index.php/$comicnum:_$title";
		$title_db{$1} = \%key;
	}
}

#for (keys %title_db) {
#  print("Comic $_ is titled $title_db{$_}\n");
#}


# Convert %title_db to JSON then dump to file

my $json = JSON->new->allow_nonref;
my $json_text = $json->encode(\%title_db);

my $titlefilename = ".\\titles.txt";
my $TITLEFILE;
open($TITLEFILE, "> $titlefilename") or die "Can't open $titlefilename";
print { $TITLEFILE } $json_text;
close($TITLEFILE);

