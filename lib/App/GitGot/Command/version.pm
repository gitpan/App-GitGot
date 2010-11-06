package App::GitGot::Command::version;
# ABSTRACT: display application version

use Moose;
extends 'App::GitGot::Command';
use 5.010;

sub _execute {
  my( $self, $opt, $args ) = @_;

  say $App::GitGot::VERSION
}

1;

__END__
=pod

=head1 NAME

App::GitGot::Command::version - display application version

=head1 VERSION

version 0.1

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

