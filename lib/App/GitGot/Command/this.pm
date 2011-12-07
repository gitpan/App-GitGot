package App::GitGot::Command::this;
{
  $App::GitGot::Command::this::VERSION = '1.02';
}
BEGIN {
  $App::GitGot::Command::this::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: check if the current repository is managed

use Mouse;
extends 'App::GitGot::Command';
use 5.010;

use Cwd;
use Path::Class;

sub command_names { qw/ this / }

sub _execute {
  my( $self, $opt, $args ) = @_;

  my $dir = dir( getcwd );

  # find repo root
  while ( ! grep { -d and $_->basename eq '.git' } $dir->children ) {
      die "you don't seem to be in a git directory\n" if $dir eq $dir->parent;
      $dir = $dir->parent;
  }

  my $max_len = $self->max_length_of_an_active_repo_label;

  for my $repo ( $self->active_repos ) {
    next unless $repo->path eq $dir->absolute;

    my $repo_remote = ( $repo->repo and -d $repo->path ) ? $repo->repo
      : ( $repo->repo )    ? $repo->repo . ' (Not checked out)'
      : ( -d $repo->path ) ? 'NO REMOTE'
      : 'ERROR: No remote and no repo?!';

    printf "%3d) ", $repo->number;

    if ( $self->quiet ) { say $repo->label }
    else {
      printf "%-${max_len}s  %-4s  %s\n",
        $repo->label, $repo->type, $repo_remote;
      if ( $self->verbose ) {
        printf "    tags: %s\n" , $repo->tags if $repo->tags;
      }
    }

    return;
  }

  say "repository not in Got list";
}

__PACKAGE__->meta->make_immutable;
1;


__END__
=pod

=head1 NAME

App::GitGot::Command::this - check if the current repository is managed

=head1 VERSION

version 1.02

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

