#!/usr/bin/env perl
use warnings;
use strict;
use feature 'say';
use feature 'try';
use Data::Dump qw(dump);

my @var_10 = (1..10);
my $var_10 = \@var_10;

for my $i($var_10) {
  say $i;
  say $i;
  say $i;
}
my $price = '$100';
my @parts = ("hello", "world");
for my $part(@parts){

}