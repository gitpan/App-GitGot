package App::GitGot;
BEGIN {
  $App::GitGot::VERSION = '1.01';
}
BEGIN {
  $App::GitGot::AUTHORITY = 'cpan:GENEHACK';
}
use Moose;
extends 'MooseX::App::Cmd';
# ABSTRACT: A tool to make it easier to manage multiple git repositories.


__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

App::GitGot - A tool to make it easier to manage multiple git repositories.

=head1 VERSION

version 1.01

=head1 SYNOPSIS

See C<perldoc got> for usage information.

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

