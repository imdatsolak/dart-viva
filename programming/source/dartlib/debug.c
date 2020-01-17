#include "dart/debug.h"

int debug = 0;

int	SetDebug(int newDebugLevel)
{
	int	oldDebugLevel = debug;
	debug = newDebugLevel;
	return oldDebugLevel;
}
