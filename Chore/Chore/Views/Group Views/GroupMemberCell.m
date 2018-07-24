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
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    if(user[@"profilePic"] != nil) {
        self.profilePic.file = user[@"profilePic"];
        [self.profilePic loadInBackground];
    }
    UIColor *darkGreenColor = [UIColor colorWithRed:0.47 green:0.72 blue:0.57 alpha:1.0];
    self.nameLabel.text = self.currUser.username;
    self.nameLabel.textColor = darkGreenColor;
}

- (IBAction)didTapButton:(id)sender {
    [self.delegate seeMemberProfile:self withUser: self.currUser];
}

@end
