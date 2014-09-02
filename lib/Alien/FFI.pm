package Alien::FFI;

use strict;
use warnings;
use base qw( Alien::Base );

# ABSTRACT: Build and make available libffi
# VERSION

=head1 SYNOPSIS

In your C<Build.PL>:

 use Alien::FFI;
 use Module::Build;
 
 my $alien = Alien::FFI->new;
 my $build = Module::Build->new(
   ...
   extra_compiler_flags => $alien->cflags,
   extra_linker_flags   => $alien->libs,
   ...
 );
 
 $build->create_build_script;

In your L<FFI::Raw> script:

 use Alien::FFI;
 use FFI::Sweet;
 
 my($dll) = Alien::FFI>new->dlls;
 FFI::Raw->new($dll, '...', ...);

=head1 DESCRIPTION

This distribution installs libffi so that it can be used by other Perl distributions.  If already
installed for your operating system, and it can be found, this distribution will use the libarchive
that comes with your operating system, otherwise it will download it from the Internet, build and
install it fro you.

=cut

1;
