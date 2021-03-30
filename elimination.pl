# Code ini berfungsi untuk melakukan eliminasi kata yang sama atau salah satunya
# berdasarkan threshold di kedua kamus yaitu otomotif dan sepakbola
# 
# Created by Maulana Hizbullah
# 1708107010055
# March 28, 2021

my $PATH = "kamus/";

for(my $threshold = $ARGV[2]; $threshold <=$ARGV[2]; $threshold += 0.05){
	
	my $persenthreshold = $threshold*100;
	print "\nTHRESHOLD = $persenthreshold%\n";
	
	#Membuat file kamus yang sudah dieliminasi
	open POSITIVE, "> $PATH/$threshold"."_$ARGV[0]_final.txt" or die "can't open file :$PATH/$ARGV[0]/$ARGV[0]_final.txt\n";
	open NEGATIVE, "> $PATH/$threshold"."_$ARGV[1]_final.txt" or die "can't open file :$PATH/$ARGV[1]/$ARGV[1]_final.txt\n";
	open DELETE, "> $PATH/$threshold"."_eleminated_both.txt" or die "can't open file $PATH/deleted_grams_final.txt";

	print"Membuat kamus final...\n";

	for(my $gr = 1; $gr <= 3; $gr++){

		my %dict_otom;
		my %dict_bola;

		#Memanggil file
		load_file(\%dict_otom,"$PATH/",$ARGV[0],$gr);
		load_file(\%dict_bola,"$PATH/",$ARGV[1],$gr);

		print"Proses membaca kamus $gr"."_gram\t:";

		#Menghitung frekuensi terbanyak dari kamus otomotif
		my $index_otom=0;
		foreach(keys %dict_otom){
			if($dict_otom{$_} > $index_otom){
				$index_otom = $dict_otom{$_};
			}
		}

		#Menghitung frekuensi terbanyak dari kamus sepakbola
		my $index_bola=0;
		foreach(keys %dict_bola){
			if($dict_bola{$_} > $index_bola){
				$index_bola = $dict_bola{$_};
			}
		}

		#Proses eliminasi kamus dengan nilai threshold
		foreach(keys %dict_otom){
			if(defined($dict_bola{$_})){
				my $otom = $dict_otom{$_}/$index_otom;
				my $bola = $dict_bola{$_}/$index_bola;
				my $ratio;

				# Normalization kata x dari kamus otomotif < bola
				if($otom < $bola){
					$ratio = $otom/$bola;

					# jika nilai rasio < threshold
					if($ratio <  $threshold){
						delete $dict_otom{$_};
						print DELETE "otom\t:$_\n";
					}else{
						delete $dict_otom{$_};
						delete $dict_bola{$_};
						print DELETE "both\t:$_\n";
					}
				}

				# Normalization kata x dari kamus otomotif > bola
				if($otom > $bola){
					$ratio = $bola/$otom;
					
					# jika nilai rasio < threshold
					if($ratio <  $threshold){
						delete $dict_bola{$_};
						print DELETE "bola\t:$_\n";
					}else{
						delete $dict_otom{$_};
						delete $dict_bola{$_};
						print DELETE "both\t:$_\n";
					}
				}

				# jika nilai rasio sama dengan threshold
				if($otom == $bola){
					delete $dict_otom{$_};
					delete $dict_bola{$_};
					print DELETE "both\t:$_\n";
				}
			}
		}

		# Perulangan untuk mencetak kata ke kamus positif (otomotif) dengan separator tab (\t)
		foreach(keys %dict_otom){
			my $positive = sprintf("%.6f", $dict_otom{$_}/$index_otom);
			print POSITIVE "$positive\t$dict_otom{$_}\t$_\n";
		}

		#Perulangan untuk mencetak kata ke kamus negatif (sepakbola) dengan separator tab (\t)
		foreach(keys %dict_bola){
			my $negative = sprintf("%.6f", $dict_bola{$_}/$index_bola);
			print NEGATIVE "$negative\t$dict_bola{$_}\t$_\n";
		}
		print"Eliminasi kamus $gr gram (ok)\n";
	}

	#Menutup file
	close POSITIVE;
	close NEGATIVE;
	close DELETE;
	print"Membuat kamus final selesai...\n\n";
}
#Subroutine untuk membuka file kamus 1, 2 dan 3 grams dengan melakukan split dari separator tab (\t)
sub load_file {
	my ($hashref,$dir,$file,$n) = @_;

	open IN, "< $dir/$n"."_grams_$file.txt" or die "Can't open file :  $dir/".$n."_grams_$file.txt\n";
	foreach(<IN>){
		chomp;
		my @arr = split("\t", $_);
		my $a = $arr[0];
		my $b = $arr[1];
		$$hashref{$b} = $a;
	}
	close IN;
}