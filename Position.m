//
//  Possition.m
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/20/09.
//  Copyright 2009 STI Logic. All rights reserved.
//

#import "Position.h"


@implementation Position

@synthesize x;
@synthesize y;

- (id)initWithPositionX:(int)newX Y:(int)newY
{
	[super init];
	x = newX;
	y = newY;
	empty = FALSE;
	return self;
}

- (id)initWithString:(NSString *)posString
{

	[super init];
	NSString *formattedPos = [NSString stringWithFormat:@"{%@}", posString];
	NSPoint point = NSPointFromString(formattedPos);
	x = point.x;
	y = point.y;
	return self;
}

-(NSString *)toString
{
	return [NSString stringWithFormat:@"%d,%d", x, y];
}

+(NSString *)toStringForX: (int)x Y:(int)y
{
	return [NSString stringWithFormat:@"%d,%d", x, y];
}

- (BOOL) isLegalPosition
{
	return FALSE;
}

- (BOOL) canBeMoved
{
	return FALSE;
}

- (void)removeCoin
{
	empty = TRUE;
}

- (void)placeCoin
{
	empty = FALSE;
}

@end
