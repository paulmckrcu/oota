/*
 * Demonstrate cbmc-based computation of sdep.
 *
 * Usage: cbmc -DCBMC sdep-quadratic.c
 *
 * Additional preprocessor variables:
 *	-DLOAD_LIMITS=N limits the arguments from -N to N, defaulting
 *		to 0..7.
 *	-DLOAD_CONSTANT=N forces the r2 arguments to the value N.
 *
 * This can also be run as a stand-alone C program:
 *	./sdep-quadratic r1_1 r2_1 r1_2 r2_2
 *
 * Where the command-line arguments give the values of r1 and r2
 * for each iteration of the loop.  The same additional preprocessor
 * variables can be used when compiling.  You can also specify -DCBMC
 * to exercise CBMC-specific code paths, sort of, anyway.
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

#ifndef LOAD_LIMITS
int limited_arg(char *arg)
{
	return get_arg(arg);
}
#else
int limited_arg(char *arg)
{
	int val = get_arg(arg);

	if (val > LOAD_LIMITS)
		val = LOAD_LIMITS;
	else if (val < -LOAD_LIMITS)
		val = -LOAD_LIMITS;
	return val;
}
#endif

#ifndef LOAD_CONSTANT
int const_arg(int arg)
{
	return arg;
}
#else
int const_arg(int arg)
{
	return LOAD_CONSTANT;
}
#endif

int main(int argc, char *argv[])
{
	int i;
	int y[2] = { 0, 0 };

	for (i = 0; i < 2; i++) {
		int r1;
		int r2;
		int r3;
		int *yp = &y[i];

		r1 = limited_arg(argv[2 * i + 1]);
		r2 = const_arg(limited_arg(argv[2 * i + 2]));
		r3 = r1 * r1 + 2 * r1 + 2;
		*yp = r2 <= r3 ? r2 : r3;
		printf("i = %d, r1 = %d, r2 = %d, r3 = %d\n", i, r1, r2, r3);
	}
	assert(y[0] == y[1]);
}
