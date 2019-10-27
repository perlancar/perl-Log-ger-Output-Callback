package Log::ger::Output::Callback;

# DATE
# VERSION

use strict;
use warnings;

sub get_hooks {
    my %conf = @_;

    my $hooks = {};

    if ($conf{logging_cb}) {
        $hooks->{create_logml_routine} = [
            __PACKAGE__, # key
            50,          # priority
            sub {        # hook
                my %hook_args = @_;
                my $logger = sub {
                    $conf{logging_cb}->(@_);
                };
                [$logger];
            },
        ];
    }

    if ($conf{detection_cb}) {
        $hooks->{create_is_routine} = [
            __PACKAGE__, # key
            50,          # priority
            sub {        # hook
                my %hook_args = @_;
                my $logger = sub {
                    $conf{detection_cb}->($hook_args{level});
                };
                [$logger];
            },
        ];
    }

    return $hooks;
}

1;
# ABSTRACT: Send logs to a subroutine

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Log::ger::Output Callback => (
     logging_cb   => sub { my ($ctx, $numlevel, $msg) = @_; ... }, # optional
     detection_cb => sub { my ($numlevel) = @_; ... },             # optional
 );


=head1 DESCRIPTION

This output plugin provides an easy way to do custom logging in L<Log::ger>. If
you want to be more proper, you can also create your own output plugin, e.g.
L<Log::ger::Output::Screen> or L<Log::ger::Output::File>. To do so, follow the
tutorial in L<Log::ger::Manual::Tutorial::49_WritingAnOutputPlugin> or
alternatively just peek at the source code of this module.


=head1 CONFIGURATION

=head1 logging_cb => code

=head1 detection_cb => code


=head1 SEE ALSO

L<Log::ger>

Modelled after L<Log::Any::Adapter::Callback>

=cut
