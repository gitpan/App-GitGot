package App::GitGot::Repo::Git;
{
  $App::GitGot::Repo::Git::VERSION = '1.03';
}
BEGIN {
  $App::GitGot::Repo::Git::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: Git repo objects
use Mouse;
extends 'App::GitGot::Repo';
use 5.010;

use namespace::autoclean;
use Git::Wrapper;
use Test::MockObject;
use Try::Tiny;

has '+type' => ( default => 'git' );

has '_wrapper' => (
  is         => 'ro' ,
  isa        => 'Git::Wrapper' ,
  lazy_build => 1 ,
  handles    => [ qw/
                      cherry
                      clone
                      config
                      gc
                      pull
                      push
                      remote
                      status
                      symbolic_ref
                    / ] ,
);

sub _build__wrapper {
  my $self = shift;

  # for testing...
  if ( $ENV{GITGOT_FAKE_GIT_WRAPPER} ) {
    my $mock = Test::MockObject->new;
    $mock->set_isa( 'Git::Wrapper' );
    foreach my $method ( qw/ cherry clone gc pull
                             remote symbolic_ref / ) {
      $mock->mock( $method => sub { return( '1' )});
    }
    $mock->mock( 'status' => sub { package MyFake;
{
  $MyFake::VERSION = '1.03';
}
BEGIN {
  $MyFake::AUTHORITY = 'cpan:GENEHACK';
} sub get { return () }; return bless {} , 'MyFake' } );
    $mock->mock( 'config' => sub { 0 });

    return $mock
  }
  else {
    return Git::Wrapper->new( $self->path )
      or die "Can't make Git::Wrapper";
  }
}


sub current_branch {
  my $self = shift;

  my $branch;

  try {
    ( $branch ) = $self->symbolic_ref( 'HEAD' );
    $branch =~ s|^refs/heads/|| if $branch;
  }
  catch {
    die $_ unless $_ && $_->isa('Git::Wrapper::Exception')
      && $_->error eq "fatal: ref HEAD is not a symbolic ref\n"
  };

  return $branch;
}

sub current_remote_branch {
  my( $self ) = shift;

  my $remote = 0;

  if ( my $branch = $self->current_branch ) {
    try {
      ( $remote ) = $self->config( "branch.$branch.remote" );
    }
    catch {
      ## not the most informative return....
      return 0 if $_ && $_->isa('Git::Wrapper::Exception') && $_->{status} eq '1';
    };
  }

  return $remote;
}

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

App::GitGot::Repo::Git - Git repo objects

=head1 VERSION

version 1.03

=head1 METHODS

=head2 current_branch

Returns the current branch checked out by this repository object.

=head2 current_remote_branch

Returns the remote branch for the branch currently checked out by this repo
object, or 0 if that information can't be extracted (if, for example, the
branch doesn't have a remote.)

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

