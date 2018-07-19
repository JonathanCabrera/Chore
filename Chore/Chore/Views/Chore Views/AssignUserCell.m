//
//  AssignUserCell.m
//  Chore
//
//  Created by Alice Park on 7/19/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AssignUserCell.h"

@implementation AssignUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell: (PFUser *)user {
    
    _user = user;
    self.userNameLabel.text = user.username;
    
}


@end