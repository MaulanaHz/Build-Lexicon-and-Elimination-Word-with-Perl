#!/usr/bin/perl

# Digunakan untuk membuat kamus 3-gram
#
# Modified by Maulana Hizbullah
# 1708107010055
# March 28, 2021

use Lingua::EN::Bigram;
use strict;
use warnings;

# destination kamus
my $PATH = "kamus/";

# name of file
open FILE_W, "> $PATH/3_grams_$ARGV[0].txt" or die "Cannot Open File!!!";

# stopwords
my %stopwords;
load_stopwords(\%stopwords);

# content of dataset file
my $text = `cat dataset/dataset_$ARGV[0].txt`;

# build n-grams
my $ngrams = Lingua::EN::Bigram->new;
$ngrams->text( $text );
my @threegrams = $ngrams->trigrams;

# get one-gram counts
my $threegrams_count = $ngrams->trigram_count;

my $index = 0;
my $threegram_value;

# looping to print threegram
$index = 0;
foreach my $threegrams (keys %$threegrams_count ) {

	# get the tokens of the bigram
	my ( $first_token, $second_token, $third_token ) = split / /, $threegrams;
	
	# skip stopwords and punctuation
	next if ( $stopwords{ $first_token } );
	next if ( $first_token =~ /[,.?!:;()\-]/ );
	next if ( $stopwords{ $second_token } );
	next if ( $second_token =~ /[,.?!:;()\-]/ );
	next if ( $stopwords{ $third_token } );
	next if ( $third_token =~ /[,.?!:;()\-]/ );
	
    $threegram_value = $$threegrams_count{ $threegrams };
	$index++;
	print FILE_W "$$threegrams_count{ $threegrams }\t$threegrams\n";
}

# Subroutine to load stopwords // https://github.com/stopwords-iso/stopwords-id
sub load_stopwords {
	my $hashref = shift;
	open IN, "<stopwords-id.txt" or die "Cannot Open File!!!";
	while (<IN>){
		chomp;
		if(!defined $$hashref{$_}){
			$$hashref{$_} = 1;
		}
	}  
}