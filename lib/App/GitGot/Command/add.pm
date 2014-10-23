package App::GitGot::Command::add;
BEGIN {
  $App::GitGot::Command::add::VERSION = '0.9.2';
}
BEGIN {
  $App::GitGot::Command::add::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: add a new repo to your config

use Moose;
extends 'App::GitGot::Command';
use 5.010;

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
    ( $repo, $name, $type ) = _init_for_git();
  }
  else {
    say "ERROR: Non-git repos not supported at this time.";
    exit;
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

  return App::GitGot::Repo->new({ entry => $new_entry });
}

sub _check_for_dupe_entries {
  my ( $self, $new_entry ) = @_;

REPO: foreach my $entry ( $self->all_repos ) {
    foreach (qw/ name repo type path /) {
      next REPO unless $entry->$_ and $entry->$_ eq $new_entry->$_;
    }
    say
"ERROR: Not adding entry for '$entry->{name}'; exact duplicate already exists.";
    exit;
  }
}

sub _init_for_git {
  my ( $repo, $name, $type );

  my $cfg = Config::INI::Reader->read_file('.git/config');

  if ( $cfg->{'remote "origin"'}{url} ) {
    $repo = $cfg->{'remote "origin"'}{url};
    if ( $repo =~ m|([^/]+).git$| ) {
      $name = $1;
    }
  }

  $type = 'git';

  return ( $repo, $name, $type );
}

1;

__END__
=pod

=head1 NAME

App::GitGot::Command::add - add a new repo to your config

=head1 VERSION

version 0.9.2

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

