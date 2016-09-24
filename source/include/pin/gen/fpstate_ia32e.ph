//Groups: @ingroup\s+(API_REF|KNOBS|IMG_BASIC_API|INS_BASIC_API|INS_INST_API|INS_BASIC_API_GEN_IA32|INS_BASIC_API_IA32|INS_MOD_API_GEN_IA32|SEC_BASIC_API|RTN_BASIC_API|REG_BASIC_API|REG_CPU_GENERIC|REG_CPU_IA32|TRACE_BASIC_API|BBL_BASIC_API|SYM_BASIC_API|MISC_PRINT|MISC_PARSE|KNOB_API|KNOB_BASIC|KNOB_PRINT|LOCK|PIN_CONTROL|TRACE_VERSION_API|BUFFER_API|PROTO_API|PIN_PROCESS_API|PIN_THREAD_API|PIN_SYSCALL_API|WINDOWS_SYSCALL_API_UNDOC|DEBUG_API|ERROR_FILE_BASIC|TYPE_BASE|INSTLIB|ALARM|CODECACHE_API|CHILD_PROCESS_API|UTILS|MISC|CONTEXT_API|PHYSICAL_CONTEXT_API|PIN_CALLBACKS|EXCEPTION_API|APPDEBUG_API|STOPPED_THREAD_API|BUFFER_API|PROTO|INST_ARGS|DEPRECATED_PIN_API|INTERNAL_EXCEPTION_PRIVATE_UNDOCUMENTED|PIN_THREAD_PRIVATE|CHILD_PROCESS_INTERNAL|BBL_BASIC|ROGUE_BASIC_API|MESSAGE_TYPE|MESSAGE_BASIC|ERRFILE|MISC_BASIC|ITC_INST_API|CONTEXT_API_UNDOC|EXCEPTION_API_UNDOC|UNDOCUMENTED_PIN_API|OPIN|TRACE_VERSIONS
/* PIN API */

/* THIS FILE IS AUTOMAGICALLY GENERATED - DO NOT CHANGE DIRECTLY*/


typedef UTIL::FXSAVE_INTEL64_DEFAULT FXSAVE;

                                                                  /* DO NOT EDIT */
struct XSAVE_HEADER
{
    UINT64 _mask;
    UINT64 _reserved[7];
};

                                                                  /* DO NOT EDIT */
const size_t VSTATE_PADDING = 256;

                                                                  /* DO NOT EDIT */
struct FPSTATE
{
    // fxsave_legacy is applicable on IA-32, Intel(R) 64 and mic processors
    FXSAVE fxsave_legacy; //                                                    512  bytes at offset 0

    // The following are only applicable on processors that support XSAVE
    struct XSTATE
    {
        XSAVE_HEADER _extendedHeader; //                                        64   bytes at offset 512
        UINT8 _ymmUpper[16*16]; // upper 128 bits of ymm0-ymm15                 256  bytes at offset 576
    } _xstate;

    // The following is only applicable on processors that support AVX512
    // So far there are 832 bytes of data but the next bulk of data begins at offset 1088.
    UINT8 _reserved[VSTATE_PADDING]; //                                         256  bytes at offset 832

    // The _vstate is comprised of three parts.
    //   1. The Opmask registers k0-k7
    //   2. The upper 256 bits of zmm0-zmm15
    //   3. zmm16-zmm31 (512 bits each)
    struct VSTATE
    {
        UINT64 _kmasks[8];          // 8 64-bit k (mask) registers              64   bytes at offset 1088
        UINT8  _zmmUpper[32*16];    // upper 256 bits of zmm0-zmm15             512  bytes at offset 1152
        UINT8  _zmms[64*16];        // 16 512-bit zmm registers (zmm16-zmm31)   1024 bytes at offset 1664
    } _vstate;

    // Total of 2688 bytes.
};

                                                                  /* DO NOT EDIT */
const size_t FPSTATE_SIZE_FXSAVE = sizeof(FXSAVE);

                                                                  /* DO NOT EDIT */
const size_t FPSTATE_SIZE_XSAVE_AVX = sizeof(FXSAVE) + sizeof(FPSTATE::XSTATE);

                                                                  /* DO NOT EDIT */
const size_t FPSTATE_SIZE_XSAVE_AVX512 =
        sizeof(FXSAVE) + sizeof(FPSTATE::XSTATE) + VSTATE_PADDING + sizeof(FPSTATE::VSTATE);

                                                                  /* DO NOT EDIT */
const size_t FPSTATE_SIZE = sizeof(FPSTATE);

                                                                  /* DO NOT EDIT */
const size_t FPSTATE_ALIGNMENT = 64;

                                                                  /* DO NOT EDIT */
const size_t FP_STATE_EXTENDED_HEADER_SIZE = sizeof(XSAVE_HEADER);

                                                                  /* DO NOT EDIT */
const UINT64 X87_CLASS_BIT = 0x1;

                                                                  /* DO NOT EDIT */
const UINT64 SSE_CLASS_BIT = 0x2;

                                                                  /* DO NOT EDIT */
const UINT64 AVX_CLASS_BIT = 0x4;

                                                                  /* DO NOT EDIT */
const UINT64 BNDREGS_CLASS_BIT = 0x8;

                                                                  /* DO NOT EDIT */
const UINT64 BNDCSR_CLASS_BIT = 0x10;

                                                                  /* DO NOT EDIT */
const UINT64 OPMASK_CLASS_BIT = 0x20;

                                                                  /* DO NOT EDIT */
const UINT64 ZMM_HI256_CLASS_BIT = 0x40;

                                                                  /* DO NOT EDIT */
const UINT64 HI16_ZMM_CLASS_BIT = 0x80;

                                                                  /* DO NOT EDIT */

