//
//  PuzzleController.h
//  SixQuarterPuzzle
//
//  Created by David Itkin on 2/21/09.
//  Copyright 2009 STI Logic. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PuzzleView.h"
#import "PuzzleModel.h"
#import "Position.h"


@interface PuzzleController : NSObject {
	IBOutlet PuzzleView *puzzleView;
	
	Position *selectedPosition;
	
	PuzzleModel *model;

}

-(IBAction) resetPuzzle:(id)sender;

- (void)selectionAt:(Position *)coinPosition;

-(IBAction) demoStepPuzzle:(id)sender;



@end
