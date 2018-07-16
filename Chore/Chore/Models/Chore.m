//
//  Chore.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "Chore.h"

@implementation Chore

@dynamic name, description, user, points, photo;

+ (nonnull NSString *)parseClassName {
    return @"Chore";
}

+ (void) makeChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withUser: (PFUser * _Nullable)user withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Chore *newChore = [Chore new];
    
    newChore.name = name;
    newChore.description = description;
    newChore.user = user;
    newChore.points = 0;
    
    NSData *placeholderData = UIImagePNGRepresentation([UIImage imageNamed:@"camera"]);
    newChore.photo = [PFFile fileWithData:placeholderData];
    
    [newChore saveInBackgroundWithBlock: completion];
}

@end
