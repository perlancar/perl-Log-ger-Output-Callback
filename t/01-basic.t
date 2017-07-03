#!perl

use strict;
use warnings;
use Test::More 0.98;

subtest "conf:logging_cb" => sub {
    my $str = "";
    require Log::ger::Output;
    Log::ger::Output->set('Callback', logging_cb => sub { $str .= $_[1] });
    my $h = {}; Log::ger::init_target(hash => $h);

    $h->{warn}("a");
    $h->{warn}("b");
    $h->{debug}("c");
    is($str, "ab");
};

# XXX test conf:detection_cb

done_testing;
