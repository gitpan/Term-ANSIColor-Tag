use inc::Module::Install;

name     'Term-ANSIColor-Tag';
author   'Kentaro Kuribayashi, <kentarok@cpan.org>',
license  'MIT';
all_from 'lib/Term/ANSIColor/Tag.pm';

requires 'Term::ANSIColor';
requires 'Class::Accessor::Lvalue::Fast';
requires 'HTML::Parser';

build_requires 'Test::More';
use_test_base;
author_tests   'xt';
auto_include_deps;
WriteAll;
