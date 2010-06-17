//
//  PuzzleModel.h
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/20/09.
//  Copyright 2009 STI Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Position.h"

// PuzzleModel the underlying model of the six quarter puzzle.  It is through this model that
// you reset, get current coin positions, get legal moves for a particular coin and move a coin from one location
// to another.
// The basic use of this class is:
//    - init to initialize the puzzle
//    - getLegalMovesForCoinAtPosition to show the legal moves for a coin
//    - moveCoinFromPosition:ToPosition to move a coin
//    - isSolved to check if the puzzle is solved
// The coordinate system of the coins is:
//
@interface PuzzleModel : NSObject {
	// dictionary with key 
	NSMutableDictionary * coinPositions;
	PuzzleModel * previousModel;
}					


// Initializes the puzzle and places the six coins in their starting positions
- (id)init;

// Initializes the puzzle (copy constructor)
- (id)initWithPuzzle: (PuzzleModel *)inputModel;

// Resets the position of coins to their starting positions
- (void)resetPuzzle;

// Returns an array of the coin Positions 
- (NSArray *)getCoinPositions;

// Returns a Dictionary that contains the legal moves for a coin located at |pos|
- (NSDictionary *)getLegalMovesForCoinAtPosition: (Position *)pos;

// Returns TRUE if it is legal to move a coin from |start| to |end|
- (BOOL)isLegalToMoveFrom: (Position *)start to: (Position *)end;

// Returns TRUE if the coins are in the solved state
- (BOOL)isSolved;

// Moves a coin from position |start| to position |end|
// Validation will be done to ensure that the move is legal
- (void)moveCoinFromPosition: (Position *)start toPosition: (Position *)end;

//getter
- (PuzzleModel *)previousModel;

//toString
-(NSString *)description;

//
// --- I think the following methods can be made private.  Will know when I hook up client code
//

- (BOOL)isCoinAtX: (int)x Y:(int)y;

- (BOOL)isCoinSurrounded: (Position *)pos;

- (int)getNumberOfCoinsTouching: (Position *)pos;

- (NSArray*)getEmptyPositionsAroundPosition: (Position *)pos;

- (void)addCoinAtX: (int)x Y:(int)y;

- (Position *)removeCoinAtX: (int)x Y:(int)y;



@end
