package App::GitGot::Command::update_status;
# ABSTRACT: update managed repositories then display their status
$App::GitGot::Command::update_status::VERSION = '1.19';
use Mouse;
extends 'App::GitGot::Command';
use 5.010;

sub command_names { qw/ update_status upst / }

sub _execute {
  my ( $self, $opt, $args ) = @_;

  say "UPDATE";
  $self->_update( $self->active_repos );

  say "\nSTATUS";
  $self->_status( $self->active_repos );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::update_status - update managed repositories then display their status

=head1 VERSION

version 1.19

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
