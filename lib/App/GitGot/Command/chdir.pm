package App::GitGot::Command::chdir;
# ABSTRACT: open a subshell in a selected project
$App::GitGot::Command::chdir::VERSION = '1.19';
use Mouse;
extends 'App::GitGot::Command';
use 5.010;

sub command_names { qw/ chdir cd / }

sub _execute {
  my( $self, $opt, $args ) = @_;

  unless ( $self->active_repos and $self->active_repos == 1 ) {
    say STDERR 'ERROR: You need to select a single repo';
    exit(1);
  }

  my( $repo ) = $self->active_repos;

  chdir $repo->path
    or say STDERR "ERROR: Failed to chdir to repo ($!)" and exit(1);

  exec $ENV{SHELL};
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::chdir - open a subshell in a selected project

=head1 VERSION

version 1.19

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
