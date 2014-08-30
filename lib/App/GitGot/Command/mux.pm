package App::GitGot::Command::mux;
# ABSTRACT: open a tmux window for a selected project
$App::GitGot::Command::mux::VERSION = '1.19';
use Mouse;
extends 'App::GitGot::Command';
use 5.010;

has dirty => (
  traits        => [qw(Getopt)] ,
  isa           => 'Bool',
  is            => 'ro',
  cmd_aliases   => 'D',
  documentation => 'open session or window for all dirty repos'
);

has session => (
  traits        => [qw(Getopt)],
  isa           => 'Bool',
  is            => 'ro',
  cmd_aliases   => 's',
  documentation => 'use tmux-sessions',
);

sub command_names { qw/ mux tmux / }

sub _execute {
  my( $self, $opt, $args ) = @_;

  my @repos = $self->dirty ? $self->_get_dirty_repos() : $self->active_repos();

  my $target = $self->session ? 'session' : 'window';

 REPO: foreach my $repo ( @repos ) {
    # is it already opened?
    my %windows = reverse map { /^(\d+):::(\S+)/ }
      split "\n", `tmux list-$target -F"#I:::#W"`;

    if( my $window = $windows{$repo->name} ) {
      if ($self->session) {
        system 'tmux', 'switch-client', '-t' => $window;
      }
      else {
        system 'tmux', 'select-window', '-t' => $window;
      }
      next REPO;
    }

    chdir $repo->path;

    if ($self->session) {
      delete local $ENV{TMUX};
      system 'tmux', 'new-session', '-d', '-s', $repo->name;
      system 'tmux', 'switch-client', '-t' => $repo->name;}
    else {
      system 'tmux', 'new-window', '-n', $repo->name;
    }
  }
}

sub _get_dirty_repos {
  my $self = shift;

  my @dirty_repos;
  foreach my $repo ( @{ $self->full_repo_list } ) {
    my $status = $repo->status();

    unless ( ref( $status )) {
      die "You need at least Git version 1.7 to use the --dirty flag.\n";
    }

    push @dirty_repos , $repo
      if $status->is_dirty;
  }

  return @dirty_repos;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::mux - open a tmux window for a selected project

=head1 VERSION

version 1.19

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
