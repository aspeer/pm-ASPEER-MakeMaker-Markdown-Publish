use 5.008;
use strict;
use warnings;
use version;

use ExtUtils::MakeMaker;

eval {
    require ASPEER::MakeMaker::Markdown::Publish;
    ASPEER::MakeMaker::Markdown::Publish->import();
    1;
};

my $mm_ver=$ExtUtils::MakeMaker::VERSION;
if ($mm_ver=~/_/) {
    $mm_ver=eval($mm_ver);
    die $@ if $@;
}
my %WriteMakefile=(
    NAME             => 'ASPEER::MakeMaker::Markdown::Publish',
    DISTNAME         => 'ASPEER-MakeMaker-Markdown-Publish',
    VERSION_FROM     => 'lib/ASPEER/MakeMaker/Markdown/Publish.pm',
    ABSTRACT_FROM    => 'lib/ASPEER/MakeMaker/Markdown/Publish.pm',
    LICENSE          => 'perl',
    AUTHOR           => 'Andrew Speer <andrew.speer@isolutions.com.au>',
    MIN_PERL_VERSION => '5.008',
    PREREQ_PM        => {
        'ASPEER::MakeMaker'          => '1.005',
        'ASPEER::Markdown::Publish'  => '0.001',
        'Cwd'                        => 0,
        'File::Basename'             => 0,
        'File::Spec'                 => 0,
        'JSON::PP'                   => 0,
        'MIME::Base64'               => 0,
        'Exporter'                   => 0,
        'strict'                     => 0,
        'vars'                       => 0,
        'warnings'                   => 0,
    },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
        'version'             => 0,
    },
    TEST_REQUIRES => {
        'Config'     => 0,
        'File::Path' => 0,
        'File::Temp' => 0,
        'Test::More' => 0,
    },
    META_MERGE => {
        'meta-spec' => {version => 2},
        resources   => {
            homepage   => 'https://gitea.isolutions.com.au/aspeer/pm-ASPEER-MakeMaker-Markdown-Publish',
            repository => {
                type => 'git',
                url  => 'https://gitea.isolutions.com.au/aspeer/pm-ASPEER-MakeMaker-Markdown-Publish.git',
                web  => 'https://gitea.isolutions.com.au/aspeer/pm-ASPEER-MakeMaker-Markdown-Publish',
            },
        },
    },
    depend => {Makefile => '$(VERSION_FROM)'},
    dist   => {COMPRESS => 'gzip -9f', SUFFIX => '.gz'},
);
my %MM_Compat=(
    '6.31'   => [qw(LICENSE)],
    '6.46'   => [qw(META_MERGE)],
    '6.48'   => [qw(MIN_PERL_VERSION)],
    '6.52'   => [qw(CONFIGURE_REQUIRES)],
    '6.64'   => [qw(TEST_REQUIRES)],
);
while (my ($mm_ver_test, $name_ar)=each(%MM_Compat)) {
    if (version->parse($mm_ver) < version->parse($mm_ver_test)) {
        delete(@WriteMakefile{@{$name_ar}});
    }
}
WriteMakefile(%WriteMakefile);
