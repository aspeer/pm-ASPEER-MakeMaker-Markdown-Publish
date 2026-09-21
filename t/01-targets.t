#!perl

use strict;
use warnings;
use lib 'lib';

use Config;
use Cwd qw(abs_path getcwd);
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use JSON::PP qw(decode_json);
use MIME::Base64 qw(decode_base64);
use Test::More;

use ASPEER::MakeMaker::Markdown::Publish::MM;


sub blurp {

    my ($fn, $text)=@_;
    open(my $output_fh, '>', $fn) || die "unable to write $fn: $!";
    print {$output_fh} $text;
    close($output_fh) || die "unable to close $fn: $!";
    return 1;

}


sub slurp {

    my ($fn)=@_;
    open(my $input_fh, '<', $fn) || die "unable to read $fn: $!";
    local $/=undef;
    my $text=<$input_fh>;
    close($input_fh) || die "unable to close $fn: $!";
    return $text;

}


#  Locate the adapter and shared parent before entering a disposable project
#
my $cwd=getcwd();
my $adapter_lib_dn=abs_path('lib');
my $common_pm_fn=abs_path($INC{'ASPEER/MakeMaker/MM.pm'});
$common_pm_fn=~s{[/\\]ASPEER[/\\]MakeMaker[/\\]MM\.pm$}{};
my $temporary_dn=tempdir(CLEANUP => 1);
chdir($temporary_dn) || die "unable to chdir $temporary_dn: $!";
make_path('lib/Sample', 'doc', 'local lib/ASPEER/Markdown');
my $local_lib_dn=abs_path('local lib');


#  The runtime publisher stub records exactly what the generated target passes
#
blurp('local lib/ASPEER/Markdown/Publish.pm', <<'PUBLISH_STUB');
package ASPEER::Markdown::Publish;
use JSON::PP qw(encode_json);
sub new {my ($class, $config_hr)=@_; return bless({config => $config_hr}, $class)}
sub run {
    my ($self, $backend, $action)=@_;
    open(my $output_fh, '>>', 'target.log') || die "unable to write target log: $!";
    print {$output_fh} encode_json({config => $self->{'config'}, backend => $backend, action => $action}), "\n";
    close($output_fh) || die "unable to close target log: $!";
    return 1;
}
1;
PUBLISH_STUB
blurp('lib/Sample.pm', "package Sample;\nour \$VERSION='0.001';\n1;\n");
blurp('doc/guide.md', "# Guide\n\nText.\n");
blurp('Makefile.PL', <<'MAKEFILE_PL');
use strict;
use warnings;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'Sample',
    VERSION_FROM => 'lib/Sample.pm',
    META_MERGE   => {
        'meta-spec' => {version => 2},
        x_documentation => {
            publish => {
                sources => ['doc'],
                output  => 'public',
                mkdocs  => {
                    config => 'doc/mkdocs/custom.yml',
                    address => '127.0.0.1:8123',
                },
                docusaurus => {
                    config => 'doc/docusaurus/custom.js',
                },
            },
        },
    },
);
MAKEFILE_PL


#  Generate a real Makefile through the public plugin import
#
local $ENV{'PERL5LIB'}=join(
    $Config{'path_sep'},
    grep {defined($_) && length($_)}
        ($adapter_lib_dn, $common_pm_fn, $local_lib_dn, $ENV{'PERL5LIB'})
);
is(system($^X, '-MASPEER::MakeMaker::Markdown::Publish', 'Makefile.PL'), 0,
    'Makefile.PL succeeds with publication plugin');
my $makefile=slurp('Makefile');
like($makefile, qr/^PUBLISH_PM_TARGET=\$\(PERLRUN\) -M\$\(PUBLISH_PM\).*-e /m,
    'target command explicitly reloads the publication dispatcher');
unlike($makefile, qr/^MM_PREFIX\s*=/m,
    'private Makefile prefix is not emitted');

foreach my $backend (qw(mkdocs vitepress docusaurus starlight)) {
    foreach my $action (qw(build serve gh_publish gh_push)) {
        like($makefile, qr/^${backend}_${action} ::$/m,
            "$backend $action target generated");
        like($makefile,
            qr/^\s*\@\$\(PUBLISH_PM_TARGET\) publish $backend $action$/m,
            "$backend $action delegates explicitly");
    }
}


#  Decode the private macro to prove values came from live META_MERGE input
#
my ($encoded)=$makefile=~/^PUBLISH_CONFIG\s*=\s*(\S+)$/m;
ok(defined($encoded) && length($encoded), 'publication configuration macro generated');
my $config_hr=decode_json(decode_base64($encoded));
is_deeply($config_hr->{'sources'}, ['doc'], 'source directories encoded');
is($config_hr->{'mkdocs'}{'config'}, 'doc/mkdocs/custom.yml',
    'MkDocs configuration location encoded');
is($config_hr->{'mkdocs'}{'address'}, '127.0.0.1:8123',
    'MkDocs customization encoded');
is($config_hr->{'docusaurus'}{'config'}, 'doc/docusaurus/custom.js',
    'Docusaurus configuration location encoded');


#  Execute generated targets through make and inspect the delegated calls
#
my $make=$Config{'make'} || 'make';
is(system($make, 'mkdocs_build'), 0, 'generated MkDocs build target succeeds');
is(system($make, 'docusaurus_gh_publish'), 0,
    'generated Docusaurus local publication target succeeds');
my @target=map {decode_json($_)} grep {length($_)} split(/\n/, slurp('target.log'));
is_deeply(
    [map {[$_->{'backend'}, $_->{'action'}]} @target],
    [['mkdocs', 'build'], ['docusaurus', 'gh_publish']],
    'generated targets dispatch backend and action'
);
is_deeply($target[0]{'config'}, $config_hr,
    'generated target passes decoded publication configuration');


#  Invalid custom metadata is rejected while generating the Makefile
#
my $invalid=slurp('Makefile.PL');
$invalid=~s/x_documentation\s*=>\s*\{/x_documentation => 'invalid', disabled => {/ ||
    die "unable to construct invalid metadata fixture";
blurp('Makefile.PL', $invalid);
isnt(system($^X, '-MASPEER::MakeMaker::Markdown::Publish', 'Makefile.PL'), 0,
    'invalid x_documentation metadata rejected');

chdir($cwd) || die "unable to restore cwd $cwd: $!";
done_testing();
