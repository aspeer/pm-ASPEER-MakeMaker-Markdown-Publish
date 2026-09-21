# NAME

ASPEER::MakeMaker::Markdown::Publish::MM - generated publication target dispatcher

# DESCRIPTION

This class implements the MakeMaker-specific portion of
`ASPEER::MakeMaker::Markdown::Publish`. It inherits the common MakeMaker helper,
encodes `META_MERGE.x_documentation.publish` into a private Makefile macro, and
delegates generated targets to `ASPEER::Markdown::Publish`.

# METHODS

## const_config

Calls the shared `ASPEER::MakeMaker` `const_config` implementation, validates
the `x_documentation` metadata shape, and stores the JSON publication hash as a
Makefile-safe Base64 value.

## publish

Decodes the configuration passed by the generated target, constructs
`ASPEER::Markdown::Publish`, and invokes the requested backend action.

# SEE ALSO

`ASPEER::MakeMaker::Markdown::Publish`, `ASPEER::Markdown::Publish`
