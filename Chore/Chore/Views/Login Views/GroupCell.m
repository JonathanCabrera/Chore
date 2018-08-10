//
//  GroupCell.m
//  Chore
//
//  Created by Alice Park on 7/17/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCell:(Group *)group {
    _currentGroup = group;
    self.groupNameLabel.text = group.name;
}

- (IBAction)didTapSelect:(id)sender {
    [self.currentGroup addMember:self.currentGroup withUser:[PFUser currentUser] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"added user to group");
        } else {
            NSLog(@"Error adding user to group: %@", error.localizedDescription);
        }
    }];
    
    [self.delegate selectCell:self didSelect:self.currentGroup];
}

@end
