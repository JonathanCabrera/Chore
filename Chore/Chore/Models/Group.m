//
//  Group.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "Group.h"

@implementation Group

    @dynamic name, members;

+ (nonnull NSString *)parseClassName {
    return @"Group";
}

+ (Group *) makeGroup: (NSString * _Nullable)name withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Group *newGroup = [Group new];
    newGroup.name = name;
    newGroup.members = [NSMutableArray new];
    
    [newGroup saveInBackgroundWithBlock:completion];
    
    return newGroup;
    
}


- (void) addMember: (Group *)group withUser: (PFUser *)user withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    [group.members addObject:user];
    
    [group saveInBackgroundWithBlock:completion];
    
    
}

@end
