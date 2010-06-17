//
//  PuzzleView.m
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/21/09.
//  Copyright 2009 STI Logic. All rights reserved.
//

#import "PuzzleView.h"
#import "PuzzleController.h"




// Declaration of private methods
@interface PuzzleView ()
-(NSImageView*) createViewForCoinAtX: (int)x Y:(int)y;

// Takes coin stacking coordinates and converts them to graphic coordinates
-(NSRect) createRectForCoinAtX: (int)x Y: (int)y;

// Determines if there is a coin at the graphical location and if so returns the puzzle position
// Otherwise returns nil
-(Position *)isCoinAtLocation:(NSPoint) selectedPoint;

// Determines if there a marker at the graphical location and if so returns the puzzle position
// Otherwise returns nil
-(Position *)isMarkerAtLocation: (NSPoint) selectedPoint;
@end

@implementation PuzzleView

// Public methods follow

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		coinViews = [[NSMutableDictionary alloc] init];
		legalMoves = [[NSMutableDictionary alloc] init];
		
		origin = [self createRectForCoinAtX:0 Y:0];
		
		
		[self addSubview:[self createViewForCoinAtX:0 Y:0]];
		[self addSubview:[self createViewForCoinAtX:0 Y:-1]];
		[self addSubview:[self createViewForCoinAtX:-1 Y:-1]];
		[self addSubview:[self createViewForCoinAtX:-2 Y:-2]];
		[self addSubview:[self createViewForCoinAtX:-1 Y:-2]];
		[self addSubview:[self createViewForCoinAtX:0 Y:-2]];
		
    }
    return self;
}


- (void)drawRect:(NSRect)rect {
//	[super drawRect:rect];
	
		NSEnumerator *legalMovesIterator = [legalMoves objectEnumerator];
		Position *aLegalMove;
		while (aLegalMove = [legalMovesIterator nextObject]) {
			NSRect legalMoveRect = [self createRectForCoinAtX: aLegalMove.x Y: aLegalMove.y];
			NSBezierPath *legalMovePath =  [NSBezierPath bezierPathWithOvalInRect:(NSRect)legalMoveRect];
			[[NSColor greenColor] setFill];
			[legalMovePath fill];
		}
}

-(NSImageView*) createViewForCoinAtX: (int)x Y:(int)y {
	
	NSImageView *view = [[NSImageView alloc] initWithFrame:[self createRectForCoinAtX:x Y:y]];
	[view setImageScaling:NSScaleToFit];
	[view setImage:[NSImage imageNamed:@"NewQuarter.png"]];
	[view setEditable:FALSE];
	[view setEnabled:FALSE];
	
	[coinViews setObject:view forKey:[Position descriptionForX:x Y:y]];
	
	return view;
	
}

-(NSRect) createRectForCoinAtX: (int)x Y: (int)y {
	CGFloat frameX = NSWidth([self frame]);
	CGFloat frameY = NSWidth([self frame]);
	
	CGFloat startX = frameX / 3.0f;
	CGFloat startY = frameY / 3.0f;
	
	coinRadius = 40.0f;
	
	NSRect frame = NSMakeRect(startX + (x * coinRadius * 2.0) + (-1 * y * coinRadius), startY + (y * coinRadius * 1.7f), coinRadius * 2.0f, coinRadius * 2.0f);
	
	return frame;
	
}


-(void)moveCoinFromPosition: (Position *)fromPosition To: (Position *)toPosition;
{
	// Get the coin view at the old location (remove from the dictionary)
	NSImageView *coinView = [coinViews objectForKey:[fromPosition description]];

	if (coinView == nil) {
		NSLog(@"moveCoinFromX:Y:toX:Y: could not find the coin at %@", [fromPosition description]);
		return;
	}
	
	// update the coins location
	[[coinView animator] setFrame:[self createRectForCoinAtX: toPosition.x Y: toPosition.y]];
	
	// remove the coinView from the dictionary under the old key
	[coinViews removeObjectForKey:[fromPosition description]];
	
	// Place into the dictionary
	[coinViews setObject:coinView forKey:[toPosition description]];
	
	[self needsDisplay];
	
}

-(void)mouseUp:(NSEvent *)event
{
	// Either fill this in with a selected position or nothing
	Position *selectedPosition = nil;
	
	// The point that was clicked on
	NSPoint selectedPoint = [self convertPoint:[event locationInWindow]	fromView:nil];
	
	selectedPosition = [self isCoinAtLocation: selectedPoint];
	if (selectedPosition == nil)
		selectedPosition = [self isMarkerAtLocation: selectedPoint];
	
	[controller selectionAt: selectedPosition];
}

-(Position *)isCoinAtLocation:(NSPoint) selectedPoint 
{
		
	NSEnumerator *enumerator = [coinViews keyEnumerator];
	NSString *key;
	while(key = [enumerator nextObject]) {
		// get view
		NSImageView *view = [coinViews objectForKey:key];
		NSRect frame = [view frame];
		
//		NSLog(@"The frame %f,%f ", frame.origin.x, frame.origin.y);
		
		if (NSPointInRect(selectedPoint, frame)) {
			NSPoint center;
			center.x = frame.origin.x + coinRadius;
			center.y = frame.origin.y + coinRadius;
			
			CGFloat dx = selectedPoint.x - center.x;
			CGFloat dy = selectedPoint.y - center.y;
			
			CGFloat distance = sqrt(dx*dx + dy*dy);
			
			if (distance <= coinRadius) {
				return [[Position alloc] initWithString:key];
			} 
		}
	}
	
	return nil;
	
	
}

-(Position *)isMarkerAtLocation: (NSPoint)selectedPoint
{
	
	NSEnumerator *legalMovesIterator = [legalMoves objectEnumerator];
	Position *aLegalMove;
	while (aLegalMove = [legalMovesIterator nextObject]) {
		NSRect frame = [self createRectForCoinAtX: aLegalMove.x Y: aLegalMove.y];
		
		//		NSLog(@"The frame %f,%f ", frame.origin.x, frame.origin.y);
		
		if (NSPointInRect(selectedPoint, frame)) {
			NSPoint center;
			center.x = frame.origin.x + coinRadius;
			center.y = frame.origin.y + coinRadius;
			
			CGFloat dx = selectedPoint.x - center.x;
			CGFloat dy = selectedPoint.y - center.y;
			
			CGFloat distance = sqrt(dx*dx + dy*dy);
			
			if (distance <= coinRadius) {
				return aLegalMove;
				
			} 
		}
	}
	
	return nil;
}



-(void)setController:(PuzzleController *)newController {
	controller = newController;
}


-(BOOL) isFirstResponder
{
	return YES;
}


-(void)addCoinAtPosition: (Position *)puzzlePosition
{
	
}

-(void)removeCoinAtPosition: (Position *)puzzlePosition
{
	
}

-(void)addMarkerAtPosition: (Position *)puzzlePosition
{
	[legalMoves setObject:puzzlePosition forKey:[puzzlePosition description]];
	[self setNeedsDisplay:TRUE];
	
}

-(void)removeMarkerAtPosition: (Position *)puzzlePosition
{
	[legalMoves removeObjectForKey:[puzzlePosition description]];
	[self setNeedsDisplay:TRUE];
}

-(void)removeMarkers
{
	[legalMoves removeAllObjects];
	[self setNeedsDisplay:TRUE];
}

@end
