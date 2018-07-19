//
//  Chore.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "Chore.h"

@implementation Chore

    @dynamic name, info, users, points, photo, deadline;

+ (nonnull NSString *)parseClassName {
    return @"Chore";
}

+ (void) makeChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withPoints: (int)points withDeadline: (NSDate *)date withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Chore *newChore = [Chore new];
    
    newChore.name = name;
    newChore.info = description;
    newChore.users = [NSMutableArray new];
    newChore.points = points;
    newChore.deadline = date;
    
    NSData *placeholderData = UIImagePNGRepresentation([UIImage imageNamed:@"camera"]);
    newChore.photo = [PFFile fileWithData:placeholderData];
    
    [newChore saveInBackgroundWithBlock: completion];
}

@end
