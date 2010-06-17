//
//  main.m
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/20/09.
//  Copyright STI Logic 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PuzzleModel.h"

int main(int argc, char *argv[])
{
	PuzzleModel *p = [[PuzzleModel alloc] init];
	
	[p isSolved];
	NSDictionary *legalMoves = [p getLegalMovesForCoinAtPosition:[[Position alloc] initWithPositionX:0	Y:0]];
	NSEnumerator *legalMovesEnumerator = [[legalMoves allValues] objectEnumerator];
	Position *aLegalMove;
	NSLog(@"Legal moves for position %d,%d are:", 0, 0);
	while(aLegalMove = [legalMovesEnumerator nextObject]) {
		NSLog(@"    %d,%d", aLegalMove.x, aLegalMove.y);
	}
		
	
    return NSApplicationMain(argc,  (const char **) argv);
}
