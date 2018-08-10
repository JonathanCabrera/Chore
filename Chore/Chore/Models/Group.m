//
//  Group.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "Group.h"

@implementation Group

@dynamic name;

+ (nonnull NSString *)parseClassName {
    return @"Group";
}

+ (Group *) makeGroup: (NSString * _Nullable)name withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Group *newGroup = [Group new];
    newGroup.name = name;
    [newGroup saveInBackgroundWithBlock:completion];
    return newGroup;
}

- (void) addMember: (Group *)group withUser: (PFUser *)user withCompletion: (PFBooleanResultBlock _Nullable)completion {
    [user setObject:group.name forKey:@"groupName"];
    [user saveInBackgroundWithBlock:completion];
}

@end
