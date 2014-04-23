package App::GitGot::Command::this;
# ABSTRACT: check if the current repository is managed
$App::GitGot::Command::this::VERSION = '1.11';
use Mouse;
extends 'App::GitGot::Command';
use 5.010;

use Cwd;

sub command_names { qw/ this / }

sub _execute {
  my( $self, $opt, $args ) = @_;

  $self->_path_is_managed( getcwd() ) or exit 1;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::this - check if the current repository is managed

=head1 VERSION

version 1.11

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
