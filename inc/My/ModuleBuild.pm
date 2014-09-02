package My::ModuleBuild;

use strict;
use warnings;
use base qw( Alien::Base::ModuleBuild );

sub new
{
  my($class, %args) = @_;
  
  $args{alien_name} = 'libffi';
  $args{alien_build_commands} = [
    '%c MAKEILFO=true --with-pic --prefix=%s',
    'make',
  ];
  $args{alien_isolate_dynamic} = 1;
  $args{alien_repository} = {
    protocol => 'http',
    host     => 'www.mirrorservice.org',
    location => '/sites/sourceware.org/pub/libffi',
    pattern  => qr{^libffi-.*\.tar\.gz$},
  };
  
  my $self = $class->SUPER::new(%args);
  
  $self;
}

1;
