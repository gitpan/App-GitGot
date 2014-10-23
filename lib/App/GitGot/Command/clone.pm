package App::GitGot::Command::clone;
# ABSTRACT: clone a remote repo and add it to your config
$App::GitGot::Command::clone::VERSION = '1.12';
use Mouse;
extends 'App::GitGot::Command';
use 5.010;

use App::GitGot::Repo::Git;
use Cwd;
use File::Basename;
use File::Spec;
use Term::ReadLine;

has 'defaults' => (
  is          => 'rw',
  isa         => 'Bool',
  cmd_aliases => 'D',
  traits      => [qw/ Getopt /],
);

sub _execute {
  my ( $self, $opt, $args ) = @_;
  my ( $repo , $path ) = @$args;

  $repo // ( say STDERR 'ERROR: Need the URL to clone!' and exit(1) );

  my $cwd = getcwd
    or( say STDERR "ERROR: Couldn't determine path" and exit(1) );


  my $name = basename $repo;
  $name =~ s/.git$//;

  $path //= "$cwd/$name";
  $path = File::Spec->rel2abs( $path );

  my $tags;

  unless ( $self->defaults ) {
    my $term = Term::ReadLine->new('gitgot');
    $name = $term->readline( 'Name: ', $name );
    $path = $term->readline( 'Path: ', $path );
    $tags = $term->readline( 'Tags: ', $tags );
  }

  my $new_entry = App::GitGot::Repo::Git->new({ entry => {
    repo => $repo,
    name => $name,
    type => 'git',
    path => $path,
  }});
  $new_entry->{tags} = $tags if $tags;

  $new_entry->clone( $repo , $path );

  $self->add_repo( $new_entry );
  $self->write_config;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::clone - clone a remote repo and add it to your config

=head1 VERSION

version 1.12

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
