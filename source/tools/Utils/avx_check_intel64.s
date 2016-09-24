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
#ifdef TARGET_MAC
.global _SupportsAvx
_SupportsAvx:
#else
.type SupportsAvx, @function
.global SupportsAvx
SupportsAvx:
#endif
    push    %rbp
    mov     %rsp, %rbp
    push %rcx
    push %rdx
    mov $1, %rax
    cpuid
    andq $0x18000000, %rcx
    cmpq $0x18000000, %rcx    # check both OSXSAVE and AVX feature flags
    jne NotSupported         
                       # processor supports AVX instructions and XGETBV is enabled by OS
    mov $0, %rcx       # specify 0 for XFEATURE_ENABLED_MASK register
                       # 0xd0010f is xgetbv  - result in EDX:EAX 
    .byte 0xf, 0x1, 0xd0
    andq $6, %rax
    cmpq $6, %rax      # check OS has enabled both XMM and YMM state support
    jne NotSupported
    mov $1, %rax
done:
    pop %rdx
    pop %rcx
    leave
    ret


NotSupported:
    mov $0, %rax
    jmp done
