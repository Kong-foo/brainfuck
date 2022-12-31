{$var = "hello"}




print_text (text,a) = 
( aaa
print {use IO::Scalar; my $out; tie *STDOUT, "IO::Scalar", \$out; print(ord($_), ($_ ne "\n") ? "," : "") for (split("", text."\n")); untie *STDOUT; return $out;}
)
