package App::GitGot::Command::update;
BEGIN {
  $App::GitGot::Command::update::VERSION = '0.3';
}
BEGIN {
  $App::GitGot::Command::update::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: update managed repositories

use Moose;
extends 'App::GitGot::Command';
use 5.010;

use Capture::Tiny qw/ capture /;

sub command_names { qw/ update up / }

sub _execute {
  my ( $self, $opt, $args ) = @_;

 REPO: for my $repo ( $self->active_repos ) {
    next REPO unless $repo->repo;

    my $name = $repo->name;

    my $msg = sprintf "%3d) %-25s : ", $repo->number, $repo->name;

    my ( $status, $fxn );

    given ( $repo->type ) {
      when ('git') { $fxn = '_git_update' }
      ### FIXME      when( 'svn' ) { $fxn = 'svn_update' }
      default { $status = "ERROR: repo type '$_' not supported" }
    }

    $status = $self->$fxn($repo) if ($fxn);

    next REPO if $self->quiet and !$status;

    say "$msg$status";
  }
}

sub _git_update {
  my ( $self, $entry ) = @_
    or die "Need entry";

  my $path = $entry->{path};

  my $msg = '';

  if ( !-d $path ) {
    my $repo = $entry->{repo};

    my ( $o, $e ) = capture { system("git clone $repo $path") };

    if ( $e =~ /\S/ ) {
      $msg .= "ERROR: $e";
    }
    else {
      $msg .= 'Checked out';
    }
  }
  elsif ( -d "$path/.git" ) {
    my ( $o, $e ) = capture { system("cd $path && git pull") };

    if ( $o =~ /^Already up-to-date/m and !$e ) {
      $msg .= 'Up to date' unless $self->quiet;
    }
    elsif ( $e =~ /\S/ ) {
      $msg .= 'ERROR';
    }
    else {
      $msg .= 'Updated';
    }

    return ( $self->verbose ) ? "$msg\n$o$e" : $msg;
  }

}

1;

__END__
=pod

=head1 NAME

App::GitGot::Command::update - update managed repositories

=head1 VERSION

version 0.3

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

