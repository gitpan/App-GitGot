package App::GitGot::Command::fork;
BEGIN {
  $App::GitGot::Command::fork::VERSION = '1.0';
}
BEGIN {
  $App::GitGot::Command::fork::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: fork a github repo

use Moose;
extends 'App::GitGot::Command';
use 5.010;

use autodie;
use App::GitGot::Repo::Git;
use Cwd;
use File::Slurp;
use Net::GitHub::V2::Repositories;

sub _execute {
  my( $self, $opt, $args ) = @_;

  my $github_url = shift @$args
    or say STDERR "ERROR: Need the URL of a repo to fork!" and exit(1);

  my( $user , $pass ) = _parse_github_identity();

  my( $owner , $repo_name ) = _parse_github_url( $github_url );

  Net::GitHub::V2::Repositories->new(
    owner => $owner ,
    repo  => $repo_name ,
    login => $user ,
    token => $pass ,
  )->fork; ## hardcore forking action!

  my $new_repo_url = $github_url;
  $new_repo_url =~ s/$owner/$user/;

  my $new_repo = App::GitGot::Repo::Git->new({ entry => {
    name => $repo_name ,
    path => cwd() . "/$repo_name" ,
    repo => $new_repo_url ,
    type => 'git' ,
  }});

  $self->add_repo( $new_repo );
  $self->write_config;
}

sub _parse_github_identity {
  my $file = "$ENV{HOME}/.github-identity";

  -e $file or
    say STDERR "ERROR: Can't find $ENV{HOME}/.github-identity" and exit(1);

  my @lines = read_file( $file );

  my %config = map { my( @x ) = split /\s/; { $x[0] => $x[1] } } @lines;

  my $user = $config{login}
    or say STDERR "Couldn't parse login info from ~/.github_identity" and exit(1);

  my $pass = $config{token}
    or say STDERR "Couldn't parse token info from ~/.github_identity" and exit(1);

  return( $user , $pass );
}

sub _parse_github_url {
  my $url = shift;

  my( $owner , $repo ) = $url =~ m|/github.com/([^/]+)/([^/]+).git$|
    or say STDERR "ERROR: Can't parse '$url'" and exit(1);

  return( $owner , $repo );
}

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

App::GitGot::Command::fork - fork a github repo

=head1 VERSION

version 1.0

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

