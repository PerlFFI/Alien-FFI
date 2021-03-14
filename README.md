# Alien::FFI ![linux](https://github.com/PerlFFI/Alien-FFI/workflows/linux/badge.svg) ![windows](https://github.com/PerlFFI/Alien-FFI/workflows/windows/badge.svg) ![macos](https://github.com/PerlFFI/Alien-FFI/workflows/macos/badge.svg)

Build and make available libffi

# SYNOPSIS

In your Makefile.PL:

```perl
use ExtUtils::MakeMaker;
use Alien::Base::Wrapper ();

WriteMakefile(
  Alien::Base::Wrapper->new('Alien::FFI')->mm_args2(
    # MakeMaker args
    NAME => 'My::XS',
    ...
  ),
);
```

In your Build.PL:

```perl
use Module::Build;
use Alien::Base::Wrapper qw( Alien::FFI !export );

my $builder = Module::Build->new(
  ...
  configure_requires => {
    'Alien::FFI' => '0',
    ...
  },
  Alien::Base::Wrapper->mb_args,
  ...
);

$build->create_build_script;
```

# DESCRIPTION

This distribution installs libffi so that it can be used by other Perl distributions.  If already
installed for your operating system, and it can be found, this distribution will use the libffi
that comes with your operating system, otherwise it will download it from the Internet, build and
install it for you.

# SEE ALSO

- [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus)

    Write Perl bindings to non-Perl libraries without C or XS

- [FFI::CheckLib](https://metacpan.org/pod/FFI::CheckLib)

    Check that a library is available for FFI

# AUTHOR

Author: Graham Ollis <plicease@cpan.org>

Contributors:

Petr Pisar (ppisar)

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
