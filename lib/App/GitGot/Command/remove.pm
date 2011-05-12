package App::GitGot::Command::remove;
BEGIN {
  $App::GitGot::Command::remove::VERSION = '1.0';
}
BEGIN {
  $App::GitGot::Command::remove::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: remove a managed repository from your config

use Moose;
extends 'App::GitGot::Command';
use 5.010;

use List::MoreUtils qw/ any /;

has 'force' => (
  is          => 'rw',
  isa         => 'Bool',
  traits      => [qw/ Getopt /],
);

sub command_names { qw/ remove rm / }

sub _execute {
  my( $self, $opt, $args ) = @_;

  unless ( $self->active_repos and @$args or $self->tags) {
    say STDERR "ERROR: You need to select one or more repos to remove";
    exit(1);
  }

  my @new_repo_list;

 REPO: for my $repo ( $self->all_repos ) {
    my $number = $repo->number;

    if ( any { $number == $_->number } $self->active_repos ) {
      my $name = $repo->label;

      if ( $self->force or $self->prompt_yn( "got rm: remove '$name'?" )) {
        say "Removed repo '$name'" if $self->verbose;
        next REPO;
      }
    }
    push @new_repo_list , $repo;
  }

  $self->full_repo_list( \@new_repo_list );
  $self->write_config();
}

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

App::GitGot::Command::remove - remove a managed repository from your config

=head1 VERSION

version 1.0

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

