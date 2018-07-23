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
@property (nonatomic, strong, nonnull) NSDate *deadline;
@property (nonatomic) int points;
@property (nonatomic, strong, nonnull) PFFile *photo;
@property (nonatomic, strong, nonnull) NSString *defaultChore;

+ (Chore *) makeChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withPoints: (int)points withDeadline: (NSDate *_Nullable)date withDefault: (NSString * _Nullable)defaultChore withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
