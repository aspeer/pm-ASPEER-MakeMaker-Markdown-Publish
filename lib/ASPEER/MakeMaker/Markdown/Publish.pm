#
#  This file is part of ASPEER::MakeMaker::Markdown::Publish.
#
#  This software is copyright (c) 2026 by Andrew Speer <andrew.speer@isolutions.com.au>.
#
#  This is free software; you can redistribute it and/or modify it under
#  the same terms as the Perl 5 programming language system itself.
#
#  Full license text is available at:
#
#  <http://dev.perl.org/licenses/>
#
package ASPEER::MakeMaker::Markdown::Publish;


#  Compiler pragma and package variables
#
use strict qw(vars);
use vars qw($VERSION $VERSION_GIT_SHA $AUTHORITY @ISA);
use warnings;


#  Inherit the shared MakeMaker hook implementation. Actual site assembly and
#  publication remains in the backend-neutral publishing module.
#
use ASPEER::MakeMaker ();
use ASPEER::MakeMaker::Markdown::Publish::MM ();
@ISA=qw(ASPEER::MakeMaker);


#  Version information
#
$AUTHORITY='cpan:ASPEER';
$VERSION='0.001';
$VERSION_GIT_SHA=do {local(@ARGV, $/, $_); @ARGV=($_=__FILE__.'.sha'); <> if -f $_};
chomp($VERSION_GIT_SHA) if defined($VERSION_GIT_SHA);


#  Done
#
1;

__END__

=begin markdown

# NAME

ASPEER::MakeMaker::Markdown::Publish - MakeMaker targets for Markdown publication

# SYNOPSIS

```perl
use ExtUtils::MakeMaker;
use ASPEER::MakeMaker::Markdown::Publish;

WriteMakefile(
    NAME         => 'Example',
    VERSION_FROM => 'lib/Example.pm',

    META_MERGE => {
        'meta-spec' => {version => 2},
        x_documentation => {
            publish => {
                sources => ['doc'],
                mkdocs  => {
                    config => 'doc/mkdocs/mkdocs.yml',
                },
            },
        },
    },
);
```

This adds build, preview, local publication, and explicit push targets for
MkDocs, VitePress, Docusaurus, and Astro Starlight.

# DESCRIPTION

`ASPEER::MakeMaker::Markdown::Publish` is a thin MakeMaker integration layer.
It installs Makefile targets, reads author-controlled configuration from
`META_MERGE.x_documentation.publish`, and passes that configuration to
`ASPEER::Markdown::Publish` when a target is invoked.

It does not assemble Markdown, run site generators, or update publication
branches itself. Those operations belong to `ASPEER::Markdown::Publish` and
remain available outside MakeMaker.

Configuration is encoded into a private generated Makefile macro. The targets
therefore use the values supplied to the live `WriteMakefile` call and never
execute `Makefile.PL` to rediscover settings. No secondary generated
configuration file is required.

# TARGETS

Each backend supplies the following target family:

```text
mkdocs_build
mkdocs_serve
mkdocs_gh_publish
mkdocs_gh_push
```

Replace `mkdocs` with `vitepress`, `docusaurus`, or `starlight` for the other
backends.

`*_gh_publish` builds and commits the rendered site to the configured local
publication branch. It does not push. `*_gh_push` is the explicit remote
operation.

# CONFIGURATION

The complete `publish` hash is passed unchanged to `ASPEER::Markdown::Publish`.
Common values may be overridden by a backend-specific hash:

```perl
x_documentation => {
    publish => {
        sources => [qw(doc lib bin)],
        output  => 'site',
        branch  => 'gh-pages',
        remote  => 'origin',

        mkdocs => {
            config      => 'doc/mkdocs/mkdocs.yml',
            config_mode => 'inherit',
            address     => '127.0.0.1:8000',
        },

        docusaurus => {
            config => 'doc/docusaurus/docusaurus.config.js',
        },
    },
}
```

Without `sources`, `ASPEER::Markdown::Publish` uses `doc/` when it exists and
falls back to module and executable sidecars only when `doc/` is absent.

