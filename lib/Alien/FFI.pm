package Alien::FFI;

use strict;
use warnings;
use Config;
use base qw( Alien::Base );

# ABSTRACT: Build and make available libffi
# VERSION
# ALIEN SYNOPSIS

=head1 DESCRIPTION

This distribution installs libffi so that it can be used by other Perl distributions.  If already
installed for your operating system, and it can be found, this distribution will use the libffi
that comes with your operating system, otherwise it will download it from the Internet, build and
install it for you.

=head1 SEE ALSO

=over 4

=item L<FFI::Platypus>

Write Perl bindings to non-Perl libraries without C or XS

=item L<FFI::CheckLib>

Check that a library is available for FFI

=back

=cut

1;
