#!/usr/bin/env perl6

use Test;
use JSON::Tiny;

use lib ( my $dir = IO::Path.new($?FILE).parent ).path;

my $module_name = %*ENV<EXERCISM>.so ?? 'Example' !! 'Allergies';
my @potential_module = <p6 pm6 pm>.map:  $module_name ~ '.' ~ *; 

my $module = first { $dir.child($_).e }, |@potential_module
    or die "No file '$module_name.p6' found\n";

require $module <&allergic-to &list-allergies>;

plan 2;

my %cases = from-json $dir.child('cases.json').slurp;

subtest 'allergic-to' => {
    my @cases = |%cases{'allergic_to'}{'cases'};

    plan +@cases;

    for |@cases -> %case {
        subtest %case.<description> => {
            plan +|%case.<expected>;
            for |%case.<expected> -> %expected {
                is allergic-to(%case.<score>,%expected.<substance>), %expected.<result>
                    or diag %expected;
            }
        }
    }
};

subtest 'list' => {
    my @cases = |%cases{'list'}{'cases'};

    plan +@cases;

    for |@cases {
        is list-allergies(.<score>), .<expected>, .<description>
            or diag $_;
    }
};
