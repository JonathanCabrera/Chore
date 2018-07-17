//
//  GroupMemberCell.m
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "GroupMemberCell.h"

@implementation GroupMemberCell

- (void)setMember:(PFUser *)user {
    
    _currUser = user;
    NSLog(@"%@", self.currUser.username);
    self.nameLabel.text = self.currUser.username;
    
    
    //self.profilePic = user[@"profilePic"];
    //[self.profilePic loadInBackground];
    
}


@end
