package Log::ger::Output::Callback;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

sub get_hooks {
    my %plugin_conf = @_;

    my $hooks = {};

    if ($plugin_conf{logging_cb}) {
        $hooks->{create_outputter} = [
            __PACKAGE__, # key
            # we want to handle all levels, thus we need to be higher priority
            # than default Log::ger hooks (10) which will install null loggers
            # for less severe levels.
            9,           # priority
            sub {        # hook
                my %hook_args = @_; # see Log::ger::Manual::Internals/"Arguments passed to hook"
                my $outputter = sub {
                    my ($per_target_conf, $msg, $per_msg_conf) = @_;
                    my $level = $per_msg_conf->{level} // $hook_args{level};
                    $plugin_conf{logging_cb}->($per_target_conf, $level, $msg, $per_msg_conf);
                };
                [$outputter];
            },
        ];
    }

    if ($plugin_conf{detection_cb}) {
        $hooks->{create_level_checker} = [
            __PACKAGE__, # key
            9,          # priority
            sub {        # hook
                my %hook_args = @_; # see Log::ger::Manual::Internals/"Arguments passed to hook"
                my $level_checker = sub {
                    $plugin_conf{detection_cb}->($hook_args{level});
                };
                [$level_checker];
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
     logging_cb   => sub { my ($per_target_conf, $lvlnum, $msg, $per_msg_conf) = @_; ... }, # optional
     detection_cb => sub { my ($lvlnum) = @_; ... },                                        # optional
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
