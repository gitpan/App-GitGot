package App::GitGot::Command::mux;
{
  $App::GitGot::Command::mux::VERSION = '1.06';
}
BEGIN {
  $App::GitGot::Command::mux::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: open a tmux window for a selected project

use Mouse;
extends 'App::GitGot::Command';
use 5.010;

sub command_names { qw/ mux tmux / }

sub _execute {
  my( $self, $opt, $args ) = @_;

  unless ( $self->active_repos and $self->active_repos == 1 ) {
    say STDERR 'ERROR: You need to select a single repo';
    exit(1);
  }

  my( $repo ) = $self->active_repos;

  # is it already opened?
  my %windows = reverse map { /^(\d+):::(\S+)/ }
    split "\n", `tmux list-windows -F"#I:::#W"`;

  if( my $window = $windows{$repo->name} ) {
      exec 'tmux', 'select-window', '-t' => $window;
  }

  chdir $repo->path;

  exec 'tmux', 'new-window', '-n', $repo->name;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

App::GitGot::Command::mux - open a tmux window for a selected project

=head1 VERSION

version 1.06

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
