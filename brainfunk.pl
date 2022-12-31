use Class::Struct;
 
$cur = 0;
$perl_trim_variable =~ s/^\s+|\s+$//;


sub setcur {
my($to) = @_;
my $newcur = $to;
while ($newcur < $cur) {
print "<";
$cur--;
}
while ($cur < $newcur) {
print ">";
$cur++;
}

}

sub setval {
my($to) = @_;

my $settoamt = $to;
while ($settoamt < $arr[$cur]) {
$arr[$cur]--;
$arr[$cur] = 255 if ($arr[$cur] == -1);
print "-";
}
while ($arr[$cur] < $settoamt) {
$arr[$cur]++;
print "+";
}

}

sub varwitvalclosestto {
my($to) = @_;
my $currentchamp = 0;
my @range = (0..255);
my $champi;
for my $i (@range) {
$currentchamp = $arr[$champi = $i] if (abs($to - $arr[$i]) > abs($to - $currentchamp));
}
return $champi;
}

sub findandreplace {
my($name, $body, $paramsref, $linesref) = @_;
my $parens = 0;
my $openparen_index = 0;
foreach $line (@{$linesref}) {
$nameloc = index($line, $name) + length($name);
#iterate over characters looking for parens starting at $nameloc
my $iter = 0;
foreach $char (split //, substr($line, $nameloc)) {
if ($char eq '(') {
$parens++;
$openparen_index = $iter;
}
$iter++;
}
}

print $parens;


#repeat but find closing parens
#foreach $line (@{$linesref}) {
#for (my $i = $openparen_index; $parens > 0; $i++) {
#if (@{$linesref}[$i] eq ')') {
#$parens--;
#if ($parens == 0) {
#$closingparen_index = $i;
#}
#}
#}

#}



my $result;
#foreach $replace (@replacements) {
#foreach $param (@params) {
#foreach $bodyline ($body) {
#$bodyline =~ s/$param/$replace/g;
#$result .= $bodyline;
#}

#}
#}

return $result;
}




struct(func => {
name => '$',
params => '@',
body => '$'
});
use Data::Dumper;
my @funcs = ();
my $fiter = 0;
my $fcount = 0;
my $currentbody = "";
while (my $in = <>) {

if ($fcount == 0 && $in =~ s/(\S+)\s*\((.+)\)\s*\=//) {
$fcount = 1;
$funcs[$fiter] = func->new();
$funcs[$fiter]->name($1);
@params = split(",", $2);
$funcs[$fiter]->params([@params]);

#print Dumper($funcs[$fiter]);

}

if ($fcount == 1 && $in =~ m/\((.*)/) {
$foundend = index($in, ")");

$currentbody .= substr($in, index($in, "(")+1, $foundend-2);

if ($foundend) {
$funcs[$fiter]->body($currentbody);
findandreplace($funcs[$fiter]->name, $funcs[$fiter]->body, $funcs[$fiter]->params);
$fiter++;
$fcount = 0;
}
else {
$fcount = 2;
}

}

if ($fcount == 2) {
$foundend = index($in, ")");
$currentbody .= substr($in, index($in, ")")+1, $foundend-2);
if ($foundend) {
$funcs[$fiter]->body($currentbody);
findandreplace($funcs[$fiter]->name, $funcs[$fiter]->body, $funcs[$fiter]->params);
$fiter++;
$fcount = 0;
}



}


push(@lines, $in);
}

@tmp11 = ["text", "t1"];
findandreplace("test", "print text", \@tmp11, \@lines);
exit;


foreach $in (@lines){
if ($in =~ m/\{(.+)\}/) {
$expr = $1;
$m = eval"$expr";
$indexstart = index($in, '{');
$indexend = index($in, '}', -1);
substr($in, $indexstart, $indexend) = $m;
#print "\nsubstr($in, $indexstart, $indexend) = $m)\n";
#$_ =~ s/\{(.+)\}/eval"$1"/e;
}

#$_ =~ s/\{(.+)\}/eval($1)/ge;

if ($in =~ m/(.+)=(.+)/) {
$from = $1;
$from =~ $perl_trim_variable;
$to = $2;
$to =~ $perl_trim_variable;
if ($from =~ /\[(\d+)\]/) {
setcur($1);
}
if ($to =~ /(\d+)/) {
setval($1);
}

}

if ($in =~ m/print\s*\[(\d+)\]/) {
setcur($1);
print ".";
}
elsif ($in =~ m/print\s*(.+)/) {
$num = $1;
@nums = split(/,/, $num);
foreach $num (@nums) {
setcur(varwitvalclosestto($num));
$oldval = $arr[$cur];
setval($num);
print ".";
}
setval($oldval);
}

if ($in =~ m/get/) {
print ",";
}

}


print "\n";

