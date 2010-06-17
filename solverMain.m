
#import "PuzzleSolver.h"
#import <Foundation/Foundation.h>

int main(int argc, char *argv[])
{
	CREATE_AUTORELEASE_POOL (pool);
	PuzzleSolver *p = [[PuzzleSolver alloc] init];
	
	int i=0;
	while([p advanceQueue]);// && ++i<100);
}

