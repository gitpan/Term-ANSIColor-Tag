package Term::ANSIColor::Tag::Parser;
use strict;
use warnings;
use base qw(
    HTML::Parser
    Class::Accessor::Lvalue::Fast
);

use Term::ANSIColor;
local $Term::ANSIColor::AUTORESET = 1;

use constant RESET => "\e[0m";

__PACKAGE__->mk_accessors(qw(result stack));

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
       $self->result = '';
       $self->stack = [];
       $self;
}

sub start {
    my ($self, $tagname, $attr, $attrseq, $text) = @_;
    if (my $escape_sequence = $self->get_escape_sequence($tagname)) {
        push @{$self->stack}, $tagname;
        $self->result .= $escape_sequence;
    }
    else {
        $self->result .= $text;
    }
}

sub text {
    my ($self, $text) = @_;
    $self->result .= $self->unescape($text);
}

sub end {
    my ($self, $tagname, $text) = @_;
    if (my $color = $self->get_escape_sequence($tagname)) {
        pop @{$self->stack};
        $self->result .= RESET;
        if (scalar @{$self->stack}) {
            $self->result .= $self->get_escape_sequence($self->stack->[-1]);
        }
    }
    else {
        $self->result .= $text;
    }
}

sub get_escape_sequence {
    my ($self, $name) = @_;
    my $escape_sequence  = '';
    for my $key (keys %Term::ANSIColor::ATTRIBUTES) {
        if (lc $name eq lc $key) {
            $escape_sequence = sprintf "\e[%dm",
                                       $Term::ANSIColor::ATTRIBUTES{$key};
        }
    }
    $escape_sequence;
}

sub unescape {
    my ($self, $text) = @_;
    return '' if !defined $text;
    $text =~ s/&lt;/</ig;
    $text =~ s/&gt;/>/ig;
    $text;
}

1;
