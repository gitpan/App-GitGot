package App::GitGot::Command::status;
BEGIN {
  $App::GitGot::Command::status::VERSION = '0.3';
}
BEGIN {
  $App::GitGot::Command::status::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: print status info about repos

use Moose;
extends 'App::GitGot::Command';
use 5.010;

use Capture::Tiny qw/ capture /;

sub command_names { qw/ status st / }

sub _execute {
  my ( $self, $opt, $args ) = @_;

 REPO: for my $repo ( $self->active_repos ) {
    my $msg = sprintf "%3d) %-35s : ", $repo->number, $repo->name;

    my ( $status, $fxn );

    if ( -d $repo->path ) {
      given ( $repo->type ) {
        when ('git') { $fxn = '_git_status' }
        ### FIXME      when( 'svn' ) { $fxn = 'svn_status' }
        default { $status = "ERROR: repo type '$_' not supported" }
      }

      $status = $self->$fxn($repo) if ($fxn);

      next REPO if $self->quiet and !$status;
    }
    elsif ( $repo->repo ) {
      $status = 'Not checked out';
    }
    else {
      my $name = $repo->name;
      $status = "ERROR: repo '$name' does not exist";
    }

    say "$msg$status";
  }
  }

sub _git_status {
  my ( $self, $entry ) = @_
    or die "Need entry";

  my $path = $entry->{path};

  my $msg = '';

  if ( -d "$path/.git" ) {
    my ( $o, $e ) = capture { system("cd $path && git status") };

    if ( $o =~ /^nothing to commit/m and !$e ) {
      if ( $o =~ /Your branch is ahead .*? by (\d+) / ) {
        $msg .= "Ahead by $1";
      }
      else { $msg .= 'OK' unless $self->quiet }
    }
    elsif ($e) { $msg .= 'ERROR' }
    else       { $msg .= 'Dirty' }

    return ( $self->verbose ) ? "$msg\n$o$e" : $msg;
  }
}

1;

__END__
=pod

=head1 NAME

App::GitGot::Command::status - print status info about repos

=head1 VERSION

version 0.3

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