# ERRORS

`x_documentation` and `x_documentation.publish` must be hash references when
supplied. Invalid metadata and failed publication targets are fatal.

# SEE ALSO

`ASPEER::Markdown::Publish`, `ASPEER::MakeMaker`,
`ASPEER::MakeMaker::Markdown::Pod`

# AUTHOR

Andrew Speer <andrew.speer@isolutions.com.au>

# LICENSE AND COPYRIGHT

This file is part of ASPEER::MakeMaker::Markdown::Publish.

This software is copyright (c) 2026 by Andrew Speer
<andrew.speer@isolutions.com.au>.

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.


=end markdown


=head1 NAME

ASPEER::MakeMaker::Markdown::Publish - MakeMaker targets for Markdown publication


=head1 SYNOPSIS


 use ExtUtils::MakeMaker;
 use ASPEER::MakeMaker::Markdown::Publish;

 WriteMakefile(
     NAME         => 'Example',
     VERSION_FROM => 'lib/Example.pm',

     META_MERGE => {
         'meta-spec' => {version => 2},
         x_documentation => {
             publish => {
                 sources => ['doc'],
                 mkdocs  => {
                     config => 'doc/mkdocs/mkdocs.yml',
                 },
             },
         },
     },
 );
This adds build, preview, local publication, and explicit push targets for
MkDocs, VitePress, Docusaurus, and Astro Starlight.


=head1 DESCRIPTION

C<ASPEER::MakeMaker::Markdown::Publish> is a thin MakeMaker integration layer.
It installs Makefile targets, reads author-controlled configuration from
C<META_MERGE.x_documentation.publish>, and passes that configuration to
C<ASPEER::Markdown::Publish> when a target is invoked.

It does not assemble Markdown, run site generators, or update publication
branches itself. Those operations belong to C<ASPEER::Markdown::Publish> and
remain available outside MakeMaker.

Configuration is encoded into a private generated Makefile macro. The targets
therefore use the values supplied to the live C<WriteMakefile> call and never
execute C<Makefile.PL> to rediscover settings. No secondary generated
configuration file is required.


=head1 TARGETS

Each backend supplies the following target family:


 mkdocs_build
 mkdocs_serve
 mkdocs_gh_publish
 mkdocs_gh_push
Replace C<mkdocs> with C<vitepress>, C<docusaurus>, or C<starlight> for the other
backends.

C<*_gh_publish> builds and commits the rendered site to the configured local
publication branch. It does not push. C<*_gh_push> is the explicit remote
operation.


=head1 CONFIGURATION

The complete C<publish> hash is passed unchanged to C<ASPEER::Markdown::Publish>.
Common values may be overridden by a backend-specific hash:


 x_documentation => {
     publish => {
         sources => [qw(doc lib bin)],
         output  => 'site',
         branch  => 'gh-pages',
         remote  => 'origin',

         mkdocs => {
             config      => 'doc/mkdocs/mkdocs.yml',
             config_mode => 'inherit',
             address     => '127.0.0.1:8000',
         },

         docusaurus => {
             config => 'doc/docusaurus/docusaurus.config.js',
         },
     },
 }
Without C<sources>, C<ASPEER::Markdown::Publish> uses C<doc/> when it exists and
falls back to module and executable sidecars only when C<doc/> is absent.


=head1 ERRORS

C<x_documentation> and C<x_documentation.publish> must be hash references when
supplied. Invalid metadata and failed publication targets are fatal.


=head1 SEE ALSO

C<ASPEER::Markdown::Publish>, C<ASPEER::MakeMaker>,
C<ASPEER::MakeMaker::Markdown::Pod>


=head1 AUTHOR

Andrew Speer L<mailto:andrew.speer@isolutions.com.au>


=head1 LICENSE AND COPYRIGHT

This file is part of ASPEER::MakeMaker::Markdown::Publish.

This software is copyright (c) 2026 by Andrew Speer
L<mailto:andrew.speer@isolutions.com.au>.

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.

=cut
