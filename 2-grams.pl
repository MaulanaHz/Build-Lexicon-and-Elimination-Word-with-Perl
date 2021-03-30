#!/usr/bin/perl

# Digunakan untuk membuat kamus 2-gram
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
open FILE_W, "> $PATH/2_grams_$ARGV[0].txt" or die "Cannot Open File!!! need argument [0]";

# stopwords
my %stopwords;
load_stopwords(\%stopwords);

# content of dataset file
my $text = `cat dataset/dataset_$ARGV[0].txt`;

# build n-grams
my $ngrams = Lingua::EN::Bigram->new;
$ngrams->text( $text );

# get bi-gram counts
my $bigram_count = $ngrams->bigram_count;

my $index = 0;
my $bigram_value;

# loop to print bigram 
$index = 0;
foreach my $bigram (keys %$bigram_count ) {

	# get the tokens of the bigram
	my ( $first_word, $second_word ) = split / /, $bigram;
			
	# skip stopwords and punctuation
	next if ( $stopwords{ $first_word } );
	next if ( $first_word =~ /[,.?!:;()\-]/ );
	next if ( $stopwords{ $second_word } );
	next if ( $second_word =~ /[,.?!:;()\-]/ );

	$bigram_value = $$bigram_count{ $bigram };
	$index++;
	print FILE_W "$$bigram_count{ $bigram }\t$bigram\n";
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