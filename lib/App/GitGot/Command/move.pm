package App::GitGot::Command::move;
# ABSTRACT: move a repo in a new directory
$App::GitGot::Command::move::VERSION = '1.19';
use Mouse;
extends 'App::GitGot::Command';
use 5.010;

use Cwd;
use Path::Class;
use File::Copy::Recursive qw/ dirmove /;

sub command_names { qw/ move mv / }

sub _execute {
  my( $self, $opt, $args ) = @_;

  die "usage: got move <repo> <new dir>\n" unless @$args <= 2 and @$args > 0;

  my $repo;

  my $target_dir = $args->[-1];

  # got move <name> <new location>
  if( @$args == 2 ) {
      die "ERROR: You need to select a single repo\n"
        unless $self->active_repos and $self->active_repos == 1;

      my( $repo ) = $self->active_repos;
  }
  else { # no repo given, assume we are in it
    my $dir = dir( getcwd );

    # find repo root
    while ( ! grep { -d and $_->basename eq '.git' } $dir->children ) {
        die "you don't seem to be in a git directory\n" if $dir eq $dir->parent;
        $dir = $dir->parent;
    }

    ( $repo ) = grep { $_->path eq "$dir" } @{$self->full_repo_list}
        or die "'$dir' not monitored by got\n";
  }

  $target_dir = dir($target_dir);
  $target_dir = $target_dir->subdir( dir($repo->path)->basename ) if -d $target_dir;

  dirmove( $repo->path => $target_dir )
    or die "couldn't move ", $repo->name, " to '$target_dir': $!";

  $repo->{path} = "$target_dir";
  $self->write_config;

  say sprintf '%s moved to %s', $repo->name, $target_dir;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::move - move a repo in a new directory

=head1 VERSION

version 1.19

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
