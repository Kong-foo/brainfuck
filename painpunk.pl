use strict;


use constant {true => 1, false => 0};

my $incrementOperator = '+';
my %variables;
my $text;

my $pointer = 0;
my $increment = 0;

while (my $in = <>) {
$text .= $in;
}




my @symbols = splitIntoSymbols($text);
my $output = resolve(@symbols);

#print "|$_|" foreach(@symbols);
#print "\n";
print "$output\n";



#print "$_ $variables{$_}\n" for (keys %variables);







sub isWhitespace {
my ($char) = @_;
return true if ($char =~ /[\s\0]/);
return false;
}



sub splitIntoSymbols {
my ($text) = @_;
my @text = split('', $text);

my $i = 0;
$i++ while (isWhitespace($text[$i]) && $i < length($text));

my @symbols;
my $currentSymbol = 0;

while ($i < length($text)) {
if (!isWhitespace($text[$i])) {
	if ($text[$i] eq '[') {
	while ($text[$i] ne ']') {
	@symbols[$currentSymbol] .= $text[$i];
	$i++;
	}
	@symbols[$currentSymbol] .= ']';
	$i++;
	}
	else {
	while (!isWhitespace($text[$i]) && $text[$i] ne '') {
	@symbols[$currentSymbol] .= $text[$i];
	$i++;
	}
	}
$currentSymbol++;
}
else {$i++;}
}

return @symbols;
}




sub resolve {
my (@symbols) = @_;

my $i = 0;
my $output = "";
while ($i < scalar(@symbols)) {

	if ($symbols[$i] eq "->") {
	($symbols[$i-1], $symbols[$i+1]) = resolveVariables($symbols[$i-1], $symbols[$i+1]);
	$variables{$symbols[$i+1]} = $symbols[$i-1];
	}

	elsif ($symbols[$i] eq "+") {
	($symbols[$i-1], $symbols[$i+1]) = resolveVariables($symbols[$i-1], $symbols[$i+1]);
	return $symbols[$i-1] + $symbols[$i+1];
		#$output .= incrementOperator($symbols[$i-1] + $symbols[$i+1]);
	}

	elsif ($symbols[$i] =~ s/^\[(.+)\]$/$1/) {
	$symbols[$i] = resolve(resolveVariables(splitIntoSymbols($symbols[$i])));
	}

	elsif ($symbols[$i] eq "print") {
	$i++;
	if ($symbols[$i] =~ s/^\[(.+)\]$/$1/) {
	$symbols[$i] = resolve(resolveVariables(splitIntoSymbols($symbols[$i])));
	}
	if ($symbols[$i] =~ s/^\-(.+)\-$/$1/) {
	$output .= convertPrint($symbols[$i]);
	}
	else {
	($symbols[$i]) = resolveVariables($symbols[$i]);
	$output .= ">" . incrementOperator($symbols[$i]);
	}
	}

	elsif ($symbols[$i] eq "while") {
	$i++;
	
	}

	elsif ($symbols[$i] eq "<") {
	#implement
	#https://esolangs.org/wiki/Brainfuck_algorithms
	#https://stackoverflow.com/questions/46056821/how-to-write-if-else-statements-in-brainfuck
	}


$i++;
}
return $output;
}

#return n increments
sub incrementOperator {
my ($n) = @_;
my $text = "";
for (my $p=0; $p < $n; $p++) {
$text .= $incrementOperator;
}
return $text;
}


#this allows having integers and some operators as variables lol
sub resolveVariables {

my @vals;
foreach my $var (@_) {

if ($variables{$var}) {
push (@vals, $variables{$var});
}
else {
push (@vals, $var);
}

}
return @vals;
}


sub convertPrint {
my ($text) = @_;
my $bfText = "";

foreach my $char (split('', $text)) {
while (ord($char) < $increment) { $increment--; $bfText.='-'; }
while (ord($char) > $increment) { $increment++; $bfText.='+'; }
$bfText.='.';
}
return $bfText;
}
