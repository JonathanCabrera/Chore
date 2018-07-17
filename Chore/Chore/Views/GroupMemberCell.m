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
    self.nameLabel.text = self.currUser.username;
    
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    self.profilePic.layer.borderWidth = 0.5f;
    self.profilePic.layer.borderColor = [UIColor grayColor].CGColor;
    
    //self.profilePic = user[@"profilePic"];
    //[self.profilePic loadInBackground];
    
}


@end
