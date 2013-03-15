package App::GitGot::Outputter::light;
{
  $App::GitGot::Outputter::light::VERSION = '1.05';
}
BEGIN {
  $App::GitGot::Outputter::light::AUTHORITY = 'cpan:GENEHACK';
}
# ABSTRACT: Color scheme appropriate for dark terminal backgrounds

use Mouse;
extends 'App::GitGot::Outputter';
use 5.010;

has 'color_error' => (
  is      => 'ro' ,
  isa     => 'Str' ,
  default => 'bold red'
);

# Color choices by drdrang based on a conversation that started with
# <http://www.leancrew.com/all-this/2010/12/batch-comparison-of-git-repositories/>

has 'color_warning' => (
  is      => 'ro' ,
  isa     => 'Str' ,
  default => 'bold magenta'
);

has 'color_major_change' => (
  is      => 'ro' ,
  isa     => 'Str' ,
  default => 'blue'
);

has 'color_minor_change' => (
  is      => 'ro' ,
  isa     => 'Str' ,
  default => 'uncolored'
);

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

App::GitGot::Outputter::light - Color scheme appropriate for dark terminal backgrounds

=head1 VERSION

version 1.05

=head1 AUTHOR

John SJ Anderson <genehack@genehack.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by John SJ Anderson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
