use 5.006;
use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.039

use Test::More  tests => 25 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'App/GitGot.pm',
    'App/GitGot/Command.pm',
    'App/GitGot/Command/add.pm',
    'App/GitGot/Command/chdir.pm',
    'App/GitGot/Command/clone.pm',
    'App/GitGot/Command/fork.pm',
    'App/GitGot/Command/gc.pm',
    'App/GitGot/Command/list.pm',
    'App/GitGot/Command/move.pm',
    'App/GitGot/Command/mux.pm',
    'App/GitGot/Command/push.pm',
    'App/GitGot/Command/remove.pm',
    'App/GitGot/Command/status.pm',
    'App/GitGot/Command/that.pm',
    'App/GitGot/Command/this.pm',
    'App/GitGot/Command/update.pm',
    'App/GitGot/Command/update_status.pm',
    'App/GitGot/Command/version.pm',
    'App/GitGot/Outputter.pm',
    'App/GitGot/Outputter/dark.pm',
    'App/GitGot/Outputter/light.pm',
    'App/GitGot/Repo.pm',
    'App/GitGot/Repo/Git.pm'
);

my @scripts = (
    'bin/got',
    'bin/got-complete'
);

# no fake home requested

my $inc_switch = -d 'blib' ? '-Mblib' : '-Ilib';

use File::Spec;
use IPC::Open3;
use IO::Handle;

open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}

foreach my $file (@scripts)
{ SKIP: {
    open my $fh, '<', $file or warn("Unable to open $file: $!"), next;
    my $line = <$fh>;
    close $fh and skip("$file isn't perl", 1) unless $line =~ /^#!.*?\bperl\b\s*(.*)$/;

    my @flags = $1 ? split(/\s+/, $1) : ();

    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, @flags, '-c', $file);
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$file compiled ok");

   # in older perls, -c output is simply the file portion of the path being tested
    if (@_warnings = grep { !/\bsyntax OK$/ }
        grep { chomp; $_ ne (File::Spec->splitpath($file))[2] } @_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
} }



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


