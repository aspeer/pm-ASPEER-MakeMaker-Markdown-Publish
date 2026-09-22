requires 'ASPEER::MakeMaker', '1.006';
requires 'ASPEER::Markdown::Publish', '0.001';
requires 'Cwd';
requires 'File::Basename';
requires 'File::Spec';
requires 'JSON::PP';
requires 'MIME::Base64';
requires 'Exporter';
requires 'strict';
requires 'vars';
requires 'warnings';
requires 'perl', '5.008';
on configure => sub {
    requires 'ExtUtils::MakeMaker';
    requires 'perl', '5.008';
    requires 'version';
    suggests 'ASPEER::MakeMaker::Markdown::Pod', '0.012';
};
on test => sub {
    requires 'Config';
    requires 'File::Path';
    requires 'File::Temp';
    requires 'Test::More';
};
