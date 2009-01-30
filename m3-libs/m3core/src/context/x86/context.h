/*
This is an implementation of makecontext/setcontext/swapcontext/getcontext
for systems that do not provide them.

It is highly system specific.

Systems without make/set/get/swapcontext include:
    OpenBSD (4.4)
    MacOS X prior to 10.5
    Cygwin
Systems with make/set/get/swapcontext include:
    Linux
    MacOS X 10.5
    NetBSD
    FreeBSD
*/

#include <stddef.h>
#define stack_t x_stack_t
#define ucontext_t x_ucontext_t
#include <signal.h>
#undef stack_t
#undef ucontext_t

struct _ucontext_t;
typedef struct _ucontext_t ucontext_t;

struct _mcontext_t;
typedef struct _mcontext_t mcontext_t;

struct _stack_t;
typedef struct _stack_t stack_t;

struct _stack_t
{
    /* assembly code depends on the layouts here so don't move stuff around */
    void* ss_sp; /* stack base or pointer */
    size_t ss_size; /* stack size */
    int ss_flags;
};

struct _mcontext_t
{
    /* assembly code depends on the layouts here so don't move stuff around
    This order is determined by pushad, plus eip at the end.
    http://msdn.microsoft.com/en-us/library/984x0h58.aspx lists non-volatile registers; pusha is a superset. */
    size_t edi;
    size_t esi;
    size_t ebp;
    size_t esp;
    size_t ebx;
    size_t edx;
    size_t ecx;
    size_t eax;
    size_t eip;
};

struct _ucontext_t
{
    /* assembly code depends on the layouts here so don't move stuff around */
    mcontext_t uc_mcontext;
    stack_t uc_stack;
    ucontext_t* uc_link;
    sigset_t uc_sigmask;
};

int  getcontext(ucontext_t*);
int  setcontext(const ucontext_t*);
void makecontext(ucontext_t*, void(*)(), int, ...);
int  swapcontext(ucontext_t*, const ucontext_t*);
