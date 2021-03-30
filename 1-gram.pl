#!/usr/bin/perl

# Digunakan untuk membuat kamus 1-gram
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
open FILE_W, "> $PATH/1_grams_$ARGV[0].txt" or die "Cannot Open File!!!";

# stopwords
my %stopwords;
load_stopwords(\%stopwords);

# content of dataset file
my $text = `cat dataset/dataset_$ARGV[0].txt`;

$text =~ s/\'//g;

# build n-grams
my $ngrams = Lingua::EN::Bigram->new;
$ngrams->text( $text );
my @onegram = $ngrams->words;

# get one-gram counts
my $onegram_count = $ngrams->word_count;

my $index = 0;
my $onegram_value;

# loop to print onegram
foreach my $onegram (keys %$onegram_count ) {

    # skip stopwords and punctuation
	next if ( $stopwords{ $onegram } );
	next if ( $onegram =~ /[,.?!:;()\-]/ );

    $onegram_value = $$onegram_count{ $onegram };
    $index++;
    print FILE_W "$onegram_value\t$onegram\n";
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