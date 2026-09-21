# NAME

ASPEER::MakeMaker::Markdown::Publish::MM::Constant - Makefile target constants

# DESCRIPTION

Defines the private `PUBLISH_*` macro namespace, bundled postamble template,
target dispatcher module, and fixed MakeMaker argument list used by
`ASPEER::MakeMaker::Markdown::Publish`.

The final argument is `PUBLISH_CONFIG`, the Base64-encoded JSON value derived
from `META_MERGE.x_documentation.publish`.
