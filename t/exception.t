use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;
use Term::ANSIColor::Tag;

dies_ok {
    Term::ANSIColor::Tag->colorize(q{<red>foo</blue>});
}, 'Invalid end tag';
like $@, qr{Invalid end tag was found}, 'Invalid end tag';
