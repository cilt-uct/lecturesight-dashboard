#!/usr/bin/perl

## Scan the overview directory and get the status file to create a venues.json file for indec.html to process.

## 2017-12-12: Corne Oosthuizen

use strict;
use warnings;
use Date::Format;
use JSON;

my $dir = '/usr/share/nginx/lecturesight/overview';

opendir(DIR, $dir) or die $!;

my @status_files
   = grep { 
      /status\.txt/
      && -f "$dir/$_"   # and is a file
   } readdir(DIR);

my %venue_list = ();

# Loop through the array printing out the filenames
foreach my $file (@status_files) {
  my $time = time2str('%Y-%m-%d %H:%M:%S', (stat $dir .'/'. $file)[9]);
  my @parts = split /-/, $file;
  my $content = do{local(@ARGV,$/)= $dir .'/'. $parts[0].'-status.txt';<>};
  my @a = ($time, $content);
  $venue_list{ $parts[0] } = \@a;
}

my $json = encode_json \%venue_list;

#print "$json\n";

open(my $fh, '>', $dir .'/venues.json');
print $fh $json . "\n";
close $fh;

closedir(DIR);
exit 0;
