use strict;


use constant {true => 1, false => 0};


my $text;
while (my $in = <>) {
$text .= $in;
}

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
	while (!isWhitespace($text[$i])) {
	@symbols[$currentSymbol] .= $text[$i];
	$i++;
	}
	}
$currentSymbol++;
}
else {$i++;}
}


print "|$_|" foreach(@symbols);
print "\n";


my %variables;

$i = 0;
while ($i < $currentSymbol) {
if ($symbols[$i] eq "->") {
$variables{$symbols[$i+1]} = $symbols[$i-1];
}

}







sub isWhitespace {
my ($char) = @_;
return true if ($char =~ /[\s\0]/);
return false;
}
