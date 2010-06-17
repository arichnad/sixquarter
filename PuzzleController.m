//
//  PuzzleController.m
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/21/09.
//  Copyright 2009 STI Logic. All rights reserved.
//

#import "PuzzleController.h"
#import "PuzzleModel.h"

@implementation PuzzleController

-(id)init
{
	[super init];
	if (self) {
		model = [[PuzzleModel alloc] init];
	}
	return self;
}

-(IBAction) resetPuzzle:(id)sender
{
//	[model resetPuzzle];
//	NSArray *positions = [model getCoinPositions];
//	NSEnumerator *enumerator = [positions objectEnumerator];
}

- (void)selectionAt:(Position *)position
{
	
	if (position == nil) {
		[puzzleView removeMarkers];
		selectedPosition = nil;
	} else if ([model isCoinAtX:position.x	Y:position.y]) {		
		selectedPosition = position;
		
		[puzzleView removeMarkers];
		NSDictionary *legalMoves = [model getLegalMovesForCoinAtPosition:position];
		
		NSEnumerator *legalMovesIterator = [legalMoves objectEnumerator];
		Position *aLegalMove;
		while (aLegalMove = [legalMovesIterator nextObject]) {
			[puzzleView addMarkerAtPosition:aLegalMove];
		}
	} else if (selectedPosition != nil && [model isLegalToMoveFrom:selectedPosition to:position]) {
		[puzzleView removeMarkers];
		[model moveCoinFromPosition:selectedPosition toPosition:position];
		[puzzleView moveCoinFromPosition:selectedPosition To:position];
		selectedPosition = nil;
	}
	
}

-(IBAction) demoStepPuzzle:(id)sender
{
//	[puzzleView moveCoinFromX:0 Y:0 toX:-2 Y:-3];
}

- (void)awakeFromNib
{
	[puzzleView setController:self];
}

@end
