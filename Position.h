//
//  Possition.h
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/20/09.
//  Copyright 2009 STI Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Position : NSObject {
	int x;
	int y;
	BOOL empty;
}

- (id)initWithPositionX:(int)newX Y:(int)newY;

// Takes a string of the form "x,y"
- (id)initWithString:(NSString *)posString;

-(NSString *)toString;

+(NSString *)toStringForX: (int)x Y:(int)y;

- (BOOL) isLegalPosition;

- (BOOL) canBeMoved;

- (void) removeCoin;

- (void) placeCoin;

@property(readonly) int x;
@property(readonly) int y;

@end
