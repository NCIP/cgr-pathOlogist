#!/usr/bin/perl -w

#&path_db;
#&path_db_sym;
#&path_db_PID;
&count_num;

sub count_num {
    $infile = "pathologist.db.txt";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split /\t/;
	if ($. == 1){
	    foreach $i (0..$#F){
		print STDERR "$i\t$F[$i]\n";
	    }
	}
	$pid{$F[1]}++;
	$mid{$F[4]}++;
	$iid{$F[10]}++;
    }
    close IN;
    @tmp = keys %pid;
    $num = 0;
    foreach $id (sort keys %pid){
	$num = $num + $pid{$id};
    }
    print "PID: $#tmp $mum\n";
    @tmp = keys %mid;
    $num = 0;
    foreach $id (sort keys %mid){
	$num = $num + $mid{$id};
    }
    print "MID: $#tmp $mum\n";
    @tmp = keys %iid;
    $num = 0;
    foreach $id (sort keys %iid){
	$num = $num + $iid{$id};
    }
    print "IID: $#tmp $mum\n";
}

sub  path_db_PID {
    $infile = "inter2gid_gid.xls";
    open IN, $infile or die "$infile $!\n";
     while (<IN>){
	chomp;
	@F = split;
	next if $. == 1;
	$id{$F[0]} = 1;
    }
    close IN;
    $outfile = "pathologist.db_PIDname.txt";
    open OUT, ">$outfile" or die "$outfile $!\n";
    print OUT "pname\tPID\tinterID\tNumberID\n";
    $outfile1 = "pathologist.db_PID.txt";
    open OUT1, ">$outfile1" or die "$outfile1 $!\n";
    print OUT1 "PID\tinterID\tNumberID\n";
    $infile = "pathologist.db.txt";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split /\t/;
	#foreach $i (0..$#F){
	    #print STDERR "$i $F[$i]\n";
	#}    
	$F[10] =~ s/\s+//g;
	next unless $id{$F[10]};
	print OUT "$F[0]\t$F[1]\t$F[10]\t$F[4]\n";
	print OUT1 "$F[1]\t$F[10]\t$F[4]\n";
    }
    close IN;
    close OUT;
    close OUT1;
}

