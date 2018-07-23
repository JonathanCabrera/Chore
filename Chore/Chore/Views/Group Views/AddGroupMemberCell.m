//
//  AddGroupMemberCell.m
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddGroupMemberCell.h"


@implementation AddGroupMemberCell

- (void)setCell {
    self.addUserImage.layer.cornerRadius = self.addUserImage.frame.size.width /2;
}

- (IBAction)didTapAdd:(id)sender {
    [self.delegate addMember:self];
}



@end
