
#import <Cocoa/Cocoa.h>
#import "PuzzleModel.h"

@interface PuzzleSolver : NSObject {
	//a queue of models
	NSMutableArray * queue;
	NSMutableDictionary * visitedNodes;
}					


//Initializes the queue of positions to try
- (id)init;

//returns true if there is more searching
//(false if we solved the puzzle or if the entire search space was exhausted)
//(if the search space is indefinite, it'll always be the former)
- (BOOL)advanceQueue;

//print out the solution
- (void)printSolution: (PuzzleModel *)curModel;

@end
