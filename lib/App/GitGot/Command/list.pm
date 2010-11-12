package App::GitGot::Command::list;
BEGIN {
  $App::GitGot::Command::list::VERSION = '0.7';
}
BEGIN {
  $App::GitGot::Command::list::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: list managed repositories

use Moose;
extends 'App::GitGot::Command';
use 5.010;

sub command_names { qw/ list ls / }

sub _execute {
  my( $self, $opt, $args ) = @_;

  my $max_len = $self->max_length_of_an_active_repo_label;

  for my $repo ( $self->active_repos ) {
    my $repo_remote = ( $repo->repo and -d $repo->path ) ? $repo->repo
      : ( $repo->repo ) ? $repo->repo . ' (Not checked out)'
        : ( -d $repo->path ) ? 'NO REMOTE'
          : 'ERROR: No remote and no repo?!';

    my $msg = sprintf "%-${max_len}s  %-4s  %s\n",
      $repo->label, $repo->type, $repo_remote;

    printf "%3d) ", $repo->number;

    if ( $self->quiet ) { say $repo->label }
    elsif ( $self->verbose ) {
      printf "$msg    tags: %s\n" , $repo->tags;
    }
    else { print $msg}
  }
}

1;

__END__
=pod

=head1 NAME

App::GitGot::Command::list - list managed repositories

=head1 VERSION

version 0.7

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

