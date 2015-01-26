package My::ModuleBuild;

use strict;
use warnings;
use Config;
use Env qw( @PATH );
use Cwd qw( cwd );
use base qw( Alien::Base::ModuleBuild );

my $libffi_version = '3.2.1';

sub new
{
  my($class, %args) = @_;
  
  my @configure = qw( sh configure --disable-builddir --disable-shared --with-pic --prefix=%s );
  
  if($^O eq 'MSWin32')
  {
    if($Config{archname} =~ /^MSWin32-x64/)
    {
      push @configure, '--build=x86_64-pc-mingw64';
    }
    
    if($Config{cc} =~ /cl(\.exe)?$/i)
    {
      push @configure, qw( --enable-static --disable-shared LD=link ), 'CPP=cl -nologo -EP';
      
      my $cwd = cwd();
      $cwd =~ s{/}{\\\\}g;
      
      if($Config{archname} =~ /^MSWin32-x64/)
      {
        push @configure, "CC=$cwd/_alien/libffi-$libffi_version/msvcc.sh -m64";
      }
      else
      {
        push @configure, "CC=$cwd/_alien/libffi-$libffi_version/msvcc.sh";
      }
      # TODO: also need to copy libffi.a => ffi.lib
    }
    
    $args{build_requires}->{'Alien::MSYS'} = 0;
  }
  
  $args{alien_name} = 'libffi';
  $args{alien_build_commands} = [
    \@configure,
    'make',
  ];
  $args{alien_isolate_dynamic} = 1;
  $args{alien_repository} = {
    protocol => 'http',
    host     => 'www.mirrorservice.org',
    location => '/sites/sourceware.org/pub/libffi',
    exact_filename => 'libffi-3.2.1.tar.gz',
  };
  
  my $self = $class->SUPER::new(%args);
  
  $self;
}

*do_system = sub
{
  my($self, @rest) = @_;
  require Alien::MSYS;
  my $msys_path = Alien::MSYS::msys_path();
  @PATH = grep { $_ ne $msys_path && $_ !~ /GnuWin32/i } @PATH;
  unshift @PATH, $msys_path;  
  if(ref($rest[0]) eq 'ARRAY')
  {
    my @cmd = map { $self->alien_interpolate($_) } @{ $rest[0] };
    print "+ @cmd\n";
    system @cmd;
    return ( success => ($? == 0), command => "@cmd" );
  }
  else
  {
    $self->SUPER::do_system(@rest);
  }
} if $^O eq 'MSWin32';

1;
