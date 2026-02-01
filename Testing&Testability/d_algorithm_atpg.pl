#!/usr/bin/perl
use strict;
use warnings;

# ==========================================
# Prototype D-Algorithm ATPG (NAND only)
# ==========================================

my $bench = "c17.bench";

my (%fanin, %fanout, %gate_type, %is_output);
my %value;   # net -> 0,1,X,D,DBAR

# ---------- Parse BENCH ----------
open(my $fh, "<", $bench) or die "Cannot open bench file\n";

while (<$fh>) {
    chomp;

    if (/^INPUT\((\d+)\)/) {
        $value{$1} = 'X';
    }
    elsif (/^OUTPUT\((\d+)\)/) {
        $is_output{$1} = 1;
    }
    elsif (/(\d+)\s*=\s*(\w+)\(([\d,]+)\)/) {
        my ($out, $gate, $ins) = ($1, $2, $3);
        my @ins = split(",", $ins);

        $gate_type{$out} = $gate;
        $fanin{$out} = \@ins;

        for my $i (@ins) {
            push @{ $fanout{$i} }, $out;
            $value{$i} //= 'X';
        }
        $value{$out} //= 'X';
    }
}
close($fh);

# ---------- Ensure ALL nets initialized ----------
for my $n (keys %fanin)  { $value{$n} //= 'X'; }
for my $n (keys %fanout) { $value{$n} //= 'X'; }
for my $n (keys %is_output) { $value{$n} //= 'X'; }

# ---------- Fault under test ----------
my $fault_net  = 23;
my $fault_type = "SA0";

print "\nFault: net $fault_net $fault_type\n";

# ---------- Fault activation ----------
$value{$fault_net} = ($fault_type eq "SA0") ? 'D' : 'DBAR';

# ---------- D-algorithm forward implication ----------
my @queue = ($fault_net);
my %visited;

while (@queue) {
    my $curr = shift @queue;
    next if $visited{$curr}++;
    next unless exists $fanout{$curr};

    for my $fo (@{ $fanout{$curr} }) {
        next unless $gate_type{$fo} eq "NAND";
        if (propagate_nand($fo)) {
            push @queue, $fo;
        }
    }
}

# ---------- NAND propagation ----------
sub propagate_nand {
    my ($out) = @_;
    my @ins = @{ $fanin{$out} };

    my $d_in;
    for my $i (@ins) {
        if ($value{$i} eq 'D' || $value{$i} eq 'DBAR') {
            $d_in = $i;
        }
    }
    return 0 unless defined $d_in;

    # Sensitize side inputs
    for my $i (@ins) {
        next if $i eq $d_in;
        return 0 if $value{$i} eq '0';
        $value{$i} = 1 if $value{$i} eq 'X';
    }

    $value{$out} = ($value{$d_in} eq 'D') ? 'DBAR' : 'D';
    return 1;
}

# ---------- Report ----------
print "\nNet values after ATPG attempt:\n";
for my $n (sort {$a <=> $b} keys %value) {
    print "Net $n : $value{$n}\n";
}

# ---------- Output check ----------
my $detected = 0;
for my $o (keys %is_output) {
    if ($value{$o} eq 'D' || $value{$o} eq 'DBAR') {
        print "\nFault observed at OUTPUT net $o\n";
        $detected = 1;
    }
}

print "\nResult: ";
print $detected ? "TEST EXISTS\n" : "FAULT REDUNDANT / UNTESTABLE\n";

