#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int main(int argc, char *argv[])
{
	int i;
	int y[2] = { 0, 0 };

	for (i = 0; i < 2; i++) {
		char r1;
		char r2;
		int *yp = &y[i];

		// Uncomment this statement for non-zero case.
		r1 = argv[i + 1][0] - '0';
		// Uncomment this statement for zero case.
		// r1 = 0;
		r2 = argv[i + 1][0] - '0';
		*yp = r1 * r2;
	}
	assert(y[0] == y[1]);
}
