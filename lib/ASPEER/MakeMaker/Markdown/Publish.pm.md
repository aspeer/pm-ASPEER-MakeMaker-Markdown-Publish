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
                module  => 'ASPEER::Markdown::Publish::MkDocs',
                sources => ['doc'],
                config  => 'doc/mkdocs/mkdocs.yml',
            },
        },
    },
);
```

# DESCRIPTION

This is a thin MakeMaker adapter. It reads `META_MERGE.x_documentation.publish`
from the live `WriteMakefile` arguments and passes the settings to
`ASPEER::Markdown::Publish` when a target is invoked. It does not assemble
documents, run a publishing engine, or update Git itself.

The selected `module` is one of `ASPEER::Markdown::Publish::MkDocs`,
`::VitePress`, `::Docusaurus`, or `::Starlight`. One engine is active at a
time. Its `config` and other engine-specific options are top-level values
in the `publish` hash. Alternatively, set only `config_file` to a JSON file
containing the selected `module` and settings. That file is read when the
target runs, so edits do not require a regenerated Makefile.

Configuration supplied inline is encoded into the generated Makefile. The
targets do not re-run `Makefile.PL` to discover it.

# TARGETS

```text
publish_build
publish_serve
publish_gh
publish_cloudflare
```

`publish_build` prepares and renders the site. `publish_serve` starts the
selected engine's foreground local server. `publish_gh` builds, updates the
publication branch, and pushes it to the configured remote (`github` by
default). `publish_cloudflare` builds and deploys the same site as Workers
Static Assets using an authored Wrangler configuration. The last two targets
are explicit, independent remote operations; neither calls the other.

# CONFIGURATION

MkDocs is used when `module` is omitted. Set `module` in
`META_MERGE.x_documentation.publish` to select another engine, or set
`MARKDOWN_PUBLISH_MODULE` to override it at runtime.

Without `sources`, an existing `doc/` is the publication boundary. Only when
`doc/` is absent are module and executable sidecars the default. An explicit
`sources` list is exact. `output`, `name`, `branch`, and `remote` are common
settings; see the selected engine module for its own options.

For Workers Static Assets, set `cloudflare => {config => 'wrangler.jsonc'}`
inside `publish`. This path selects a dedicated Worker configuration with its
name and compatibility date. Optionally set `wrangler` to the executable path
or `environment` to an authored Wrangler environment in the same `cloudflare`
hash. Wrangler uses its own login or environment for authentication; do not
put credentials in metadata. Deployment does not change Git.

# ERRORS

`x_documentation` and `x_documentation.publish` must be hash references when
supplied. Invalid configuration and failed target actions are fatal.

# SEE ALSO

`ASPEER::Markdown::Publish`, `ASPEER::MakeMaker::Markdown::Pod`

# AUTHOR

Andrew Speer <andrew.speer@isolutions.com.au>

# LICENSE AND COPYRIGHT

This file is part of ASPEER::MakeMaker::Markdown::Publish. Copyright (c) 2026
Andrew Speer. This is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.
