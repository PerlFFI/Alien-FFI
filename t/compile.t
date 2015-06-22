use strict;
use warnings;
use Test::More;
BEGIN { plan skip_all => 'test requires Test::CChecker' unless eval q{ use Test::CChecker 0.06; 1 } }
use Alien::FFI;

plan tests => 1;

compile_output_to_note;

compile_with_alien 'Alien::FFI';

compile_run_ok <<C_CODE, "basic compile test";

#include <ffi.h>

unsigned int foo(void)
{
  return 0xaa;
}

int
main(int argc, char *argv[])
{
  ffi_cif   ffi_cif;
  ffi_type *args[1];
  void     *values[1];
  int       return_value;
  
  if(ffi_prep_cif(&ffi_cif, FFI_DEFAULT_ABI, 0, &ffi_type_uint32, args) == FFI_OK)
  {
    ffi_call(&ffi_cif, (void*) foo, &return_value, values);
  
    if(return_value == 0xaa)
      return 0;
    else
      return 2;
  }
  else
  {
    return 2;
  }
}
C_CODE