sub path_db_sym {
    $infile = "/huy/Database/gene/DATA_04_23_2011/gene_info.hs";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split;
	next if $. == 1;
	$gid2sym{$F[1]} = $F[2];
    }
    close IN;
    $outfile1 = "inter2gid_sym.xls";
    open OUT1, ">$outfile1" or die "$outfile1 $!\n";
    print OUT1 "InterID\ttype\tGeneSym\n";
    $outfile2 = "inter2gid_gid.xls";
    open OUT2, ">$outfile2" or die "$outfile2 $!\n";
    print OUT2 "InterID\ttype\tGeneID\n";
    $infile = "inter2gid.xls";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split /\t/;
	next if $. == 1;
	if (!$F[4]){
	    next;
	    print STDERR "$_\n";
	}   
	next unless $F[4] =~ /\d/;
	next unless $F[1] =~ /\d/ or $F[2] =~ /\d/ or $F[3] =~ /\d/;
	$input       = "";
	$inhibitor   = "";      
	$agent       = "";
	$output      = "";
	$input_s     = "";
	$inhibitor_s = "";      
	$agent_s     = "";
	$output_s    = "";
	$touched     = 0;
	
	if ($F[1] =~ /\d/){
	    $F[1] =~ s/LL:/ /g;
	    $F[1] =~ s/,/ /g;
	    @f = split /\s+/, $F[1];
	    foreach $i (0..$#f){
		next unless $f[$i];
		$f[$i] =~ s/\s+//g;
	       
		$input .= "$F[0]\tinput\t$f[$i]\n";
		
		if ($gid2sym{$f[$i]}){
		    
		    $input_s .= "$F[0]\tinput\t$gid2sym{$f[$i]}\n";
		    $touched = 1;
		    
		}
	    }
	}
	if ($F[2] =~ /\d/){
	    $F[2] =~ s/LL:/ /g;
	    $F[2] =~ s/,/ /g;
	    @f = split /\s+/, $F[2];
	    foreach $i (0..$#f){
		next unless $f[$i];
		$f[$i] =~ s/\s+//g;
		
		$inhibitor .= "$F[0]\tinhibitor\t$f[$i]\n";
		
		if ($gid2sym{$f[$i]}){
		  
		    $inhibitor_s .= "$F[0]\tinhibitor\t$gid2sym{$f[$i]}\n";
		    $touched = 1;
		    
		}
	    }
	}
	if ($F[3] =~ /\d/){
	    $F[3] =~ s/LL:/ /g;
	    $F[3] =~ s/,/ /g;
	    @f = split /\s+/, $F[3];
	    foreach $i (0..$#f){
		next unless $f[$i];
		$f[$i] =~ s/\s+//g;
	      
		$agent .= "$F[0]\tagent\t$f[$i]\n";
		
		if ($gid2sym{$f[$i]}){
		    
		    $agent_s .= "$F[0]\tinhibitor\t$gid2sym{$f[$i]}\n";
		    $touched = 1;
	 
		}
	    }
	}
	if ($F[4] =~ /\d/){
	    $F[4] =~ s/LL:/ /g;
	    $F[4] =~ s/,/ /g;
	    @f = split /\s+/, $F[4];
	    foreach $i (0..$#f){
		next unless $f[$i];
		$f[$i] =~ s/\s+//g;
		$output .= "$F[0]\toutput\t$f[$i]\n";
	    
		if ($gid2sym{$f[$i]}){
		    $output_s .= "$F[0]\toutput\t$gid2sym{$f[$i]}\n";
		   
		    $touched++;
		}
	    }
	}
	next unless $touched > 1;
	if ($input_s){
	    print OUT1 $input_s;
	    print OUT2 $input;
	}
	if ($inhibitor_s){
	    print OUT1 $inhibitor_s;
	    print OUT2 $inhibitor;
	}
	if ($agent_s){
	    print OUT1 $agent_s;
	    print OUT2 $agent;
	}
	if ($output_s){
	    print OUT1 $output_s;
	    print OUT2 $output;
	}
    }
    close IN;
    close OUT1;
    close OUT2;
}

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
    $outfile = "nomapping.txt";
    open OUT, ">$outfile" or die "$outfile $!\n";
    $infile = "pathologist.db.txt";
    open IN, $infile or die "$infile $!\n";
    while (<IN>){
	chomp;
	@F = split /\t/;
	foreach $i (0..$#F){
	    if ($F[$i] =~ /inactive/){
		print STDERR "$. $i $F[$i]\n";
	    }
	}
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
	} 
	if ($F[2] eq "complex"){
	    if ($gid eq "NA"){
		$gid = "";
	    }
	    if ($complex2gid{$F[4]}){
		$gid .= $complex2gid{$F[4]} . ",";
	    } else {
		next;
		print STDERR "complex2gid $F[4] $_ ?\n";
		exit;
	    }
	} elsif ($F[5] =~ /UP/){
	    @f = split /\,/, $F[5];
	    if ($gid eq "NA"){
		$gid = "";
	    }
	    foreach $i1 (0..$#f){
		$f[$i1] =~ s/^UP://g;
		$f[$i1] =~ s/\s+//g;
		$f[$i1] =~ s/-\d+$//g;
		if (!$UP2LL{$f[$i1]}){
		    if ($f[$i1] =~ /LL/){
			$gid .= $f[$i1] . ",";
		    } else {
			print STDERR "UP2LL $f[$i1] ?\n";
		    }
		    #exit;
		} else {
		    $gid .= $UP2LL{$f[$i1]} . ",";
		}
	    }
	    $gid =~ s/,$//g;
	} else {
	    if (!$F[5]){
		#print STDERR "F[5] = $F[5]: $_ ?\n";
		foreach $col (0..$#F){
		    print OUT "$. $col $F[$col]\n";
		}
		#exit;
	    } else {
		if ($F[5] =~ /LL/){
		} else {
		    foreach $col (0..$#F){
			print STDERR "$. $col $F[$col]\n";
		    }
		    exit;
		}
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
    close OUT;
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
	    #print STDERR "inter2: $i\n";
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
