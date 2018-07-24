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
    self.nameLabel.text = self.currUser.username;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMember)];
    [self.profilePic addGestureRecognizer:tapRecognizer];
}

- (void)didTapMember {
    [self.delegate seeMemberProfile:self withUser: self.currUser];
}


@end
