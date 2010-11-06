
use strict;
use warnings;

BEGIN { require 5.010; }

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'A tool to make it easier to manage multiple git repositories.',
  'AUTHOR' => 'John SJ Anderson <genehack@genehack.org>',
  'BUILD_REQUIRES' => {
    'English' => '0',
    'Test::More' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'App-GitGot',
  'EXE_FILES' => [
    'bin/got'
  ],
  'LICENSE' => 'perl',
  'NAME' => 'App::GitGot',
  'PREREQ_PM' => {
    'Capture::Tiny' => '0',
    'Config::INI::Reader' => '0',
    'Cwd' => '0',
    'FindBin' => '0',
    'List::MoreUtils' => '0',
    'Moose' => '0',
    'MooseX::App::Cmd' => '0',
    'MooseX::App::Cmd::Command' => '0',
    'Net::GitHub::V2::Repositories' => '0',
    'Storable' => '0',
    'Term::ReadLine' => '0',
    'Term::ReadLine::Perl' => '0',
    'Try::Tiny' => '0',
    'YAML' => '0',
    'autodie' => '0',
    'namespace::autoclean' => '0',
    'version' => '0'
  },
  'VERSION' => '0.1',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



