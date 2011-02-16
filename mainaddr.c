#include <stdio.h>

extern long etext;

int main(int argc, char *argv[])
{
	printf("%lu\n", &etext);
	return 0;
}

