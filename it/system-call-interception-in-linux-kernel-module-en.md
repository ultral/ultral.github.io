---
redirect_from:
  - /system-call-interception-in-linux-kernel-module.html
  - /it/system-call-interception-in-linux-kernel-module.html
---
# System call interception in Linux-kernel module (kernel 2.6.34.7-61.fc13.x86_64)

*Date: 2019-01-23*

## Preface

It is the translation of my [article](https://habr.com/post/110369). The module was created as a part of my master thesis in the 2010 year. The master thesis theme is *Keylogging in Linux kernel*. The main idea was to find out a way to intercept system calls for x64 arch Linux kernel. Source code locates at [github.com/ultral/linux-keylogger](https://github.com/ultral/linux-keylogger).

## Introduction

There were a lot of different articles about system call interception for x32 arch. As a part of a research, I faced the issue of how to intercept system calls for x86_64 arch via Linux-kernel module.

## Let's begin

How can we intercept a system call?

1. Find out the syscall table address.
2. Replace the original system call by the new one.

### Syscall table address

IDT (**I**nterrupt **D**escription **T**able) bounds *interrupt handler* & *interruption code*. In protected mode, IDT is an array of descriptors stored in memory. Each processor has a special **IDTR** register. The register consist of IDT physical address and IDT length. The first assumption was to get IDT address from IDTR register and after that calculate syscall tables address. However, the assumption was wrong, because, in that case, we got x32 handler address.

The second assumption was more interesting. Before continue, I'd like to Describe MSR (**M**odel-**S**pecific **R**egister). A MSR is any of various control registers in the x86 instruction set used for debugging, program execution tracing, computer performance monitoring, and toggling certain CPU features. Let's talk about  `MSR_LSTAR` — `0xc0000082` (long mode SYSCALL target). You can get full list at `/usr/include/asm/msr-index.h`.

The `MSR_LSTAR` stores system call entry for x86-64 architecture. You can get the address:

```c
int i, lo, hi;
asm volatile("rdmsr" : "=a" (lo), "=d" (hi) : "c" (MSR_LSTAR));
system_call = (void*)(((long)hi<<32) | lo);
```

Let's go further. I had got the address & was searching `\xff\x14\xc5`. `\xff\x14\xc5` is a magic numbers. If you look through kernel 2.6.34.7-61.fc13.x86_64 code, especially, function `system_call`, you will find out that the next 4 bytes are syscall_table address.

We knew the syscall table address, it meant that we could get a syscall handler address & replace/intercept it.

The source code:

```c
unsigned char *ptr;

for (ptr=system_call, i=0; i<500; i++) {
  if (ptr[0] == 0xff && ptr[1] == 0x14 && ptr[2] == 0xc5)
    return (void*)(0xffffffff00000000 | *((unsigned int*)(ptr+3)));
  ptr++;
}
```

### System call interception

I faced an issue. There was an error in case of changing an address in system call table. Fortunately, it was easy as pie:

* Disable memory protection.
* Rewrite a syscall handler address.
* Enable memory protection.

If you want to disable memory protection you should know: the register `CR0` consist of flags. The flags manage processor behaviour. The flag WP is `Write Protect`, it is the 48th bit at `CR0`.

Disable memory protection:

```c
asm("pushq %rax");
asm("movq %cr0, %rax");
asm("andq $0xfffffffffffeffff, %rax");
asm("movq %rax, %cr0");
asm("popq %rax");
```

Enable memory protection:

```c
asm("pushq %rax");
asm("movq %cr0, %rax");
asm("xorq $0x0000000000001000, %rax");
asm("movq %rax, %cr0");
asm("popq %rax");
```

## Conclusion

On one hand, it should enough to deal with the system call interception, but on the other hand, I don't sure that nothing has been changed since 2010. So use it as is. Source code locates at [github.com/ultral/linux-keylogger](https://github.com/ultral/linux-keylogger). Also I created [the demo video](https://www.youtube.com/watch?v=FgPVCQa0qsw).
