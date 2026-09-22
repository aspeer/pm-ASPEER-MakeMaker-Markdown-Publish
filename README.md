# ASPEER::MakeMaker::Markdown::Publish

Add MakeMaker targets for publishing Perl distribution documentation through
MkDocs, VitePress, Docusaurus, or Astro Starlight.

The module is deliberately a thin adapter. It reads
`META_MERGE.x_documentation.publish` from the live `WriteMakefile` arguments,
encodes that configuration into the generated Makefile, and delegates every
target to `ASPEER::Markdown::Publish`.

```perl
use ExtUtils::MakeMaker;
use ASPEER::MakeMaker::Markdown::Publish;

WriteMakefile(
    NAME         => 'Example',
    VERSION_FROM => 'lib/Example.pm',
    META_MERGE   => {
        'meta-spec' => {version => 2},
        x_documentation => {
            publish => {
                sources => ['doc'],
                config  => 'doc/mkdocs/mkdocs.yml',
            },
        },
    },
);
```

After regenerating the Makefile:

```sh
make publish_build
make publish_serve
# Explicit GitHub update:
make publish_gh
# Explicit Cloudflare Workers Static Assets deployment:
make publish_cloudflare
```

MkDocs supplies all four targets when `module` is omitted. Set
`MARKDOWN_PUBLISH_MODULE` to override the configured module at runtime.
`publish_gh` builds and pushes the publication branch to the configured remote
(`github` by default).
`publish_cloudflare` builds and deploys the same site to the Worker named in
an authored Wrangler config supplied as `cloudflare => {config => 'wrangler.jsonc'}`
in `x_documentation.publish`. It neither commits nor pushes Git.

See the [module documentation](lib/ASPEER/MakeMaker/Markdown/Publish.pm.md) and
[examples](examples/README.md).
