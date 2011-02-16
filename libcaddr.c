#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>

int main(int argc, char *argv[])
{
	Dl_info info;
	void* p = dlsym(RTLD_DEFAULT, "poll");
	if (!p)
		return -1;

	if (dladdr(p, &info) == -1)
		return -1;
        printf("%lu\n", (long)info.dli_fbase);
#if 0
        printf("%s\n", info.dli_fname);
        printf("%lx\n", (long)p);
#endif
        return 0;
}
