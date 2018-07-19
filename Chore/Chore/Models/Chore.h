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
@property (nonatomic, strong, nonnull) NSMutableArray *users;
@property (nonatomic) int points;
@property (nonatomic, strong, nonnull) PFFile *photo;


+ (void) makeChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withPoints: (int)points withDeadline: (NSDate *_Nullable)date withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
