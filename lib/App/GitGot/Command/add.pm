package App::GitGot::Command::add;
# ABSTRACT: add a new repo to your config
$App::GitGot::Command::add::VERSION = '1.13';
use Mouse;
extends 'App::GitGot::Command';
use 5.010;

use App::GitGot::Repo::Git;
use Config::INI::Reader;
use Cwd;
use File::Basename;
use Term::ReadLine;

has 'defaults' => (
  is          => 'rw',
  isa         => 'Bool',
  cmd_aliases => 'D',
  traits      => [qw/ Getopt /],
);

has 'origin' => (
  is          => 'rw',
  isa         => 'Str',
  cmd_aliases => 'o',
  default     => 'origin',
  traits      => [qw/ Getopt /],
);

sub _execute {
  my ( $self, $opt, $args ) = @_;

  my $new_entry = $self->_build_new_entry_from_user_input();

  # this will exit if the new_entry duplicates an existing repo in the config
  $self->_check_for_dupe_entries($new_entry);

  $self->add_repo( $new_entry );
  $self->write_config;
}

sub _build_new_entry_from_user_input {
  my ($self) = @_;

  my ( $repo, $name, $type, $tags, $path );

  if ( -e '.git' ) {
    ( $repo, $name, $type ) = $self->_init_for_git;
  }
  else {
    say STDERR "ERROR: Non-git repos not supported at this time.";
    exit(1);
  }

  if ( $self->defaults ) {
    my $cwd = getcwd
      or die "ERROR: Couldn't determine path";
    $name //= basename getcwd;
    die "ERROR: Couldn't determine name"      unless $name;
    $repo //= '';
    die "ERROR: Couldn't determine repo type" unless $type;
    $path = $cwd;
  }
  else {
    my $term = Term::ReadLine->new('gitgot');
    $name = $term->readline( 'Name: ', $name );
    $repo = $term->readline( ' URL: ', $repo );
    $path = $term->readline( 'Path: ', getcwd );
    $tags = $term->readline( 'Tags: ', $tags );
  }

  my $new_entry = {
    repo => $repo,
    name => $name,
    type => $type,
    path => $path,
  };

  $new_entry->{tags} = $tags if $tags;

  return App::GitGot::Repo::Git->new({ entry => $new_entry });
}

sub _check_for_dupe_entries {
  my ( $self, $new_entry ) = @_;

REPO: foreach my $entry ( $self->all_repos ) {
    foreach (qw/ name repo type path /) {
      if ( $new_entry->$_ ) {
        next REPO unless $entry->$_ and $entry->$_ eq $new_entry->$_;
      }
    }
    say STDERR
"ERROR: Not adding entry for '$entry->{name}'; exact duplicate already exists.";
    exit(1);
  }
}

sub _init_for_git {
  my $self = shift;

  my $cfg = Config::INI::Reader->read_file('.git/config');

  my $remote = sprintf 'remote "%s"', $self->origin;

  no warnings qw/ uninitialized /;

  my $repo = $cfg->{$remote}{url};
  my ( $name ) = $repo =~ m|([^/]+).git$|;

  return ( $repo, $name, 'git' );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::add - add a new repo to your config

=head1 VERSION

version 1.13

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
