
#import "PuzzleSolver.h"
#import <stdio.h>


@implementation PuzzleSolver

- (id)init
{
	[super init];
	queue = [[NSMutableArray alloc] init];
	PuzzleModel * model = [[PuzzleModel alloc] init];
	[model isSolved];
	[queue addObject:model];

	visitedNodes = [[NSMutableDictionary alloc] init];
	return self;
}

- (BOOL)advanceQueue
{
	if([queue count] == 0)
	{
		//no more searching, search space exhausted
		return FALSE;
	}
	PuzzleModel * startingModel = [queue objectAtIndex:0];
	[queue removeObjectAtIndex:0];
	NSEnumerator * fromPositionEnumerator = [[startingModel getCoinPositions] objectEnumerator];
	Position * from;
	//try every possibility
	while(from = [fromPositionEnumerator nextObject]) 
	{
		NSEnumerator * toPositionEnumerator = [[startingModel getLegalMovesForCoinAtPosition:from] objectEnumerator];
		Position * to;
		while(to = [toPositionEnumerator nextObject])
		{
			PuzzleModel * curModel = [[PuzzleModel alloc] initWithPuzzle:startingModel];
			[curModel moveCoinFromPosition: from toPosition:to];
			
			
			//trimming
			if([visitedNodes objectForKey:[curModel description]] != nil)
			{
				continue;
			}
			[visitedNodes setObject:curModel forKey:[curModel description]];
			
			
			if([curModel isSolved])
			{
				[self printSolution:curModel];
				//no more searching, puzzle solved
				return FALSE;
			}
			[queue addObject:curModel];
		}
	}
	//search some more
	return TRUE;
}

- (void)printSolution: (PuzzleModel *)curModel
{
	NSLog(@"%d", [queue count]);
	while(curModel != nil)
	{
		NSLog([curModel description]);
		curModel = [curModel previousModel];
	}
}

@end
