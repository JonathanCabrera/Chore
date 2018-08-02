//
//  ChoreAssignment.m
//  Chore
//
//  Created by Alice Park on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "ChoreAssignment.h"

@implementation ChoreAssignment

@dynamic userName, groupName, uncompletedChores, completedChores, points;

+ (nonnull NSString *)parseClassName {
    return @"ChoreAssignment";
}

+ (void) makeChoreAssignment: (NSString * _Nullable)userName withGroupName: (NSString * _Nullable)groupName withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    ChoreAssignment *newAssignment = [ChoreAssignment new];
    newAssignment.userName = userName;
    newAssignment.groupName = groupName;
    newAssignment.points = 0;
    newAssignment.uncompletedChores = [[NSMutableArray alloc] init];
    newAssignment.completedChores = [[NSMutableArray alloc] init];
    [newAssignment saveInBackgroundWithBlock: completion];
}

+ (void) assignChore: (NSString * _Nullable)userName withChore: (Chore *)chore withCompletion: (PFBooleanResultBlock _Nullable)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"ChoreAssignment"];
    [query whereKey:@"userName" equalTo:userName];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            ChoreAssignment *currentAssignment = posts[0];
             //NSLog(@"chore deadline: %@", chore.deadline);
            NSMutableArray<Chore *> *newUncompleted = currentAssignment.uncompletedChores;
           // NSLog(@"newUncompleted chores count: %lu", [newUncompleted count]);
            [newUncompleted addObject:chore];
           // NSLog(@"newUncompleted chores count: %lu", [newUncompleted count]);
            [currentAssignment setObject:newUncompleted forKey:@"uncompletedChores"];
            //NSLog(@"uncompleted chores count: %lu", [currentAssignment.uncompletedChores count]);
            [currentAssignment saveInBackgroundWithBlock:completion];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
@end

