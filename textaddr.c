#include <stdio.h>

extern long etext;

int main(int argc, char *argv[])
{
	printf("%lu\n", (unsigned long)&etext);
	return 0;
}

