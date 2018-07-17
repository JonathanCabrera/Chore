//
//  Chore.h
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Chore : PFObject <PFSubclassing>

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *info;
@property (nonatomic, strong, nonnull) PFUser *user;
@property (nonatomic) int points;
@property (nonatomic, strong, nonnull) PFFile *photo;


+ (void) makeChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withUser: (PFUser * _Nullable)user withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
