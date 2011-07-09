package App::GitGot::Outputter;
BEGIN {
  $App::GitGot::Outputter::VERSION = '1.01';
}
BEGIN {
  $App::GitGot::Outputter::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: Generic base class for outputting formatted messages.

use Moose;
use 5.010;

use Term::ANSIColor;

# boolean indicating whether color messages should be output at all
has 'no_color' => ( is => 'ro' , isa => 'Bool' , default => 0 );


sub error {
  my( $self , $message ) = @_;
  return $self->_colored( $message , $self->color_error );
}


sub warning {
  my( $self , $message ) = @_;
  return $self->_colored( $message , $self->color_warning );
}


sub major_change {
  my( $self , $message ) = @_;
  return $self->_colored( $message , $self->color_major_change );
}


sub minor_change {
  my( $self , $message ) = @_;
  return $self->_colored( $message , $self->color_minor_change );
}

sub _colored {
  my( $self , $message , $color_string ) = @_;

  return ( $self->no_color || $color_string eq 'uncolored' ) ? $message
    : colored( $message , $color_string );
}

__PACKAGE__->meta->make_immutable;
1;

__END__
=pod

=head1 NAME

App::GitGot::Outputter - Generic base class for outputting formatted messages.

=head1 VERSION

version 1.01

=head1 METHODS

=head2 error

Display a message using the 'color_error' color settings.

=head2 warning

Display a message using the 'color_warning' color settings.

=head2 major_change

Display a message using the 'color_major_change' color settings.

=head2 minor_change

Display a message using the 'color_minor_change' color settings.

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

