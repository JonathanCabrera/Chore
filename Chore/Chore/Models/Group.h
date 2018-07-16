//
//  Group.h
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <Parse/Parse.h>

@interface Group : PFObject

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSMutableArray *members;

+ (void) makeGroup: (NSString * _Nullable)name withCompletion: (PFBooleanResultBlock  _Nullable)completion;


@end
