#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int main(int argc, char *argv[])
{
	int i;
	int y[2] = { 0, 0 };

	for (i = 0; i < 2; i++) {
		int r1;
		int r2;
		int r3;
		int *yp = &y[i];

		r1 = argv[2 * i + 1][0] & 0x7;
		// r2 = 0; // Comment out for sdep
		r2 = argv[2 * i + 2][0] & 0x7; // Comment out for !sdep
		r3 = r1 * r1 + 2 * r1 + 2;
		*yp = r2 <= r3 ? r2 : r3;
	}
	assert(y[0] == y[1]);
}
