//
//  AssignUserCell.m
//  Chore
//
//  Created by Alice Park on 7/30/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AssignUserCell.h"

@implementation AssignUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCell: (ChoreAssignment *)assignment {
    _assignment = assignment;
    self.nameLabel.text = [assignment.userName capitalizedString];
    self.nameLabel.textColor = [UIColor colorWithRed:0.00 green:0.56 blue:0.32 alpha:1.0];
    self.pointsLabel.text = [NSString stringWithFormat:@"%d pts", assignment.points];
    self.pointsLabel.textColor = [UIColor darkGrayColor];
    self.backgroundColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUser)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)didTapUser {
    [self.delegate selectUser:self withUserName:self.assignment.userName];
}

@end
