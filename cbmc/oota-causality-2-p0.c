#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int main(int argc, char *argv[])
{
	int i;
	int y[2] = { 0, 0 };

	for (i = 0; i < 2; i++) {
		char r1;
		int *yp = &y[i];

		r1 = argv[i + 1][0];
		*yp = r1;
	}
	assert(y[0] == y[1]);
}
