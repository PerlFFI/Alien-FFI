use Test2::V0 -no_srand => 1;
use Test::Alien;
use Alien::FFI;

alien_ok 'Alien::FFI';
my $xs = do { local $/; <DATA> };
xs_ok { xs => $xs, verbose => 1 }, with_subtest {
  my($module) = @_;
  is $module->test1, 0;
};

done_testing;

__DATA__

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <ffi.h>

unsigned char foo(void)
{
  return 0xaa;
}

int
test1(void)
{
  ffi_cif         ffi_cif;
  ffi_type       *args[1];
  void           *values[1];
  unsigned char   return_value;
  
  if(ffi_prep_cif(&ffi_cif, FFI_DEFAULT_ABI, 0, &ffi_type_uint8, args) == FFI_OK)
  {
    ffi_call(&ffi_cif, (void*) foo, &return_value, values);
  
    if(return_value == 0xaa)
      return 0;
  }
  
  return 2;
}

MODULE = TA_MODULE PACKAGE = TA_MODULE

int
test1(class);
    const char *class;
  CODE:
    RETVAL = test1();
  OUTPUT:
    RETVAL
