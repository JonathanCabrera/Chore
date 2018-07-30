//
//  AssignChoreCell.m
//  Chore
//
//  Created by Alice Park on 7/30/18.
//  Copyright © 2018 JAK. All rights reserved.
//

#import "AssignChoreCell.h"

@implementation AssignChoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCell: (DefaultChore *)chore {
    _chore = chore;
    self.nameLabel.text = chore.name;
    self.nameLabel.textColor = [UIColor colorWithRed:0.00 green:0.56 blue:0.32 alpha:1.0];
    self.pointsLabel.text = [NSString stringWithFormat:@"%d pts", chore.points];
    self.pointsLabel.textColor = [UIColor colorWithRed:0.00 green:0.56 blue:0.32 alpha:1.0];
    self.backgroundColor = [UIColor colorWithRed:0.90 green:0.96 blue:0.85 alpha:1.0];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapChore)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)didTapChore {
    [self.delegate selectChore:self withChore:self.chore];
}

@end
