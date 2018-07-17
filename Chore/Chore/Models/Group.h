//
//  Group.h
//  Chore
//
//  Created by Alice Park on 7/16/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Group : PFObject <PFSubclassing>

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSMutableArray *members;

+ (Group *) makeGroup: (NSString * _Nullable)name withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (void) addMember: (Group *)group withUser: (PFUser *)user withCompletion: (PFBooleanResultBlock _Nullable)completion;


@end
