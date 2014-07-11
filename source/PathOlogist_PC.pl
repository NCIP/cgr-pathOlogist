#!/usr/bin/perl -w
# C:\Documents and Settings\yhu\Desktop\Document\Tools\Matlab\PathOlogist
&path_db;

sub path_db {
    # pathway name and their ID
    $infile = "pathologist.pathways.txt";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split /\t/;
	$pid2name{$F[0]} = $F[1];
    }
    close IN;
    # $F[0] complexID
    # $F[3] was not used?
    $infile = "pathologist.complexes.txt";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split /\t/;
	next unless $F[4];
	if ($complex2gid{$F[0]}){
	    $complex2gid{$F[0]} .= ",$F[4]";
	} else {
	    $complex2gid{$F[0]} = $F[4];
	}
    }
    close IN;
    $infile = "UP2LL.txt";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split;
	if ($UP2LL{$F[0]}){
	    $UP2LL{$F[0]} .= ",LL:" . $F[1];
	} else {
	    $UP2LL{$F[0]} = "LL:" . $F[1];
	}
	if ($F[0] eq "Q9UQB8"){
	    print STDERR "$_\n";
	}
    }
    close IN;
    ##
    # $F[1]  = pid pathologist.pathways.txt
    # $F[4]  = molecularID 
    # $F[10] = interactionID 
    ## 
    $infile = "pathologist.db.txt";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split /\t/;
	if (!$pid2name{$F[1]}){
	    print STDERR "pid $F[1]\n";
	}
	$in_out{$F[9]} = 1;
	$id1{$F[1]}++;
	$id4{$F[4]}++;
	$id10{$F[10]}++;
	$name2{$F[2]}++;
	$name11{$F[11]}++;
	$molecular{$F[4]} = 1;
	$gid = "NA";
	if ($F[5] =~ /LL:/){
	    @f = split /\,/, $F[5];
	    $gid = "";
	    foreach $i1 (0..$#f){
		if ($f[$i1] =~ /UP/){
		    $f[$i1] =~ s/^UP://g;
		    $f[$i1] =~ s/\s+//g;
		    $f[$i1] =~ s/-\d+$//g;
		    if (!$UP2LL{$f[$i1]}){
			print STDERR "UP2LL $f[$i1]?\n";
			#exit;
		    } else {
			$gid .= $UP2LL{$f[$i1]} . ",";
		    }
		} else {
		    $gid .= "$f[$i1],";
		}
	    }
	    $gid =~ s/,$//g;
	} else {
	    if ($F[2] eq "complex"){
		if ($complex2gid{$F[4]}){
		    $gid = $complex2gid{$F[4]};
		} else {
		    next;
		    print STDERR "complex2gid $F[4] $_ ?\n";
		    exit;
		}
	    } elsif ($F[5] =~ /UP/){
		@f = split /\,/, $F[5];
		$gid = "";
		foreach $i1 (0..$#f){
		    $f[$i1] =~ s/^UP://g;
		    $f[$i1] =~ s/\s+//g;
		    $f[$i1] =~ s/-\d+$//g;
		    if (!$UP2LL{$f[$i1]}){
			print STDERR "UP2LL $f[$i1]?\n";
			#exit;
		    } else {
			$gid .= $UP2LL{$f[$i1]} . ",";
		    }
		}
		$gid =~ s/,$//g;
	    } else {
		next if !$F[5];
		print STDERR "F[5] = $F[5]: $_ ?\n";
		exit;
	    }
	}
	if ($inter2name{$F[10]}){
	    $inter2name{$F[10]} .= " $F[9]";
	    $inter2gid{$F[10]} .= " $gid";
	} else {
	    $inter2name{$F[10]} = $F[9];
	    $inter2gid{$F[10]} = $gid;
	}
	if ($F[2] eq "complex"){
	    $complex{$F[4]} = 1;
	}
    }
    close IN;
    $outfile = "inter2name.txt";
    open OUT, ">$outfile" or die "$outfile $!\n";
    foreach $i (sort keys %inter2name){
	print OUT "$i";
	@f = split /\s+/, $inter2name{$i};
	%name = ();
	foreach $j (0..$#f){
	    $name{$f[$j]} = 1;
	}
	$num  = 0;
	$num1 = 0;
	foreach $n (sort keys %name){
	    print OUT "\t$n";
	    if ($n eq "output"){
		$num++;
	    }
	    if ($n eq "input"){
		$num++;
	    }
	    if ($n eq "inhibitor"){
		$num++;
	    }
	    if ($n eq "agent"){
		$num++;
		$num1 = 1;
	    }
	}
	print OUT "\n";
	if ($num < 2){
	    #print STDERR "inter1: $i\n";
	}
	if ($num > 2 and $num1 < 1){
	    print STDERR "inter2: $i\n";
	}
    }
    close OUT;
    $outfile = "inter2gid.xls";
    open OUT, ">$outfile" or die "$outfile $!\n";
    print OUT "interID";
    foreach $n ("input", "inhibitor", "agent", "output"){
	print OUT "\t$n";
    }
    print OUT "\n";
    foreach $i (sort keys %inter2name){
	@f  = split /\s+/, $inter2name{$i};
	@f2 = split /\s+/, $inter2gid{$i};
	%name     = ();
	%name2gid = ();
	foreach $j (0..$#f){
	    next unless $f2[$j];
	    $name{$f[$j]} = 1;
	    if ($name2gid{$f[$j]}){
		$name2gid{$f[$j]} .= ",$f2[$j]";
	    } else {
		$name2gid{$f[$j]} = $f2[$j];
	    }
	}
	print OUT "$i";
	foreach $n ("input", "inhibitor", "agent", "output"){
	    if (!$name2gid{$n}){
		print OUT "\tNA";
	    } else {
		@tmp  = split /\,/, $name2gid{$n};
		$str  = "";
		%gids = ();
		foreach $i2 (0..$#tmp){
		    if ($tmp[$i2] =~ /UP/){
			$tmp[$i2] =~ s/UP://g;
			if ($UP2LL{$tmp[$i2]}){
			    $tmp1 = $UP2LL{$tmp[$i2]};
			    $gids{$tmp1} = 1;
			}
		    } else {
			$gids{$tmp[$i2]} = 1;
		    }
		}
		foreach $i3 (sort keys %gids){
		    $str .= "$i3,";
		}
		$str =~ s/,$//g;
		print OUT "\t$str";
	    }
	}
	print OUT "\n";
    }
    close OUT;
    foreach $k (sort keys %in_out){
	print STDERR "inout: $k\n";
    }
    @tmp = keys %id1;
    print STDERR "1: $#tmp\n";
    @tmp = keys %id4;
    print STDERR "4: $#tmp\n";
    @tmp = keys %id10;
    print STDERR "10: $#tmp\n";
    foreach $k (sort keys %name2){
	print STDERR "name2: $k\n";
    }
    foreach $k (sort keys %name11){
	#print STDERR "name11: $k\n";
    }
    # $F[0] complexID
    # $F[3] was not used?
    $infile = "pathologist.complexes.txt";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split /\t/;
	if (!$complex{$F[0]}){
	    print STDERR "complex $_\n";
	}
	if (!$molecular{$F[3]}){
	    #print STDERR "molecular $_\n";
	}
    }
    close IN;
}
