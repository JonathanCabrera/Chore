//
//  Chore.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "Chore.h"

@implementation Chore

@dynamic name, info, user, points, photo;

+ (nonnull NSString *)parseClassName {
    return @"Chore";
}

+ (void) makeChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)info withUser: (PFUser * _Nullable)user withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Chore *newChore = [Chore new];
    
    newChore.name = name;
    newChore.info = info;
    newChore.user = user;
    newChore.points = 0;
    
    NSData *placeholderData = UIImagePNGRepresentation([UIImage imageNamed:@"camera"]);
    newChore.photo = [PFFile fileWithData:placeholderData];
    
    [newChore saveInBackgroundWithBlock: completion];
}

@end
