//
//  PuzzleModel.m
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/20/09.
//  Copyright 2009 STI Logic. All rights reserved.
//

#import "PuzzleModel.h"


@implementation PuzzleModel

- (id)init
{
	[super init];
	coinPositions = [[NSMutableDictionary alloc] init];
	previousModel = nil;
	[self resetPuzzle];
	return self;
}

- (id)initWithPuzzle: (PuzzleModel *)inputModel
{
	[super init];
	coinPositions = [[NSMutableDictionary alloc] init];
	//[coinPositions addEntriesFromDictionary: [inputModel coinPositions]];
	NSEnumerator * coinEnumerator = [[inputModel getCoinPositions] objectEnumerator];
	Position * coin;
	while(coin = [coinEnumerator nextObject])
	{
		[coinPositions setObject:coin forKey:[coin description]];
	}
	previousModel = inputModel;
	return self;
}


- (void)resetPuzzle
{
	[self addCoinAtX:0 Y:0];
	[self addCoinAtX: -1 Y:-1];
	[self addCoinAtX: 0 Y:-1];
	[self addCoinAtX: -2 Y:-2];
	[self addCoinAtX: -1 Y:-2];
	[self addCoinAtX: -0 Y:-2];
}

- (void)addCoinAtX: (int)x Y:(int)y
{
	Position *p = [[Position alloc] initWithPositionX:x Y:y];
	[coinPositions setObject:p forKey:[p description]];
}

- (Position *)removeCoinAtX: (int)x Y:(int)y
{
	NSString *key = [Position descriptionForX:x Y:y];
	Position *removedPosition = [coinPositions objectForKey:key];
	[coinPositions removeObjectForKey:key];
	return removedPosition;
}

- (BOOL)isCoinAtX: (int)x Y:(int)y  
{
	NSString *key = [Position descriptionForX:x Y:y];
	return ([coinPositions objectForKey:key] != nil);
}

- (PuzzleModel *)previousModel
{
	return previousModel;
}

NSComparisonResult intSort(id num1, id num2, void *context)
{
    int v1 = [num1 y];
    int v2 = [num2 y];
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
	{
		v1 = [num1 x];
		v2 = [num2 x];
		if (v1 < v2)
			return NSOrderedAscending;
		else if (v1 > v2)
			return NSOrderedDescending;
		else
			return NSOrderedSame;
	}
}

-(NSString *)description
{
	//return [NSString stringWithFormat:@"%d,%d", 111, 222];
	NSString *output = [[NSString alloc] init];
	NSArray *positions = [self getCoinPositions];
	NSArray *sortedPositions = [positions sortedArrayUsingFunction:intSort context:NULL];
	return [sortedPositions componentsJoinedByString:@","];
}

- (BOOL)isSolved
{
	Position * aPosition;
	
	//find the lowest coin, and start there
	int lowestSum;
	Position * lowestPosition = nil;
	BOOL isSolved = TRUE;
	NSEnumerator *objectEnumerator = [coinPositions objectEnumerator];
	while (aPosition = [objectEnumerator nextObject])
	{
		if(lowestPosition == nil || [aPosition x]+[aPosition y]<lowestSum)
		{
			lowestPosition = aPosition;
			lowestSum = [aPosition x]+[aPosition y];
		}
	}

	//go around the circle
	int x = [lowestPosition x], y = [lowestPosition y], direction;
	for(direction=0;direction<6;direction++) //yes, direction<5 would be more efficient
	{
		int d=direction>2?-1:1;
		x+=direction%3==2?0:d;
		y+=direction%3==0?0:d;
		if(![self isCoinAtX:x Y:y])
		{
			return FALSE;
		}
	}

	return TRUE;
}

- (NSArray *)getCoinPositions
{
	return [[NSArray alloc] initWithArray:[coinPositions allValues]];
}

- (void)moveCoinFromPosition: (Position *)start toPosition: (Position *)end
{
	// make sure that a coin exists at start position
	if (![self isCoinAtX:[start x]	Y:[start y]]) {
		//NSLog(@"Trying to move from a position, %@, that has no coin", [start description]);
		return;
	}
	
	// check to make sure end is a legal position
	if (![self isLegalToMoveFrom:start to:end]) {
		NSLog(@"Moving from start, %@, to end, %@, is not a legal move", [start description], [end description]);
		return;
	}
	
	// Sanity check to make sure that end position is empty (this should never happen but...
	if ([self isCoinAtX:[end x] Y:[end y]]) {
		NSLog(@"Trying to move to a position, %@, that already has a coin", [end description]);
		return;
	}
	
	//NSLog(@"Moving from %@ to %@ ", [start description], [end description]);
		
	[self removeCoinAtX:[start x]	Y:[start y]];
	[self addCoinAtX:[end x] Y:[end y]];
}

