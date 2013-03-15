package App::GitGot::Repo;
{
  $App::GitGot::Repo::VERSION = '1.05';
}
BEGIN {
  $App::GitGot::Repo::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: Base repository objects
use Mouse;
use 5.010;

use namespace::autoclean;

has 'label' => (
  is       => 'ro' ,
  isa      => 'Str' ,
);

has 'name' => (
  is          => 'ro',
  isa         => 'Str',
  required    => 1 ,
);

has 'number' => (
  is          => 'ro',
  isa         => 'Int',
  required    => 1 ,
);

has 'path' => (
  is          => 'ro',
  isa         => 'Str',
  required    => 1 ,
);

has 'repo' => (
  is          => 'ro',
  isa         => 'Str',
);

has 'tags' => (
  is          => 'ro',
  isa         => 'Str',
);

has 'type' => (
  is          => 'ro',
  isa         => 'Str',
  required    => 1 ,
);

sub BUILDARGS {
  my( $class , $args ) = @_;

  my $count = $args->{count} || 0;

  die "Must provide entry" unless
    my $entry = $args->{entry};

  my $repo = $entry->{repo} //= '';

  if ( ! defined $entry->{name} ) {
    $entry->{name} = ( $repo =~ m|([^/]+).git$| ) ? $1 : '';
  }

  $entry->{tags} //= '';

  my $return = {
    number => $count ,
    name   => $entry->{name} ,
    path   => $entry->{path} ,
    repo   => $repo ,
    type   => $entry->{type} ,
    tags   => $entry->{tags} ,
  };

  $return->{label} = $args->{label} if $args->{label};

  return $return;
}


sub in_writable_format {
  my $self = shift;

  my $writeable = {
    name => $self->name ,
    path => $self->path ,
  };

  foreach ( qw/ repo tags type /) {
    $writeable->{$_} = $self->$_ if $self->$_;
  }

  return $writeable;
}


__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

App::GitGot::Repo - Base repository objects

=head1 VERSION

version 1.05

=head1 METHODS

=head2 in_writable_format

Returns a serialized representation of the repository for writing out in a
config file.

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
