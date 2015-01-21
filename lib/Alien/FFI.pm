package Alien::FFI;

use strict;
use warnings;
use Config;
use base qw( Alien::Base );

# ABSTRACT: Build and make available libffi
# VERSION

sub libs
{
  shift->SUPER::libs(@_) . (
       $^O eq 'openbsd'
    && !$Config{usethreads} 
    && Alien::FFI->install_type eq 'share' 
    ? ' /usr/lib/libpthread.a' : '');
}

=head1 SYNOPSIS

In your C<Build.PL>:

 use Alien::FFI;
 use Module::Build;
 
 my $build = Module::Build->new(
   ...
   extra_compiler_flags => Alien::FFI->cflags,
   extra_linker_flags   => Alien::FFI->libs,
   ...
 );
 
 $build->create_build_script;

In your L<FFI::Raw> script:

 use Alien::FFI;
 use FFI::Raw;
 
 my($dll) = Alien::FFI->dynamic_libs;
 FFI::Raw->new($dll, '...', ...);

=head1 DESCRIPTION

This distribution installs libffi so that it can be used by other Perl distributions.  If already
installed for your operating system, and it can be found, this distribution will use the libffi
that comes with your operating system, otherwise it will download it from the Internet, build and
install it fro you.

=cut

1;
