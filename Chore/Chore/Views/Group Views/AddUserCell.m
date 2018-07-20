//
//  AddUserCell.m
//  Chore
//
//  Created by Alice Park on 7/18/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AddUserCell.h"

@implementation AddUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCell:(PFUser *)user {
    _currentUser = user;
    self.nameLabel.text = user.username;
}

- (IBAction)didTapSelect:(id)sender {
    [self.delegate selectCell:self didSelect:self.currentUser];
}

@end