- (BOOL)isLegalToMoveFrom: (Position *)start to: (Position *)end
{
	return ([[self getLegalMovesForCoinAtPosition:start] objectForKey:[end description]] != nil);
}


- (NSDictionary *)getLegalMovesForCoinAtPosition: (Position *)pos
{
	// first make sure there is a coin at the position, 
	if (![self isCoinAtX:[pos x] Y:[pos y]]) {
		NSLog(@"There is no coin at %@", [pos description]);
		return [NSDictionary dictionary];
	}
	
	// second make sure that the coin is not surrounded (there needs to be a gap of two coins)
	if ([self isCoinSurrounded: pos]) {
		//NSLog(@"Coin at position %@ is surrounded", [pos description]);
		return [NSDictionary dictionary];
	}
		
	// DANGER DANGER
	// I am removing the coin to the do the rest of these checks, before returning I must ensure that I re-add the coin
	// DANGER DANGER
	Position *removedCoin = [self removeCoinAtX:[pos x] Y:[pos y]];
	
	// collect up all positions that are around the coins and are not themselves occupied with a coin
	// and if any of these emtpy positions touch at least two coins then it is a legal move
	// TODO: should also check to see if empty position is surrounded, though I don't think this is a problem in this puzzle
	NSMutableDictionary *legalEmptyPositions = [[NSMutableDictionary alloc] init];
	NSEnumerator *coinEnumerator = [coinPositions objectEnumerator];
	Position *aCoinPosition;
	while (aCoinPosition = [coinEnumerator nextObject])
	{
		NSArray *surroundingEmptyPositions = [self getEmptyPositionsAroundPosition: aCoinPosition];
		NSEnumerator *surroundingEmptyEnumerator = [surroundingEmptyPositions objectEnumerator];
		Position *anEmptyPosition;
		while(anEmptyPosition = [surroundingEmptyEnumerator nextObject]) {
			if ([self getNumberOfCoinsTouching: anEmptyPosition] >= 2 && [self getNumberOfCoinsTouching:anEmptyPosition] <= 4) {
				[legalEmptyPositions setValue:anEmptyPosition forKey:[anEmptyPosition description]];				
			}			
		}
	}
	
	// remove the coins current location from the array of legal moves.
	[legalEmptyPositions removeObjectForKey:[removedCoin description]];
		
	// DANGAR DANGER readd the coin that was removed to do the tests
	[self addCoinAtX:[removedCoin x] Y:[removedCoin y]];
	
	return [NSDictionary dictionaryWithDictionary:legalEmptyPositions]; 
}

- (NSArray*)getEmptyPositionsAroundPosition: (Position *)pos
{
	NSMutableArray *emptyPositions = [[NSMutableArray alloc] init];
	
	if (![self isCoinAtX:[pos x] Y:([pos y]+1)])
		[emptyPositions addObject:[[Position alloc] initWithPositionX:[pos x] Y:([pos y]+1)]];
	if (![self isCoinAtX:([pos x]+1) Y:([pos y]+1)])
		[emptyPositions addObject:[[Position alloc] initWithPositionX:([pos x]+1) Y:([pos y]+1)]];
	if (![self isCoinAtX:([pos x]-1) Y:([pos y])])
		[emptyPositions addObject:[[Position alloc] initWithPositionX:([pos x]-1) Y:([pos y])]];
	if (![self isCoinAtX:([pos x]+1) Y:([pos y])])
		[emptyPositions addObject:[[Position alloc] initWithPositionX:([pos x]+1) Y:([pos y])]];
	if (![self isCoinAtX:([pos x]) Y:([pos y]-1)])
		[emptyPositions addObject:[[Position alloc] initWithPositionX:[pos x] Y:([pos y]-1)]];
	if (![self isCoinAtX:([pos x]-1) Y:([pos y]-1)])
		[emptyPositions addObject:[[Position alloc] initWithPositionX:([pos x]-1) Y:([pos y]-1)]];

	return emptyPositions;
	
 }

- (BOOL)isCoinSurrounded: (Position *)pos
{
	return ([self getNumberOfCoinsTouching:pos] > 4);
}

- (int)getNumberOfCoinsTouching: (Position *)pos
{
	int touchingCoins = 0;
	
	if ([self isCoinAtX:[pos x] Y:([pos y]+1)])
		touchingCoins++;
	if ([self isCoinAtX:([pos x]+1) Y:([pos y]+1)])
		touchingCoins++;
	if ([self isCoinAtX:([pos x]-1) Y:([pos y])])
		touchingCoins++;
	if ([self isCoinAtX:([pos x]+1) Y:([pos y])])
		touchingCoins++;	
	if ([self isCoinAtX:([pos x]) Y:([pos y]-1)])
		touchingCoins++;
	if ([self isCoinAtX:([pos x]-1) Y:([pos y]-1)])
		touchingCoins++;

	return touchingCoins;
}


@end
