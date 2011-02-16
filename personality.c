#include <sys/personality.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
	int p = personality(0xffffffff);
	printf("%x\n", p);
	return 0;
}
