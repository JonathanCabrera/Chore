//
//  Chore.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "Chore.h"

@implementation Chore

    @dynamic name, info, points, photo, deadline, userName, completionStatus;

+ (nonnull NSString *)parseClassName {
    return @"Chore";
}

+ (Chore *) makeChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withPoints: (int)points withDeadline: (NSDate *)date withUserName: (NSString * _Nullable)userName withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Chore *newChore = [Chore new];
    newChore.name = name;
    newChore.info = description;
    newChore.points = points;
    newChore.deadline = date;
    newChore.completionStatus = NO;
    newChore.userName = userName;
    NSData *placeholderData = UIImagePNGRepresentation([UIImage imageNamed:@"camera"]);
    newChore.photo = [PFFile fileWithData:placeholderData];
    [newChore saveInBackgroundWithBlock: completion];
    return newChore;
}

@end
