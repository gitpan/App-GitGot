package App::GitGot::Command::push;
{
  $App::GitGot::Command::push::VERSION = '1.05';
}
BEGIN {
  $App::GitGot::Command::push::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: Push local changes to the default remote in git repos

use Mouse;
extends 'App::GitGot::Command';
use 5.010;

use Data::Dumper;
use Try::Tiny;

# incremental output looks nicer for this command...
STDOUT->autoflush(1);
sub _use_io_page { 0 }

sub _execute {
  my( $self, $opt, $args ) = @_;

  my $max_len = $self->max_length_of_an_active_repo_label;

 REPO: for my $repo ( $self->active_repos ) {
    next REPO unless $repo->type eq 'git';

    unless ( $repo->current_remote_branch and $repo->cherry ) {
      printf "%3d) %-${max_len}s : Nothing to push\n",
        $repo->number , $repo->label unless $self->quiet;
      next REPO;
    }

    try {
      printf "%3d) %-${max_len}s : ", $repo->number , $repo->label;
      # really wish this gave _some_ kind of output...
      my @output = $repo->push;
      printf "%s\n", $self->major_change( 'PUSHED' );
    }
    catch {
      say STDERR $self->error( 'ERROR: Problem with push on repo ' , $repo->label );
      say STDERR "\n" , Dumper $_;
    };
  }
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

App::GitGot::Command::push - Push local changes to the default remote in git repos

=head1 VERSION

version 1.05

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
