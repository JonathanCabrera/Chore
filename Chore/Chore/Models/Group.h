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

+ (Group  *_Nullable) makeGroup: (NSString * _Nullable)name withCompletion: (PFBooleanResultBlock  _Nullable)completion;

- (void) addMember: (Group * _Nullable)group withUser: (PFUser * _Nullable)user withCompletion: (PFBooleanResultBlock _Nullable)completion;

@end
