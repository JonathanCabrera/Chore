//
//  DefaultChore.h
//  Chore
//
//  Created by Alice Park on 7/26/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "PFObject.h"
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DefaultChore : PFObject <PFSubclassing>

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSString *info;
@property (nonatomic) int points;

+ (DefaultChore *_Nullable) makeDefaultChore: (NSString * _Nullable)name withDescription: (NSString * _Nullable)description withPoints: (int)points withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
