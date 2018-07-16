//
//  Chore.h
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

@interface Chore : PFObject <PFSubclassing>

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *description;
@property (nonatomic, strong, nonnull) User *user;
@property (nonatomic) int points;
@property (nonatomic, strong, nonnull) PFFile *photo;


+ (void) makeChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withUser: (User * _Nullable)user withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
