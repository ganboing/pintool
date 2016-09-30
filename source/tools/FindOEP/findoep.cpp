#include <pin.H>

static FILE* mylog = fopen("findoep.log", "w");
static REG RegPrevSp;
static unsigned packed = 1;
static ADDRINT exe_peb;
static ADDRINT exe_retaddr;

static const char* _base_name(const string& path){
	size_t i = path.rfind('\\');
	if (i == string::npos){
		return path.c_str();
	}
	return path.c_str() + i + 1;
}

void print_addr_pretty(FILE* f, ADDRINT addr) {
	IMG img = IMG_FindByAddress(addr);
	RTN rtn = RTN_FindByAddress(addr);
	fprintf(f, "[%s!+%p]",
		IMG_Valid(img) ? _base_name(IMG_Name(img)) : "",
		IMG_Valid(img) ? (void*)(addr - IMG_StartAddress(img)) : (void*)addr);
	if (RTN_Valid(rtn))
		fprintf(f, " (%s+%p)",
		RTN_Name(rtn).c_str(),
		(void*)(addr - RTN_Address(rtn)));
}

static VOID record_stack_change(ADDRINT addr, ADDRINT sp, ADDRINT* prev_sp, ADDRINT ebx){
	if (!packed){
		for (;;);
	}
	ADDRINT retaddr = ADDRINT(0) - 1;
	//PIN_SafeCopy(&retaddr, (VOID*)sp, sizeof(ADDRINT)); 
	//fprintf(mylog, "[%p] sp = %p\n", (VOID*)addr, (VOID*)sp);
	//fflush(mylog);
	PIN_LockClient();
	print_addr_pretty(mylog, addr);
	PIN_UnlockClient();
	fprintf(mylog, " sp= %p\n", sp);
	fflush(mylog);
	//if (exe_peb == ebx && retaddr == exe_retaddr){
		//--packed;
		//fprintf(mylog, "possible OEP [%p] sp = %p\n", (VOID*)addr, (VOID*)sp);
	//}
	*prev_sp = sp;
}

static VOID start_recording(ADDRINT ebx, ADDRINT esp){
	fprintf(mylog, "image started with peb = %p\n", ebx);
	fflush(mylog);
	exe_peb = ebx;
	PIN_SafeCopy(&exe_retaddr, (VOID*)esp, sizeof(ADDRINT));
	INS_AddInstrumentFunction([](INS ins, VOID* ){
		//if (!IMG_IsMainExecutable(IMG_FindByAddress(INS_Address(ins))))
		INS_InsertCall(ins, IPOINT_BEFORE, (AFUNPTR)record_stack_change, 
			IARG_INST_PTR, 
			IARG_REG_VALUE,
			REG_STACK_PTR, 
			IARG_REG_REFERENCE, 
			RegPrevSp, 
			IARG_REG_VALUE, 
			REG_GBX, 
			IARG_END);
	}, NULL);
}

int main(int argc, char** argv){
	PIN_InitSymbolsAlt(DEBUG_OR_EXPORT_SYMBOLS);
	PIN_Init(argc, argv);

	RegPrevSp = PIN_ClaimToolRegister();

	IMG_AddInstrumentFunction([](IMG img, VOID* v){
		if (!IMG_IsMainExecutable(img)){
			return;
		}
		RTN entry = RTN_FindByAddress(IMG_Entry(img));
		RTN_Open(entry);
		INS_InsertCall(
			RTN_InsHead(entry),
			IPOINT_BEFORE,
			(AFUNPTR)start_recording,
			IARG_REG_VALUE,
			REG_GBX,
			IARG_REG_VALUE,
			REG_STACK_PTR,
			IARG_END);
		RTN_Close(entry);
	}, NULL);

	PIN_AddThreadStartFunction([](THREADID tid, CONTEXT* ctxt, INT32 flags, VOID* v){
		PIN_SetContextReg(ctxt, RegPrevSp, ADDRINT(0) - 1);
	}, NULL);

	PIN_AddFiniFunction([](INT32 code, VOID* v){
		fclose(mylog);
	}, NULL);

	PIN_StartProgram();
}