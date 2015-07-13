package My::ModuleBuild;

use strict;
use warnings;
use Config;
use Text::ParseWords qw( shellwords );
use Env qw( @PATH );
use Cwd qw( cwd );
use base qw( Alien::Base::ModuleBuild );

my $libffi_version = '3.2.1';
$libffi_version = '3.1' if $^O eq 'MSWin32' && $Config{ccname} eq 'cl';

# some weird older perl CPAN.pm or Module::Build or something.
# installs okay with older versions of Alien::Base
# even though 0.009 is a configure_requires
# we need to nip it in the bud here else
# it breaks in FFI::Platypus
if($] < 5.010 && ! eval { use Alien::Base 0.009 (); 1 })
{
  print STDERR "Alien::Base 0.009 really is required as a configure prereq.\n";
  print STDERR "Please install it first.\n";
  exit;
}

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
    
    if($Config{ccname} eq 'cl')
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

    }
  }
  
  if($^O eq 'darwin')
  {
    # perl -MConfig= -MText::ParseWords=shellwords -E 'my @ldflags = shellwords $Config{ldflags}; while(@ldflags) { my $arg = shift @ldflags; next unless $arg eq "-arch"; push @arch, $arg, shift @ldflags }; say $_ for @arch'
    my @ldflags = shellwords $Config{ldflags};
    my @arch;
    while(@ldflags)
    {
      my $arg = shift @ldflags;
      next unless $arg eq "-arch";
      push @arch, $arg, shift @ldflags;
    }
    push @configure, "LDFLAGS=@arch";
    push @configure, "CFLAGS=@arch";
  }
  
  $args{alien_name} = 'libffi';
  $args{alien_build_commands} = [
    \@configure,
    'make',
  ];
  
  if($libffi_version eq '3.1')
  {
    # version 3.1 (only used for MSWin32) generated a bad libffi.pc file
    unshift @{ $args{alien_build_commands} }, [ $^X, '-ni.bak', '-e', 's/^toolexeclibdir=.*$/toolexeclibdir=\$\{libdir\}/; print', 'libffi.pc.in' ];
  }
  
  $args{alien_isolate_dynamic} = 1;
  $args{alien_repository} = {
    protocol => 'http',
    host     => 'mirrors.kernel.org',
    location => '/sourceware/libffi/',
    exact_filename => "libffi-$libffi_version.tar.gz",
  };
  $args{alien_stage_install} = 1;
  
  my $self = $class->SUPER::new(%args);

  if($^O eq 'MSWin32' && ($Alien::Base::ModuleBuild::Force || !$self->alien_check_installed_version))
  {
    $self->_add_prereq( 'build_requires' => 'Alien::MSYS' => 0 );
  }
  
  $self;
}

*do_system = sub
{
  my($self, @rest) = @_;
  require Alien::MSYS;
  my $msys_path = Alien::MSYS::msys_path();
  @PATH = grep { $_ ne $msys_path && $_ !~ /GnuWin32/i } @PATH;
  unshift @PATH, $msys_path;
  $self->SUPER::do_system(@rest);
} if $^O eq 'MSWin32' && eval q{ use Alien::MSYS (); 1 };

1;
