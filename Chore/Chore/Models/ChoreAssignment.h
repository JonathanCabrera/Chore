//
//  ChoreAssignment.h
//  Chore
//
//  Created by Alice Park on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Chore.h"

@interface ChoreAssignment : PFObject <PFSubclassing>

@property (nonatomic, strong, nonnull) NSString *groupName;
@property (nonatomic, strong, nonnull) NSString *userName;
@property (nonatomic, strong, nonnull) NSMutableArray *uncompletedChores;
@property (nonatomic, strong, nonnull) NSMutableArray *completedChores;
@property (nonatomic) int points;

+ (void) makeChoreAssignment: (NSString * _Nullable)userName withGroupName: (NSString * _Nullable)groupName withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) assignChore: (NSString * _Nullable)userName withChore: (Chore * _Nullable)chore withCompletion: (PFBooleanResultBlock _Nullable)completion;

@end
