//
//  PuzzleView.h
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/21/09.
//  Copyright 2009 STI Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Position.h"

@class PuzzleController;


@interface PuzzleView : NSView {
	// contains a dictionary of NSImageView objects keyed by the x,y puzzle position
	
	NSMutableDictionary *coinViews;
	
	NSMutableDictionary *legalMoves;
	
	BOOL showLegalMoves;
	
	PuzzleController *controller;
	
	NSRect origin;
	CGFloat coinRadius;
	
}


// Moves the image of the coin from old to new coordinates (coin stacdking coordinates)
-(void)moveCoinFromPosition: (Position *)fromPosition To: (Position *)toPosition;

-(void)setController:(PuzzleController *)newController;

-(void)addCoinAtPosition: (Position *)puzzlePosition;

-(void)removeCoinAtPosition: (Position *)puzzlePosition;

-(void)addMarkerAtPosition: (Position *)puzzlePosition;

-(void)removeMarkerAtPosition: (Position *)puzzlePosition;

-(void)removeMarkers;

// Private methods are declared in the .m

@end
	