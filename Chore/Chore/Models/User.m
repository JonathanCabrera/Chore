//
//  User.m
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "User.h"

@implementation User

    @dynamic name, photo, group, points, completedChores, uncompletedChores;


+ (nonnull NSString *)parseClassName {
    return @"User";
}



+ (void) makeUser: (NSString * _Nullable)name withGroup: (Group * _Nullable)group withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    User *newUser = [User new];
    newUser.name = name;
    NSData *placeholderData = UIImagePNGRepresentation([UIImage imageNamed:@"user"]);
    newUser.photo = [PFFile fileWithData:placeholderData];
    newUser.group = group;
    newUser.points = 0;
    newUser.completedChores = [NSMutableArray new];
    newUser.uncompletedChores = [NSMutableArray new];
    
    [newUser saveInBackgroundWithBlock:completion];
}

@end
