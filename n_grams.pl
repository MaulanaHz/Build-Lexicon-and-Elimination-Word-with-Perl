#!/usr/bin/perl

# n_grams.pl 
# Digunakan untuk membuat kamus N-gram
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
    open FILE_W, "> $PATH/full_grams_$ARGV[0].txt" or die "Cannot Open File!!!";
# stopwords
my %stopwords;
load_stopwords(\%stopwords);

# content of dataset file
my $text = `cat dataset/dataset_$ARGV[0].txt`;

$text =~ s/\'//g;

for(my $gram = 1; $gram <=3; $gram++){

    # build n-grams
    my $ngrams = Lingua::EN::Bigram->new;
    $ngrams->text( lc($text) );
    my @n_gram = $ngrams->ngram( $gram );

    # get one-gram counts
    my $n_gram_count = $ngrams->ngram_count( \@n_gram );

    my $index = 0;
    my $n_gram_value;

    # loop to print onegram
    foreach my $n_gram (keys %$n_gram_count ) {

        # get the tokens of the n_gram
	    my ( $first_token, $second_token, $third_token ) = split / /, $n_gram;

        # skip stopwords and punctuation
        if($gram == 1){
            next if ( $stopwords{ $first_token } );
            next if ( $first_token =~ /[,.?!:;()\-]/ );
        }
        if($gram == 2){
            next if ( $stopwords{ $first_token } );
            next if ( $first_token =~ /[,.?!:;()\-]/ );
            next if ( $stopwords{ $second_token } );
            next if ( $second_token =~ /[,.?!:;()\-]/ );
        }
        if($gram == 3){
            next if ( $stopwords{ $first_token } );
            next if ( $first_token =~ /[,.?!:;()\-]/ );
            next if ( $stopwords{ $second_token } );
            next if ( $second_token =~ /[,.?!:;()\-]/ );
            next if ( $stopwords{ $third_token } );
            next if ( $third_token =~ /[,.?!:;()\-]/ );
        }

        $n_gram_value = $$n_gram_count{ $n_gram };
        $index++;
        print FILE_W "$n_gram_value\t$n_gram\n";
    }
    print("Kamus $gram gram Created!\n");
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