//
//  User.h
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <Parse/Parse.h>
#import "Group.h"

@interface User : PFUser <PFSubclassing>

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) PFFile *photo;
@property (nonatomic, strong, nonnull) Group *group;
@property (nonatomic) int points;
@property (nonatomic, strong, nonnull) NSMutableArray *completedChores;
@property (nonatomic, strong, nonnull) NSMutableArray *uncompletedChores;


+ (void) makeUser: (NSString * _Nullable)name withGroup: (Group * _Nullable)group withCompletion: (PFBooleanResultBlock  _Nullable)completion;




@end
