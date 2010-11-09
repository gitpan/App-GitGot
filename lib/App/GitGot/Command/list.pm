package App::GitGot::Command::list;
BEGIN {
  $App::GitGot::Command::list::VERSION = '0.4';
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

  for my $repo ( $self->active_repos ) {
    my $repo_name;

    if ( $repo->repo and -d $repo->path ) { $repo_name = $repo->repo }
    elsif ( $repo->repo ) { $repo_name = $repo->repo . ' (Not checked out)' }
    elsif ( -d $repo->path ) { $repo_name = 'NO REMOTE' }
    else { $repo_name = 'ERROR: No remote and no repo?!' }

    my $msg = sprintf "%-35s %-4s %-50s\n",
      $repo->name, $repo->type, $repo_name;

    printf "%3d) ", $repo->number;

    if ( $self->quiet ) { say $repo->name }
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

version 0.4

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

