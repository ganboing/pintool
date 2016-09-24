/*BEGIN_LEGAL 
Intel Open Source License 

Copyright (c) 2002-2016 Intel Corporation. All rights reserved.
 
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.  Redistributions
in binary form must reproduce the above copyright notice, this list of
conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.  Neither the name of
the Intel Corporation nor the names of its contributors may be used to
endorse or promote products derived from this software without
specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE INTEL OR
ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
END_LEGAL */

#ifndef _XED_CPUID_REC_H_
# define _XED_CPUID_REC_H_
#include "xed-types.h"
#include "xed-portability.h"
#include "xed-cpuid-bit-enum.h"
#include "xed-isa-set-enum.h"


typedef struct {
    xed_uint32_t leaf;    // cpuid leaf
    xed_uint32_t subleaf; // cpuid subleaf
    xed_uint32_t bit;     // the bit number for the feature
    xed_reg_enum_t reg;   // the register containing the bit (EAX,EBX,ECX,EDX)
} xed_cpuid_rec_t;

#define XED_MAX_CPUID_BITS_PER_ISA_SET (4)

/// Returns the name of the i'th cpuid bit associated with this isa-set.
/// Call this repeatedly, with 0 <= i <
/// XED_MAX_CPUID_BITS_PER_ISA_SET. Give up when i ==
/// XED_MAX_CPUID_BITS_PER_ISA_SET or the return value is
/// XED_CPUID_BIT_INVALID.
XED_DLL_EXPORT
xed_cpuid_bit_enum_t
xed_get_cpuid_bit_for_isa_set(xed_isa_set_enum_t isaset,
                              xed_uint_t i);

/// This provides the details of the CPUID bit specification, if the
/// enumeration value is not sufficient.  Returns 1 on success and fills in
/// the structure pointed to by p. Returns 0 on failure.
XED_DLL_EXPORT
xed_int_t
xed_get_cpuid_rec(xed_cpuid_bit_enum_t cpuid_bit,
                  xed_cpuid_rec_t* p);

#endif

