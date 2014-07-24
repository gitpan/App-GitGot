package App::GitGot::Command::that;
# ABSTRACT: check if a given repository is managed
$App::GitGot::Command::that::VERSION = '1.17';
use Mouse;
extends 'App::GitGot::Command';
use 5.010;

sub command_names { qw/ that / }

sub _execute {
  my( $self, $opt, $args ) = @_;
  my $path = pop @$args;

  defined $path and -d $path
    or say STDERR 'ERROR: You must provide a path to a repo to check' and exit 1;

  $self->_path_is_managed( $path ) or exit 1;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::GitGot::Command::that - check if a given repository is managed

=head1 VERSION

version 1.17

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
