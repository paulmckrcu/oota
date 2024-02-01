/*
 * Demonstrate cbmc-based computation of sdep given C++ nondeterminism.
 *
 * Usage: cbmc -DCBMC sdep-nondet.c
 *
 * This can also be run as a stand-alone C program:
 *	./sdep-nondet val
 *
 * Where the command-line argument gives the value of val for each
 * iteration of the loop.  The same additional preprocessor variables
 * can be used when compiling.  You can also specify -DCBMC to exercise
 * CBMC-specific code paths, sort of, anyway.
 */

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#ifdef CBMC
int get_arg(char *arg)
{
	return (int)(long)arg;
}
#else
int get_arg(char *arg)
{
	return strtol(arg, NULL, 0) & 0x7;
}
#endif

int div(int x, int y)
{
	return x / y;
}

int main(int argc, char *argv[])
{
	int i;
	int val = 0;
	int z[2] = { 0, 0 };

	if (argc > 1)
		val = get_arg(argv[1]);
	if (val < 0)
		val = -val;  // Avoid divide-by-zero UB
	printf("argc = %d, val = %d\n", argc, val);
	for (i = 0; i < 2; i++) {
		int r1 = val;

		z[i] = div(++r1, ++r1);
		printf("i = %d, r1 = %d, z[i] = %d\n", i, r1, z[i]);
	}
	assert(z[0] == z[1]);
}
