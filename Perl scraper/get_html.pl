#!/usr/bin/perl 
  
# Modules used 
use MediaWiki::API;
use JSON::PP;
use Data::Dumper;


# dump_to_file(filename, hash) overwrites $filename with a $JSON version of hash
sub dump_to_file {
	# grab the arguments
	my $filename = shift;
	my $hash = shift;
	
	# convert to JSON
	my $json = JSON->new->allow_nonref;
	my $json_text = $json->encode($hash);

	# open a file (the > indicates overwrite)
	my $FILE;
	open($FILE, "> $filename") or die "Can't open $titlefilename";

	# dump JSON
	print {$FILE } $json_text;
	close($FILE);
}

# get_explainxkcd_page(name) grabs the text of the explainxkcd page with title $name

sub get_explainxkcd_page {
	# grab the argument
	my $name = shift;
	
	# activate the explainxkcd API 
	my $mw = MediaWiki::API->new();
	$mw->{config}->{api_url} = 'https://www.explainxkcd.com/wiki/api.php';
	
	# grab the main text of page
	my $page = $mw->get_page( { title => $name } );
	my $text = $page->{'*'};
		
	return($text);
}



# scrape_explainxkcd_page(hash, name) scrapes explainxkcd page $name for a list of comics and adds it to $hash
sub scrape_explainxkcd_page {
	# grab the arguments
	
	my $hash = shift;
	my $name = shift;
	
	# grab the text
	my $text = get_explainxkcd_page($name);
	
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
		
			#create the URL
			$key{"URL"} = "https://www.explainxkcd.com/wiki/index.php/$comicnum:_$title";
			
			#add all this to hash
			$hash ->{$1} = \%key;
		}
	}	
}




# create a key/value hash of hashes for the comic numbers and titles
my %title_db = ();

# scrape pages for comics.  Can't use 'List of all comics (full)' because it is too large, so we use individual pages instead

# It's important here that we use \%title_db instead of %title_db in order to pass a reference to the hash %title_db rather than a copy of the hash

scrape_explainxkcd_page( \%title_db, 'List of all comics' );

# uncomment this if you want to see what \%title_db looks like
#print("Output of title_db:\n");
#print Dumper \%title_db;

dump_to_file(".\\titles.txt", \%title_db);


