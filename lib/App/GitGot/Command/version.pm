package App::GitGot::Command::version;
{
  $App::GitGot::Command::version::VERSION = '1.10';
}
BEGIN {
  $App::GitGot::Command::version::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: display application version

use Mouse;
extends 'App::GitGot::Command';
use 5.010;

sub _execute { say $App::GitGot::VERSION }

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::version - display application version

=head1 VERSION

version 1.10

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
