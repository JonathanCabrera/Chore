//
//  DefaultChore.m
//  Chore
//
//  Created by Alice Park on 7/26/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "DefaultChore.h"

@implementation DefaultChore

    @dynamic name, info, points;


+ (nonnull NSString *)parseClassName {
    return @"DefaultChore";
}

+ (DefaultChore *_Nullable) makeDefaultChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withPoints: (int)points withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    DefaultChore *newChore = [DefaultChore new];
    newChore.name = name;
    newChore.info = description;
    newChore.points = points;
    [newChore saveInBackgroundWithBlock: completion];
    return newChore;
}

@end
