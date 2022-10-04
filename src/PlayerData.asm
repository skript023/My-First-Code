section	.text
   global _start     ;must be declared for linker (ld)
	
_start:	            ;tells linker entry point
   mov	edx,len     ;message length
   mov	ecx,msg     ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
	
   mov	eax,1       ;system call number (sys_exit)
   int	0x80        ;call kernel

section	.data
msg db 'Hello, world!', 0xa  ;string to be printed
len equ $ - msg     ;length of the string

ENABLE:
    alloc(Devmode,$1000,IS_DLC_PRESENT)

    label(code)
    label(return)
    
    Devmode:
    
    code:
    mov [rsp+08],rbx
    
    IS_DLC_PRESENT:
    mov al,01
    ret
    and al,08
    return:
DISABLE:
    IS_DLC_PRESENT:
    mov [rsp+08],rbx
    push rdi
    dealloc(Devmode)

newmem:
  mov [rax],#159147087
code:
  lea rdi,[rsi+000000E0]
  mov rcx,rdi
  movups xmm0,[rax]
  mov eax,r12d
  movdqu [rsp+40],xmm0
  xchg [r14],eax
  mov [r14+04],r12d
  jmp return
ForceJoin:
  jmp newmem
  mov eax, esp
  movdqu [rsp+40],xmm0
  xchg [r14],eax
  mov [r14+04],r12d


  newmem:
  mov [rax],#159147087
  lea rdi,[rsi+000000E0]
  mov rcx,rdi
  movups xmm0,[rax]
  mov eax,r12d
  movdqu [rsp+40],xmm0
  xchg [r14],eax
  mov [r14+04],r12d
code:
  jmp newmem
ForceJoin:
  mov eax, esp
  movdqu [rsp+40],xmm0
  xchg [r14],eax
  mov [r14+04],r12d
  jmp return
ForceJoin:
  lea rdi,[rsi+000000E0]
  mov rcx,rdi
  movups xmm0,[rax]
  mov eax,r12d
  movdqu [rsp+40],xmm0
  xchg [r14],eax
  mov [r14+04],r12d



define(address,"GTA5.exe"+1B5016)
define(bytes,48 8D BE E0 00 00 00)


 
 
assert(address,bytes)
alloc(newmem,$1000,"GTA5.exe"+1B5016)

label(code)
label(return)

newmem:
  mov [rax],#159147087
  lea rdi,[rsi+000000E0]
  mov rcx,rdi
  movups xmm0,[rax]
  mov eax,r12d
  movdqu [rsp+40],xmm0
  xchg [r14],eax
  mov [r14+04],r12d
code:
  lea rdi,[rsi+000000E0]
  jmp return

address:
  jmp newmem
  mov eax, esp
  movdqu [rsp+40],xmm0
  xchg [r14],eax
  mov [r14+04],r12d
return:

[DISABLE]
//code from here till the end of the code will be used to disable the cheat
address:
  lea rdi,[rsi+000000E0]
  mov rcx,rdi
  movups xmm0,[rax]
  mov eax,r12d
  movdqu [rsp+40],xmm0
  xchg [r14],eax
  mov [r14+04],r12d

dealloc(newmem)

