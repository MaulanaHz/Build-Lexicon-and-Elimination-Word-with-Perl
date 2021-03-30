# Digunakan untuk membangun dataset sebesar 6000 per kategori
#
# Create by Maulana Hizbullah
# 1708107010055
# March 28, 2021

# destination dataset
my $PATH = "dataset/";

# name of file for bola
open FILE_W, "> $PATH/dataset_$ARGV[0].txt" or die "Cannot Open File!!! need argument [0]";
my $n = 0;
my $text;
while($n < 6000){
	$n++;
	$text = `cat data/$ARGV[0]-$n.bersih.txt`;
	print FILE_W "$text";
}

# name of file for otomotif
open FILE_W, "> $PATH/dataset_$ARGV[1].txt" or die "Cannot Open File!!! need argument [0]";
my $n = 0;
my $text;
while($n < 6000){
	$n++;
	$text = `cat data/$ARGV[1]-$n.bersih.txt`;
	print FILE_W "$text";
}