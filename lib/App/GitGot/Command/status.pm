package App::GitGot::Command::status;
BEGIN {
  $App::GitGot::Command::status::VERSION = '0.9.1';
}
BEGIN {
  $App::GitGot::Command::status::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: print status info about repos

use Moose;
extends 'App::GitGot::Command';
use 5.010;

use Term::ANSIColor;
use Try::Tiny;

sub command_names { qw/ status st / }

sub _execute {
  my ( $self, $opt, $args ) = @_;

  my $max_len = $self->max_length_of_an_active_repo_label;

 REPO: for my $repo ( $self->active_repos ) {
    my $label = $repo->label;

    my $msg = sprintf "%3d) %-${max_len}s  : ", $repo->number, $label;

    my ( $status, $fxn );

    if ( -d $repo->path ) {
      given ( $repo->type ) {
        when ('git') { $fxn = '_git_status' }
        ### FIXME      when( 'svn' ) { $fxn = 'svn_status' }
        default {
          $status = $self->error("ERROR: repo type '$_' not supported");
        }
      }

      $status = $self->$fxn($repo) if ($fxn);

      next REPO if $self->quiet and !$status;
    }
    elsif ( $repo->repo ) {
      $status = 'Not checked out';
    }
    else {
      $status = $self->error("ERROR: repo '$label' does not exist");
    }

    say "$msg$status";
  }
}

sub _git_status {
  my ( $self, $entry ) = @_
    or die "Need entry";

  my( $msg , $verbose_msg ) = $self->_run_git_status( $entry );

  $msg .= $self->_run_git_cherry( $entry )
    if $entry->current_remote_branch;

  return ( $self->verbose ) ? "$msg$verbose_msg" : $msg;
}

sub _run_git_cherry {
  my( $self , $entry ) = @_;

  my $msg = '';

  try {
    if ( $entry->remote ) {
      my $cherry = $entry->cherry;
      if ( $cherry > 0 ) {
        $msg = $self->major_change("Ahead by $cherry");
      }
    }
  }
  catch { $msg = $self->error('ERROR') . "\n$_" };

  return $msg
}

sub _run_git_status {
  my( $self , $entry ) = @_;

  my %types = (
    indexed  => 'Changes to be committed' ,
    changed  => 'Changed but not updated' ,
    unknown  => 'Untracked files' ,
    conflict => 'Files with conflicts' ,
  );

  my( $msg , $verbose_msg ) = ('','');

  try {
    my $status = $entry->status;
    if ( keys %$status ) { $msg .= $self->warning('Dirty') . ' ' }
    else                 { $msg .= $self->minor_change('OK ') unless $self->quiet }

    if ( $self->verbose ) {
    TYPE: for my $type ( keys %types ) {
        my @states = $status->get( $type ) or next TYPE;
        $verbose_msg .= "\n** $types{$type}:\n";
        for ( @states ) {
          $verbose_msg .= sprintf '  %-12s %s' , $_->mode , $_->from;
          $verbose_msg .= sprintf ' -> %s' , $_->to if $_->mode eq 'renamed';
          $verbose_msg .= "\n";
        }
      }
      $verbose_msg = "\n$verbose_msg" if $verbose_msg;
    }
  }
  catch { $msg .= $self->error('ERROR') . "\n$_" };

  return( $msg , $verbose_msg );
}

1;

__END__
=pod

=head1 NAME

App::GitGot::Command::status - print status info about repos

=head1 VERSION

version 0.9.1

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

